# Understanding the Camera Capture Flow for Face Verification

## 📋 Current Understanding

Based on your explanation, here's the complete flow for the face ID verification:

---

## 🔄 Complete Flow (Step-by-Step)

### Step 1: Permission Request
**File**: `CameraPermission.dart`
- User clicks "Allow Permission"
- `_requestCameraPermission()` is called
- Uses `permission_handler` package
- `Permission.camera.request()` shows system dialog
- **If granted**: Navigate to Identity Verification Tips

---

### Step 2: Identity Verification Tips
**File**: `identity_verification.dart` (current)
- Shows tips for successful face capture
- User clicks "Continue"
- **Currently goes to**: `SetupTransactionPinPage` ❌

**Should go to**: Camera Capture Screen (Missing!) ✅

---

### Step 3: Camera Capture Screen (MISSING - NEEDS TO BE CREATED)

**Expected behavior based on your description:**

```dart
// This screen needs to be created
class FaceCaptureScreen extends StatefulWidget {
  
  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  List<CameraDescription>? _cameras;
  CameraDescription? _camera;
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// Step 3a: Initialize Camera
  Future<void> _initializeCamera() async {
    // Get available cameras
    _cameras = await availableCameras();
    
    // Pick front camera (for selfie)
    _camera = _cameras!.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => _cameras!.first,
    );
    
    // Create controller
    _controller = CameraController(
      _camera!,
      ResolutionPreset.medium,
    );
    
    // Initialize controller
    await _controller!.initialize();
    
    // Trigger rebuild
    setState(() {
      _isCameraInitialized = true;
    });
  }

  /// Step 3b: Capture and Send Image
  Future<void> _captureAndSendImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      // Capture image
      final XFile file = await _controller!.takePicture();
      
      // Read bytes
      final Uint8List imageBytes = await file.readAsBytes();
      
      // Convert to base64
      String base64Image = base64Encode(imageBytes);
      
      // Send to API
      // TODO: Get actual NIN from user data (currently hardcoded)
      final nin = '80471012392'; // HARDCODED - NEEDS TO BE FIXED
      
      await ref.read(authNotifierProvider.notifier)
          .faceidVerification(context, nin, base64Image);
          
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isCameraInitialized
          ? ClipOval(
              child: CameraPreview(_controller!), // Live camera feed
            )
          : CircularProgressIndicator(), // Loading
    );
  }
}
```

---

### Step 4: Backend API Call
**Endpoint**: `/api/v1/user/kyc-tier2` (AppConstants.FACE_VERIFICATION_ROUTES)

**Expected Request**:
```json
{
  "nin": "80471012392",
  "selfie": "base64EncodedImageString..."
}
```

**Current Issues** (from your description):
- ❌ NIN is hardcoded `'80471012392'`
- ❌ Selfie (base64Image) is NOT included in request body
- ❌ Repository/controller has a bug

---

## 🐛 Known Issues

### Issue 1: Missing Camera Capture Screen
**Problem**: No actual camera capture screen exists between tips and PIN setup

**Current Flow**:
```
Identity Tips → Continue → Setup Transaction PIN ❌
```

**Expected Flow**:
```
Identity Tips → Continue → Camera Capture → Capture Photo → API Call → Setup Transaction PIN ✅
```

---

### Issue 2: Hardcoded NIN
**Problem**: NIN is hardcoded as `'80471012392'` in the capture method

**Fix Needed**:
```dart
// Instead of:
final nin = '80471012392'; // HARDCODED

// Should be:
final nin = ref.read(userProvider)?.nin; // Get from user data
// OR
final nin = widget.nin; // Pass from previous screen
```

---

### Issue 3: Selfie Not Included in Request
**Problem**: The `base64Image` is captured but not sent in the API request body

**Current (Bug)**:
```dart
// In controller/repo - selfie is missing
final request = {
  'nin': nin,
  // 'selfie': selfie, // MISSING!
};
```

**Fix Needed**:
```dart
final request = {
  'nin': nin,
  'selfie': base64Image, // ✅ Include the captured image
};
```

---

## 📁 Files That Need To Be Created/Modified

### 1. Create: Face Capture Screen
**File**: `lib/features/dashboard/view/KYC/face_capture.dart` (NEW)

**Responsibilities**:
- Initialize camera with `availableCameras()`
- Create `CameraController`
- Display live camera preview in circular ClipOval
- Capture photo with `takePicture()`
- Convert to base64
- Call API

---

### 2. Create: Face Verification Request Model
**File**: `lib/features/models/face_verification_request.dart` (NEW)

```dart
class FaceVerificationRequest {
  final String nin;
  final String selfie; // base64 encoded image

  FaceVerificationRequest({
    required this.nin,
    required this.selfie,
  });

  Map<String, dynamic> toJson() => {
    'nin': nin,
    'selfie': selfie,
  };
}
```

---

### 3. Create: Face Verification Response Model
**File**: `lib/features/models/face_verification_response.dart` (NEW)

```dart
class FaceVerificationResponse {
  final String message;
  final int statusCode;
  // Add other fields based on actual API response

  FaceVerificationResponse({
    required this.message,
    required this.statusCode,
  });

  factory FaceVerificationResponse.fromJson(Map<String, dynamic> json) =>
      FaceVerificationResponse(
        message: json['message'] ?? 'Verification successful',
        statusCode: json['statusCode'] ?? 200,
      );
}
```

---

### 4. Add: API Endpoint
**File**: `lib/core/constants/api_endpoints.dart` (MODIFY)

```dart
class ApiEndpoints {
  // ... existing endpoints ...
  
  // KYC - Face Verification
  static const String faceVerification = '/api/v1/user/kyc-tier2';
}
```

---

### 5. Add: Repository Method
**File**: `lib/features/repositories/user_repository.dart` (MODIFY)

```dart
Future<FaceVerificationResponse> verifyFace(
    FaceVerificationRequest request) async {
  try {
    final response = await apiClient.post(
      ApiEndpoints.faceVerification,
      data: request.toJson(), // ✅ Includes both nin and selfie
    );
    return FaceVerificationResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(
      e.response?.data['message'] ?? 'Face verification failed'
    );
  }
}
```

---

### 6. Add: Notifier Method
**File**: `lib/features/notifiers/user_notifier.dart` (MODIFY)

```dart
Future<FaceVerificationResponse?> verifyFace(
    FaceVerificationRequest request) async {
  state = state.copyWith(isInitialLoading: true, message: null);
  try {
    final res = await _repository.verifyFace(request);
    state = state.copyWith(
      isInitialLoading: false,
      isDataAvailable: true,
      message: res.message,
    );
    return res;
  } catch (e, stack) {
    log('[UserNotifier Face Verification Error] $e\n$stack');
    state = state.copyWith(
      isInitialLoading: false,
      isDataAvailable: false,
      message: e.toString(),
    );
    return null;
  }
}
```

---

### 7. Update: Identity Verification Screen
**File**: `lib/features/dashboard/view/KYC/identity_verification.dart` (MODIFY)

```dart
// Change the Continue button to navigate to FaceCaptureScreen
FullWidthButton(
  text: 'Continue',
  isEnabled: true,
  onPressed: () {
    ref.read(kycStepProvider.notifier).state = 5;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FaceCaptureScreen(), // ✅ New screen
      ),
    );
  },
),
```

---

## 🎯 Summary of Required Changes

### Files to CREATE:
1. `lib/features/dashboard/view/KYC/face_capture.dart` - Camera capture screen
2. `lib/features/models/face_verification_request.dart` - Request model
3. `lib/features/models/face_verification_response.dart` - Response model

### Files to MODIFY:
1. `lib/core/constants/api_endpoints.dart` - Add face verification endpoint
2. `lib/features/repositories/user_repository.dart` - Add `verifyFace()` method
3. `lib/features/notifiers/user_notifier.dart` - Add `verifyFace()` method
4. `lib/features/dashboard/view/KYC/identity_verification.dart` - Update navigation

### Packages to ADD (if not present):
1. `camera: ^0.10.5+5` - For camera functionality
2. Already have: `permission_handler` ✅

---

## 🔍 Key Points to Remember

1. **Camera Selection**: Use front camera for selfie
   ```dart
   _camera = _cameras!.firstWhere(
     (camera) => camera.lensDirection == CameraLensDirection.front
   );
   ```

2. **Image Format**: Convert captured image to base64
   ```dart
   String base64Image = base64Encode(imageBytes);
   ```

3. **NIN Source**: Should come from user data, NOT hardcoded
   ```dart
   final nin = ref.read(userProvider)?.nin ?? widget.nin;
   ```

4. **Request Body**: Must include BOTH nin and selfie
   ```json
   { "nin": "...", "selfie": "..." }
   ```

5. **UI**: Camera preview in circular ClipOval for face capture
   ```dart
   ClipOval(child: CameraPreview(_controller!))
   ```

---

## ✅ This Understanding is Ready For Implementation

Once you confirm this understanding is correct, I can proceed to create the Face Capture screen and implement the complete flow following the exact same patterns used for BVN initialization and validation.
