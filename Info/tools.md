# Tools

[..](README.md)

| Software                                | Usecase                |
|:---------------------------------------:|------------------------|
| [GitKraken](https://www.gitkraken.com/) | Easy to use Git client |
| [Godot](https://godotengine.org/)       | Game Engine we use     |
| [Trello](https://trello.com)            | Organisation           |
| [Github](https://github.com)            | Git Service            |
| [GDScript Toolkit](https://github.com/Scony/godot-gdscript-toolkit) | Formatter for GDScript |

## GDSscript Formatter

### Install
#### On Windows & Arch
```cmd
pip install gdtoolkit
```
#### On MacOS and Linux
```sh
pip3 install gdtoolkit
```

Make sure `~/.local/bin/` is in your `$PATH`

### Format
#### In Bash
```bash
gdformat $(find . -name '*.gd')
```
#### In Fish
```fish
gdformat **.gd
```
