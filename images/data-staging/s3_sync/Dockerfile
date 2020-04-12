FROM ubuntu

RUN apt-get update
RUN apt-get install awscli -y
RUN mkdir ~/.aws
COPY .aws-credentials ~/.aws/credentials
COPY aws-config ~/.aws/config
COPY run.sh run.sh

ENTRYPOINT ["/bin/bash", "./run.sh"]
