require "minitest/autorun"
require "tmpdir"
require "fileutils"
$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))
require "gitsum"

class TestGitsum < Minitest::Test
  def setup
    @dir = Dir.mktmpdir("gitsum-test-")
    Dir.chdir(@dir) do
      system("git init -q -b main", out: File::NULL, err: File::NULL)
      system("git config user.email a@example.com")
      system("git config user.name A")

      File.write("hello.rb", "puts 'hi'\nputs 'there'\n")
      File.write("notes.md", "# doc\n\nsome text here.\n")
      system("git add -A", out: File::NULL)
      system("git commit -q -m 'first'", out: File::NULL)

      system("git config user.email b@example.com")
      system("git config user.name B")
      File.write("more.rb", "x = 1\n")
      system("git add more.rb")
      system("git commit -q -m 'second'", out: File::NULL)

      # A again, one more commit
      system("git config user.email a@example.com")
      system("git config user.name A")
      File.write("final.rb", "y = 2\n")
      system("git add final.rb")
      system("git commit -q -m 'third'", out: File::NULL)
    end
  end

  def teardown
    FileUtils.rm_rf(@dir)
  end

  def test_detects_git_repo
    assert Gitsum.git_repo?(@dir)
  end

  def test_rejects_non_repo
    Dir.mktmpdir do |plain|
      refute Gitsum.git_repo?(plain)
    end
  end

  def test_scan_counts_commits
    report = Gitsum.scan(@dir)
    assert_equal 3, report.total_commits
  end

  def test_scan_counts_authors
    report = Gitsum.scan(@dir)
    assert_equal 2, report.authors["A"]
    assert_equal 1, report.authors["B"]
  end

  def test_scan_orders_authors_desc
    report = Gitsum.scan(@dir)
    assert_equal "A", report.authors.keys.first
  end

  def test_scan_counts_lines_by_ext
    report = Gitsum.scan(@dir)
    # hello.rb(2) + more.rb(1) + final.rb(1) = 4 ruby lines
    assert_equal 4, report.extensions["rb"]
    # notes.md = 3 lines
    assert_equal 3, report.extensions["md"]
  end

  def test_scan_date_range_present
    report = Gitsum.scan(@dir)
    refute_nil report.first_commit
    refute_nil report.last_commit
  end

  def test_scan_raises_on_non_repo
    Dir.mktmpdir do |plain|
      assert_raises(Gitsum::Error) { Gitsum.scan(plain) }
    end
  end
end
