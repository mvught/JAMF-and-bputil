#!/bin/bash

###
#
#     Name:  Secure Boot Level.sh
#     Description:
#     This utility is not meant for normal users or even sysadmins. It provides
#     unabstracted access to capabilities which are normally handled for the
#     user automatically when changing the security policy through GUIs such as
#     the Startup Security Utility in macOS Recovery. It is possible to make
#     your system security much weaker and therefore easier to compromise using
#     this tool. This tool is not to be used in production environments. It is
#     possible to render your system unbootable with this tool. It should only
#     be used to understand how the security of Apple Silicon Macs works. Use
#     at your own risk!
#     Author:  Thijs v Vught
#     Created:  2022-12-30
#     Last Modified:  2023-01-03
#     Version:  1.1
#   
#
###

################################## VARIABLES ##################################

# The body of the message that will be displayed before prompting the user for
# their password. All message strings below can be multiple lines.
message="## Secure Boot Level\n\nYour Startup Security is set to Medium, to make sure your Mac always starts up from the designated startup disk and from a legitimate, trusted operating system we need to bring this back to Full Security.\n\n Please enter your Mac password to set the Secure Boot Level to High."
forgotMessage="## Secure Boot Level\n\nYour Startup Security is set to Medium, to make sure your Mac always starts up from your designated startup disk and from a legitimate, trusted operating system we need to bring this back to Full Security.\n\n ### Password Incorrect please try again:"
banner="https://www.agconnect.nl/sites/ag/files/2020-12/hack_shutterstock_1218735091.png?raw=true"
infotext="More Information"
infolink="https://support.apple.com/en-gb/HT208198"

# The body of the message that will be displayed if a failure occurs.
FAIL_MESSAGE="## Check password or be sure you are an Admin and try again.\n\nPlease contact support: mailadres@mail.nl."

## SwiftDialog
dialogApp="/usr/local/bin/dialog"

## SwiftDialog Icon
icon="/System/Library/PreferencePanes/Security.prefPane"

# Main dialog
dialogCMD="$dialogApp \
--title \"none\" \
--bannerimage \"$banner\" \
--message \"$message\" \
--button1text \"Submit\" \
--icon "${icon}" \
--infobuttontext \"${infotext}\" \
--infobuttonaction "${infolink}" \
--messagefont 'size=14' \
--position 'centre' \
--ontop \
--moveable \
--textfield \"Enter Password\",secure,required"

# Forgot password dialog
dialogForgotCMD="$dialogApp \
--title \"none\" \
--bannerimage \"$banner\" \
--message \"$forgotMessage\" \
--button1text \"Submit\" \
--icon "${icon}" \
--infobuttontext \"${infotext}\" \
--infobuttonaction "${infolink}" \
--messagefont 'size=14' \
--position 'centre' \
--ontop \
--moveable \
--textfield \"Enter Password\",secure,required"

# Error dialog
dialogError="$dialogApp \
--title \"none\" \
--bannerimage \"$banner\" \
--message \"$FAIL_MESSAGE\" \
--button1text \"Close\" \
--infotext \"$scriptVersion\" \
--messagefont 'size=14' \
--position 'centre' \
--ontop \
--moveable \ "

# Success Dialog
dialogSuccess="$dialogApp \
--title \"none\" \
--image \"https://github.com/unfo33/venturewell-image/blob/main/a-hand-drawn-illustration-of-thank-you-letter-simple-doodle-icon-illustration-in-for-decorating-any-design-free-vector.jpeg?raw=true\" \
--imagecaption \"Your Secure Boot Level is set to High!\" \
--bannerimage \"$banner\" \
--button1text \"Close\" \
--infotext \"$scriptVersion\" \
--messagefont 'size=14' \
--position 'centre' \
--ontop \
--moveable \ "
###############################################################################
######################### DO NOT EDIT BELOW THIS LINE #########################
###############################################################################

# Get the logged in user's name
CURRENT_USER=$(/bin/echo "show State:/Users/ConsoleUser" | /usr/sbin/scutil | /usr/bin/awk '/Name :/&&!/loginwindow/{print $3}')

# SAP Privileges CLI "Promote"
# Make sure we have root privileges (for bputil).
sudo -u $CURRENT_USER /Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add

# Exits if root is the currently logged-in user, or no logged-in user is detected.
function check_logged_in_user {
  if [ "$currentuser" = "root" ] || [ -z "$currentuser" ]; then
    echo "Nobody is logged in."
    exit 0
  fi
}

# Display a branded prompt explaining the password prompt.
echo "Alerting user $CURRENT_USER about incoming password prompt..."
USER_PASS=$(eval "$dialogCMD" | grep "Enter Password" | awk -F " : " '{print $NF}')

# Thanks to James Barclay (@futureimperfect) for this password validation loop.
TRY=1
until /usr/bin/dscl /Search -authonly "$CURRENT_USER" "${USER_PASS}" &>/dev/null; do
    (( TRY++ ))
    echo "Prompting $CURRENT_USER for their Mac password (attempt $TRY)..."
    USER_PASS=$(eval "$dialogForgotCMD" | grep "Enter Password" | awk -F " : " '{print $NF}')
    if (( TRY >= 5 )); then
        echo "[ERROR] Password prompt unsuccessful after 5 attempts. Displaying \"forgot password\" message..."
        eval "$dialogError"
        exit 1
    fi
done
echo "Successfully prompted for Mac password."

sudo bputil -f -u $CURRENT_USER -p $USER_PASS
    echo "Displaying \"success\" message..."
    eval "$dialogSuccess"

# SAP Privileges CLI "Demote"
sudo -u $CURRENT_USER /Applications/Privileges.app/Contents/Resources/PrivilegesCLI --remove

exit 0
