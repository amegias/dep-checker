# DepChecker
DepChecker is a tool for analyzing XCode / SPM project dependencies in order to detect outdated dependencies.
This application reads the project and queries repositories (GitHub, Bitbucket, etc) to get the latest versions of each one and compare them with the current ones in the project.
It can be run from the command line (CLI) or integrated as an MCP server.

## CLI

### Arguments

#### In-line

- `project-path`: Path to the project. It should point to the xcodeproj or Package.swift folder (required).
- `output-format`: Prints the result in `json` or `table` format (optional).
- `github-token`: GitHub token for retrieving data related to GitHub dependencies (optional).
- `resolved-package-path`: Path to the Package.resolved folder. It will help to get the exact version of the resolved dependencies (optional).
- `max-days`: Maximum number of days to consider a package as outdated. If it is not nil and some dependency is outdated `> max-days`, the execution will fail (optional).
- `exclude-dependencies`: List of dependencies to exclude from the analysis (optional).
- `include-dependencies`: List of dependencies to include in the analysis (optional).
- `includeTransitiveDependencies`: Gets also the transitive dependencies found in resolved package files.
- `configuration-file`: Path to the configuration file (optional). Check [the possible values](./Sources/CLIInput/FileInput.swift).

#### Configuration file (optional)
The parameters specified in-line take precedence over these.

```json
{
  "gitHubToken": "anyToken", // Optional
  "maxDays": 365,  // Optional
  "maxDaysPerDependency" {  // Optional
    "anyDependencyName": 100
  }
}
```

### Usage
#### Mint

```sh
mint run --executable dep-checker amegias/ios-dep-checker [--output-format <output-format>] [--configuration-file <configuration-file>] [--github-token <github-token>] --project-path <project-path> [--resolved-package-path <resolved-package-path>] [--max-days <max-days>] [--exclude-dependencies <exclude-dependencies> ...] [--include-dependencies <include-dependencies> ...] [--include-transitive-dependencies]
```

#### Swift

```sh
swift run -c release dep-checker [--output-format <output-format>] [--configuration-file <configuration-file>] [--github-token <github-token>] --project-path <project-path> [--resolved-package-path <resolved-package-path>] [--max-days <max-days>] [--exclude-dependencies <exclude-dependencies> ...] [--include-dependencies <include-dependencies> ...] [--include-transitive-dependencies]
```

#### GitHub Action
You can also integrate DepChecker into your GitHub workflow by using the following GitHub Actions configuration:

```yaml
name: DepChecker

on:
  workflow_dispatch:

jobs:
  check:
  name: Run DepChecker tool
  runs-on: macos-latest

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
      swift run -c release dep-checker --project-path ../MyProject/ --github-token ${{ secrets.GITHUB_TOKEN }} --max-days 365
```

## MCP Server

This tool is also available as an MCP server for AI clients that comply with the protocol.

### Arguments

#### In-line

- `configuration-file`: Path to the configuration file (optional). Check [the possible values](./Sources/MCPServerInput/FileInput.swift).

#### Configuration file (optional)

```json
{
  "gitHubToken": "anyToken", // Optional
}
```

#### Environment vars (optional)
```sh
GH_TOKEN=anyToken
```

### VS Code + Copilot (or similar)
1. Open `mcp.json` config file.
2. Add the `dep-checker-mcp` as a new MCP.
```json
{
  "servers": {
    "dep-checker-mcp": {
      "command": "mint",
      "args": [
        "run",
        "amegias/ios-dep-checker",
        "dep-checker-mcp",
        "--configuration-file ~/.depChecker/config.json"  // Optional
      ],
      "env": {
        "GH_TOKEN": "any" // Optional
      }
    }
  }
}
```

## Contributing

We welcome contributions!

## Contact

For any questions or feedback, please open an issue.
