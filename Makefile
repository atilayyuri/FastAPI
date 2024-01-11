# system python interpreter. used only to create virtual environment
PY = python3
VENV = venv
BIN=$(VENV)/bin
PYTHON3:=$(shell command -v python3 2> /dev/null)
REQUIREMENTS:=./app/requirements.txt

.DEFAULT_GOAL = help
help: ##		Displays this message
	@echo "----------------------------HELP------------------------------"
	@echo "--------------------------------------------------------------"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep |  sed -e 's/\\$$//' | sed -e 's/##		/\n	/'
	@echo "--------------------------------------------------------------"
	@echo "--------------------------------------------------------------"

check-setup: ##		Checks local installations to develop, build and deploy the application
ifndef PYTHON3
	@echo "Please install python 3.6 or higher"
	@echo "Make sure that python3 executable is defined in the PATH variable"
endif


# make it work on windows too
ifeq ($(OS), Windows_NT)
	BIN=$(VENV)/Scripts
	PY=python
endif


all: lint test


update: $(VENV) ## Update project dependencies
	$(BIN)/pip install --upgrade -r $(REQUIREMENTS)

activate: ## Activate the virtual environment
	@. $(BIN)/activate


install: $(VENV) ## Install project dependencies
	$(BIN)/pip install -r $(REQUIREMENTS)
	@. $(BIN)/activate

clean:
	rm -rf $(VENV)
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete

$(VENV): $(REQUIREMENTS)
	$(PY) -m venv $(VENV)
	$(BIN)/pip install --upgrade pip

# $(VENV): $(REQUIREMENTS)
# 	$(PY) -m venv $(VENV)
# 	$(BIN)/pip install --upgrade -r $(REQUIREMENTS)
# 	$(BIN)/pip install -e .
# 	touch $(VENV)

.PHONY: test
test: $(VENV)
	$(BIN)/pytest

.PHONY: lint
lint: $(VENV)
	$(BIN)/flake8

.PHONY: release
release: $(VENV)
	$(BIN)/python setup.py sdist bdist_wheel upload

