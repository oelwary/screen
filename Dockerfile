FROM debian:jessie

RUN apt-get update && apt-get install -y \
    git \
    curl \
    jq \
    vim \
    default-jdk   


# download and setup Apache pig
WORKDIR /opt
RUN curl http://apache.claz.org/pig/pig-0.17.0/pig-0.17.0.tar.gz --output pig-0.17.0.tar.gz
RUN gunzip pig-0.17.0.tar.gz
RUN tar vxf pig-0.17.0.tar
RUN ln -s /opt/pig-0.17.0 /opt/pig

WORKDIR /root

# Copy apache pig scripts and runner scripts into image
RUN mkdir scripts
COPY scripts/* scripts/


RUN ["/bin/bash", "-c", "mkdir data && cd data && while read i; do git clone $i; done < <(curl -s https://api.github.com/orgs/datasets/repos?per_page=100 | jq -r '.[].clone_url')"]

# Copy setup script into the image. This script moves files from all 
# data folders they were cloned into to a single data folder that
# apache pig can read
COPY move_files move_files
RUN chmod +x move_files

# Setup folder to contain all CSV files.
RUN mkdir data_flat

# copy all CSV files to "flat" folder
RUN find data -type f -name '*.csv' -exec ./move_files {} \;


# Create a volume to be used for writing out results thus the
# output of scripts is reserved after the container exist
VOLUME ["/results_export"]


