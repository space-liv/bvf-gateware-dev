import tarfile
import os
import pathlib
import shutil
from strategy import Strategy
from helper import find_and_replace_variables


class Packager:
    def __init__(self, strategy: Strategy):
        self.strategy = strategy

    def package(self):
        output_dir = self.strategy.get_locations()["package_output_dir"]
        output_dir = pathlib.Path(output_dir)
        output_dir = (
            output_dir.absolute() if not output_dir.is_absolute() else output_dir
        )

        if output_dir.exists():
            shutil.rmtree(output_dir)

        output_dir.mkdir(parents=True, exist_ok=True)

        if (
            self.strategy.get_packaging()["include_dtbo"] == False
            and self.strategy.get_packaging()["include_bitstream"] == False
        ):
            print("Nothing to package")
            return

        package_name = self.strategy.get_packaging()["package_name"]
        if package_name is not None:
            package_name = find_and_replace_variables(package_name)
            package_name = package_name + ".tar.gz"
        else:
            package_name = "smc_bvf_package.tar.gz"

        with tarfile.open(output_dir / package_name, "w:gz") as tar:
            if self.strategy.get_packaging()["include_dtbo"]:
                dtbo = (
                    pathlib.Path(self.strategy.get_locations()["dtbo_output_dir"])
                    / "mpfs_dtbo.spi"
                )
                if dtbo.exists():
                    tar.add(dtbo, arcname="mpfs_dtbo.spi")
                else:
                    raise FileNotFoundError(f"DTBO file not found: {dtbo}")

            if self.strategy.get_packaging()["include_bitstream"]:
                bitstream = (
                    pathlib.Path(self.strategy.get_locations()["bitstream_dir"])
                    / "linux"
                    / "mpfs_bitstream.spi"
                )
                digest = (
                    pathlib.Path(self.strategy.get_locations()["bitstream_dir"])
                    / "linux"
                    / "mpfs_bitstream_spi.digest"
                )
                if bitstream.exists():
                    tar.add(bitstream, arcname="mpfs_bitstream.spi")
                else:
                    raise FileNotFoundError(f"Bitstream file not found: {bitstream}")

                if digest.exists():
                    tar.add(digest, arcname="mpfs_bitstream_spi.digest")
