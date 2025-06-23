# ADARA Parser

ADARA Parser is a C++ command-line tool for parsing and processing ADARA (Accelerating Data Acquisition,
Reduction, and Analysis) data streams.
ADARA is a data acquisition system developed for the Spallation Neutron Source (SNS) at
Oak Ridge National Laboratory (ORNL).
This parser reads ADARA protocol data, interprets neutron event and pulse information,
and can be used for data analysis, reduction, or conversion to other formats.

The project is organized with source files in the `src/` directory and header files in the `include/` directory.
Build artifacts are placed in the `_build/` directory.
The software depends on the Boost C++ libraries, particularly `boost_program_options`,
and is intended to be built in a reproducible environment using Micromamba or Conda.

# adara_parser
ADARA parser

## Setting up the Micromamba environment

1. Ensure you have [Micromamba](https://mamba.readthedocs.io/en/latest/installation.html#micromamba) installed.
2. Create the environment:

```sh
micromamba create -f environment.yml
```

3. Activate the environment:

```sh
micromamba activate adara-parser-env
```

## Building the executable

Once the environment is activated, build the project with:

```sh
make all
```

The executable and object files will be placed in the `_build` directory.
