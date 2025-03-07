# Internal
setup-xcbeautify:
	@echo "Setting up xcbeautify..."
	@command -v xcbeautify >/dev/null 2>&1 || brew install xcbeautify

# Main jobs

format:
	swift package plugin --allow-writing-to-package-directory swiftformat

build-release:
	@echo "Building release..."
	swift build -c release
	@echo "Done! Check .build/arm64-apple-macosx/release/DepChecker"

tests: setup-xcbeautify
	@echo "Running tests..."
	swift test | xcbeautify

tests-ci:
	@echo "Running tests in CI..."
	swift test
