# Internal
setup-xcbeautify:
	@echo "Setting up xcbeautify..."
	@command -v xcbeautify >/dev/null 2>&1 || brew install xcbeautify

# Main jobs

scan_dead_code:
	@echo "Setting up periphery..."
	@command -v periphery >/dev/null 2>&1 || brew install periphery
	periphery scan --strict

format:
	swift package plugin --allow-writing-to-package-directory swiftformat

build-release:
	@echo "Building release..."
	swift build -c release
	@echo "Done in .build/arm64-apple-macosx/release/"

tests: setup-xcbeautify
	@echo "Running tests..."
	swift test | xcbeautify

tests-ci:
	@echo "Running tests in CI..."
	swift test

# MCP
build-mcp:
	swift build --product dep-checker-mcp

debug-mcp: build-mcp
	npx @modelcontextprotocol/inspector $(shell pwd)/.build/arm64-apple-macosx/debug/dep-checker-mcp --configuration-file "~/.depChecker/config.json"