# 🧾 Git Hook Setup & Merge Report

**Task:** Implement a `post-update` hook to automatically create release tags after each push to the `master` branch.
**User:** `natasha`
**Date:** `2025-10-08`
**Environment:** Storage Server — Stratos DC

---

## 🔧 Repository Details

| Parameter       | Value                                |
| --------------- | ------------------------------------ |
| Repository Path | `/opt/blog.git`                      |
| Working Copy    | `/usr/src/kodekloudrepos/blog`       |
| Repository Type | Bare (`.git` only)                   |
| Primary Branch  | `master`                             |

---

## 🧩 Task Summary

1. **Merged `feature` branch into `master`:**

   ```bash
   cd /usr/src/kodekloudrepos/blog
   git checkout master
   git merge feature
   ```

2. **Created a `post-update` hook** at:

   ```
   /opt/blog.git/hooks/post-update
   ```

   and made it executable:

   ```bash
   chmod +x /opt/blog.git/hooks/post-update
   ```

3. **Hook logic:**

   ```bash
   #!/bin/bash
   BRANCH_REF=$(git for-each-ref --format='%(refname:short)' refs/heads/master)
   if [[ "$BRANCH_REF" == "master" ]]; then
       TODAY=$(date +%F)
       TAG="release-$TODAY"
       git tag -a "$TAG" -m "Automated release tag for $TODAY"
       echo "Creating release tag: $TAG"
   fi
   ```

4. **Tested by pushing updates to `master`:**

   ```bash
   git push origin master
   ```

---

## ✅ Verification Steps

* Verified that the hook executed on push:

  ```
  remote: Creating release tag: release-2025-10-08
  ```
* Confirmed new tag presence:

  ```bash
  git tag
  # Output:
  # release-2025-10-08
  ```
* Ensured no permission or ownership changes were made to the repository.
* Validated hook functionality by performing an additional push test — confirmed automatic tagging works consistently.

---

## 🧠 Notes

* The `git push origin` inside a bare repository was removed to avoid “no remote origin” errors.
* Tag creation is local to the bare repo; no extra push needed.
* Hook is idempotent and will only trigger on pushes to `master`.

---

## 📤 Deliverables

* [x] Merged `feature` → `master`
* [x] Post-update hook implemented
* [x] Tested successfully
* [x] Created release tag: `release-2025-10-08`

---
