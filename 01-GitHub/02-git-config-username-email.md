# How to configure GitHub `username` and `gmail` to your system

To configure your `Git username and email`, use the `git config` command in your terminal or PowerShell. This sets your identity for commits across repositories or per repo.


### Global Configuration

```bash
git config --global user.name "Your User Name"

git config --global user.email "your.email@example.com"
```

![Replace placeholders with your details](../Images/github7.png)


- Run these commands to set your username and email system-wide `(stored in ~/.gitconfig on Linux/Mac` or `%USERPROFILE%\.gitconfig on Windows)`. 

***

## Git Config Verification

```bash
# View all global settings
git config --global --list

# OR check specific values
git config --get user.name
git config --get user.email
```

***