# Not Released
## Fixed
- Fix loading of jquery-ui files (Fixes https://github.com/mbulat/plutus/issues/58)

## Added
- Add `Account#amounts` and `Account#entries` to get all amounts and entries, respectively

## Changed
- How migrations are done, which may be a breaking change from older versions of Plutus. When upgrading to this version, run `rake plutus:install:migrations`, and ensure that the files that are generated are of migrations you only need. It should not generate new versions if you've installed the latest version before this.
