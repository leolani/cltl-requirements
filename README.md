# cltl-requirements
Local package index for Leolani components and common dependencies.

## Purpose

Creation of a local package index provides a central place to manage versions of the packages and components used in the Leolani application. When using the local package index, requirements of the individual components can simply refer to the latest version (i.e. don't need to specify a version number).

## Installation

To setup the local index run the install.sh script

    > source install.sh

This will setup a virtual environment with `pypi-mirror` installed.


## Usage

### Build the local package index

To build the local index execute the `build.sh` script:

    > ./build.sh

This will download the packages specified in the `requirements.txt` and  build a package index containing the downloaded packages and the packages from *dists/*.

### Use the local package index

In your project install packages from the local index either by specifying it in the `pip` command:

    > pip install --no-index -f /path/to/cltl-requirements/mirror -f /path/to/cltl-requirements/leolani -r requirements.txt

or include

    --no-index
    --find-links=/path/to/cltl-requirements/mirror
    --find-links /path/to/cltl-requirements/leolani

at the start of the *requirements.txt* file of your project.

### Publish Leolani components to the local package index

Build a distribution for the package in your project

    > python setup.py bdist_wheel

and copy the generated wheel to the *dists/* folder in this repository. To keep things clean, remove previous versions of the package.

    > rm /path/to/cltl-requirements/dists/cltl.my-package-0.0.1.tar.gz
    > cp dist/cltl.my-package-0.0.2.tar.gz /path/to/cltl-requirements/dists

Commit the changes to *dists/* and rebuild the local package index by running the [build step](#build-the-local-package-index).


## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## License

Distributed under the MIT License. See [`LICENSE`](https://github.com/leolani/cltl-combot/blob/main/LICENCE) for more information.

## Authors

* [Taewoon Kim](https://tae898.github.io/)
* [Thomas Baier](https://github.com/numblr)
* [Selene Báez Santamaría](https://selbaez.github.io/)
* [Piek Vossen](https://github.com/piekvossen)
