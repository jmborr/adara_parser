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

## Usage

Inspecting one (or more) ADARA data stream files:

```bash
$> adara-parser --hex m00000*-f00000*-run-44576.adara | grep "RUN STATUS" | head -n 2
1117010897.011143026 RUN STATUS (0x4003,v1) [36 bytes]
1117010900.037361961 RUN STATUS (0x4003,v1) [36 bytes]
```

Serving saved raw data stream files:

```bash
# mimic the ADARA server in Terminal #1
/bin/cat m00000*-f00000*-run-44576.adara | nc -l 127.0.0.1 31414
# mimic  a client subscription for processing the data stream in Terminal #2
nc 127.0.0.1 31414 | adara-parser --showrun | less
```
Example raw data stream files for run REF_M_44635 (2.4.GB, ~700 “modes”) in
`/SNS/REF_M/shared/jbq/REF_M.For.Jose.44635/` containing three folders:

```bash
20250525-084739.421126841/
20250525-084817.010925178-run-44635/
20250525-171230.508522002/
```

"pre" folder `20250525-084739.421126841/` contains file `m00000001-f00000001.adara`.
This is the first file of the `m000*` series.  
"post" folder `20250525-171230.508522002/` contains file `m00000001-f00000001.adara`.
This is the last file in the series.  
The bulk of the series are all the files `m000*` inside directory `20250525-084817.010925178-run-44635/`

## Development

### Setting up the Micromamba environment

1. Ensure you have [Micromamba](https://mamba.readthedocs.io/en/latest/installation.html#micromamba) installed.
2. Create the environment:

```sh
micromamba create -f environment.yml
```

3. Activate the environment:

```sh
micromamba activate adara-parser
```

### Building the executable

Once the environment is activated, build the project with:

```sh
make all
```

The executable and object files will be placed in the `_build` directory.

### Automatically activating the environment with direnv

You can use [direnv](https://direnv.net/) to automatically activate the conda environment
and set up your build path when you enter the project directory
. Add a file named `.envrc` to your project root with the following contents:

```sh
#
# automatically activate conda environment drtsans 
eval "$(micromamba shell.bash hook)"
micromamba activate adara-parser

#
# export environment variables
export PATH="$PWD/_build:$PATH"
```

After creating the `.envrc` file, allow it with:

```sh
direnv allow
```

This will ensure your environment is ready and the build directory is in your PATH whenever you enter the project folder.
