# KYC Integration Roadmap

## 🚨 CRITICAL: BVN Verification Flow Explained

### Why Two BVN Endpoints?

BVN verification follows a **two-step security process** (standard Nigerian fintech pattern):

#### Step 1: Initialize BVN (Send OTP)
```
User enters BVN → Call POST /initialize-bvn → Backend sends OTP to BVN-linked phone → Returns verificationId
```
**Request**: `{ "bvn": "22409341326" }`  
**Response**: `{ "verificationId": "xyz123", "message": "OTP sent to your phone" }`

#### Step 2: Validate BVN (Verify OTP)
```
User enters OTP → Call POST /validate-bvn → Backend verifies OTP → Updates KYC level
```
**Request**: `{ "verificationId": "xyz123", "otpCode": "123456" }`  
**Response**: `{ "verified": true, "kycLevel": "KYC2", "message": "BVN verified" }`

**⚠️ Missing Screen Alert**: The app was missing the BVN OTP verification screen between BVN entry and Camera Permission. This has now been added as `bvn_otp_verification.dart`.

---

## Current Status (October 2025)

### ✅ Implemented (UI Only - No Backend)
The KYC flow currently collects user data through a multi-step UI but **does not submit to any backend endpoints**. All data is stored in local Riverpod state providers.

#### Updated Flow:
1. **KYC Setup Page** → Shows requirements
2. **Residential Address** → Collects state, LGA, house address, landmark
3. **BVN Input** → Collects 11-digit BVN (client-side validation only)
4. **BVN OTP Verification** → ✅ NEW! Verifies BVN ownership via OTP
5. **Camera Permission** → Placeholder for camera access
6. **Identity Verification Tips** → Shows selfie capture guidelines
7. **Transaction PIN Setup** → Sets up transaction PIN

### ⚠️ What's Missing
- **No API endpoints** for KYC data submission
- **No BVN verification** with third-party service
- **No selfie capture/upload** implementation
- **No backend validation** of collected data
- **No KYC level tracking** (Level 1/2/3)

---

## Future Implementation Plan

### Phase 1: Backend Endpoints (KYC Level 2)
When backend endpoints are ready, implement:

#### 1. API Endpoints
Add to `lib/core/constants/api_endpoints.dart`:
```dart
// KYC Endpoints
static const String submitKycAddress = '/api/v1/user/kyc/address';

// BVN Verification (Two-step process)
static const String initializeBvn = '/api/v1/user/kyc/initialize-bvn';  // Step 1: Send OTP
static const String validateBvn = '/api/v1/user/kyc/validate-bvn';      // Step 2: Verify OTP

static const String uploadKycDocument = '/api/v1/user/kyc/upload';
static const String getKycStatus = '/api/v1/user/kyc/status';
```

**Important**: BVN verification is a TWO-STEP process:
1. **Initialize BVN** (`POST /initialize-bvn`) - Sends OTP to BVN-linked phone, returns `verificationId`
2. **Validate BVN** (`POST /validate-bvn`) - Verifies OTP with `verificationId` + `otpCode`

#### 2. Request Models
Create in `lib/features/models/`:

**kyc_address_request.dart**
```dart
class KycAddressRequest {
  final String state;
  final String lga;
  final String houseAddress;
  final String landmark;

  KycAddressRequest({
    required this.state,
    required this.lga,
    required this.houseAddress,
    required this.landmark,
  });

  Map<String, dynamic> toJson() => {
    'state': state,
    'lga': lga,
    'houseAddress': houseAddress,
    'landmark': landmark,
  };
}
```

**bvn_initialize_request.dart** (Step 1: Send OTP)
```dart
class BvnInitializeRequest {
  final String bvn;

  BvnInitializeRequest({required this.bvn});

  Map<String, dynamic> toJson() => {
    'bvn': bvn,
  };
}
```

**bvn_initialize_response.dart**
```dart
class BvnInitializeResponse {
  final String message;
  final String verificationId; // IMPORTANT: Needed for step 2
  final int statusCode;

  BvnInitializeResponse({
    required this.message,
    required this.verificationId,
    required this.statusCode,
  });

  factory BvnInitializeResponse.fromJson(Map<String, dynamic> json) =>
      BvnInitializeResponse(
        message: json['message'] ?? '',
        verificationId: json['verificationId'] ?? '',
        statusCode: json['statusCode'] ?? 0,
      );
}
```

**bvn_validation_request.dart** (Step 2: Verify OTP)
```dart
class BvnValidationRequest {
  final String verificationId; // From step 1 response
  final String otpCode;         // User-entered OTP

  BvnValidationRequest({
    required this.verificationId,
    required this.otpCode,
  });

  Map<String, dynamic> toJson() => {
    'verificationId': verificationId,
    'otpCode': otpCode,
  };
}
```

**kyc_response.dart**
```dart
class KycResponse {
  final String message;
  final String kycLevel; // "KYC1", "KYC2", "KYC3"
  final bool verified;
  final int statusCode;

  KycResponse({
    required this.message,
    required this.kycLevel,
    required this.verified,
    required this.statusCode,
  });

  factory KycResponse.fromJson(Map<String, dynamic> json) => KycResponse(
    message: json['message'] ?? '',
    kycLevel: json['kycLevel'] ?? 'KYC1',
    verified: json['verified'] ?? false,
    statusCode: json['statusCode'] ?? 0,
  );
}
```

#### 3. Repository Methods
Add to `lib/features/repositories/user_repository.dart`:

```dart
Future<KycResponse> submitKycAddress(KycAddressRequest request) async {
  try {
    final response = await apiClient.post(
      ApiEndpoints.submitKycAddress,
      data: request.toJson(),
    );
    return KycResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Address submission failed');
  }
}

// BVN Step 1: Initialize (sends OTP)
Future<BvnInitializeResponse> initializeBvn(BvnInitializeRequest request) async {
  try {
    final response = await apiClient.post(
      ApiEndpoints.initializeBvn,
      data: request.toJson(),
    );
    return BvnInitializeResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Failed to send BVN OTP');
  }
}

// BVN Step 2: Validate (verifies OTP)
Future<KycResponse> validateBvn(BvnValidationRequest request) async {
  try {
    final response = await apiClient.post(
      ApiEndpoints.validateBvn,
      data: request.toJson(),
    );
    return KycResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'BVN verification failed');
  }
}

Future<KycResponse> getKycStatus() async {
  try {
    final response = await apiClient.get(ApiEndpoints.getKycStatus);
    return KycResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Failed to fetch KYC status');
  }
}
```

#### 4. Notifier
Create `lib/features/notifiers/kyc_notifier.dart`:

```dart
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:valarpay/core/network/api_client.dart';
import 'package:valarpay/core/network/data_state.dart';
import 'package:valarpay/features/models/kyc_response.dart';
import 'package:valarpay/features/repositories/user_repository.dart';

class KycNotifier extends StateNotifier<DataState<KycResponse>> {
  final UserRepository _repository;

  KycNotifier(this._repository) : super(DataState<KycResponse>.initial());

  Future<void> submitAddress(KycAddressRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.submitKycAddress(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[KycNotifier Address Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  // BVN Step 1: Initialize (sends OTP)
  Future<void> initializeBvn(BvnInitializeRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.initializeBvn(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res], // Contains verificationId
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[KycNotifier BVN Initialize Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  // BVN Step 2: Validate (verifies OTP)
  Future<void> validateBvn(BvnValidationRequest request) async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.validateBvn(request);
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[KycNotifier BVN Validate Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  Future<void> fetchKycStatus() async {
    state = state.copyWith(isInitialLoading: true, message: null);
    try {
      final res = await _repository.getKycStatus();
      state = state.copyWith(
        isInitialLoading: false,
        data: [res],
        isDataAvailable: true,
        message: res.message,
      );
    } catch (e, stack) {
      log('[KycNotifier Status Error] $e\n$stack');
      state = state.copyWith(
        isInitialLoading: false,
        isDataAvailable: false,
        message: e.toString(),
      );
    }
  }

  void reset() => state = DataState<KycResponse>.initial();
}

// Providers
final kycNotifierProvider =
    StateNotifierProvider<KycNotifier, DataState<KycResponse>>(
  (ref) => KycNotifier(ref.read(userRepositoryProvider)),
);
```

#### 5. UI Integration
Update KYC pages to call notifier methods:

**Residential_address.dart** (line ~135):
```dart
onPressed: () async {
  final addressRequest = KycAddressRequest(
    state: state,
    lga: lga,
    houseAddress: houseAddress,
    landmark: landmark,
  );
  
  await ref.read(kycNotifierProvider.notifier).submitAddress(addressRequest);
  
  final kycState = ref.read(kycNotifierProvider);
  if (kycState.isDataAvailable) {
    // Success - navigate
    ref.read(kycStepProvider.notifier).state = 2;
    Navigator.push(context, MaterialPageRoute(builder: (context) => const BVNPage()));
  } else {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(kycState.message ?? 'Submission failed')),
    );
  }
}
```

**BVN.dart** - Step 1: Initialize BVN (Send OTP)
```dart
onPressed: () async {
  final bvnRequest = BvnInitializeRequest(bvn: bvn);
  
  // Step 1: Send OTP to BVN-linked phone
  await ref.read(kycNotifierProvider.notifier).initializeBvn(bvnRequest);
  
  final kycState = ref.read(kycNotifierProvider);
  if (kycState.isDataAvailable) {
    // Get verificationId from response
    final verificationId = kycState.data?.first.verificationId;
    
    // Navigate to OTP verification screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BvnOtpVerificationPage(
          bvn: bvn,
          verificationId: verificationId,
        ),
      ),
    );
  } else {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(kycState.message ?? 'Failed to send OTP')),
    );
  }
}
```

**bvn_otp_verification.dart** - Step 2: Validate BVN (Verify OTP)
```dart
onPressed: () async {
  final request = BvnValidationRequest(
    verificationId: widget.verificationId,
    otpCode: _otp,
  );
  
  // Step 2: Verify OTP
  await ref.read(kycNotifierProvider.notifier).validateBvn(request);
  
  final kycState = ref.read(kycNotifierProvider);
  if (kycState.isDataAvailable && kycState.data?.first.verified == true) {
    // BVN verified successfully
    ref.read(kycStepProvider.notifier).state = 3;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CameraPermissionPage()),
    );
  } else {
    // Show error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(kycState.message ?? 'Invalid OTP')),
    );
  }
}
```

---

### Phase 2: Selfie Capture & Upload (KYC Level 3)

#### 1. Add Dependencies
Update `pubspec.yaml`:
```yaml
dependencies:
  image_picker: ^1.0.4
  permission_handler: ^11.0.1
```

#### 2. Add Multipart Upload to ApiClient
Add to `lib/core/network/api_client.dart`:
```dart
Future<Response> postMultipart(String path, {
  required String filePath,
  required String fieldName,
  Map<String, dynamic>? additionalData,
}) async {
  final formData = FormData.fromMap({
    fieldName: await MultipartFile.fromFile(filePath),
    if (additionalData != null) ...additionalData,
  });
  
  return await dio.post(path, data: formData);
}
```

#### 3. Create Selfie Capture Page
Create `lib/features/dashboard/view/KYC/selfie_capture_page.dart`:
- Use `image_picker` to capture photo
- Show preview
- Upload via repository method
- Handle success/error

#### 4. Repository Upload Method
```dart
Future<KycResponse> uploadKycDocument(String imagePath, String documentType) async {
  try {
    final response = await apiClient.postMultipart(
      ApiEndpoints.uploadKycDocument,
      filePath: imagePath,
      fieldName: 'document',
      additionalData: {'documentType': documentType},
    );
    return KycResponse.fromJson(response.data);
  } on DioException catch (e) {
    throw Exception(e.response?.data['message'] ?? 'Document upload failed');
  }
}
```

---

## Migration Checklist

When backend is ready:

- [ ] Backend confirms endpoint paths and request/response formats
- [ ] Add API endpoint constants
- [ ] Create request/response models with proper validation
- [ ] Implement repository methods with error handling
- [ ] Create/update KYC notifier with state management
- [ ] Wire providers in notifier file
- [ ] Update UI pages to call notifier methods
- [ ] Add loading states and error handling in UI
- [ ] Add success/failure toast notifications
- [ ] Update KYC widget on home screen to show KYC level status
- [ ] Test with mock data
- [ ] Integration testing with real backend
- [ ] Handle edge cases (network errors, timeouts, validation failures)

---

## Current State Providers (To Be Replaced)

These local state providers will be replaced by consolidated models:

```dart
// lib/features/dashboard/view/KYC/Residential_address.dart
final stateProvider = StateProvider<String>((ref) => '');
final lgaProvider = StateProvider<String>((ref) => '');
final houseAddressProvider = StateProvider<String>((ref) => '');
final landmarkProvider = StateProvider<String>((ref) => '');

// lib/features/dashboard/view/KYC/BVN.dart
final bvnProvider = StateProvider<String>((ref) => '');

// lib/features/dashboard/view/KYC/kyc_step_provider.dart
final kycStepProvider = StateProvider<int>((ref) => 1);
```

**Recommendation**: Create a unified `KycFormState` model that holds all form data and progress tracking for cleaner state management.

---

## Notes

- **Security**: BVN and personal data are sensitive. Ensure HTTPS, encryption, and proper data handling
- **Validation**: Add client-side validation for all fields before submission
- **User Experience**: Show clear loading states, progress indicators, and helpful error messages
- **Testing**: Write unit tests for models, repositories, and notifiers
- **Documentation**: Keep this file updated as implementation progresses

---

**Last Updated**: October 16, 2025  
**Status**: Awaiting backend endpoints for KYC submission
