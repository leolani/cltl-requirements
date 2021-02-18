SHELL = /bin/bash

project_root = $(realpath ..)
project_name = $(notdir $(realpath .))
project_version = $(shell cat version.txt)

mirror := requirements.lock

depend:
	touch makefile.d


.DEFAULT_GOAL := install


.PHONY: clean
clean:
	$(info Clean $(project_name))
	@rm -rf mirror requirements.lock

.PHONY: install
install: $(mirror)

$(mirror): requirements.txt
	pip download --requirement requirements.txt -d mirror \
		| grep Collecting | cut -f 2 -d ' ' > requirements.lock

.PHONY: docker
docker: $(mirror)
	DOCKER_BUILDKIT=1 docker build -t cltl/${project_name}:${project_version} .
