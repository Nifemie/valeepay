# Notifications Feature

This folder contains the notification screens and functionality for the ValarPay app.

## Files

- `notifications_screen.dart` - Main notifications screen with tabs for different notification types
- `welcome_notification_screen.dart` - Welcome screen shown to new users

## Features

### Notifications Screen
- **Tabbed Interface**: Four tabs (Transactions, Services, Updates, Messages)
- **Empty States**: Shows bell icon with appropriate messages when no notifications exist
- **Notification List**: Displays notifications with icons, titles, subtitles, and timestamps
- **Read/Unread States**: Visual indicators for read and unread notifications
- **Settings Access**: Navigation to notification settings

### Notification Types
1. **Transactions** - Payment confirmations, bill payments, transfers
2. **Services** - Service updates and notifications
3. **Updates** - App updates and feature announcements  
4. **Messages** - Direct messages from ValarPay

### Navigation
- Accessible from home screen bell icon
- Settings screen accessible from notifications screen
- Proper back navigation implemented

## Reusable Widgets

The notification widgets are located in `lib/features/dashboard/widgets/home_widgets/notification_widgets.dart`:

- `NotificationTabView` - Container for notification lists with empty states
- `NotificationEmptyState` - Empty state with bell icon and message
- `NotificationTile` - Individual notification item
- `NotificationSettingsScreen` - Settings screen for notification preferences
- `NotificationSettingTile` - Individual setting toggle

## Usage

To navigate to notifications from any screen:
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const NotificationsScreen(),
  ),
);
```

The notification button in the home screen automatically handles this navigation.