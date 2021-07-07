# syntax = docker/dockerfile:1.2

ARG image=latest
ARG version=latest

FROM cltl/${image}:${version}

COPY leolani ./leolani