#* Variables
SHELL := /usr/bin/env bash
PYTHON := python


#* Installation

.PHONY: install
install:
	poetry install -n
	yarn

.PHONY: pre-commit-install
pre-commit-install:
	poetry run pre-commit install

.PHONY: migrate
migrate:
	poetry run python manage.py migrate

.PHONY: bootstrap
bootstrap: install pre-commit-install migrate
	touch app/settings/local.py

#* Formatters

.PHONY: codestyle
codestyle:
	poetry run pyupgrade --exit-zero-even-if-changed --py38-plus **/*.py
	poetry run isort --settings-path pyproject.toml ./
	poetry run black --config pyproject.toml ./
	yarn prettier --write .

.PHONY: formatting
formatting: codestyle


#* Linting

.PHONY: test
test:
	poetry run pytest -vs -m "not integration_test"
	yarn test

.PHONY: check-codestyle
check-codestyle:
	poetry run isort --diff --check-only --settings-path pyproject.toml ./
	poetry run black --diff --check --config pyproject.toml ./
	poetry run darglint --docstring-style google --verbosity 2 pyck
	yarn tsc --noemit
	yarn prettier --check .

.PHONY: check-safety
check-safety:
	poetry check
	poetry run safety check --full-report
	poetry run bandit -ll --recursive pyck tests

.PHONY: lint
lint: check-codestyle check-safety test

.PHONY: ci
ci: lint
	poetry run pytest
	yarn test


#* Assets

.PHONY: build
build:
	yarn vite build
	SECRET_KEY=dummy poetry run python manage.py collectstatic --noinput --clear

.PHONY: release
	release: migrate


#* Cleaning

.PHONY: pycache-remove
pycache-remove:
	find . | grep -E "(__pycache__|\.pyc|\.pyo$$)" | xargs rm -rf

.PHONY: build-remove
build-remove:
	rm -rf build/ dist/ docs/api/ docs/components/ temp/

.PHONY: clean-all
clean-all: pycache-remove build-remove
