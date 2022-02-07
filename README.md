Build an ML Pipeline for Short-Term Rental Prices in NYC
================


This project is part of the [ML DevOps Engineer Nanodegree](https://www.udacity.com/course/machine-learning-dev-ops-engineer-nanodegree--nd0821)
 program, from Udacity. I developed an end-to-end reusable ML pipeline to
 estimate the typical price for a given property based on the cost of similar
 properties. New data is received in bulk every week, so this pipeline can be
 used with the same cadence to retrain the model. All the experiments and files
 produced by this project were versioned with Weights & Biases, and you can
 access them [here](https://wandb.ai/ucaiado/nyc_airbnb).


### Install
To set up your environment to run the codes in this repository, start by getting
 your API key from W&B by going to [this link](https://wandb.ai/authorize) and
 click on the + icon (copy to clipboard), then paste your key into this command:

```bash
> pip install wandb
> wandb login [your API key]
```

Then, install Docker in your machine, start the Docker Desktop App and run:

```bash
> make docker-build
```


### Run
In a terminal or command window, navigate to the top-level project directory
 `mlops-ml-pipeline-rental-prices/` (that contains this README) and run the
 following command:

```bash
> make test-on-new-data
```

You can also run the pipeline step-by-step. To see the available steps, run:

```bash
> make
```
 You should see the following list:

 ```
download-data                  Execute Download step
perform-eda                    Start jupyter notebook
basic-cleaning                 Perform the basic cleaning step
data-check                     Perform some tests on the dataset
data-split                     Split the dataset to use in ML pipeline
train-model                    Train a Random Forest
optimize-hyperparams           Optimize model hyperparameters
test-model                     Tests the model selected
test-on-new-data               Tests the model on new data
 ```

### License
The contents of this repository are covered under the [MIT License](LICENSE).