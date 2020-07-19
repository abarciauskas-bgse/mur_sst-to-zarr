FROM continuumio/anaconda3

RUN apt-get update
RUN apt-get -y install gcc g++

COPY environment.yml environment.yml
RUN conda env create -f environment.yml
COPY rechunk.py rechunk.py
COPY run.sh run.sh

ENTRYPOINT ["./run.sh"]
