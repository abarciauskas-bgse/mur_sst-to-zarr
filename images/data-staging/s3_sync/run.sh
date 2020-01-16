#!/bin/bash

export INPUT_URI=$1
export OUTPUT_URI=$2
time aws s3 sync $1 $2

