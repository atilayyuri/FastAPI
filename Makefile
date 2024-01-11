VENV = venv
PY = python3
PYTHON:=$(VENV)/bin/python3
PYTHON_CHECK:=$(shell command -v python3 2> /dev/null)
BIN=$(VENV)/bin
APPNAME:=app
REQUIREMENTS:=./$(APPNAME)/requirements.txt

.DEFAULT_GOAL = help
help: ##		Displays this message
	@echo "----------------------------HELP------------------------------"
	@echo "--------------------------------------------------------------"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep |  sed -e 's/\\$$//' | sed -e 's/##		/\n	/'
	@echo "--------------------------------------------------------------"
	@echo "--------------------------------------------------------------"

check-setup: ##		Checks local installations to develop, build and deploy the application
ifndef PYTHON_CHECK
	@echo "Please install python 3.6 or higher"
	@echo "Make sure that python3 executable is defined in the PATH variable"
endif


# make it work on windows too
ifeq ($(OS), Windows_NT)
	BIN=$(VENV)/Scripts
	PY=python
endif


all: lint test

$(VENV): $(REQUIREMENTS)
	$(PY) -m venv $(VENV)
	$(BIN)/pip install --upgrade pip

install: $(VENV) ## Install project dependencies
	$(BIN)/pip install -r $(REQUIREMENTS)
	@. $(BIN)/activate

update: $(VENV) ## Update project dependencies
	$(BIN)/pip install --upgrade -r $(REQUIREMENTS)

activate: ## Activate the virtual environment
	@. $(BIN)/activate

clean:
	rm -rf $(VENV)
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete

update-req:
	$(BIN)/pip freeze > $(REQUIREMENTS)

run:
	$(BIN)/uvicorn main:$(APPNAME) --app-dir $(APPNAME) --reload 

# $(VENV): $(REQUIREMENTS)
# 	$(PY) -m venv $(VENV)
# 	$(BIN)/pip install --upgrade -r $(REQUIREMENTS)
# 	$(BIN)/pip install -e .
# 	touch $(VENV)

lint: isort black mypy flake8 bandit

.PHONY: isort
isort:
	$(PYTHON) -m isort --check-only .

.PHONY: black
black:
	$(PYTHON) -m black .

.PHONY: mypy
mypy:
	$(PYTHON) -m mypy .

.PHONY: flake8
flake8:
	$(PYTHON) -m flake8 $(APPNAME)

.PHONY: bandit
bandit:
	$(PYTHON) -m bandit -r $(APPNAME)

.PHONY: test
test:
	$(BIN)/pytest

.PHONY: release
release:
	$(PYTHON) setup.py sdist bdist_wheel upload



