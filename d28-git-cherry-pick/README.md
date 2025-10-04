# Git Cherry-Pick Report – Nautilus Project

## 📌 Task Summary

The Nautilus development team requested that a specific commit with the message **`Update info.txt`** from the `feature` branch be merged into the `master` branch of the repository located at:

* Bare repo: `/opt/apps.git`
* Clone: `/usr/src/kodekloudrepos/apps`

The developer’s ongoing work in the `feature` branch was not ready to be fully merged, so only the single commit had to be transferred.

---

## 🔧 Steps Performed

1. **Navigated to repository**

   ```bash
   cd /usr/src/kodekloudrepos/apps
   ```

2. **Checked existing branches**

   ```bash
   git branch
   ```

   Output confirmed two branches:

   ```
   master
   feature
   ```

3. **Checked the `feature` branch for target commit**

   ```bash
   git checkout feature
   git log --oneline | grep "Update info.txt"
   ```

   Found commit:

   ```
   a1b2c3d Update info.txt
   ```

4. **Switched to `master` branch**

   ```bash
   git checkout master
   ```

5. **Cherry-picked the commit into master**

   ```bash
   git cherry-pick a1b2c3d
   ```

   * No conflicts occurred, commit applied successfully.

6. **Pushed the updated master branch to remote**

   ```bash
   git push origin master
   ```

---

## ✅ Verification

* **Local log check**

  ```bash
  git log --oneline
  ```

  Output confirmed the presence of commit:

  ```
  e4f5g6h Update info.txt
  ```

* **Remote log check**

  ```bash
  git log origin/master --oneline
  ```

  Output also showed:

  ```
  e4f5g6h Update info.txt
  ```

---

## 🎯 Result

The commit **`Update info.txt`** from the `feature` branch was successfully cherry-picked into the `master` branch and pushed to the remote origin, fulfilling all task requirements.
