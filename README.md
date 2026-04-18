# gitsum

quick stats about a git repo. who wrote what, which file types dominate.

```bash
gitsum
```

```
repo:   /Users/you/myproject
span:   2024-01-05 → 2026-04-18
commits: 412

authors (top 10):
  alice                      201   48.8%  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
  bob                        150   36.4%  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
  claire                      61   14.8%  ▇▇▇▇▇▇▇

lines by extension (top 10):
  rb         14520    62.4%
  md          3200    13.7%
  yml         1841     7.9%
```

no gems, no config. just shells out to `git`.

## install

```bash
gem install gitsum
```

## usage

```bash
gitsum                     # current dir
gitsum path/to/repo        # somewhere else
gitsum --top 5             # show only top 5 authors + extensions
gitsum --json              # machine-readable
gitsum --version
```

exits 1 if the path isn't a git repo, 0 otherwise.

## license

mit.
