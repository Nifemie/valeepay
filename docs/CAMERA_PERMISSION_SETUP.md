# Camera Permission Setup Guide

## Overview
The Camera Permission screen (`CameraPermission.dart`) has been updated to properly request camera permissions using the `permission_handler` package.

## Current Status

### ✅ Implemented
- Converted from `ConsumerWidget` to `ConsumerStatefulWidget` for state management
- Added `_requestCameraPermission()` method with proper permission flow
- Added `_showOpenSettingsDialog()` for permanently denied permissions
- Button now calls permission request method with loading state
- Proper error handling with `AppMessenger`

### ⚠️ TODO: Add Required Package

**You need to add the `permission_handler` package to `pubspec.yaml`:**

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # ... existing dependencies ...
  
  permission_handler: ^11.0.1  # Add this line
```

After adding, run:
```bash
flutter pub get
```

### 📱 Platform-Specific Setup

#### Android (android/app/src/main/AndroidManifest.xml)
Add camera permission:
```xml
<manifest ...>
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    
    <!-- Existing permissions -->
    <uses-permission android:name="android.permission.INTERNET" />
    ...
</manifest>
```

#### iOS (ios/Runner/Info.plist)
Add camera usage description:
```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera for identity verification to keep your account secure.</string>
```

## Implementation Details

### Permission Flow

```
User clicks "Allow Permission"
    ↓
Request camera permission (Permission.camera.request())
    ↓
┌─────────────────┬──────────────────┬────────────────────┐
│   isGranted     │    isDenied      │ isPermanentlyDenied│
│                 │                  │                    │
│  ✅ Navigate    │  ❌ Show Error   │  ⚙️ Show Settings  │
│  to next screen │  Message         │  Dialog            │
└─────────────────┴──────────────────┴────────────────────┘
```

### Code Structure

**File: `lib/features/dashboard/view/KYC/CameraPermission.dart`**

```dart
class _CameraPermissionPageState extends ConsumerState<CameraPermissionPage> {
  bool _isLoading = false;

  Future<void> _requestCameraPermission() async {
    setState(() => _isLoading = true);
    
    try {
      final status = await Permission.camera.request();
      
      if (status.isGranted) {
        // ✅ Permission granted - navigate to next screen
        ref.read(kycStepProvider.notifier).state = 5;
        Navigator.push(context, ...);
      } 
      else if (status.isDenied) {
        // ❌ Permission denied - show error
        AppMessenger.show(context, message: '...', type: MessageType.error);
      } 
      else if (status.isPermanentlyDenied) {
        // ⚙️ Permanently denied - guide to settings
        _showOpenSettingsDialog();
      }
    } catch (e) {
      // Handle errors
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showOpenSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Camera Permission Required'),
        content: Text('Please enable camera access in settings...'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(onPressed: () async {
            Navigator.pop(context);
            await openAppSettings(); // Opens device settings
          }, child: Text('Open Settings')),
        ],
      ),
    );
  }
}
```

### Button Integration

```dart
FullWidthButton(
  text: 'Allow Permission',
  isEnabled: true,
  isLoading: _isLoading,  // Shows spinner during request
  onPressed: _requestCameraPermission,
)
```

## Activation Steps

### Step 1: Add Package
Edit `pubspec.yaml` and add:
```yaml
permission_handler: ^11.0.1
```

Run:
```bash
flutter pub get
```

### Step 2: Uncomment Implementation
In `CameraPermission.dart`, uncomment the TODO sections:

**Line ~27:** Uncomment the actual permission request code:
```dart
// Remove the /* and */ around:
final status = await Permission.camera.request();
// ... rest of the permission logic
```

**Line ~55:** Remove the temporary navigation code:
```dart
// DELETE these lines:
AppMessenger.show(context, message: 'Camera permission will be requested...', ...);
ref.read(kycStepProvider.notifier).state = 5;
Navigator.push(...);
```

**Line ~101:** Uncomment settings opener:
```dart
// Change from:
// await openAppSettings();
// To:
await openAppSettings();
```

### Step 3: Update Platform Files

**Android:**
```bash
# Edit android/app/src/main/AndroidManifest.xml
# Add: <uses-permission android:name="android.permission.CAMERA" />
```

**iOS:**
```bash
# Edit ios/Runner/Info.plist
# Add NSCameraUsageDescription key
```

### Step 4: Test

1. Run the app
2. Navigate to KYC Camera Permission screen
3. Click "Allow Permission"
4. System permission dialog should appear
5. Test all scenarios:
   - ✅ Allow → Should navigate to Identity Verification
   - ❌ Deny → Should show error message
   - ⚙️ Deny + "Don't ask again" → Should show settings dialog

## Error Handling

All error scenarios are handled:
- ✅ Permission granted → Navigate to next screen
- ❌ Permission denied → Show error with AppMessenger
- ⚙️ Permanently denied → Dialog with "Open Settings" button
- 🔥 Exception thrown → Caught and displayed with AppMessenger
- 🔄 Loading state → Button shows spinner, prevents multiple clicks

## Benefits

1. **User-Friendly**: Clear error messages and guidance
2. **Follows Patterns**: Same style as login/BVN screens
3. **Platform Support**: Works on both Android and iOS
4. **Settings Integration**: Guides users to enable permissions if blocked
5. **Loading States**: Visual feedback during permission request
6. **Error Recovery**: Handles all permission states gracefully

## Next Steps After Setup

Once activated, test the complete KYC flow:
```
1. BVN Entry → Initialize API ✅
2. OTP Verification → Validate API ✅  
3. Camera Permission → Request Permission ✅ (Ready when package added)
4. Identity Verification → Capture Photo (Next step)
```

## Support

If you encounter issues:
- Ensure `permission_handler` is in pubspec.yaml
- Run `flutter clean && flutter pub get`
- Check AndroidManifest.xml has camera permission
- Check Info.plist has usage description
- Test on physical device (permissions don't work well on simulators)
