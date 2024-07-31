# Gateware
This project provides an alternative method for developing and compiling gateware that does not rely upon the usage of the Libero SoC graphical tooling. This project instead uses TCL scripts executed through the libero CLI tool to build up the MSS, and other areas of the gateware.

## Installation and Setup
1. Clone [bvf-gateware](https://github.com/Space-Machines-Company/bvf-gateware) repository
2. Clone [bvf-hss](https://github.com/Space-Machines-Company/bvf-hss) repository
3. Duplicate `strategies/default.toml`
4. Update `hss_location` to be where the repository cloned in Step 2 is located
5. Install `requirements.txt` using `pip install -r requirements.txt`
6. Install and setup Microchip's Libero SoC tool suite (follow instructions [here](https://docs.beagleboard.org/latest/boards/beaglev/fire/demos-and-tutorials/mchp-fpga-tools-installation-guide.html)). You must install Libero SoC v2024.1
7. Add `. ~/microchip/setup-tools.sh` to your bash/zsh RC file (`~/.bashrc`, `~/.zshrc`)

__Note: A version of the tool setup script can be found in the `tools/` folder of this repository (this has been updated to use 2024.1).__

## Command Usage (Python)
```
python runner/main.py [OPTIONS]

Options:

    --file [FILE]                       The TOML strategy file that should be used during the Gateware, HSS, and MSS build process (see strategies/default.toml)

    --targets [all, fpga, dtbo, none]   The targets that need to be built
    --preview                           Gateware builder will only generate the libero project and will skip generation of programming files

    --package                           Package output files (bitstream and dtbo programming file) into a tar ball (tar.gz)
```

## Build Strategies
The build strategy files allows for fine tuned customisation of gateware image builds such that modules can be excluded from certain variants and different versions of MSS configs and HSS images can be used.

`Instructions are coming... I promise`
