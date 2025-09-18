# DepChecker

DepChecker is a tool designed to help Swift developers analyze project dependencies. It checks the dependencies used in a project, identifies outdated packages and suggests updates.

## Features

- Analyze project dependencies
- Identify outdated packages
- Suggest updates for dependencies

## Usage

### Locally

To analyze the dependencies of your project, run:

```sh
swift run -c release dep-checker [--output-format <output-format>] [--configuration-file <configuration-file>] [--git-hub-token <git-hub-token>] --project-path <project-path> [--resolved-package-path <resolved-package-path>] [--max-days <max-days>] [--exclude-dependencies <exclude-dependencies> ...] [--include-dependencies <include-dependencies> ...] [--include-transitive-dependencies]
```

#### Params

- `output-format`: Prints the result in `json` or `table` format (optional).
- `configuration-file`: Path to the configuration file (optional). Check [the possible values](/Sources/Input/Models/FileInput.swift).
- `git-hub-token`: GitHub token for retrieving data related to GitHub dependencies (optional)
- `project-path`: Path to the project. It should point to the xcodeproj or Package.swift folder (required)
- `resolved-package-path`: Path to the Package.resolved folder. It will help to get the exact version of the resolved dependencies (optional)
- `max-days`: Maximum number of days to consider a package as outdated. If it is not nil and some dependency is outdated `> max-days`, the execution will fail. (optional)
- `exclude-dependencies`: List of dependencies to exclude from the analysis (optional)
- `include-dependencies`: List of dependencies to include in the analysis (optional)
- `includeTransitiveDependencies`: Gets also the transitive dependencies found in resolved package files.

#### Example

```sh
swift run -c release dep-checker -c ~/.depChecker/config.json --project-path ~/Projects/my-project/
```

##### ~/.depChecker/config.json
(Parameters specified in-line take precedence over these)

```json
{
  "gitHubToken": "anyToken",
  "maxDays": 365,
  "maxDaysPerDependency" {
    "anyDependencyName": 100
  }
}
```

### GitHub Action

You can also integrate DepChecker into your GitHub workflow using the following GitHub Action configuration:

```yaml
name: DepChecker

on:
  workflow_dispatch:

jobs:
  check:
  name: Run DepChecker tool
  runs-on: macos-15

  steps:
    - name: Checkout
    # Checking out your Swift project
    uses: actions/checkout@v4

    - name: Checkout DepChecker tool
    # Checking out DepChecker in depChecker sub-folder
    uses: actions/checkout@v4
    with:
      repository: amegias/ios-dep-checker
      path: depChecker

    - name: Execute DepChecker
    # Executing depChecker from its folder
    run: |
      cd depChecker
      swift run -c release dep-checker --project-path ../MyProject/ --git-hub-token ${{ secrets.GITHUB_TOKEN }} --max-days 365
```

### Mint

```sh
mint install amegias/ios-dep-checker
dep-checker --project-path ../MyProject/ --git-hub-token ${{ secrets.GITHUB_TOKEN }} --max-days 365

```

## Contributing

We welcome contributions!

## Contact

For any questions or feedback, please open an issue.
