# ⚠️ DEVELOPMENT SKIP BUTTON - REMOVAL CHECKLIST

## 🚨 CRITICAL: This must be removed before production release!

---

## What Was Added

A "Skip for Testing" button was added to the BVN screen to allow testing of the wallet PIN setup functionality without requiring a valid BVN from the backend (which is still in development).

### Location
**File**: `lib/features/dashboard/view/KYC/BVN.dart`

### Lines to Remove
Search for the comment:
```dart
// 🚨 DEVELOPMENT ONLY - REMOVE BEFORE PRODUCTION 🚨
```

Remove everything from that comment down to (and including):
```dart
// Warning text
Text(
  '⚠️ Development Mode: This button bypasses BVN verification',
  ...
),
```

### Also Remove This Import
```dart
import 'package:valarpay/features/dashboard/view/KYC/setup_pin.dart';
```
(It will be unused once the skip button is removed)

---

## Why It Was Added

1. Backend BVN verification is still in development
2. We can't use real BVN numbers for testing
3. Need to test wallet PIN setup functionality independently
4. Want to verify the complete flow end-to-end

---

## When to Remove

✅ **Remove when:**
- Backend BVN verification is fully functional
- You can successfully verify with real BVN numbers
- Ready to deploy to production/staging
- Before any public release or beta testing with real users

❌ **Keep for now if:**
- Backend is still in development
- Testing PIN setup functionality
- Working in local/dev environment only

---

## How to Remove

### Step 1: Open the file
```
lib/features/dashboard/view/KYC/BVN.dart
```

### Step 2: Find the skip button code (around line 226)
Look for:
```dart
const SizedBox(height: 16),

// 🚨 DEVELOPMENT ONLY - REMOVE BEFORE PRODUCTION 🚨
```

### Step 3: Delete from line 226 to approximately line 267
Delete everything including:
- The SizedBox(height: 16)
- The Container with skip button
- The warning Text widget

### Step 4: Remove the unused import (line 6)
Delete:
```dart
import 'package:valarpay/features/dashboard/view/KYC/setup_pin.dart';
```

### Step 5: Verify
- Run the app
- Navigate to BVN screen
- Confirm skip button is gone
- Confirm only "Continue" button is visible
- Test BVN verification with real backend

---

## Visual Identification

The skip button is easy to spot:
- 🟠 **Orange border and text**
- 🟠 **Orange skip icon**
- 🔴 **Red warning text below**
- 📝 **Says "SKIP FOR TESTING (Remove Before Production)"**

If you see this button in the app, it means the development code is still present!

---

## Testing After Removal

After removing the skip button, verify:

1. ✅ BVN screen only shows "Continue" button
2. ✅ Continue button is disabled until 11 digits entered
3. ✅ Continue button calls real BVN API
4. ✅ Valid BVN proceeds to OTP screen
5. ✅ Invalid BVN shows error message
6. ✅ No way to bypass BVN verification
7. ✅ App compiles without errors
8. ✅ No unused imports warnings

---

## Checklist for Production Release

Before deploying to production, verify all of these:

- [ ] Skip button removed from BVN.dart
- [ ] Unused import removed
- [ ] App tested with real BVN verification
- [ ] No development-only code remains
- [ ] All error handling works correctly
- [ ] Code reviewed by team member
- [ ] Git commit message mentions skip button removal
- [ ] Production build tested on physical device

---

## Related Files

If you added similar skip buttons elsewhere, also check:
- `lib/features/dashboard/view/KYC/bvn_otp_verification.dart`
- Any other KYC screens
- Authentication screens

---

## Search Terms for Finding All Skip Buttons

Use these search terms in your IDE to find any skip buttons:

1. `DEVELOPMENT ONLY`
2. `SKIP FOR TESTING`
3. `Remove Before Production`
4. `Development Mode`
5. `Colors.orange` (the skip button uses orange)

---

## Git Workflow

### When Adding Skip Button (Done)
```bash
git add lib/features/dashboard/view/KYC/BVN.dart
git commit -m "feat(dev): Add temporary skip button for BVN testing - REMOVE BEFORE PROD"
```

### When Removing Skip Button (Future)
```bash
git add lib/features/dashboard/view/KYC/BVN.dart
git commit -m "chore: Remove development skip button from BVN screen"
```

---

## Emergency Rollback

If you accidentally deploy with the skip button:

### Option 1: Hot fix
```bash
git checkout HEAD~1 lib/features/dashboard/view/KYC/BVN.dart
# Then remove the skip button manually
git commit -m "hotfix: Remove skip button from production"
git push
```

### Option 2: Revert commit
```bash
git revert <commit-hash-with-skip-button>
git push
```

---

## Additional Notes

### Why This Approach?

We chose this approach because:
1. ✅ Fastest way to test PIN setup
2. ✅ Clearly marked as development-only
3. ✅ Easy to remove (single file, single section)
4. ✅ Visually obvious (orange/red colors)
5. ✅ Self-documenting (comments explain purpose)

### Alternatives Considered

1. Mock BVN response - More complex
2. Flutter build flavors - Requires more setup
3. Feature flags - Overkill for simple testing
4. Separate test branch - Makes testing harder

---

## Date Added
October 17, 2025

## Added By
Development team testing wallet PIN setup

## Estimated Removal Date
When backend BVN verification is stable (TBD)

---

## 🔔 REMINDER TRIGGERS

Set these reminders:

1. **Before any deployment**: Check if skip button is removed
2. **Before code review**: Verify no dev-only code
3. **Before merging to main**: Search for "DEVELOPMENT ONLY"
4. **Before app store submission**: Run production build test

---

## Contact

If you have questions about removing this:
- Check this document first
- Review the BVN_TOKEN_FIX.md documentation
- Ask the developer who added it

---

**⚠️ BOTTOM LINE: This skip button is ONLY for development testing. It MUST be removed before any production release!**
