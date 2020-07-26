FROM continuumio/anaconda3

RUN apt-get update
RUN apt-get -y install gcc g++

COPY environment.yml environment.yml
RUN conda env create -f environment.yml
COPY run.sh run.sh
COPY Rechunking_Zarr.ipynb Rechunking_Zarr.ipynb

ENTRYPOINT ["./run.sh"]
