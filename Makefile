SHELL := /bin/bash
DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-build:  ## Build the Docker image used in this project
	cp ~/.netrc .;
	docker build . --progress tty -t udacity/mlops_tests:latest ;
	rm .netrc

list-mlflow-envs:  ## Get a list of the MlFlow environments to remove
	@conda info --envs | grep mlflow | cut -f1 -d" " ;

clean-mlflow-envs:  ## Clean conda environments created using MlFlow
	@for e in $(conda info --envs | grep mlflow | cut -f1 -d" "); do conda uninstall --name $e --all -y;done ;

linter:  ## Lint library files
	docker-compose \
	-p mlops \
	-f docker-compose \
	run --rm -w /opt mlops \
	bash scripts/linter-code.sh src/*.py

bash:  ## Open an interactive terminal in Docker container
	docker-compose \
	-p mlops \
	-f docker-compose.yml \
	run --rm mlops

download-data:  ## Execute Download step
	docker-compose \
	-p download-data \
	-f docker-compose.yml \
	run --rm download-data