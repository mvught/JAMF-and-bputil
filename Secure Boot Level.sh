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
#
#     bputil performs actions by calling the BootPolicy library. This modifies
#     the security configuration of the system, which is stored in a file
#     called the LocalPolicy. This file is digitally signed by the Secure
#     Enclave Processor (SEP). The private key which is used to sign the
#     LocalPolicy is protected by a separate key which is only accessible when
#     a user has put in their password as part of a successful authentication.
#     This is why this tool must either have a username and password specified
#     on the command line, or via the interactive prompt.
#
#     By design, the SEP application which is responsible for making changes to
#     the LocalPolicy will inspect the boot state of the main Application Pro-
#     cessor (AP). It will only allow the below security-downgrading operations
#     if it detects that the AP is in the intended boot state. When System
#     Integrity Protection (SIP) was first introduced to Macs, it was decided
#     that requiring a reboot to macOS Recovery would provide intentional fric-
#     tion which would make it harder for malicious software to downgrade the
#     system. That precedent is extended here to detect the special boot to
#     macOS Recovery via holding the power key at boot time. We refer to this
#     as One True Recovery (1TR), and most of the below downgrade options will
#     only work when booted into 1TR, not when called from normal macOS. This
#     helps ensure that only a physically-present user, not malicious software
#     running in macOS, can permanently downgrade the security settings. The
#     below CLI options specify what boot environments a downgrade can be per-
#     formed from.
#
#     The SEP-signed LocalPolicy is evaluated at boot time by iBoot. Configura-
#     tions within the LocalPolicy change iBoot's behavior, such as whether it
#     will require that all boot objects must be signed with metadata specific
#     to the particular machine (a "personalized" signature, which is the
#     default, and the always-required policy on iOS), or whether it will
#     accept "global" signatures which are valid for all units of a specific
#     hardware model. The LocalPolicy can also influence other boot or OS secu-
#     rity behavior as described in the below options.
#     Author:  Thijs v Vught
#   Created:  2022-12-30
#     Last Modified:  2022-12-30
#   Version:  1.0
#   
#
###

scriptVersion="1.0"

################################## VARIABLES ##################################

# The body of the message that will be displayed before prompting the user for
# their password. All message strings below can be multiple lines.
message="## Secure Boot Level\n\nYour laptop Secure Boot Level is Medium and we want it at High .\n\n Please provide your password to set Secure Boot Level Full."
forgotMessage="## Secure Boot Level\n\nYour laptop Secure Boot Level is Medium and we want it at High .\n\n Please provide your password to set Secure Boot Level Full. \n\n ### Password Incorrect please try again:"
banner="https://www.agconnect.nl/sites/ag/files/2020-12/hack_shutterstock_1218735091.png?raw=true"

# The body of the message that will be displayed if a failure occurs.
FAIL_MESSAGE="## Check password or be sure you are an Admin and try again.\n\nPlease contact support: applesupport@umcutrecht.nl."

## SwiftDialog
dialogApp="/usr/local/bin/dialog"

# Main dialog
dialogCMD="$dialogApp \
--title \"none\" \
--bannerimage \"$banner\" \
--message \"$message\" \
--button1text \"Submit\" \
--infotext \"$scriptVersion\" \
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
--infotext \"$scriptVersion\" \
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
--imagecaption \"Your Secure Boot Level is Set!\" \
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

exit 0
