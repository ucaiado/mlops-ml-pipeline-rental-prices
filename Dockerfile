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
