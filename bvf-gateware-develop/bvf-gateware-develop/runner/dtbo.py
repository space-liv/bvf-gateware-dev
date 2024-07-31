from strategy import Strategy
import os
import subprocess
import ctypes
import struct
import shutil
import pathlib
from helper import get_git_hash


class DTBOBuilder:
    def __init__(self, strategy: Strategy):
        self.strategy = strategy

    def __clean_output(self, output_dir: pathlib.Path):
        if output_dir.exists():
            print("Deleting output directory: ", output_dir)
            shutil.rmtree(output_dir)
        else:
            print("Output directory does not exist so no cleaning required")

    def __copy_module_dtso(self, output_dir: pathlib.Path):
        for module in self.strategy.get_modules():
            module_path = (
                pathlib.Path("./source/fpga/components").absolute()
                / module["name"]
                / module["variant"]
                / "dts"
            )
            if module_path.exists() == False:
                print(f"Module path {module_path} does not exist, skipping...")
                continue  # Skip if the module path does not exist

            dtso_files = list(module_path.glob("*.dtso"))

            if len(dtso_files) == 0:
                print(f"No dtso files found for module {module['name']}, skipping...")
                continue

            print(f"Found {len(dtso_files)} dtso files for module {module['name']}")

            module_output_dir = pathlib.Path(output_dir, module["name"])
            module_output_dir.mkdir(parents=True, exist_ok=True)

            for dtso_file in dtso_files:
                shutil.copy(dtso_file, module_output_dir)

                print("Device Tree Overlay Selected:")
                print("    Module: ", module["name"])
                print("    Variant: ", module["variant"])
                print("    DTBO File: ", dtso_file.name)
                print("\n")

    def __build_magic(self, buffer):
        struct.pack_into(
            "cccc", buffer, 0, b"M", b"C", b"H", b"P"
        )  # XXX: Does this need to be MCHP?

    def __build_version(self, buffer, version=0):
        struct.pack_into("H", buffer, 8, version)

    def __build_descriptor_len(self, buffer, num_contexts, num_dtbos):
        struct.pack_into("I", buffer, 4, (12 + (4 * num_contexts) + (4 * num_dtbos)))

    def __build_num_contexts(self, buffer, num_contexts):
        struct.pack_into("I", buffer, 10, num_contexts)

    def __get_dtbo_files(self, output_dir: pathlib.Path):
        dtbo_files = []
        for root, _, files in os.walk(output_dir):
            for file in files:
                if file.endswith(".dtbo"):
                    p = os.path.join(root, file)
                    print(f"Path: {p}")
                    dtbo_files.append(p)

        return dtbo_files

    def __get_total_dtbo_size(self, files):
        size = 0
        for file in files:
            size += os.path.getsize(file)

        return size

    def __build_info(self, buffer, output_dir, num_contexts, files):
        dtbo_desc_list_offset = 12 + (num_contexts * 4)
        struct.pack_into("I", buffer, 12, dtbo_desc_list_offset)
        num_dtbo = len(files)
        struct.pack_into("I", buffer, 16, num_dtbo)
        data_offset = 20 + (num_dtbo * 12)
        index = 0
        for file in files:
            size = os.path.getsize(file)
            struct.pack_into("I", buffer, 20 + (index * 12), data_offset)
            struct.pack_into("I", buffer, 24 + (index * 12), data_offset + size)
            struct.pack_into("I", buffer, 28 + (index * 12), size)
            data_offset += size
            index += 1

        dtbo_path = pathlib.Path(output_dir, "mpfs_dtbo.spi")
        with open(dtbo_path, "wb+") as f:
            f.write(buffer)

        with open(dtbo_path, "ab") as f:
            for file in files:
                with open(file, "rb") as dtbo:
                    f.write(dtbo.read())

    def __inject_git_info_into_src_dtso(self, dtso_file, git_version):
        with open(dtso_file, "r") as f:
            dtso = f.read()
            dtso = dtso.replace("GW_GIT_HASH", git_version)
            with open(dtso_file, "w") as fout:
                fout.write(dtso)

    def __compile_dtso(self, output_dir):
        for root, _, files in os.walk(output_dir):
            for file in files:
                if file.endswith(".dtso"):
                    dtbo_file = file.replace(".dtso", ".dtbo")
                    dtso_path = os.path.join(root, file)
                    dtbo_path = os.path.join(root, dtbo_file)

                    self.__inject_git_info_into_src_dtso(
                        dtso_path, f"git_{get_git_hash(length=16)}"
                    )
                    print("================================")
                    print("Compiling DTBO: ", dtso_path)
                    print("================================")
                    subprocess.run(["dtc", "-O", "dtb", "-o", dtbo_path, dtso_path])

    def build(self):
        print("====================================================================")
        print("Cleaning the DTBO build locations")
        print("====================================================================")
        output_dir = pathlib.Path(self.strategy.get_locations()["dtbo_output_dir"])
        output_dir = (
            output_dir.absolute() if not output_dir.is_absolute() else output_dir
        )
        self.__clean_output(output_dir)

        print("====================================================================")
        print("Copying and Compiling DTSO Files")
        print("====================================================================")
        output_dir.mkdir(parents=True, exist_ok=True)
        self.__copy_module_dtso(output_dir)
        self.__compile_dtso(output_dir)

        print("====================================================================")
        print("Creating DTBO Prog File (mpfs_dtbo.spi)")
        print("====================================================================")
        files = self.__get_dtbo_files(output_dir)
        num_contexts = 1
        num_dtbo = len(files)

        buffer = ctypes.create_string_buffer(12 + (num_contexts * 8) + (12 * num_dtbo))

        self.__build_magic(buffer)
        self.__build_descriptor_len(buffer, num_contexts, num_dtbo)
        self.__build_version(buffer)
        self.__build_num_contexts(buffer, num_contexts)
        self.__build_info(buffer, output_dir, num_contexts, files)

        print("====================================================================")
        print("Finished building DTBO files")
        print("====================================================================")
        print("DTBO Build Complete")
        print("    Output Directory: ", output_dir)
        print("    Number of DTBO Files: ", num_dtbo)
        print("    Total DTBO Size: ", self.__get_total_dtbo_size(files))
        print("\n")

        print("Buffer Dump:")
        print(buffer[:])
