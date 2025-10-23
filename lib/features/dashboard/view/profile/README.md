# Profile Screens Implementation

This folder contains the complete profile management screens for the ValarPay app, following the design shown in the provided screenshots.

## Screens Implemented

### 1. Main Profile Screen (`profile.dart`)
- Entry point for profile management
- Shows profile header with user ID
- Menu items for Personal Details, Contact Details, and Address
- Uses reusable ProfileMenuItem widgets

### 2. Personal Details Screen (`personal_details_screen.dart`)
- Displays user's personal information
- Shows: Full Name, Last Name, Date of Birth, Gender
- Read-only view of personal data

### 3. Contact Details Screen (`contact_details_screen.dart`)
- Displays contact information
- Shows: Mobile Number, Email Address
- Editable fields that navigate to update screens

### 4. Address Screen (`address_screen.dart`)
- Displays address information
- Shows: LGA, State, Address, Landmark
- Read-only view of address data

### 5. Update Username Screen (`update_username_screen.dart`)
- Reusable screen for updating various profile fields
- Configurable title, current value, and field label
- Validation and change detection
- Success feedback

## Reusable Widgets

Located in `lib/features/dashboard/widgets/services_widgets/profile_widgets/`:

### 1. ProfileMenuItem (`profile_menu_item.dart`)
- Reusable menu item with icon, title, and navigation
- Consistent styling with theme support
- Optional trailing widgets and arrow indicators

### 2. ProfileInfoTile (`profile_info_tile.dart`)
- Displays profile information in a consistent format
- Label and value display
- Optional edit functionality with navigation
- Theme-aware styling

### 3. ProfileHeader (`profile_header.dart`)
- Profile header with avatar and user information
- Optional edit button
- Consistent styling across screens

### 4. ProfileSectionHeader (`profile_section_header.dart`)
- Section headers with optional action buttons
- Title and subtitle support
- Consistent typography

## Navigation Integration

The profile screens are integrated into the app's routing system:

- `/profile` - Main profile screen
- `/personal-details-view` - Personal details view
- `/contact-details-view` - Contact details view
- `/address-view` - Address view

A "My Profile" menu item has been added to the account widget in the Me screen.

## Features

### Theme Support
- All screens support both light and dark themes
- Consistent color scheme with app branding
- Proper contrast and accessibility

### Navigation Flow
- Hierarchical navigation with proper back buttons
- Smooth transitions between screens
- Context-aware navigation

### User Experience
- Consistent UI patterns across all screens
- Clear visual hierarchy
- Intuitive navigation flow
- Proper loading and error states

### Reusability
- Modular widget architecture
- Configurable components
- Easy to extend and maintain

## Usage Example

```dart
// Navigate to profile screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ProfileScreen(),
  ),
);

// Or using GoRouter
context.push('/profile');
```

## Data Integration

The screens are ready for backend integration:
- Profile data can be fetched from user providers
- Update functionality can be connected to API endpoints
- Form validation and error handling are in place

## Customization

The screens can be easily customized by:
- Modifying the reusable widgets
- Updating the theme colors
- Adding new profile fields
- Extending the navigation flow

All screens follow the established patterns in the ValarPay app and maintain consistency with the existing design system.