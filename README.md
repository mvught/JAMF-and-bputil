# JAMF-and-bputil

![GitHub release (latest by date)](https://img.shields.io/badge/release-v1.0-blue)
![Github](https://img.shields.io/badge/macOS-11%2B-green)

<img src="/Screenshots/Swift SelfService SBL.png" width="800">

- [Introduction](#introduction)
- [Requirements](#requirements)
- [Download](#download)
- [Technologies](#technologies)
- [JAMF](#JAMF)
  * [Smart Groups](#Smart-Groups)
  * [SelfService Item](#SelfService-Item)
  * [Script](#Script)
- [Note and disclaimer](#note-and-disclaimer)

## Introduction
I created this script to make my life easy.
Previously, we had to call the users to go through the steps together with the user.
This all went through the terminal but took a lot of time so when Swift came along I dived into it and came up with the following:

This utility is not meant for normal users or even sysadmins. It provides unabstracted access to capabilities which are normally handled for the user automatically when changing the security policy through GUIs such as the Startup Security Utility in macOS Recovery (“recoveryOS”). It is possible to make your system security much weaker and therefore easier to compromise using this tool. This tool is not to be used in production environments. It is possible to render your system unbootable with this tool. It should only be used to understand how the security of Apple Silicon Macs works. Use at your own risk!

## Requirements
* macOS 11 or higher
* Mac with Apple T2 and M1 Security Chip
* SAP Privileges
* Volume Owner and Secure Token user

## Download

### Secure Boot Level
Script: [**Download**](https://github.com/mvught/JAMF-and-bputil/blob/main/Secure%20Boot%20Level.sh)

### Manual BPUTIL
Manual: [**Download**](https://github.com/mvught/JAMF-and-bputil/blob/main/Manual%20BPUTIL.sh)

## Technologies
* Written in Swift using SwiftUI
* Built for and compatible with macOS 11.0 and higher
* Native support for Apple Silicon
* Dark Mode support

## JAMF

### Smart Groups
To work properly with bputil, we need 3 smart groups. Here is an example:
* Full
* Medium
* No Security (Off)
<img src="/Screenshots/Secure Boot Level Full.png" width="450">

<img src="/Screenshots/Secure Boot Level Medium.png" width="450">

<img src="/Screenshots/Secure Boot Level No Security.png" width="450">

### SelfService Item
Make a name: "Secure Boot Level" and scope it to your target "smart-group"

<img src="/Screenshots/SelfService SBL Item.png" width="450">

<img src="/Screenshots/FirmwarePasswordUtilityIconX.png" width="50">

[**Download**](https://github.com/mvught/JAMF-and-bputil/blob/main/Screenshots/FirmwarePasswordUtilityIconX.png)

### Script
Remember well that the user must be an "admin" and "volumeowner" to set security to Full. Otherwise, it won't work and the policy fails.


## Note and disclaimer
* UMC-Utrecht developed this script as a side project to add additional value you
* The script can be used free of charge and is provided ‘as is’, without any warranty
* Comments and feature request are appreciated. Please file an issue on Github
