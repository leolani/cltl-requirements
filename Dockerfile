# syntax = docker/dockerfile:1.2

FROM python:3.9

SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        build-essential \
        zlib1g-dev \
        wget \
        unzip \
        cmake \
        gfortran \
        libblas-dev \
        liblapack-dev \
        libatlas-base-dev \
    && apt-get clean

WORKDIR /repo
COPY requirements.txt makefile ./
COPY leolani ./leolani

RUN --mount=type=cache,mode=0755,target=/root/.cache/pip \
        pwd && ls -la && make