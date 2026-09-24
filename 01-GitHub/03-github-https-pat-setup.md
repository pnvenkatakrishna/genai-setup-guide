# How to Create a Repository and Push Code to GitHub Using HTTPS and a Personal Access Token (PAT)

### Step 1: Create New Repository on GitHub
1. GitHub Dashboard → "Create New Repository"

![alt text](../Images/gitpat1.png)

2. Repository name: "my-project"  


![alt text](../Images/gitpat2.png)

3. DON'T initialize README → Create repository
4. Copy HTTPS URL: https://github.com/yourusername/my-project.git


![alt text](../Images/gitpat3.png)



### Step 2: Clone Repository Locally

```bash
git clone https://github.com/yourusername/my-project.git
cd my-project
```

![alt text](../Images/gitpat4.png)


### Step 3: Set Git User Identity (First Time Only)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Step 4: Generate Personal Access Token (PAT)

##  Open GitHub settings 

```text
GitHub → Settings → Developer settings → Personal access tokens → "Generate new token"
```

![settings and devolper settings](../Images/gitpat5.png)


![alt text](../Images/gitpat6.png)



![alt text](../Images/gitpat7.png)


#### give repo (Full control of private repositories) (as shown in the below image)

![alt text](../Images/gitpat8.png)

```
Copy token: ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
**⚠️ Save securely - cannot view again**
```
![alt text](../Images/gitpat9.png)




### Step 5: Create Files & Commit Changes
```bash
# Create sample files
echo "# My Python Project" > README.md
echo "print('Hello GitHub!')" > hello.py

# Stage & commit
git add .
git commit -m "Add initial Python app + README"
```

### Step 6: Push to Remote (Uses PAT)
```bash
git push -u origin main
```
**Terminal prompts:**
```
Username for 'https://github.com': yourusername  
Password for 'https://yourusername@github.com': ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Step 7: Verify Success
```
✓ [origin/main 8f2a3d4] Add initial Python app + README
✓ Success! Check GitHub - files are live.
```

### Future Workflow (No Re-Authentication)
```bash
# Edit file
echo "print('Updated code')" >> hello.py
git add . && git commit -m "Update hello message"
git push  # ✅ No prompts - cached automatically
```



