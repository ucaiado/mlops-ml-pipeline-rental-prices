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
	-f docker-compose.yml \
	run --rm -w /opt mlops \
	bash scripts/linter-code.sh steps/src/train_random_forest/*.py

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

perform-eda:  ## Start jupyter notebook
	docker-compose \
	-p perform-eda \
	-f docker-compose.yml \
	run  --service-ports  --rm perform-eda

basic-cleaning:  ## Perform the basic cleaning step
	docker-compose \
	-p basic-cleaning \
	-f docker-compose.yml \
	run --rm basic-cleaning

data-check:  ## Perform some tests on the dataset
	docker-compose \
	-p data-check \
	-f docker-compose.yml \
	run --rm data-check

data-split:  ## Split the dataset to use in ML pipeline
	docker-compose \
	-p data-split \
	-f docker-compose.yml \
	run --rm data-split

train-model:  ## Train a Random Forest
	docker-compose \
	-p train-model \
	-f docker-compose.yml \
	run --rm train-model

optimize-hyperparams:  ## Optimize model hyperparameters
	docker-compose \
	-p optimize-hyperparams \
	-f docker-compose.yml \
	run --rm optimize-hyperparams

test-model:  ## Tests the model selected
	docker-compose \
	-p test-model \
	-f docker-compose.yml \
	run --rm test-model