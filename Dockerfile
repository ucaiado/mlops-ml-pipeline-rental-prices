FROM continuumio/miniconda3:latest

RUN pip install mlflow

# Install additional python packages
COPY conda.main.yml /tmp/
RUN conda env create -f tmp/conda.main.yml && \
    rm -rf /root/.cache

# Copy aditional files
COPY .netrc /root/

# Expose port 5000
EXPOSE 5000
