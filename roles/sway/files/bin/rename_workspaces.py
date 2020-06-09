#! /usr/bin/env python3
# encoding: utf-8

import logging
import os
import re
import shutil
from typing import List

from i3ipc import Connection, Event

logger = logging.getLogger(__name__)

# See https://fontawesome.com/cheatsheet
# for a quick way to search appropriate icons
GLYPH_MAP = {
    "kitty": "" ,
    "firefox": "",
    "rhythmbox": "",
    "Spotify": "",
    "steam": "",
    "zoom": "",
    "org.gnome.Nautilus": "",
    "Steam": "",
}

def rename_workspaces(i3, _):
    for workspace in i3.get_tree().workspaces():
        try:
            set_workspace_name(i3, workspace)
        except Exception:
            logger.exception("Unexpected error")


def set_workspace_name(i3, workspace):
    icons = []
    for node in workspace.leaves():
        # X windows
        if node.app_id is None:
            key = node.ipc_data.get("window_properties", {}).get("class")
        else:
            key = node.app_id

        print(key)

        if key in GLYPH_MAP:
            icons.append(GLYPH_MAP[key])


    old = workspace.name
    if icons:
        new = f"{workspace.num} " + " ".join(icons) + " "
    else:
        new = f"{workspace.num}"

    i3.command(f"rename workspace '{old}' to '{new}'")


def main():
    i3 = Connection()

    rename_workspaces(i3, None)

    i3.on(Event.WINDOW_NEW, rename_workspaces)
    i3.on(Event.WINDOW_CLOSE, rename_workspaces)
    i3.on(Event.WINDOW_MOVE, rename_workspaces)
    i3.main()


if __name__ == "__main__":
    main()
