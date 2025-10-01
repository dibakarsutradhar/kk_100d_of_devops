# Report: Reverting Latest Commit in `apps` Repository

## Task Description

The Nautilus application development team requested the DevOps team to roll back the latest commit in the `/usr/src/kodekloudrepos/apps` repository (on Storage server in Stratos DC). The latest commit (HEAD) must be reverted to the previous commit (the initial commit). A new commit should be created with the message:

```
revert apps
```

---

## Steps Performed

### 1. SSH into the Storage Server

```bash
ssh natasha@ststor01
```

---

### 2. Navigate to the Repository

```bash
cd /usr/src/kodekloudrepos/apps
```

---

### 3. Check Commit History

```bash
git log --oneline
```

Example output:

```
a1b2c3d Latest commit that needs revert
7g8h9i0 Initial commit message
```

Here:

* `a1b2c3d` = HEAD (to be reverted)
* `7g8h9i0` = initial commit

---

### 4. Revert the Latest Commit

Run:

```bash
git revert HEAD -m 1 -n
```

⚠️ If the commit is **not a merge commit**, just:

```bash
git revert HEAD
```

---

### 5. Use the Required Commit Message

The default editor will open. Replace the message with:

```
revert apps
```

Save & exit.

---

### 6. Verify New Commit

```bash
git log --oneline | head -5
```

Expected output:

```
d4e5f6g revert apps
a1b2c3d Latest commit that needs revert
7g8h9i0 Initial commit message
```

---

### 7. Push Changes (if required)

```bash
git push origin master
```

---

## Final Status

* ✅ Latest commit successfully reverted to the initial commit state.
* ✅ New commit created with exact message `revert apps`.
* ✅ Repository is now back to its expected state.
