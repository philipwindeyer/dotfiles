# dotfiles

My dotfiles, installed apps, macOS system settings, Finder settings, etc.

Fork, or copy and set up as you'd like. The root scripts (i.e. `macos.sh`) can be run as often as you'd like. Subsequent runs after the first/inital execution, will ignore or appropriately handle common functions that should only run once, but will still update dependencies and apps, thus keeping everything up to date.

Note: For Windows setup, see specific instructions at [windows.md](windows.md)

In `scripts/`, there is a zsh/ps1 script per environment (macOS, macOS - work machine, etc). These scripts source common functions from `scripts/common` and `scripts/macos` for macOS scripts, and `scripts/windows` for Windows.

For automatic management/installation of Homebrew formulae and casks, asdf plugins, etc, use the text files in each sub-directory to list your required apps etc.

Set them as environment vars in the root script accordingly (where applicable)

E.g. (inside `macos.sh`)

```
readonly TAPS=common/taps.txt
readonly FORMULAE=common/formulae.txt
readonly CASKS=macos/casks.txt
readonly APPS=macos/apps.txt
readonly ASDF_PLUGINS=common/asdf-plugins.txt
readonly ASDF_LIBS=common/asdf-libs.txt
readonly NPM_PKGS=common/npm-global-pkgs.txt
readonly GEMS=common/gems.txt
readonly DOCK_APPS=macos/dock-apps.txt
```

Inside windows.ps1

```
$env:CHOCOLATEY_APPS = 'windows/chocolatey.txt'
```

## Additional information (for work)

- [Laptop setup](https://qantas-hotels.atlassian.net/wiki/spaces/SQADHOT/pages/2232254496/Laptop+Setup)
- [Terraform ARM64](https://qantas-hotels.atlassian.net/wiki/spaces/infra/pages/2236547073/M1+provider+fix)
