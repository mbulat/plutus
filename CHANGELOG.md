# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Changed
- Tenancy is enabled from the get go. Assigning a tenant is optional. See "Previous Versions" in the README on upgrading.
- Required jquery-ui version
- How migrations are done, which may be a breaking change from older versions of Plutus

### Fixed
- Fix loading of jquery-ui files (Fixes https://github.com/mbulat/plutus/issues/58)

### Added
- Add `Account#amounts` and `Account#entries` to get all amounts and entries, respectively
