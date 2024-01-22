VENV=venv
APPNAME=backend
REQUIREMENTS=./$(APPNAME)/requirements.txt
REQUIREMENTS-DEV=./$(APPNAME)/requirements-dev.txt

EXECUTABLES = python virtualenv


## Make it work on multiple systems
ifeq ($(OS),Windows_NT)
	SHELL:= pwsh -NoProfile
	BIN=.\$(VENV)\Scripts
	PYTHON=.\$(VENV)\Scripts\python.exe
	PY=python.exe
	PIP=pip.exe
	K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell where $(exec)),some string,$(error "No $(exec) in PATH")))

else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		PYTHON=$(VENV)/bin/python
		BIN=$(VENV)/bin
		PY=python3
		PIP=pip
		K := $(foreach exec,$(EXECUTABLES),\
        $(if $(shell command -v $(exec)),some string,$(error "No $(exec) in PATH")))
	endif
endif

.DEFAULT_GOAL = help
help: ##		Displays this message
	@echo "----------------------------HELP------------------------------"
	@echo "--------------------------------------------------------------"
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep |  sed -e 's/\\$$//' | sed -e 's/##		/\n	/'
	@echo "--------------------------------------------------------------"
	@echo "--------------------------------------------------------------"


all: install lint 

$(VENV): $(REQUIREMENTS)
	$(PY) -m venv $(VENV)
	$(PYTHON) -m pip install --upgrade pip
##	$(BIN)/$(PIP) install --upgrade pip

install: $(VENV) ## Install project dependencies
	$(PYTHON) -m pip install -r $(REQUIREMENTS)
##	$(BIN)/$(PIP) install -r $(REQUIREMENTS)


update: $(VENV) ## Update project dependencies
	$(BIN)/$(PIP) install --upgrade -r $(REQUIREMENTS-DEV)


activate: ## Activate the virtual environment
	@. $(BIN)/activate

clean:
	rm -rf $(VENV)
	find . -type f -name *.pyc -delete
	find . -type d -name __pycache__ -delete

clean-w:
	rmdir /s /q .\$(VENV)\

freeze:
	$(BIN)/pip freeze > $(REQUIREMENTS)

run:
	$(BIN)/uvicorn main:app --app-dir $(APPNAME) --reload 


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



