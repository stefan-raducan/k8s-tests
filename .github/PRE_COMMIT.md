# Pre-commit Setup

This repository uses [pre-commit](https://pre-commit.com/) to automatically check code quality before commits.

## What's Checked

✅ **Secret Detection** - Prevents committing API keys, passwords, tokens
✅ **Python Formatting** - Black, isort, flake8
✅ **Type Checking** - mypy (static type analysis)
✅ **YAML Formatting** - Prettier
✅ **Dockerfile Linting** - Hadolint
✅ **General Checks** - Trailing whitespace, large files, merge conflicts

## Installation

Pre-commit is already installed in this repo. The hooks will run automatically on `git commit`.

### Quick Setup

Install all development dependencies:

```bash
pip install -r requirements-dev.txt
python3 -m pre_commit install
```

### Manual Installation (if needed)

```bash
# Install pre-commit only
pip install pre-commit

# Install the git hooks
python3 -m pre_commit install
```

## Usage

### Automatic (on commit)

Pre-commit runs automatically when you commit:

```bash
git add .
git commit -m "your message"
# Pre-commit hooks run automatically
```

### Manual Run

Run on all files:

```bash
python3 -m pre_commit run --all-files
```

Run on staged files only:

```bash
python3 -m pre_commit run
```

## Secret Detection

The repo uses `detect-secrets` to prevent committing sensitive data.

### Initial Baseline

Create/update the secrets baseline:

```bash
pip install detect-secrets
detect-secrets scan --baseline .secrets.baseline
```

### If Secrets Are Detected

If pre-commit blocks a commit due to detected secrets:

1. **Remove the secret** from your code
2. Use environment variables or secret management instead
3. If it's a false positive, audit and update the baseline:

```bash
detect-secrets audit .secrets.baseline
```

## Skipping Hooks (Emergency Only)

To skip pre-commit hooks (not recommended):

```bash
git commit --no-verify -m "emergency fix"
```

## Updating Hooks

Update to latest versions:

```bash
python3 -m pre_commit autoupdate
```
