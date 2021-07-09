SHELL = /bin/bash

project_root = $(realpath ..)
project_name = $(notdir $(realpath .))
project_version = $(shell cat version.txt)

# We use this makefile from tests
makefile_dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(makefile_dir)util/make/makefile.base.mk
include $(makefile_dir)util/make/makefile.git.mk


mirror := mirror
mirror_lock := requirements.lock
artifacts := leolani


.DEFAULT_GOAL := build


.PHONY: clean
clean:
	$(info Clean $(project_name))
	@rm -rf $(mirror) $(mirror_lock) $(artifacts) docker.lock docker.mirror.lock
	@mkdir $(mirror) $(artifacts)

$(mirror_lock): requirements.txt
	$(info Download to mirror)
	@pip download --requirement requirements.txt -d mirror \
		| grep Collecting | cut -f 2 -d ' ' > $(mirror_lock)

.PHONY:
build: $(mirror_lock) $(artifacts)

$(artifacts):
	@mkdir -p $(artifacts)


install: docker

.PHONY: docker
docker: docker.lock

docker.mirror.lock: $(mirror_lock)
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}-mirror:${project_version} -f Dockerfile.mirror .
	@echo "${project_version}" > docker.mirror.lock

docker.lock: docker.mirror.lock $(artifacts) $(wildcard $(artifacts)/*)
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}:${project_version} --build-arg image=${project_name}-mirror --build-arg version=$(shell cat docker.mirror.lock) .
	@touch docker.lock
