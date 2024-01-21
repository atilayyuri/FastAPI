VENV=venv
APPNAME=app
REQUIREMENTS=./$(APPNAME)/requirements.txt
REQUIREMENTS-DEV=./$(APPNAME)/requirements-dev.txt


## Make it work on multiple systems
ifeq ($(OS),Windows_NT)
	BIN=$(VENV)/Scripts
	PYTHON=$(VENV)/Scripts/python.exe
	PY=python.exe
	PIP=pip.exe
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		PYTHON=$(VENV)/bin/python
		BIN=$(VENV)/bin
		PY=python3
		PYTHON_CHECK:=$(shell command -v python3 2> /dev/null)
		VIRTUALENV:=$(shell command -v virtualenv 2> /dev/null)
		PIP_CHECK:= $(shell command -v pip 2> /dev/null)
		PIP=pip
	endif
endif

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
ifndef PIP_CHECK
	@echo "pip is not available, please install it.."
endif
ifndef VIRTUALENV
	@echo "virtualenv is not available, please install it.."
endif


all: install lint 

$(VENV): $(REQUIREMENTS)
	$(PY) -m venv $(VENV)
	$(BIN)/$(PIP) install --upgrade pip

install: $(VENV) ## Install project dependencies
	$(BIN)/$(PIP) install -r $(REQUIREMENTS)


update: $(VENV) ## Update project dependencies
	$(BIN)/$(PIP) install --upgrade -r $(REQUIREMENTS-DEV)


activate: ## Activate the virtual environment
	@. $(BIN)/activate

clean:
	rm -rf $(VENV)
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete

freeze:
	$(BIN)/pip freeze > $(REQUIREMENTS)

run:
	$(BIN)/uvicorn main:$(APPNAME) --app-dir $(APPNAME) --reload 


# check-deps:  ## Check new versions and update deps
# 	$(PYTHON) -m pur -r requirements-dev.txt -d

# update-deps:  ## Check new versions and update deps
# 	$(PYTHON) -m pur -r requirements-dev.txt

# install-deps:  ## Install dependencies
# 	$(PYTHON) -m pip install -r requirements-dev.txt


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



