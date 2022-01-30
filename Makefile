SHELL := /bin/bash
DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

docker-build:  ## Build the Docker image used in this project
	cp ~/.netrc .;
	docker build . --progress tty -t udacity/mlops_tests:latest ;
	rm .netrc

bash:  ## Open an interactive terminal in Docker container
	docker-compose \
	-p mlops \
	-f docker-compose.yml \
	run --rm mlops

download-model:  ## Download model from Wandb
	docker-compose \
	-p download-model \
	-f docker-compose.yml \
	run --rm download-model

download-data:  ## Download test data to batch predict
	docker-compose \
	-p download-data \
	-f docker-compose.yml \
	run --rm download-data

offline-inference:  ## Run offline inference on the test set
	docker-compose \
	-p offline-inference \
	-f docker-compose.yml \
	run --rm offline-inference

online-inference:  ## Run online inference on the test set
	docker-compose \
	-p online-inference \
	-f docker-compose.yml \
	run --service-ports --rm online-inference
