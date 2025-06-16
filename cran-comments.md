## Test Environments
- Local: R 4.2.0, macOS 10.14.6
- GitHub Actions: ubuntu-latest (R-release)

## R CMD check Results
✔️ 0 errors | ✔️ 0 warnings | ⚠️ 1 note
* "installed size is 160.1Mb": This is a data package containing pre-processed French census and associated spatial data.

## Large Data Justification
- Datasets are compressed with `xz` (optimal ratio).
- Size reflects high-resolution geometries for accuracy, and detailed census for France.
- Users can load subsets via `data("dataset")` to limit memory usage.

## Downstream Dependencies
- None.
