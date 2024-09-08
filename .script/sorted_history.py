import os
from collections import OrderedDict


def GetDirectory():
    os_type = os.name
    if os_type == "posix":
        return os.path.join(
            os.environ["HOME"],
            ".local",
            "share",
            "fish",
            "fish_history",
        )
    elif os_type == "nt":
        return os.path.join(
            os.environ["USERPROFILE"],
            "AppData",
            "Roaming",
            "Microsoft",
            "Windows",
            "PowerShell",
            "PSReadLine",
            "ConsoleHost_history.txt",
        )
    else:
        raise NotImplementedError(
            "This sorted history script does not support the current os."
        )


def ReadHistoryFile(directory):
    with open(directory, "r") as file:
        return file.readlines()


def FilterAndSortLines(lines):
    os_type = os.name
    commands = OrderedDict()
    if os_type == "posix":
        for line in lines:
            if "- cmd:" in line.strip():
                command = line.strip().split("- cmd:", 1)[1].strip()
                base_cmd = command.split()[0]
                if base_cmd not in commands:
                    commands[base_cmd] = set()
                commands[base_cmd].add(command)
    elif os_type == "nt":
        for line in lines:
            if line.strip():
                command = line.strip()
                base_cmd = command.split()[0]
                if base_cmd not in commands:
                    commands[base_cmd] = set()
                commands[base_cmd].add(command)
    else:
        raise NotImplementedError(
            "This sorted history script does not support the current os."
        )

    return commands


def WriteSortedHistory(directory, commands):
    os_type = os.name
    with open(directory, "w") as file:
        for base_cmd in commands:
            for command in sorted(commands[base_cmd]):
                if os_type == "posix":
                    file.write(f"- cmd: {command}\n")
                else:
                    file.write(f"{command}\n")


def Main():
    directory = GetDirectory()
    lines = ReadHistoryFile(directory)
    sorted_commands = FilterAndSortLines(lines)
    WriteSortedHistory(directory, sorted_commands)


if __name__ == "__main__":
    Main()
