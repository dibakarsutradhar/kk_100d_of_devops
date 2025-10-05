# 🧾 Git Stash Restoration Report

**Task Name:** Restore Stashed Changes (`stash@{1}`) in `/usr/src/kodekloudrepos/blog`

**Server:** Storage Server (`ststor01`)
**User:** `natasha`

---

## 🧩 Task Summary

The Nautilus application development team requested restoration of specific stashed changes in the `/usr/src/kodekloudrepos/blog` repository.
The required stash to be restored was identified as `stash@{1}`.
After restoration, the changes needed to be committed and pushed to the remote repository.

---

## 🧰 Steps Performed

### 1️⃣ Navigated to Repository

```bash
cd /usr/src/kodekloudrepos/blog
```

### 2️⃣ Verified Available Stashes

```bash
sudo git stash list
```

**Output Example:**

```
stash@{0}: WIP on master: add new content
stash@{1}: WIP on master: update index.html
```

### 3️⃣ Applied the Target Stash

```bash
sudo git stash apply stash@{1}
```

✅ Output:

```
On branch master
Changes not staged for commit:
  modified: index.html
```

### 4️⃣ Committed Restored Changes

```bash
sudo git add .
sudo git commit -m "restored stash changes"
```

### 5️⃣ Pushed Changes to Remote Repository

```bash
sudo git push origin master
```

---

## 🧾 Final Verification

Checked latest commits:

```bash
sudo git log --oneline -1
```

✅ Output:

```
3d4e5fa (HEAD -> master, origin/master) restored stash changes
```

---

## 📸 Figures

* **Figure 1:** Screenshot of stash list showing `stash@{1}`
  ![Figure 1 – Git Stash List](path/to/screenshot1.png)

* **Figure 2:** Screenshot after successful push to origin
  ![Figure 2 – Push Confirmation](path/to/screenshot2.png)

---

## ✅ Result

Successfully restored the **`stash@{1}`** changes, committed them with the message
`restored stash changes`, and pushed to the remote repository (`origin/master`).

---
