#!/bin/zsh

function add_to_zshrc() {
  log_message "Adding $1 to ~/.zshrc unless it already exists"
  grep -qxF "$1" ~/.zshrc || echo "$1" >>~/.zshrc
}

function install_software_updates() {
  log_heading "Installing macOS software updates"
  sudo softwareupdate --install --all
}

function install_xcode_command_line_tools() {
  log_heading "Xcode Command Line Tools"

  if ! command -v xcode-select &>/dev/null; then
    log_message "Installing Xcode Command Line Tools"
    xcode-select --install
  else
    log_message "Xcode Command Line Tools are already installed"
  fi
}

function enable_touchid_sudo() {
    local sudo_local="/etc/pam.d/sudo_local"
    local template="/etc/pam.d/sudo_local.template"
    local touchid_line="auth       sufficient     pam_tid.so"
    
    if [[ -f "$sudo_local" ]] && grep -q "^$touchid_line" "$sudo_local"; then
        log_message "TouchID for sudo is already enabled"
        return 0
    fi
    
    log_message "Setting up TouchID for sudo..."
    
    if [[ ! -f "$sudo_local" ]]; then
        if [[ ! -f "$template" ]]; then
            log_message "Template file $template not found"
            return 1
        fi
        log_message "Copying template to sudo_local..."
        sudo cp "$template" "$sudo_local" || {
            log_message "Failed to copy template"
            return 1
        }
    fi
    
    if grep -q "^#.*$touchid_line" "$sudo_local"; then
        log_message "Uncommenting TouchID line..."
        sudo sed -i '' "s/^#\(.*$touchid_line\)/\1/" "$sudo_local"
    elif ! grep -q "$touchid_line" "$sudo_local"; then
        log_message "Adding TouchID line..."
        sudo sed -i '' "1a\\
$touchid_line
" "$sudo_local"
    fi
    
    log_message "TouchID for sudo has been enabled!"
    log_message "You may need to restart Terminal for changes to take effect"
}


function install_rosetta() {
  log_heading "Rosetta"

  if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
    if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
      log_message "Installing Rosetta"
      sudo softwareupdate --install-rosetta --agree-to-license
    else
      log_message "Rosetta is already installed"
    fi
  else
    log_message "Rosetta will not be installed. This is not an Apple Silicon Mac"
  fi
}

function install_homebrew() {
  log_heading "Homebrew"

  if ! command -v brew &>/dev/null; then
    log_message "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log_message "Homebrew is already installed"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"

  log_message "Updating Homebrew"
  brew update
  brew upgrade
  brew cleanup
}

function install_mas() {
  log_heading "Mac App Store CLI"

  if ! command -v mas &>/dev/null; then
    log_message "Installing mas"
    brew install mas
  else
    log_message "mas is already installed"
  fi

  mas upgrade
}

function install_homebrew_taps() {
  log_heading "Adding Homebrew taps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    brew tap "${LINE}"
  done <$1
}

function install_homebrew_cask() {
  brew list --cask $1 >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    brew install --cask $1
  fi
}

function install_homebrew_casks() {
  log_heading "Installing Homebrew casks"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_cask "${LINE}"
  done <$1
}

function install_homebrew_package() {
  brew list $1 >/dev/null 2>&1

  if [ $? -eq 0 ]; then
    log_message "$1 is already installed"
  else
    log_message "Installing $1"
    brew install $1
  fi
}

function install_homebrew_packages() {
  log_heading "Installing Homebrew packages (formulae)"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    install_homebrew_package "${LINE}"
  done <$1
}

function install_mas_app() {
  mas list | grep -q "^$1 "

  if [ $? -eq 0 ]; then
    log_message "$2 (ID $1) is already installed"
  else
    log_message "Installing $2 (ID $1)"
    mas install "$1"
  fi
}

function install_mas_apps() {
  log_heading "Installing Mac App Store apps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    [[ -z "$LINE" || "$LINE" =~ ^# ]] && continue
    local id="${LINE%% *}"
    local name="${LINE#* }"
    install_mas_app "$id" "$name"
  done <$1
}

function install_nvm() {
  log_heading "Node Version Manager (nvm)"

  NVM_VERSION=$(curl --silent "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r '.tag_name')
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh | bash
}

function install_nvm_node_versions() {
  log_heading "Installing Node.js versions with nvm"

  if [[ -n "$1" && -f "$1" ]]; then
    while IFS='' read -r LINE || [ -n "${LINE}" ]; do
      [[ -z "$LINE" || "$LINE" =~ ^# ]] && continue
      nvm install "${LINE}"
    done <"$1"
  else
    log_message "Versions file not provided or not found; skipping explicit installs"
  fi

  nvm install node
}

function install_npm_global_pkgs() {
  log_heading "Installing npm global packages"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    npm install -g "${LINE}"
  done <$1
}

function enable_pnpm() {
  log_heading "Enabling pnpm"

  if command -v corepack &>/dev/null; then
    log_message "Corepack detected; enabling pnpm via Corepack"
    corepack enable pnpm
  else
    log_message "Corepack not found; skipping pnpm enable. Install corepack first (add corepack to lib/npm-global-pkgs.txt)"
  fi
}

function install_rbenv() {
  log_heading "Installing rbenv"

  if ! command -v rbenv &>/dev/null; then
    log_message "Installing rbenv"
    brew install rbenv
  else
    log_message "rbenv is already installed"
  fi
}

function install_rbenv_ruby_versions() {
  log_heading "Installing Ruby versions with rbenv"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    [[ -z "$LINE" || "$LINE" =~ ^# ]] && continue
    if rbenv versions --bare | grep -qx "$LINE"; then
      log_message "Ruby $LINE is already installed"
    else
      log_message "Installing Ruby $LINE"
      rbenv install "$LINE"
    fi
  done <"$1"

  local first_version
  first_version=$(grep -v '^\s*#' "$1" | sed '/^\s*$/d' | head -n 1)
  if [[ -n "$first_version" ]]; then
    rbenv global "$first_version"
  fi
}

function configure_dock() {
  log_heading "Configuring macOS Dock"

  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock mouse-over-hilite-stack -bool true
  defaults write com.apple.dock showhidden -bool false
  defaults write com.apple.dock tilesize 52
  defaults write com.apple.dock orientation bottom
  defaults write com.apple.dock ResetLaunchPad -bool true
  defaults write com.apple.dock show-recents -bool true

  killall Dock
}

function process_dock_items() {
  grep '_CFURLString' | grep -v '_CFURLStringType' | sed -E 's/.*= "(.*)";/\1/' | sed 's|file://||g' | sed 's|%20| |g'
}

function list_dock_apps() {
  CURRENT_DOCK_APPS=$(defaults read com.apple.dock persistent-apps | process_dock_items)
}

function list_dock_dirs() {
  CURRENT_DOCK_DIRS=$(defaults read com.apple.dock persistent-others | process_dock_items)
}

function set_dock_apps() {
  list_dock_apps
  list_dock_dirs

  log_heading "Setting Dock Apps"

  while IFS='' read -r LINE || [ -n "${LINE}" ]; do
    APP_PATH=$(eval echo "${LINE}")
    if echo "$CURRENT_DOCK_APPS" | grep -q "$APP_PATH"; then
      log_message "App already exists in Dock: $APP_PATH"
    else
      log_message "Adding app to Dock: $APP_PATH"
      defaults write com.apple.dock persistent-apps -array-add "<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>$APP_PATH</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>"
    fi
  done <$1

  local dirs=(
    "$HOME/"
    "$HOME/Downloads/"
  )

  for dir in "${dirs[@]}"; do
    if echo "$CURRENT_DOCK_DIRS" | grep -q "$dir"; then
      log_message "Directory already exists in Dock: $dir"
    else
      log_message "Adding directory to Dock: $dir"
      defaults write com.apple.dock persistent-others -array-add "<dict><key>tile-data</key><dict><key>arrangement</key><integer>1</integer><key>displayas</key><integer>1</integer><key>file-data</key><dict><key>_CFURLString</key><string>file://$dir</string><key>_CFURLStringType</key><integer>15</integer></dict><key>showas</key><integer>2</integer></dict><key>tile-type</key><string>directory-tile</string></dict>"
    fi
  done

  killall Dock

  # Re-evaluate current dock items after changes
  list_dock_apps
  list_dock_dirs

  # Check for extra apps
  while IFS='' read -r CURRENT_APP; do
    [ -z "$CURRENT_APP" ] && continue
    # Remove trailing slash if it exists
    CURRENT_APP="${CURRENT_APP%/}"
    FOUND=false
    while IFS='' read -r DESIRED_APP || [ -n "${DESIRED_APP}" ]; do
      if [ "$(eval echo "${DESIRED_APP}")" = "$CURRENT_APP" ]; then
        FOUND=true
        break
      fi
    done < "$1"
    
    if [ "$FOUND" = false ]; then
      log_message "Extra app found in Dock: $CURRENT_APP"
    fi
  done <<< "$CURRENT_DOCK_APPS"

  # Check for extra directories
  while IFS='' read -r CURRENT_DIR; do
    [ -z "$CURRENT_DIR" ] && continue
    FOUND=false
    for dir in "$HOME/" "$HOME/Downloads/"; do
      if [ "$dir" = "$CURRENT_DIR" ]; then
        FOUND=true
        break
      fi
    done
    
    if [ "$FOUND" = false ]; then
      log_message "Extra directory found in Dock: $CURRENT_DIR"
    fi
  done <<< "$CURRENT_DOCK_DIRS"
}

function configure_finder() {
  log_heading "Configuring Finder"

  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder ShowTabView -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowToolbar -bool true
  defaults write com.apple.finder ShowSidebar -bool true
  defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
  defaults write com.apple.finder NewWindowTarget -string "PfHm"
  defaults write com.apple.finder AppleShowAllFiles false
  defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

  # Enable snap-to-grid for icons on the desktop and in other icon views
  /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
  /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

  chflags nohidden ~/Library
  sudo chflags nohidden /Volumes

  killAll cfprefsd
  killAll Finder
}

function configure_macos_settings() {
  log_heading 'Updating global macOS settings'

  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Disable the “Are you sure you want to open this application?” dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Resets audio out controller
  killall coreaudiod

  # Resets hostname to prevent rewrites when on other networks
  sudo scutil --set HostName "$(scutil --get LocalHostName).local"

  # Enable "Tap to click"
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
  sudo defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
  sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

  # Date and time in Finder bar
  defaults write com.apple.menuextra.clock IsAnalog -bool false
  defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

  # Battery percentage
  defaults write com.apple.menuextra.battery ShowPercent -bool true

  # Global Keyboard shortcuts
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Save as PDF\\U2026" "@\$p"
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Show Next Tab" "@~\\U2192"
  defaults write -globalDomain NSUserKeyEquivalents -dict-add "Show Previous Tab" "@~\\U2190"

  # Terminal theme
  defaults write ~/Library/Preferences/com.apple.Terminal.plist "Default Window Settings" "Homebrew"
  defaults write ~/Library/Preferences/com.apple.Terminal.plist "Startup Window Settings" "Homebrew"
  defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew"
  defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

  # Enable Night Shift from sunset to sunrise
  defaults write com.apple.CoreBrightness CBBlueReductionStatus -int 1
  defaults write com.apple.CoreBrightness CBScheduleType -int 1

  # Set Night Shift color temperature (75% warm)
  defaults write com.apple.CoreBrightness CBColorTemperature -float 0.75

  killall SystemUIServer
  sleep 2
  killAll Finder
}
