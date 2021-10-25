# cltl-requirements

Local package index for Leolani components and common dependencies.

## Purpose

Creation of a local package index provides a central place to manage versions of the packages and components used in the
Leolani application. When using the local package index, requirements of the individual components can simply refer to
the latest version (i.e. don't need to specify a version number).

## Installation

Clone the repository including make files with

    git clone --recurse-submodules -j8 https://github.com/leolani/cltl-requirements.git

To setup the local index run

    > make build

This will download the packages specified in the `requirements.txt` and build a package index containing the downloaded
packages.

## Usage

### Content

The repository contains two folders

* `mirror/` with the downloaded external dependencies
* `leolani/` with artifacts built from the Leolani components

If only the later is used, the `make build` step in the previous section can be skipped.

### Use the local package index

In your project install packages from the local index either by specifying it in the `pip` command:

    > pip install --no-index -f /path/to/cltl-requirements/mirror -f /path/to/cltl-requirements/leolani -r requirements.txt

or include

    --no-index
    --find-links=/path/to/cltl-requirements/mirror
    --find-links /path/to/cltl-requirements/leolani

at the start of the *requirements.txt* file of your project.

If external dependencies are loaded directly from PyPI use

    --find-links /path/to/cltl-requirements/leolani

only.

### Publish Leolani components to the local package index

Build a distribution for the package in your project

    > python setup.py bdist_wheel

and copy the generated wheel to the `leolani/` folder in this repository. To keep things clean, remove previous versions
of the package.

    > rm /path/to/cltl-requirements/leolani/cltl.my-package-0.0.1.tar.gz
    > cp dist/cltl.my-package-0.0.2.tar.gz /path/to/cltl-requirements/leolani

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any
contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See [`LICENSE`](https://github.com/leolani/cltl-combot/blob/main/LICENCE) for more
information.

## Authors

* [Taewoon Kim](https://tae898.github.io/)
* [Thomas Baier](https://github.com/numblr)
* [Selene Báez Santamaría](https://selbaez.github.io/)
* [Piek Vossen](https://github.com/piekvossen)
