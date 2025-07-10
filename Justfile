set dotenv-load := true
set unstable := true

# Lists all available commands.
@help:
    just --list

# Run cog against necessary documentation files.
@_cog:
    uvx --from cogapp cog -r README.md
    uvx --from cogapp cog -r CONTRIBUTING.md

# ---------------------------------------------- #
# Script to rule them all recipes.               #
# ---------------------------------------------- #

# Install pre-commit hooks
[script]
_install-pre-commit: _check-pre-commit
    if [[ ! -f .git/hooks/pre-commit ]]; then
      echo "Pre-commit hooks are not installed yet! Doing so now."
      pre-commit install
    fi
    exit 0

# Downloads and installs uv on your system.
[group('uv')]
[linux]
[macos]
[script]
[unix]
uv-install:
    if ! command -v uv &> /dev/null;
    then
      echo "uv is not found on path! Starting install..."
      curl -LsSf https://astral.sh/uv/install.sh | sh
    else
      uv self update
    fi

# Downloads and installs uv on your system
[group('uv')]
[script]
[windows]
uv-install:
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# Update uv
[group('uv')]
uv-update:
    uv self update

# Uninstall uv
[group('uv')]
uv-uninstall:
    uv self uninstall

[script]
_check-pre-commit:
    if ! command -v pre-commit &> /dev/null; then
      echo "Pre-commit is not installed!"
      exit 1
    fi

[script]
_check-env:
    if [[ -z "$DJANGO_DEBUG" ]]; then
      echo "DJANGO_DEBUG is not set and application will run in production mode." >&2
    fi

# Setup the project and update dependencies.
[group('lifecycle')]
bootstrap: uv-install _install-pre-commit _check-env
    uv sync
    just manage migrate

# Checks that project is ready for development.
_check: _check-env _check-pre-commit
    #!/usr/bin/env bash
    if ! command -v uv &> /dev/null; then
      echo "UV is not installed!"
      exit 1
    fi
    if [[ ! -f ".venv/bin/python" ]]; then
      echo "Virtualenv is not installed! Run 'just bootstrap' to complete setup."
      exit 1
    fi

# Run tests, check types, perform linting, and security checks.
[group('qa')]
@check-all: _check test lint check-types safety
    echo "All checks complete!"

# Check types
[group('qa')]
check-types: _check
    uv run pyright

# Run a devserver and worker cluster
[group('run')]
server:
    #!/usr/bin/env bash
    DJANGO_SETTINGS_MODULE="tests.settings" PYTHONPATH="$PYTHONPATH:$(pwd)" uv run django-admin runserver

# Run just formatter and ruff formatter.
[group('qa')]
fmt: _check
    just --fmt --unstable
    uv run -m ruff format

# Run ruff linting
[group('qa')]
lint *ARGS: _check
    uv run ruff check {{ ARGS }} src

# Run the test suite
[group('qa')]
test *ARGS: _check
    uv run -m pytest {{ ARGS }}

# Run tox for code style, type checking, and multi-python tests. Uses run-parallel.
[group('qa')]
tox *ARGS: _check
    uvx --python 3.12 --with tox-uv tox run-parallel {{ ARGS }}

# Runs bandit safety checks.
[group('qa')]
safety: _check
    uv run -m bandit -c pyproject.toml -r src

# Access Django management commands.
[group('run')]
[script('bash')]
manage *ARGS: _check
    DJANGO_SETTINGS_MODULE="tests.settings" PYTHONPATH="$PYTHONPATH:$(pwd)" uv run django-admin {{ ARGS }}

# Access mkdocs commands
[group('lifecycle')]
@docs *ARGS: _check
    uv run --no-sync mike {{ ARGS }}

# Build Python package
[group('lifecycle')]
@build *ARGS: _check
    uv build {{ ARGS }}

# Removes pycache directories and files.
_pycache-remove:
    find . | grep -E "(__pycache__|\.pyc|\.pyo$$)" | xargs rm -rf

# Remove generated builds.
_build-remove:
    rm -rf dist/*

# Remove generated docs
_docs-clean:
    rm -rf site/*

# Remove qa caches
_qa-cache-clean:
    rm -rf .ruff_cache .pytest_cache

# Remove generated virtualenvs
_venv-clean:
    rm -rf .venv .tox

# Removes pycache directories and files, and generated builds.
[group('lifecycle')]
clean: _pycache-remove _build-remove _docs-clean _qa-cache-clean

# Destroy and recreate environment from scratch.
[group('lifecycle')]
fresh: clean _venv-clean && bootstrap
    @echo "Removed old environments and caches! Recreating..."
