FROM continuumio/miniconda3:latest

RUN pip install mlflow

# Install additional python packages
COPY environment.yml /tmp/
RUN conda env create -f tmp/environment.yml && \
    rm -rf /root/.cache

# Copy aditional files
COPY .netrc /root/

# Expose port 5000
EXPOSE 5000

# set up jupytext
RUN pip install --no-cache-dir jupytext && \
    pip install --no-cache-dir ipykernel && \
    pip install --no-cache-dir jupyter_contrib_nbextensions && \
    pip install --no-cache-dir jupyter_nbextensions_configurator && \
    jupyter contrib nbextension install --user && \
    jupyter nbextension install --py jupytext --user && \
    jupyter nbextension enable --py jupytext --user
