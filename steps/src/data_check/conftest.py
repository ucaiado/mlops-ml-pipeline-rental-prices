#!/usr/bin/env python
"""
Support file for pytest. Define some fixtures that can be used in all tests
"""
import pytest
import pandas as pd
import wandb


def pytest_addoption(parser):
    '''
    Define variables to pass when running tests
    '''
    parser.addoption("--csv", action="store")
    parser.addoption("--ref", action="store")
    parser.addoption("--kl_threshold", action="store")
    parser.addoption("--min_price", action="store")
    parser.addoption("--max_price", action="store")
    parser.addoption("--min_days", action="store")
    parser.addoption("--max_days", action="store")


@pytest.fixture(scope='session')
def data(request):
    '''
    Return the data referred as "data" in tests
    '''
    run = wandb.init(job_type="data_tests", resume=True)

    # Download input artifact. This will also note that this script is using this
    # particular version of the artifact
    data_path = run.use_artifact(request.config.option.csv).file()

    if data_path is None:
        pytest.fail("You must provide the --csv option on the command line")

    df_rtn = pd.read_csv(data_path)

    return df_rtn


@pytest.fixture(scope='session')
def ref_data(request):
    '''
    Return the reference data referred as "ref_data" in tests
    '''
    run = wandb.init(job_type="data_tests", resume=True)

    # Download input artifact. This will also note that this script is using this
    # particular version of the artifact
    data_path = run.use_artifact(request.config.option.ref).file()

    if data_path is None:
        pytest.fail("You must provide the --ref option on the command line")

    df_rtn = pd.read_csv(data_path)

    return df_rtn


@pytest.fixture(scope='session')
def kl_threshold(request):
    '''
    Return a float referred as "kl_threshold" in tests
    '''
    f_kl_threshold = request.config.option.kl_threshold

    if f_kl_threshold is None:
        pytest.fail("You must provide a threshold for the KL test")

    return float(f_kl_threshold)


@pytest.fixture(scope='session')
def min_price(request):
    '''
    Return a float referred as "min_price" in tests
    '''
    f_min_price = request.config.option.min_price

    if f_min_price is None:
        pytest.fail("You must provide min_price")

    return float(f_min_price)


@pytest.fixture(scope='session')
def max_price(request):
    '''
    Return a float referred as "max_price" in tests
    '''
    f_max_price = request.config.option.max_price

    if f_max_price is None:
        pytest.fail("You must provide max_price")

    return float(f_max_price)


@pytest.fixture(scope='session')
def min_days(request):
    '''
    Return a integer referred as "min_days" in tests
    '''
    i_min_days = request.config.option.min_days

    if i_min_days is None:
        pytest.fail("You must provide min_days")

    return int(i_min_days)


@pytest.fixture(scope='session')
def max_days(request):
    '''
    Return a integer referred as "max_days" in tests
    '''
    i_max_days = request.config.option.max_days

    if i_max_days is None:
        pytest.fail("You must provide max_days")

    return int(i_max_days)
