# Azure Virtual Desktop Prep
---

**SEE ADDED NOTE AT THE END**

---
This script has two parts: The configuration.ps1 file contains the variables needed to execute the New-AVDEnv.ps1 file. 
The configuration file **must** be filled out before executing the New-AVDEnv.ps1 file or chaos will ensue!

==Please test and verify this code before running in a production environment==

## Required Powershell Modules
- AZ
- Az.DesktopVirtualization


# UPDATE NOTES - What this Script is NOT
This script does NOT fully create Fslogix containers for user profiles.
For a more full featured option look at [Microsoft's AVD Accelerator](https://github.com/Azure/avdaccelerator)
