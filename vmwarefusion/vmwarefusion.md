# VMware Fusion Setup Guide for macOS

Registering with Broadcom enables free access to **VMware Fusion**, essential for i**nstalling Windows virtual machines** on Intel or Apple Silicon Macs.

### Purpose Overview
Broadcom Support Portal registration unlocks official VMware Fusion downloads without entitlements for personal use. This supports creating Windows VMs on macOS seamlessly.
***

## Pre-Registration Hardware Check
Before registering with Broadcom for VMware Fusion, verify your Mac's model and available storage to ensure compatibility and sufficient space for Windows VMs.

### Check Mac Model
Identify your Mac hardware to select the correct VMware Fusion build and Windows architecture.

- Go to **Apple Menu > About This Mac**; note the **Chip** (e.g., Apple M1/M2/M3/M4 = ARM/Apple Silicon) or **Processor** (Intel Core i5/i7/etc. = x64).
- Intel Macs require **x64 (Intel 64-bit)** Windows ISOs and universal Fusion builds.
- Apple Silicon Macs (M-series) need **ARM64** Windows 11 ISOs (x64 won't boot).

## Storage Requirements
Allocate adequate SSD space for smooth VM performance.

- **Minimum**: 64GB total free space (VMware Fusion ~1GB + Windows VM 50GB + apps/updates).
- **Recommended**: If your laptop has 512GB SSD, it is good to create VM for good performance.
- Check via **Apple Menu > About This Mac > Storage** or **Finder > Go > Computer**.

## Pre-Registration Checklist
| Check | Intel Mac | Apple Silicon Mac | Notes |
|-------|-----------|-------------------|-------|
| **Model** | Intel Core iX | Apple M1/M2/M3/M4 | Determines Windows arch |
| **RAM** | 8GB+ | 16GB+ unified | VMs consume host RAM |
| **Storage** | 64GB+ free | 64GB+ free | Host + Guest allocation |
| **Windows ISO** | x64 (Win 10/11) | ARM64 (Win 11 only) | Download separately |
| **Fusion Build** | Universal .dmg | Universal .dmg | Works on both   |

This prevents download/install issues and ensures Windows VM creation succeeds post-Fusion setup.

***

## Broadcom Account Registration Guide

**Registering a Broadcom Support Portal account involves creating a basic profile on their official site for access to support, downloads, and communities.** This process starts with email verification. 

## Registration Steps
Follow these steps on the Broadcom Support Portal at https://support.broadcom.com:

1. Go to the Broadcom Support Portal homepage.

![homepage](../images/broadcom1.png)

2. Click **Register** in the upper-right corner. 


3. Enter your individual email address, complete the CAPTCHA, and click **Next**. 

![email registering](../images/broadcom2.png)

4. Check your email for the verification code from Broadcom, enter it, and click **Verify & Continue** .



5. Fill in your basic information (name, etc.), accept the **Terms of Use**, and click **Create Account** .

![fill the info](../images/broadcom3.png)


6. After success, click **I'll do it later** to upgrade for case management, downloads, and entitlements. 

![alt text](../images/broadcom4.png)

## Log in to the portal.

- Log in at https://support.broadcom.com.

    - - To login (check on the top right)



![alt text](../images/broadcom5.png)


### Steps to Access Downloads
- After logging into the Broadcom Support Portal, navigate to downloads to check for VMware Fusion availability. VMware Fusion Pro is offered as a free download for non-entitled users.

* On the left menu, click **My Downloads**. 

![downloads](../images/broadcom6.png)


* Look for **Free Software Downloads available HERE** (hyperlink) and click it. 

![hyperlink](../images/broadcom7.png)

* Search for **"VMware Fusion"**.

![alt text](../images/broadcom8.png)

* Click on **VMware Fusion 13**, and Select the latest version (e.g., VMware-Fusion-13.6.4-xxxxxxxx_universal.dmg for macOS universal support.

![alt text](../images/broadcom9.png)


- To accept the terms on the VMware Fusion 13.6.4 download page, follow the below steps. 


* Click the **"Terms and Conditions"** link (usually below the download table) to open it in a **new browser tab**. 

* Review the terms in the new tab, then close it or keep it open—the **"I AGREE" checkbox** will now be **enabled** on the original download tab. 


![alt text](../images/broadcom10.png)

* Switch back to the **previous tab** (Broadcom downloads page).


* **Check the "I AGREE" box**, then click the **download icon** (cloud arrow) next to the desired build (e.g., VMware-Fusion-13.6.4-xxxxxxxx_universal.dmg). 


![alt text](../images/broadcom11.png)


* After clicking the download icon on the VMware Fusion 13.6.4 page, a details form prompts before final download. Fill required fields and submit to proceed. 

![alt text](../images/broadcom12.png)


#### Refined Download Prompt Steps
* **Fill Details**: Enter **Name**, **Email** (use your registered Broadcom email), **Company** (optional), and **Phone** (if shown as required) in the "Download Notification" form. 

* **Submit Form**: Check **"I AGREE"** (now enabled), then click **Submit** or **Continue** button.

![alt text](../images/broadcom13.png)


* **Final Download**: Return to the downloads table; click the **download icon** (cloud arrow) again next to **VMware-Fusion-13.6.4-xxxxxxxx_universal.dmg**. 

![alt text](../images/broadcom14.png)


### once you download, please reachout your lab assistant for additional settings.
