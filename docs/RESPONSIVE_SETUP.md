# Responsive Design Setup with Flutter ScreenUtil

## Overview
The ValarPayee app uses `flutter_screenutil` to ensure consistent responsive design across different devices and orientations. The design is based on Figma dimensions of **375px × 812px**.

## Configuration

### Main App Setup
```dart
// lib/main.dart
ScreenUtilInit(
  designSize: const Size(375, 812), // Figma design dimensions
  minTextAdapt: true,
  splitScreenMode: true,
  builder: (context, child) {
    return MaterialApp.router(
      // App configuration
    );
  },
)
```

## Usage Guidelines

### Basic Responsive Units
- **Width**: Use `.w` for horizontal dimensions
- **Height**: Use `.h` for vertical dimensions  
- **Font Size**: Use `.sp` for text sizes
- **Radius**: Use `.r` for border radius

### Examples
```dart
// Spacing
SizedBox(height: 24.h)
SizedBox(width: 16.w)
EdgeInsets.all(24.w)

// Container dimensions
Container(
  width: 40.w,
  height: 40.h,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
  ),
)

// Text styles
Text(
  'ValarPayee',
  style: TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  ),
)
```

## Responsive Utils Class

### Available Constants
```dart
// Spacing
ResponsiveUtils.spacing8    // 8.h
ResponsiveUtils.spacing16   // 16.h
ResponsiveUtils.spacing24   // 24.h
ResponsiveUtils.spacing40   // 40.h

// Font sizes
ResponsiveUtils.fontSize14  // 14.sp
ResponsiveUtils.fontSize16  // 16.sp
ResponsiveUtils.fontSize24  // 24.sp

// Common text styles
ResponsiveUtils.titleLarge  // 28.sp, bold
ResponsiveUtils.bodyMedium  // 14.sp, w500
ResponsiveUtils.buttonText  // 16.sp, w600

// Padding presets
ResponsiveUtils.paddingAll24
ResponsiveUtils.paddingHorizontal16
ResponsiveUtils.paddingVertical12
```

### Screen Breakpoints
```dart
ResponsiveUtils.isMobile   // <= 600px
ResponsiveUtils.isTablet   // > 600px && <= 1024px
ResponsiveUtils.isDesktop  // > 1024px
```

## Implementation Status

### ✅ Configured Screens
- **Main App** - ScreenUtilInit setup
- **Sign In Screen** - Full responsive implementation
- **Need Help Modal** - Responsive dimensions
- **Intro Wrapper** - ScreenUtil import added

### 🔄 Screens to Update
- Biometric Login Screen
- Signup Success Screen
- Verify Phone Screen
- Email Password Screen
- Personal/Business Details Screens
- All other authentication screens

## Best Practices

### 1. Consistent Spacing
Use predefined spacing values from ResponsiveUtils:
```dart
// Good
SizedBox(height: ResponsiveUtils.spacing24)

// Also good
SizedBox(height: 24.h)

// Avoid
SizedBox(height: 24.0)
```

### 2. Text Styles
Use responsive text styles:
```dart
// Good
Text('Title', style: ResponsiveUtils.titleLarge)

// Also good  
Text('Title', style: TextStyle(fontSize: 28.sp))

// Avoid
Text('Title', style: TextStyle(fontSize: 28))
```

### 3. Container Dimensions
Always use responsive units for containers:
```dart
// Good
Container(
  width: 40.w,
  height: 40.h,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(8.r),
  ),
)
```

### 4. Padding and Margins
Use responsive padding:
```dart
// Good
Padding(padding: EdgeInsets.all(24.w))
Padding(padding: ResponsiveUtils.paddingAll24)

// Avoid
Padding(padding: EdgeInsets.all(24.0))
```

## Device Testing

### Supported Orientations
- Portrait (primary)
- Landscape (responsive)

### Target Devices
- **Mobile**: 375×812 (iPhone X/11/12/13)
- **Tablet**: iPad dimensions
- **Desktop**: Web responsive

### Testing Checklist
- [ ] Text remains readable on all screen sizes
- [ ] Buttons maintain proper touch targets (44×44 minimum)
- [ ] Spacing scales proportionally
- [ ] Images and icons scale correctly
- [ ] Forms remain usable in landscape mode

## Migration Guide

### Converting Existing Screens
1. Add ScreenUtil import:
```dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
```

2. Convert dimensions:
```dart
// Before
height: 24.0
width: 16.0
fontSize: 14.0
borderRadius: BorderRadius.circular(8.0)

// After  
height: 24.h
width: 16.w
fontSize: 14.sp
borderRadius: BorderRadius.circular(8.r)
```

3. Use ResponsiveUtils for common values:
```dart
import '../../../../core/utils/responsive_utils.dart';

// Use predefined styles
style: ResponsiveUtils.titleLarge
padding: ResponsiveUtils.paddingAll24
```

## Performance Considerations

- ScreenUtil calculations are cached for performance
- Minimal impact on build times
- Automatic adaptation to device pixel ratio
- Efficient memory usage with singleton pattern

## Troubleshooting

### Common Issues
1. **Text too small on large screens**: Use `.sp` instead of fixed sizes
2. **Inconsistent spacing**: Use ResponsiveUtils constants
3. **Layout overflow**: Check responsive units in Flex widgets
4. **Performance issues**: Avoid creating new ScreenUtil instances

### Debug Tips
```dart
// Check current screen dimensions
print('Screen width: ${ScreenUtil().screenWidth}');
print('Screen height: ${ScreenUtil().screenHeight}');
print('Device pixel ratio: ${ScreenUtil().pixelRatio}');
```