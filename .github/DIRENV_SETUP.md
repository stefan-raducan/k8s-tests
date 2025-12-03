# Direnv Setup for k8s-tests

This project uses [direnv](https://direnv.net/) to automatically activate the Python virtual environment when you enter the project directory.

## What is direnv?

direnv automatically loads and unloads environment variables based on the current directory. When you `cd` into this project, it will:
- Automatically activate the Python virtual environment
- Load environment variables from `.env` (if it exists)
- Deactivate when you leave the directory

## Setup

### 1. direnv is already configured in your shell

You've already added this to `~/.zshrc`:
```bash
eval "$(direnv hook zsh)"
```

### 2. Allow direnv for this project

The `.envrc` file has been created and allowed. If you need to re-allow it:

```bash
direnv allow
```

### 3. Create virtual environment (first time only)

```bash
python3 -m venv .direnv/python-3.11
```

direnv will automatically create and manage the virtual environment in `.direnv/` directory.

### 4. Install dependencies

```bash
# direnv will auto-activate the venv
pip install -r requirements-dev.txt
pre-commit install
```

## Usage

### Automatic activation

Simply `cd` into the project directory:

```bash
cd /Users/stefan/repos/k8s-tests
# direnv: loading ~/repos/k8s-tests/.envrc
# direnv: export +VIRTUAL_ENV ~PATH
```

The virtual environment is now active! No need to manually run `source venv/bin/activate`.

### Leave the directory

```bash
cd ..
# direnv: unloading
```

The virtual environment is automatically deactivated.

### Check status

```bash
direnv status
```

## Configuration

The `.envrc` file contains:

```bash
# Use Python virtual environment
layout python python3

# Automatically load .env file if it exists
dotenv_if_exists
```

## Environment Variables (Optional)

Create a `.env` file for project-specific environment variables:

```bash
# .env (not committed to git)
KUBECONFIG=~/.kube/config
ENVIRONMENT=dev
```

These will be automatically loaded by direnv.

## Troubleshooting

### "direnv: error .envrc is blocked"

Run:
```bash
direnv allow
```

### Virtual environment not activating

Check direnv is working:
```bash
direnv status
```

Reload:
```bash
direnv reload
```

### Disable direnv temporarily

```bash
direnv deny
```

Re-enable:
```bash
direnv allow
```
