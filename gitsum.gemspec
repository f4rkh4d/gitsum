require_relative "lib/gitsum"

Gem::Specification.new do |s|
  s.name = "gitsum"
  s.version = Gitsum::VERSION
  s.summary = "quick stats about a git repo — commits per author, lines per file type"
  s.description = "a tiny command-line tool that shells out to git and gives you a readable breakdown of who wrote what and which file types dominate. zero dependencies."
  s.authors = ["farkhad"]
  s.email = ["bennett@frkhd.com"]
  s.homepage = "https://github.com/f4rkh4d/gitsum"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.6.0"
  s.files = Dir["lib/**/*.rb", "bin/*", "README.md", "LICENSE"]
  s.executables = ["gitsum"]
  s.bindir = "bin"
  s.metadata = {
    "source_code_uri" => "https://github.com/f4rkh4d/gitsum",
    "bug_tracker_uri" => "https://github.com/f4rkh4d/gitsum/issues",
  }
  s.add_development_dependency "minitest", "~> 5.0"
end
