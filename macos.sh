#!/usr/bin/env bash

# macOS defaults
#
# Log out / restart after running.

set -euo pipefail

# Close System Settings so it can't overwrite our changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# Ask for sudo upfront; keep it alive in the background
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Medium sidebar icon size
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars (alternatives: WhenScrolling, Automatic)
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2    -bool true

# Save to disk, not iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Display ASCII control characters with caret notation in text views
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Non-floating Help Viewer windows
defaults write com.apple.helpviewer DevMode -bool true

# Show host info when clicking the clock on the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Set date format to ISO 8601
defaults write NSGlobalDomain AppleICUDateFormatStrings -dict-add 1 "y-MM-dd"

# Faster window resize animation
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Ctrl+Cmd+click to drag any window (great for large/multi-monitor setups)
defaults write NSGlobalDomain NSWindowShouldDragOnGesture -bool true

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# # Disable Gatekeeper quarantine warnings on downloaded apps
# defaults write com.apple.LaunchServices LSQuarantine -bool false

###############################################################################
# Locale                                                                      #
###############################################################################

defaults write NSGlobalDomain AppleLanguages        -array "en-US"
defaults write NSGlobalDomain AppleLocale            -string "en_US"
defaults write NSGlobalDomain AppleMeasurementUnits  -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits       -bool false

###############################################################################
# Trackpad & Mouse                                                            #
###############################################################################

# Tap to click (trackpad + login screen)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Two-finger tap for right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Trackpad speed / scroll speed
defaults write NSGlobalDomain com.apple.trackpad.scaling   -float 1.0
defaults write NSGlobalDomain com.apple.trackpad.scrolling -float 0.588

# Mouse speed / scroll wheel speed
defaults write NSGlobalDomain com.apple.mouse.scaling       -float 2.5
defaults write NSGlobalDomain com.apple.scrollwheel.scaling  -float 0.3125

# Ctrl + scroll to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle  -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask   -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus   -bool true

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Fastest key repeat + shortest delay before repeat
defaults write NSGlobalDomain KeyRepeat        -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Full keyboard access in all controls (e.g. Tab through modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable double-space → period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes and smart dashes (they break code in Notes, etc.)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled  -bool false

# NOTE: Uncomment if you also want these off globally.
# defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled        -bool false
# defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled    -bool false

###############################################################################
# Screen & Screenshots                                                        #
###############################################################################

# Require password 5 seconds after sleep / screensaver
defaults write com.apple.screensaver askForPassword      -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 5

# Save screenshots to ~/Desktop in PNG without window shadows
defaults write com.apple.screencapture location       -string "${HOME}/Desktop"
defaults write com.apple.screencapture type            -string "png"
defaults write com.apple.screencapture disable-shadow  -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# New windows open at home directory
defaults write com.apple.finder NewWindowTarget     -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# List view by default (alternatives: icnv, clmv, Flwv)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar   -bool true

# Full POSIX path in the title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the "change extension?" warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Spring-loaded directories (fast)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay   -float 0.2

# Desktop icons for external drives
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop     -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool true

# Don't create .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores     -bool true

# AirDrop over Ethernet
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Expand File Info panes: General, Open With, Sharing & Permissions
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General    -bool true \
  OpenWith   -bool true \
  Privileges -bool true

# Show ~/Library and /Volumes
chflags nohidden ~/Library
sudo chflags nohidden /Volumes

###############################################################################
# Dock                                                                        #
###############################################################################

# Wipe all default app icons from the Dock
defaults write com.apple.dock persistent-apps -array

# Helper to add an app to the Dock
function dock_app() {
  defaults write com.apple.dock persistent-apps -array-add \
    "<dict><key>tile-data</key><dict><key>file-data</key><dict>\
<key>_CFURLString</key><string>${1}</string>\
<key>_CFURLStringType</key><integer>0</integer>\
</dict></dict></dict>"
}

dock_app "/Applications/Safari.app"
dock_app "/Applications/Google Chrome.app"
dock_app "/System/Applications/Preview.app"
dock_app "/System/Applications/Chess.app"
dock_app "/System/Applications/Automator.app"
dock_app "/System/Applications/Shortcuts.app"
dock_app "/Applications/Visual Studio Code.app"
dock_app "/System/Applications/Utilities/Terminal.app"
dock_app "/System/Applications/System Settings.app"

# 32px icons, left side, auto-hide with no delay
defaults write com.apple.dock tilesize              -int 32
defaults write com.apple.dock orientation            -string "left"
defaults write com.apple.dock autohide               -bool true
defaults write com.apple.dock autohide-delay          -float 0
defaults write com.apple.dock autohide-time-modifier  -float 0.5

# Hide recent apps section from the Dock
defaults write com.apple.dock show-recents -bool false

# Highlight hover effect on grid stacks
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# Minimize windows into their app icon
defaults write com.apple.dock minimize-to-application -bool false

# Show indicator lights for open apps
defaults write com.apple.dock show-process-indicators -bool true

# Hidden apps get translucent icons
defaults write com.apple.dock showhidden -bool true

# Don't rearrange Spaces by recent use
defaults write com.apple.dock mru-spaces -bool false

# Don't group windows by app in Mission Control
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Mission Control animations
defaults write com.apple.dock expose-animation-duration -int 0

# Hot corners:
#   Top-right + ⌘  → Display sleep
#   Bottom-right    → Disable screen saver
defaults write com.apple.dock wvous-tr-corner    -int 10
defaults write com.apple.dock wvous-tr-modifier  -int 1048576
defaults write com.apple.dock wvous-br-corner    -int 6
defaults write com.apple.dock wvous-br-modifier  -int 0

###############################################################################
# Safari                                                                      #
###############################################################################

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu                 -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Add a context-menu item for Web Inspector in all other web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

###############################################################################
# Mail                                                                        #
###############################################################################

# Copy addresses as "foo@example.com" not "Name <foo@example.com>"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Show attachment icons instead of inline previews
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

###############################################################################
# Terminal                                                                    #
###############################################################################

# UTF-8 only
defaults write com.apple.terminal StringEncodings -array 4

# Secure Keyboard Entry
defaults write com.apple.terminal SecureKeyboardEntry -bool true

###############################################################################
# TextEdit                                                                    #
###############################################################################

# Plain text by default, UTF-8 everywhere
defaults write com.apple.TextEdit RichText                    -int 0
defaults write com.apple.TextEdit PlainTextEncoding           -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite   -int 4

###############################################################################
# Time Machine                                                                #
###############################################################################

defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

###############################################################################
# Activity Monitor                                                            #
###############################################################################

defaults write com.apple.ActivityMonitor OpenMainWindow  -bool true
defaults write com.apple.ActivityMonitor IconType        -int 5      # CPU usage in Dock icon
defaults write com.apple.ActivityMonitor ShowCategory    -int 0      # All processes
defaults write com.apple.ActivityMonitor SortColumn      -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection   -int 0

###############################################################################
# Mac App Store & Software Update                                             #
###############################################################################

defaults write com.apple.appstore WebKitDeveloperExtras  -bool true
defaults write com.apple.appstore ShowDebugMenu          -bool true

defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
defaults write com.apple.SoftwareUpdate ScheduleFrequency    -int 1   # daily
defaults write com.apple.SoftwareUpdate AutomaticDownload    -int 1
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

defaults write com.apple.commerce AutoUpdate                -bool true
defaults write com.apple.commerce AutoUpdateRestartRequired  -bool true

###############################################################################
# Photos                                                                      #
###############################################################################

# Don't open Photos when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# Restart affected services                                                   #
###############################################################################

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Mail" \
           "Photos" "Safari" "SystemUIServer" "Terminal"; do
  killall "${app}" &>/dev/null || true
done

echo "Installing Rosetta"
softwareupdate --install-rosetta --agree-to-license

echo "Done. Some changes require a logout or restart to take effect."
