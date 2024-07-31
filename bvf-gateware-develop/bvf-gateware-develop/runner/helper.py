import subprocess
import re

from typing import List, Tuple, Optional


def get_git_hash(length: Optional[int] = None) -> str:
    hash = subprocess.check_output(["git", "rev-parse", "HEAD"]).strip().decode("utf-8")
    if length is not None:
        return hash[:length]
    return hash


def find_variables(input: str) -> List[Tuple[int, int, str]]:
    variables = []
    for match in re.finditer(r"\[(.*?)\]", input):
        variables.append((match.start(), match.end(), match.group()[1:-1]))

    return variables


def find_and_replace_variables(input: str) -> str:
    variables = find_variables(input)
    output = input
    for var in variables:
        variable_name = var[2]
        if variable_name.lower() == "git_hash":
            # output[var[0]:var[1]] = get_git_hash()
            output = output[: var[0]] + get_git_hash(length=8) + output[var[1] :]
    return output


if __name__ == "__main__":
    teststr = "This is a test [git_hash] string"

    print(find_and_replace_variables(teststr))
