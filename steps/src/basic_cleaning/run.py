#!/usr/bin/env python
"""
Download from W&B the raw dataset and apply some basic data cleaning, exporting
the result to a new artifact
"""
import os
import argparse
import logging
import wandb
import pandas as pd


logging.basicConfig(level=logging.INFO, format="%(asctime)-15s %(message)s")
logger = logging.getLogger()


def basic_cleaning(args: argparse.Namespace) -> None:
    '''
    pPerform basic data cleaning in raw data recovered from W&B

    Parameters
    ----------
    args :  argparse.Namespace
        Argument to use to clean the data.

    Returns
    -------
    None
    '''
    run = wandb.init(job_type="basic_cleaning")
    run.config.update(args)

    # Download input artifact. This will also log that this script is using this
    # particular version of the artifact
    logger.info("Loading data")
    artifact_local_path = run.use_artifact(args.input_artifact).file()
    df_data = pd.read_csv(artifact_local_path)

    # Drop outliers from prices
    logger.info("Fixing price values")
    idx = df_data['price'].between(args.min_price, args.max_price)
    df_data = df_data[idx]

    # Drop outliers from minimum_nights
    logger.info("Fixing minimum_nights values")
    idx = df_data['minimum_nights'].between(args.min_days, args.max_days)
    df_data = df_data[idx]

    # Convert last_review to datetime
    logger.info("Converting last_review to datetime")
    df_data['last_review'] = pd.to_datetime(df_data['last_review'])

    # Upload data to W&B as a new artifact
    logger.info("Saving file")
    filename = "clean_sample.csv"
    df_data.to_csv(filename, index=False)

    artifact = wandb.Artifact(
        name=args.output_artifact,
        type=args.output_type,
        description=args.output_description,
    )
    artifact.add_file(filename)

    logger.info("Logging artifact")
    run.log_artifact(artifact)

    os.remove(filename)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="A very basic data cleaning")

    parser.add_argument(
        "--input_artifact",
        type=str,
        help="Name of the input artifact stored in W&B",
        required=True
    )

    parser.add_argument(
        "--output_artifact",
        type=str,
        help="Name for the outpit artifact after basic cleaning",
        required=True
    )

    parser.add_argument(
        "--output_type",
        type=str,
        help="Type for the output artifact",
        required=True
    )

    parser.add_argument(
        "--output_description",
        type=str,
        help="Short description of the output artifact",
        required=True
    )

    parser.add_argument(
        "--min_price",
        type=float,
        help="Lower bound value of property prices",
        required=True
    )

    parser.add_argument(
        "--max_price",
        type=float,
        help="Upper bound value of property prices",
        required=True
    )

    parser.add_argument(
        "--min_days",
        type=int,
        help="Lower bound value of minimum_nights in days",
        required=True
    )

    parser.add_argument(
        "--max_days",
        type=int,
        help="Lower bound value of minimum_nights in days",
        required=True
    )

    this_args = parser.parse_args()

    basic_cleaning(this_args)
