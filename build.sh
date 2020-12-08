#!/bin/bash

# Remove existing index and download folder
rm -rf downloads
rm -rf leolani

# Prepare packages from PyPI and component dists
pypi-mirror download -d downloads -r requirements.txt
cp dists/* downloads

# Create the index
pypi-mirror create -d downloads -m leolani

rm -rf downloads
