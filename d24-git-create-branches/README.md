# 📄 Report: Creating a New Git Branch (`xfusioncorp_official`)

### Task Summary

The Nautilus development team required a new branch to be created in the existing Git repository `/usr/src/kodekloudrepos/official` on the Storage Server in Stratos DC. The branch must be named `xfusioncorp_official` and based on the `master` branch.

---

### Steps Performed

#### 1. Navigate to the repository

```bash
cd /usr/src/kodekloudrepos/official
```

#### 2. Handle repository ownership and safety warnings

Initially, Git reported *“dubious ownership”* and *permission denied* errors because the repository was not fully owned by the `natasha` user.

* Verified ownership:

  ```bash
  ls -ld /usr/src/kodekloudrepos/official
  ls -ld /usr/src/kodekloudrepos/official/.git
  ```

* Fixed ownership to allow `natasha` to manage the repo:

  ```bash
  sudo chown -R natasha:natasha /usr/src/kodekloudrepos/official
  ```

This ensured that `natasha` had the necessary permissions to operate inside the Git repo.

---

#### 3. Verify repository status

```bash
git status
```

Output:

```
On branch master
nothing to commit, working tree clean
```

---

#### 4. Create and switch to the new branch

```bash
git checkout -b xfusioncorp_official
```

This both created the branch and switched the working directory to it.

Verification:

```bash
git branch
```

Output:

```
* xfusioncorp_official
  master
```

---

#### 5. Switch back to master branch (after fixing permissions)

```bash
git checkout master
```

Confirmed branch switch:

```bash
git branch
```

Output:

```
  xfusioncorp_official
* master
```

---

### ✅ Final State

* Repository: `/usr/src/kodekloudrepos/official`
* Branches present:

  * `master`
  * `xfusioncorp_official`
* Both branches are clean with no uncommitted changes.

---

### Key Notes

* Ownership adjustment (`chown -R natasha:natasha`) was necessary for smooth Git operations.
* No code changes were made in compliance with task requirements.
* Branch `xfusioncorp_official` is now ready for development team use.


