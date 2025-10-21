# DepChecker Architecture

The app (CLI and MCP Server) is divided into 5 modules:

```mermaid
        graph TD;
                APP@{ shape: circle }-->InputCalculator;
                subgraph 1 [Input]
                                InputCalculator-.reads.->FileInputReader@{shape: cyl};
                end

                APP-->ProjectAnalyzer;
                subgraph 2 [Analysis]
                                ProjectAnalyzer-->FileFinder@{shape: cyl};
                                ProjectAnalyzer--has serveral-->Analyzer;
                                ProjectAnalyzer-->DependencyMerger;
                end

                APP-->DependencyChecker;
                subgraph 3 [Check]
                                DependencyChecker-->RepositoryMatcherFactory;
                                RepositoryMatcherFactory-.matches.->Repository@{shape: rounded };
                end

                APP-->OutputPrinter;
                subgraph 4 [Output]
                                OutputPrinter-->OutputPrinterFactory;
                                OutputPrinterFactory-.gets.->Printer@{shape: rounded };
                end

                APP-->DependencyValidator;
                subgraph 5 [Validation]
                                DependencyValidator-.gets.->CheckedDependencyValidator@{shape: rounded };
                end

                AppConfiguration@{shape: cyl}
```

## Input
This module is responsible for gathering the input values from the arguments and/or the config file.

## Analysis
This module is responsible for retrieving the external dependencies for a given project (xcodeproj or Package.swift) and a Package.resolved file (optional). After that, it returns a merged collection.

## Check
This module is responsible for resolving the current version and the latest version of each dependency. These processes are executed in parallel. If some of them fail, it does not affect the others.

## Output
This module is responsible for printing the results to the standard output depending on the format. There are two output implementations: JSON and Table. It can be extended for more formats.

## Validation
This module is responsible for validating the retrieved dependencies. If some validation fails, the app process will fail.

## `AppConfiguration`
This singleton registers the values needed for the correct execution of the app.
There are two important properties:
- `repositoryMatchers`: Contains the available repository handlers. Currently, we handle GitHub repositories and Bitbucket repositories.
- `checkedDependencyValidators`: Contains the available validators. All of them are executed to verify if any rule has not been fulfilled. We can implement any verification we consider.
