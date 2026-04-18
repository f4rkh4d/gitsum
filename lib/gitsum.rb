# gitsum — quick stats about a git repo.
#
# Counts commits per author and lines per file extension over the repo's
# full history. Pure shell-out to `git`, no external gems.

require "open3"

module Gitsum
  VERSION = "0.1.0"

  # Result of scanning a git repo.
  Report = Struct.new(:authors, :extensions, :total_commits, :first_commit, :last_commit, keyword_init: true)

  # Scan the given directory (defaults to cwd). Raises if it's not a git repo.
  def self.scan(dir = ".")
    raise Error, "not a git repo: #{dir}" unless git_repo?(dir)

    authors = count_authors(dir)
    exts = count_extensions(dir)
    total = authors.values.sum
    first, last = date_range(dir)

    Report.new(
      authors: authors,
      extensions: exts,
      total_commits: total,
      first_commit: first,
      last_commit: last,
    )
  end

  # ---- internal ----

  def self.git_repo?(dir)
    out, _err, status = Open3.capture3("git", "-C", dir, "rev-parse", "--is-inside-work-tree")
    status.success? && out.strip == "true"
  end

  def self.count_authors(dir)
    out, _, status = Open3.capture3("git", "-C", dir, "log", "--format=%an")
    raise Error, "git log failed" unless status.success?
    tally = Hash.new(0)
    out.each_line { |l| tally[l.strip] += 1 unless l.strip.empty? }
    tally.sort_by { |_, v| -v }.to_h
  end

  def self.count_extensions(dir)
    out, _, status = Open3.capture3("git", "-C", dir, "ls-files")
    raise Error, "git ls-files failed" unless status.success?

    tally = Hash.new(0)
    out.each_line do |path|
      path = path.chomp
      next if path.empty?
      ext = File.extname(path).sub(/^\./, "").downcase
      ext = "(no ext)" if ext.empty?
      begin
        lines = File.foreach(File.join(dir, path)).count
      rescue StandardError
        lines = 0
      end
      tally[ext] += lines
    end
    tally.sort_by { |_, v| -v }.to_h
  end

  def self.date_range(dir)
    first, _, s1 = Open3.capture3("git", "-C", dir, "log", "--reverse", "--format=%as", "-n", "1")
    last, _, s2 = Open3.capture3("git", "-C", dir, "log", "--format=%as", "-n", "1")
    [s1.success? ? first.strip : nil, s2.success? ? last.strip : nil]
  end

  class Error < StandardError; end
end
