# dotfiles

My dotfiles, installed apps, macOS system settings, Finder settings, etc.

Fork, or copy and set up as you'd like. The root scripts (i.e. `macos.sh`) can be run as often as you'd like. Subsequent runs after the first/inital execution, will common functions that should only run once, but will still update dependencies and apps, thus keeping everything up to date.

In `scripts/`, there is a zsh script per environment (macOS, macOS - work machine, etc). These scripts source common functions from `scripts/common` and `scripts/macos` for macOS scripts.

For automatic management/installation of Homebrew formulae and casks, asdf plugins, etc, use the text files in each sub-directory to list your required apps etc.

Set them as environment vars in the root script accordingly.

E.g. (inside `macos.sh`)

```
readonly TAPS=common/taps.txt
readonly FORMULAE=common/formulae.txt
readonly CASKS=macos/casks.txt
readonly APPS=macos/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly YARN_PKGS=common/yarn-global-pkgs.txt
readonly DOCK_APPS=macos/dock-apps.txt
```
