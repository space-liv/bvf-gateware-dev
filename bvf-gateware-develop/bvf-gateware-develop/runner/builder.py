from strategy import Strategy

import shutil
import os
import platform
import pathlib
from helper import get_git_hash, find_and_replace_variables
from typing import Optional


class MissingToolingError(Exception):
    pass


class Builder:
    def __init__(self, strategy: Strategy, preview: bool = False):
        self.strategy = strategy
        self.preview = preview
        # self.wd = wd

    def __check_tooling(self):
        if shutil.which("libero") is None:
            raise MissingToolingError(
                "Libero v2024.1 is not installed and/or not in the PATH"
            )

        if shutil.which("pfsoc_mss") is None:
            raise MissingToolingError(
                "PFSOC MSS is not installed and/or not in the PATH"
            )

        if os.environ.get("SC_INSTALL_DIR") is None:
            raise MissingToolingError(
                "SC_INSTALL_DIR is not set, \
                                      please set and point towards \
                                      appropriate SoftConsole installation location"
            )

        if os.environ.get("FPGENPROG") is None:
            raise MissingToolingError(
                "FPGENPROG is not set, please set and point towards \
                                      appropriate FPGENPROG executable"
            )

        path = os.environ["PATH"]

        if "riscv-unknown-elf-gcc" not in path:
            raise MissingToolingError(
                "RISC-V GCC toolchain is not installed and/or not in the PATH"
            )

        if platform.system() == "Linux":
            if shutil.which("dtc") is None:
                raise MissingToolingError(
                    "Device Tree Compiler is not installed and/or not in the PATH"
                )

    def __build_module_list(
        self, modules
    ):  # Builds into format: MODULE=NAME:VARIANT:VERSION:CONTRAINT_1%CONTRAINT_2%...%CONTRAINT_N,NAME:VARIANT:VERSION:CONTRAINT_1%CONTRAINT_2%...%CONTRAINT_N.....
        module_strs = []
        for module in modules:
            module_str = f"{module['name']}:{module['variant']}:{module['version']}:"
            for constraint in module["constraint"]:
                module_str += f"{constraint['file_name']}"
                if constraint != module["constraint"][-1]:
                    module_str += "%"

            module_strs.append(module_str)

        return ",".join(module_strs)

    def __clean(self, locations):
        for location in locations:
            if os.path.exists(locations[location]):
                shutil.rmtree(locations[location])

    def __make_mss(self, config_path: pathlib.Path, output_location: pathlib.Path):
        print("====================================================================")
        print("Generating MSS Configuration")
        print(
            "====================================================================\r\n",
            flush=True,
        )

        config_path_abs = (
            config_path.absolute() if not config_path.is_absolute() else config_path
        )
        output_location_abs = (
            output_location.absolute()
            if not output_location.is_absolute()
            else output_location
        )

        os.system(
            f"pfsoc_mss -GENERATE -CONFIGURATION_FILE:{config_path_abs} -OUTPUT_DIR:{output_location_abs}"
        )

    def __make_hss(
        self,
        hss_path: pathlib.Path,
        output_loc: pathlib.Path,
        board: str,
        mss_output_dir: pathlib.Path,
    ):
        print("====================================================================")
        print("Building Hart Software Services")
        print(
            "====================================================================\r\n",
            flush=True,
        )

        xml_file = pathlib.Path(
            hss_path, f"boards/{board}/soc_fpga_design/xml_PF_SOC_MSS_mss_cfg.xml"
        )
        xml_file = xml_file.absolute() if not xml_file.is_absolute() else xml_file

        try:
            os.remove(xml_file)
        except:
            print(
                "HSS target board does not have a default MSS XML configuration... continuing on with life"  # This is not an issue
            )

        shutil.copy(pathlib.Path(mss_output_dir, "PF_SOC_MSS_mss_cfg.xml"), xml_file)

        # Select HSS configuration
        def_config = os.path.join(hss_path, f"boards/{board}/def_config")
        shutil.copyfile(def_config, os.path.join(hss_path, "./.config"))

        # Call Makefile
        current_dir = os.getcwd()
        os.chdir(hss_path)
        make_command = f"make BOARD={board}"
        os.system(make_command)
        os.chdir(current_dir)

        hex_file = os.path.join(
            hss_path, "Default/bootmode1/hss-envm-wrapper-bm1-p0.hex"
        )
        if os.path.isfile(hex_file):
            shutil.copy(hex_file, output_loc)
            os.chmod(output_loc, 0o777)
        else:
            raise FileNotFoundError(
                "Compiled HSS hex file not found, it is likely the HSS build failed"
            )

    def __get_design_version(self):
        design_version = self.strategy.get_version()
        if design_version is None:
            design_version = 1
        else:
            design_version

        return design_version

    def __call_libero(
        self,
        script: str,
        top_level: str,
        module_str: str,
        output_dir: pathlib.Path,
        prog_dir: pathlib.Path,
        mss_output_dir: pathlib.Path,
        mss_config_path: pathlib.Path,
        silicon_sig: str,
        design_version: str,
        hss_image_path: pathlib.Path,
        preview: Optional[bool] = True,
    ):
        command = (
            f"libero "
            + f"SCRIPT:{script} "
            + f'SCRIPT_ARGS:"TOP_LEVEL_NAME={top_level} MODULES={module_str} '
            + f"OUTPUT_DIR={output_dir} MSS_OUTPUT_DIR={mss_output_dir} PROGFILE_DIR={prog_dir} "
            + f"DESIGN_VERSION={design_version} SILICON_SIGNATURE={silicon_sig} MSS_CONFIG_PATH={mss_config_path} "
            + f"HSS_IMAGE_PATH={hss_image_path}"
        )

        if preview is True:
            command += " PREVIEW_DESIGN=1"

        command += '"'  # Close the SCRIPT_ARGS

        print("====================================================================")
        print("Running Libero Command")
        print(
            "====================================================================\r\n",
            flush=True,
        )
        print("Executing command: " + command)
        os.system(command)

    def __generate_project(self, locations, module_str):
        script = pathlib.Path("./source/build.tcl").absolute()

        top_level = f"{find_and_replace_variables(self.strategy.get_top_level_name())}"

        output_dir = pathlib.Path(locations["project_dir"])
        prog_dir = pathlib.Path(locations["bitstream_dir"])
        mss_output_dir = pathlib.Path(locations["mss_output_dir"])
        mss_config_path = pathlib.Path(self.strategy.get_mss()["mss_cfg_location"])

        # Make absolute prior to passing to Libero
        prog_dir = prog_dir.absolute() if not prog_dir.is_absolute() else prog_dir
        output_dir = (
            output_dir.absolute() if not output_dir.is_absolute() else output_dir
        )
        mss_output_dir = (
            mss_output_dir.absolute()
            if not mss_output_dir.is_absolute()
            else mss_output_dir
        )
        mss_config_path = (
            mss_config_path.absolute()
            if not mss_config_path.is_absolute()
            else mss_config_path
        )

        hss_image_path = pathlib.Path(
            locations["hss_output_dir"], "hss-envm-wrapper-bm1-p0.hex"
        )

        hss_image_path = (
            hss_image_path.absolute()
            if not hss_image_path.is_absolute()
            else hss_image_path
        )

        silicon_sig = "bea913b0"  # No idea what this is but it's in the original code
        design_version = self.__get_design_version()

        current_dir = os.getcwd()
        os.chdir("./source/")
        self.__call_libero(
            script,
            top_level,
            module_str,
            output_dir,
            prog_dir,
            mss_output_dir,
            mss_config_path,
            silicon_sig,
            design_version,
            hss_image_path,
            preview=self.preview,
        )
        os.chdir(current_dir)

    def run(self):
        print("====================================================================")
        print("Checking Tooling")
        self.__check_tooling()
        print("Tooling check passed")
        print("====================================================================")

        locations = self.strategy.get_locations()
        locations["hss_output_dir"] = self.strategy.get_hss()["hss_output_dir"]

        print("====================================================================")
        print("Cleaning the build locations")
        print("====================================================================")
        self.__clean(locations)

        for loc in locations:
            if not os.path.exists(locations[loc]):
                if loc == "project_dir":
                    continue  # This will be created by Libero
                os.makedirs(locations[loc])

        module_str = self.__build_module_list(self.strategy.get_modules())
        print("Module string: ", module_str)

        print("====================================================================")
        print("Building with the following modules:")
        print(module_str.replace(",", "\n"))
        print("====================================================================")
        print("Building with the following locations:")
        print(*locations, sep="\n")
        print("====================================================================")
        print("\r\n\r\n\r\n")

        # Make MSS Configuration using PFSOC_MSS tool
        self.__make_mss(
            pathlib.Path(self.strategy.get_mss()["mss_cfg_location"]),
            pathlib.Path(locations["mss_output_dir"]),
        )
        self.__make_hss(
            pathlib.Path(self.strategy.get_hss()["hss_location"]),
            pathlib.Path(locations["hss_output_dir"]),
            self.strategy.get_hss()["board"],
            pathlib.Path(locations["mss_output_dir"]),
        )

        self.__generate_project(locations, module_str)
