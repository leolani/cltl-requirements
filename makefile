SHELL = /bin/bash

project_root = $(realpath ..)
project_name = $(notdir $(realpath .))
project_version = $(shell cat version.txt)

# We use this makefile from tests
makefile_dir := $(dir $(lastword $(MAKEFILE_LIST)))
include $(makefile_dir)util/make/makefile.base.mk


mirror := mirror
mirror_lock := requirements.lock
artifacts := leolani


.DEFAULT_GOAL := build


.PHONY: clean
clean:
	$(info Clean $(project_name))
	@rm -rf $(mirror) $(mirror_lock) $(artifacts) docker.lock
	@mkdir $(mirror) $(artifacts)

$(mirror_lock): requirements.txt
	pip download --requirement requirements.txt -d mirror \
		| grep Collecting | cut -f 2 -d ' ' > $(mirror_lock)

.PHONY:
build: $(mirror_lock) $(artifacts)

$(artifacts):
	mkdir -p $(artifacts)


.PHONY: docker
docker: docker.lock

docker.lock: $(mirror_lock) $(artifacts)
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}:${project_version} .
	touch docker.lock
