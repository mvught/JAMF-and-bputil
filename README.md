# JAMF-and-bputil

![GitHub release (latest by date)](https://img.shields.io/badge/release-v1.0-green)
![Github](https://img.shields.io/badge/macOS-11%2B-green)

<img src="/Screenshots/Swift SelfService SBL.png" width="800">

<img src="/Screenshots/generic_version_2.1_small.png" width="450"> <img src="/Screenshots/generic_light_mode_cropped.png" width="450"> <img src="/Screenshots/generic_version_2.3_small_dark.png" width="450">

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Download](#download)
- [Technologies](#technologies)
- [JAMF](#JAMF)
  * [Smart Groups](#Smart Groups)
  * [Script](#Script)
- [Note and disclaimer](#note-and-disclaimer)

## Introduction
I created this script to make the level of me and my users easier.
Previously, we had to call the users to go through the steps together with the user.
This all went through the terminal but took a lot of time so when Swift came along I dived into it and came up with the following:

This utility is not meant for normal users or even sysadmins. It provides unabstracted access to capabilities which are normally handled for the user automatically when changing the security policy through GUIs such as the Startup Security Utility in macOS Recovery (“recoveryOS”). It is possible to make your system security much weaker and therefore easier to compromise using this tool. This tool is not to be used in production environments. It is possible to render your system unbootable with this tool. It should only be used to understand how the security of Apple Silicon Macs works. Use at your own risk!

## Requirements
* macOS 11.0.1 or higher
* Apple Silicon Mac

## Download

### Secure Boot Level.sh
Script: [**Download**](https://github.com/mvught/JAMF-and-bputil/blob/main/Secure%20Boot%20Level.sh)

### General Commands Manual BPUTIL.man
Manual: [**Download**](https://github.com/mvught/JAMF-and-bputil/blob/main/General%20Commands%20Manual%09BPUTIL.man)

## Technologies
* Written in Swift using SwiftUI
* Built for and compatible with macOS 11.0 and higher
* Native support for Apple Silicon
* Dark Mode support

## JAMF

### Smart Groups
We have to make 3 smart groups because we have 3 levels:
* Full
* Medium
* No Security (Off)
<img src="/Screenshots/Secure Boot Level Full.png" width="450">

<img src="/Screenshots/Secure Boot Level Medium.png" width="450">

<img src="/Screenshots/Secure Boot Level No Security.png" width="450">

### Script
Remember well that the user must be an admin to set security to Full. Otherwise, it won't work and the policy fails.


## Note and disclaimer
* UMC developed this script as a side project to add additional value you
* The script can be used free of charge and is provided ‘as is’, without any warranty
* Comments and feature request are appreciated. Please file an issue on Github
