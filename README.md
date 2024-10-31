# Django Prune Media

A Django app that provides management commands for pruning unused media files.

[![PyPI](https://img.shields.io/pypi/v/django-prune-media)](https://pypi.org/project/django-prune-media/)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/django-prune-media)
![PyPI - Versions from Framework Classifiers](https://img.shields.io/pypi/frameworkversions/django/django-prune-media)
[![Black code style](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/ambv/black)
[![Pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/andrlik/django-prune-media/blob/main/.pre-commit-config.yaml)
[![License](https://img.shields.io/github/license/andrlik/django-prune-media)](https://github.com/andrlik/django-prune-media/blob/main/LICENSE)
[![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json)](https://github.com/astral-sh/uv)
[![Ruff](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json)](https://github.com/astral-sh/ruff)
[![Security: bandit](https://img.shields.io/badge/security-bandit-green.svg)](https://github.com/PyCQA/bandit)
[![Checked with pyright](https://microsoft.github.io/pyright/img/pyright_badge.svg)](https://microsoft.github.io/pyright/)
[![Semantic Versions](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--versions-e10079.svg)](https://github.com/andrlik/django-prune-media/releases)
![Test results](https://github.com/andrlik/django-prune-media/actions/workflows/ci.yml/badge.svg)
[![Coverage Status](https://coveralls.io/repos/github/andrlik/django-prune-media/badge.svg?branch=main)](https://coveralls.io/github/andrlik/django-prune-media?branch=main)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue)](https://andrlik.github.io/django-prune-media/)

## Why another app for this?

Most of the apps I've found operate from the assumption that you are using Django's FileSystemStorage
which is often not the case in production. This application solely uses the Django Storage API, which means
it works for custom backends like Django Storages too.

## Installation

```bash
uv add django-prune-media
```

Add it to your settings.py.

```python
INSTALLED_APPS = [..., "prune_media", ...]
```

Usage:

To list or delete the media to be pruned:

```bash
python manage.py prune_media --help

 Usage: django-admin prune_media [OPTIONS]

 Remove unreferenced media files to save space.

╭─ Options ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --no-interaction    --no-no-interaction      Don't ask for confirmation before deleting. [default: no-no-interaction]             │
│ --dry-run           --no-dry-run             Do a dry-run without deleting anything. [default: no-dry-run]                        │
│ --help                                       Show this message and exit.                                                          │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Django ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --version                  Show program's version number and exit.                                                                │
│ --settings           TEXT  The Python path to a settings module, e.g. "myproject.settings.main". If this isn't provided, the      │
│                            DJANGO_SETTINGS_MODULE environment variable will be used.                                              │
│ --pythonpath         PATH  A directory to add to the Python path, e.g. "/home/djangoprojects/myproject". [default: None]          │
│ --traceback                Raise on CommandError exceptions                                                                       │
│ --no-color                 Don't colorize the command output.                                                                     │
│ --force-color              Force colorization of the command output.                                                              │
│ --skip-checks              Skip system checks.                                                                                    │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
```

Or to find empty directories:

```bash
python manage.py show_empty_media_dirs

Usage: django-admin show_empty_media_dirs [OPTIONS]

 List empty media directories.
 The storage API does not support deletion of directories but at least this way you know what can be removed.

╭─ Options ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --clean    --no-clean      Print paths only so they can be piped to other commands [default: no-clean]                            │
│ --help                     Show this message and exit.                                                                            │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯
╭─ Django ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ --version                  Show program's version number and exit.                                                                │
│ --settings           TEXT  The Python path to a settings module, e.g. "myproject.settings.main". If this isn't provided, the      │
│                            DJANGO_SETTINGS_MODULE environment variable will be used.                                              │
│ --pythonpath         PATH  A directory to add to the Python path, e.g. "/home/djangoprojects/myproject". [default: None]          │
│ --traceback                Raise on CommandError exceptions                                                                       │
│ --no-color                 Don't colorize the command output.                                                                     │
│ --force-color              Force colorization of the command output.                                                              │
│ --skip-checks              Skip system checks.                                                                                    │
╰───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

```
