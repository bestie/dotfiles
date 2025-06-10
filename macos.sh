#/bin/sh

set -e

### Mouse and trackpad #########################################################
# Enable three finger drag
# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
# Set trackpad speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.0
# Set trackpad scrolling speed
defaults write NSGlobalDomain com.apple.trackpad.scrolling -float 0.588
# Set mouse speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5
# Set scroll speed
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.3125
# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1


### Keyboard ##################################################################
# Fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 0
# Short key repeat delay
defaults write NSGlobalDomain InitialKeyRepeat -int 12


### Finder ####################################################################
# Set default Finder location to the home directory
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Default to column view in Finder
defaults write com.apple.finder FXPreferredViewStyle Clmv
# Show icons for storage devices on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
# Show file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Disable change a file extension warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable snap-to-grid for icons on the desktop and in other icon views
defaults write com.apple.dock wvous-bl-corner -int 5
# Set the icon size of Finder items to 36 pixels
defaults write com.apple.finder IconViewSettings -dict iconSize 16
# Set date format to ISO8601
defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add 1 "y-MM-dd"
# Do not create .DS_Store files on network or USB drives
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Show the ~/Library folder
chflags nohidden ~/Library


### Dock ######################################################################
# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 32
# Dock positions auto-hide and delay
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5


### Other UI ##################################################################
# Disable mission control animations
defaults write com.apple.dock expose-animation-duration -int 0
# Faster window resize animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001


### Text input ###############################################################
# Disable double space period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# Disable auto-correct
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Or just in Terminal
# defaults write com.apple.Terminal NSAutomaticSpellingCorrectionEnabled -bool false
# Disable auto-capitalization
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false


### Applications ##############################################################
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Activity Monitor                                                            #

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

#"Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false


# Restart UI
killall Finder
killall Dock
