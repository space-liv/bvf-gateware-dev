import argparse
from strategy import Strategy
import pathlib

from builder import Builder
from dtbo import DTBOBuilder
from packager import Packager

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="CLI Build Runner")
    parser.add_argument(
        "--file",
        type=pathlib.Path,
        required=True,
        help="Path to the build strategy file",
    )

    parser.add_argument(
        "--preview",
        action="store_true",
        help="Generate Libero Project without programming files",
    )

    parser.add_argument(
        "--targets",
        choices=["dtbo", "fpga", "all", "none"],
        default="all",
        help="Select the target to build",
    )

    parser.add_argument(
        "--package",
        action="store_true",
        help="Package the output files",
    )

    args = parser.parse_args()

    tomlFile = args.file

    if not tomlFile.exists():
        raise FileNotFoundError(f"File {tomlFile} does not exist")

    strategy = Strategy(tomlFile)

    if args.targets == "fpga" or args.targets == "all":
        builder = Builder(strategy, args.preview)
        builder.run()

    if args.targets == "dtbo" or args.targets == "all":
        dtbo_builder = DTBOBuilder(strategy)
        dtbo_builder.build()

    if args.package:
        packager = Packager(strategy)
        packager.package()
