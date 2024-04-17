# KoboDailyNotes

View your daily notes from Obsidian on your Kobo.

## Dependencies
This project relies on the [compiler toolchains provided by KOReader](https://github.com/koreader/koxtoolchain), which is built inside a podman container, and as such will likely only work on Linux.

As the project is compiled inside a podman container, most of the dependencies do not need to be installed on the build machine. However, there are still some. On Arch Linux, the following dependencies are required.

`sudo pacman -S podman buildah passt`

## Installation

TODO: Document how to copy a compiled release to the Kobo and how to run it with NickelMenu
