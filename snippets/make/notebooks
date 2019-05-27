.PHONY: help venv jupyter-notebook jupyter-lab dist-clean
.DEFAULT_GOAL := help

define PRINT_HELP_PYSCRIPT
import re, sys

for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print("%-20s %s" % (target, help))
endef
export PRINT_HELP_PYSCRIPT

help:  ## display this help
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

venv: ./.venv/bin/python ## create the local virtual environment

jupyter-notebook: .venv/bin/python  ## run a notebook server
	.venv/bin/jupyter notebook --debug

jupyter-lab: ./.venv/bin/python  ## run a jupyterlab server
	.venv/bin/jupyter lab --debug

dist-clean:  ## remove venv files
	rm -rf .venv

.venv/bin/python:
	python3.7 -m venv ./.venv
	./.venv/bin/pip install -r requirements.txt
