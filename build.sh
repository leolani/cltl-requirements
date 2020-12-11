#!/bin/bash

set -e

# Remove existing index and download folder
rm -rf mirror

# Prepare packages from PyPI and component dists
pypi-mirror download --binary --download-dir mirror --requirement requirements.txt