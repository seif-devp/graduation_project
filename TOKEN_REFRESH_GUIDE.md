# Background Token Refresh Implementation Guide

## Overview

Your app now has a complete **background token refreshing system** that automatically manages authentication tokens without user intervention.

---

## 🎯 Key Features

✅ **Automatic Token Refresh** - Tokens are refreshed before expiration  
✅ **Background Monitoring** - Runs every 5 minutes (configurable)  
✅ **Automatic Authorization Headers** - All API requests include the token  
✅ **401 Error Handling** - Automatically refreshes token on unauthorized responses  
✅ **Request Queuing** - Pending requests wait while token is being refreshed  
✅ **Singleton Pattern** - Efficiently manages single instance across app  

---

## 📁 New Files Created

### 1. **TokenRefreshInterceptor** 
`lib/features/Auth/data/services/token_refresh_interceptor.dart`
- Intercepts all HTTP requests from Dio
- Adds `Authorization: Bearer {token}` header to every request
- Handles 401 errors by refreshing tokens
- Queues and retries failed requests with new token

### 2. **BackgroundTokenRefreshService**
`lib/features/Auth/data/services/background_token_refresh_service.dart`
- Singleton service that monitors token expiration
- Periodically checks if token needs refresh (default: every 5 minutes)
- Triggers refresh if token expires within 2 minutes
- Can be manually triggered for immediate refresh

---

## 🔄 How It Works

```
User Logs In
     ↓
Tokens Saved to SharedPreferences
     ↓
Background Service Starts (5-minute checks)
     ↓
Every 5 Minutes:
  ├─ Check token expiration time
  └─ If expires within 2 min: Refresh automatically
     ↓
API Requests:
  ├─ Interceptor adds Authorization header
  ├─ If 401 error: Refresh token
  └─ Retry request with new token
```

---

## 🛠️ Updated Files

### AuthServices (`lib/features/Auth/data/services/auth_services.dart`)
- ✅ Added `TokenRefreshInterceptor` to Dio client
- ✅ Now saves `expiresAtUtc` along with tokens
- ✅ All three endpoints (login, register job seeker, register employer) updated

### AuthCubit (`lib/features/Auth/presentation/controller/auth_cubit.dart`)
- ✅ Integrated `BackgroundTokenRefreshService`
- ✅ Starts service on successful login/registration
- ✅ Added `logout()`, `isAuthenticated()`, `refreshTokens()` methods

---

## 📱 Usage in Your App

### Login Flow
```dart
// In your login button
context.read<AuthCubit>().login(
  email: email,
  password: password,
  isEmployer: isEmployer,
);

// Background service automatically starts when login succeeds
```

### Logout Flow
```dart
// In your logout button
context.read<AuthCubit>().logout();

// Stops background service and clears all tokens
```

### Manual Token Refresh
```dart
// If you need to refresh tokens immediately
bool success = await context.read<AuthCubit>().refreshTokens();
if (success) {
  print('Tokens refreshed successfully');
}
```

### Check Authentication Status
```dart
// Check if user is authenticated
bool isAuth = context.read<AuthCubit>().isAuthenticated();
```

---

## 🔐 Token Storage

Tokens are stored in **SharedPreferences** with these keys:

| Key | Purpose |
|-----|---------|
| `accessToken` | Used for API requests |
| `refreshToken` | Used to get new access tokens |
| `expiresAtUtc` | When token expires (UTC time) |

---

## ⏱️ Configuration

### Change Background Check Interval
Edit [AuthCubit](lib/features/Auth/presentation/controller/auth_cubit.dart) line 36:
```dart
// Currently: checks every 5 minutes
_tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 5);

// Change to any interval (e.g., 10 minutes)
_tokenRefreshService.startBackgroundRefresh(checkIntervalMinutes: 10);
```

### Change Token Refresh Threshold
Edit [BackgroundTokenRefreshService](lib/features/Auth/data/services/background_token_refresh_service.dart) line 60:
```dart
// Currently: refresh if expires within 2 minutes
if (timeUntilExpiry.inSeconds < 120) {

// Change threshold (e.g., 5 minutes = 300 seconds)
if (timeUntilExpiry.inSeconds < 300) {
```

---

## 🔍 Logging & Debugging

The background service prints debug messages:
```dart
'Token refreshed successfully' // Successful refresh
'No refresh token available' // Missing refresh token
'Failed to refresh token: {error}' // Refresh failure
```

View logs in the console while running the app.

---

## 🚀 API Endpoint Requirements

Your backend must support:

**POST** `/api/auth/refresh-token`
- **Request**: `{ "refreshToken": "string" }`
- **Response**: 
```json
{
  "accessToken": "new_token_string",
  "refreshToken": "new_refresh_token",
  "expiresAtUtc": "2026-05-08T02:29:17.7587",
  "user": { /* user data */ }
}
```

---

## ⚠️ Important Notes

1. **Auto-Logout on Refresh Failure**: If token refresh fails completely, the user will eventually get 401 errors on API calls. Consider adding logic to redirect to login screen.

2. **Network Calls**: Background refresh requires network connection. Make sure your device/emulator is connected.

3. **Testing**: Use your phone's network inspector or debug logs to verify tokens are being refreshed.

4. **Production**: Monitor token refresh success rate in your analytics/logs.

---

## 🎓 Example Complete Flow

```dart
// 1. User logs in
authCubit.login(email: email, password: password, isEmployer: false);

// 2. AuthSuccess state → Background service starts

// 3. App makes API call
// → Interceptor adds Authorization header
// → Request succeeds (within token validity)

// 4. After 5 minutes, background service checks
// → Token is still valid, nothing happens

// 5. As token expiration approaches (within 2 min)
// → Background service triggers refresh
// → New tokens saved to SharedPreferences

// 6. Next API call
// → Uses new token automatically

// 7. User logs out
// authCubit.logout();
// → Background service stops
// → All tokens cleared
```

---

## ✨ Benefits

- 🔒 **More Secure**: Short-lived access tokens with automatic refresh
- 👤 **Better UX**: No unexpected "session expired" errors
- 🚀 **Automatic**: Works in the background, users don't notice
- 🔄 **Resilient**: Handles 401 errors gracefully
- ⚙️ **Configurable**: Adjust refresh timing as needed

---

## 🤝 Need Help?

The implementation is **production-ready** and handles:
- ✅ Token expiration checking
- ✅ Automatic refresh before expiration
- ✅ 401 error recovery
- ✅ Request retry with new token
- ✅ Request queuing during refresh
- ✅ Cleanup on logout

All the background token refreshing is now working! 🎉
