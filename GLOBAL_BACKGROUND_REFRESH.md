# Global Background Token Refresh Integration

## ✅ Implementation Complete

Background token refreshing is now **fully integrated into the main app** and runs globally across the entire application.

---

## 🏗️ Architecture

```
main.dart (App Entry)
    ↓
AppInitializer (Global Service Manager)
    ├─ Initialize CacheHelper
    ├─ Check if user is authenticated
    └─ Start BackgroundTokenRefreshService (if tokens exist)
    ↓
Work Widget (App Root)
    ├─ Listen to app lifecycle
    ├─ Restart service when app resumes
    └─ Cleanup when app closes
    ↓
BackgroundTokenRefreshService (Singleton)
    ├─ Monitor token expiration (every 5 min)
    ├─ Auto-refresh before expiration
    └─ Handle 401 errors in TokenRefreshInterceptor
```

---

## 📁 New & Updated Files

### **New File: `lib/core/services/app_initializer.dart`**
- Global service initializer singleton
- Manages app startup and lifecycle
- Methods:
  - `initialize()` — Called from main.dart
  - `restartBackgroundRefresh()` — Called when app resumes
  - `cleanup()` — Called when app closes

### **Updated: `lib/main.dart`**
- Now async with proper initialization
- Calls `AppInitializer().initialize()` before `runApp()`
- Clean and minimal

### **Updated: `lib/work.dart`**
- Now extends `StatefulWidget` instead of `StatelessWidget`
- Implements `WidgetsBindingObserver` for lifecycle events
- Restarts background refresh when app comes to foreground
- Cleanup when app closes

### **Existing: `lib/features/Auth/presentation/controller/auth_cubit.dart`**
- Still starts background refresh on login (redundant but safe)
- Provides logout method to stop service

---

## 🔄 Complete Flow

### **App Startup**
```
1. main.dart executes
2. WidgetsFlutterBinding.ensureInitialized()
3. AppInitializer().initialize()
   ├─ CacheHelper.init()
   ├─ Check for existing tokens
   └─ If authenticated → BackgroundTokenRefreshService.startBackgroundRefresh()
4. runApp(Work())
5. Work widget initializes and adds WidgetsBindingObserver
```

### **User Logs In**
```
1. AuthCubit.login() called
2. Tokens saved to SharedPreferences
3. BackgroundTokenRefreshService.startBackgroundRefresh() (called by AuthCubit)
4. AuthSuccess state emitted
5. Background service already running → continues monitoring
```

### **App Goes to Background**
```
Work.didChangeAppLifecycleState(AppLifecycleState.paused)
→ Print log message
→ Service continues running in background
```

### **App Comes to Foreground**
```
Work.didChangeAppLifecycleState(AppLifecycleState.resumed)
→ AppInitializer().restartBackgroundRefresh()
→ Service restarts if tokens exist
→ Print log message
```

### **App Closes**
```
Work.didChangeAppLifecycleState(AppLifecycleState.detached)
→ AppInitializer().cleanup()
→ BackgroundTokenRefreshService.stopBackgroundRefresh()
→ Timer cancelled
```

### **User Logs Out**
```
AuthCubit.logout()
→ AppInitializer().cleanup() (or call BackgroundTokenRefreshService.stopBackgroundRefresh())
→ Service stops
→ Tokens cleared
```

---

## 🎯 What Happens in Background

**Every 5 minutes:**
1. Service checks token expiration time
2. If token expires within 2 minutes → triggers refresh
3. Makes POST request to `/api/auth/refresh-token`
4. Saves new tokens to SharedPreferences
5. Continues monitoring

**When API returns 401:**
1. TokenRefreshInterceptor catches error
2. Automatically calls `_refreshTokenRequest()`
3. Saves new tokens
4. Retries the original request
5. User doesn't notice anything

---

## 📊 Service Status Logging

When the app runs, you'll see console logs:
```
✓ Cache helper initialized
✓ Background token refresh service started    [App startup]
📱 App resumed - Background token refresh restarted
📱 App paused
📱 App inactive
📱 App hidden
📱 App detached - Cleanup completed
```

---

## 🔐 Security & Performance

✅ **Runs in background** — No UI blocking  
✅ **Singleton pattern** — Only one instance  
✅ **Smart refresh** — Doesn't refresh more than needed  
✅ **Graceful degradation** — Errors don't crash app  
✅ **Minimal network** — Only refreshes before expiration  
✅ **Memory efficient** — Timer cleaned up on logout/app close  

---

## 🚀 Features

| Feature | Status | Notes |
|---------|--------|-------|
| Auto-start on app launch | ✅ | If user has tokens |
| Background monitoring | ✅ | Every 5 minutes |
| Auto-refresh before expiry | ✅ | Within 2 minutes |
| Add auth headers to requests | ✅ | Via interceptor |
| Handle 401 errors | ✅ | Auto-refresh & retry |
| App lifecycle handling | ✅ | Pause/resume/detach |
| Manual token refresh | ✅ | Via AuthCubit |
| Logout cleanup | ✅ | Stops service, clears tokens |

---

## 💡 Usage Examples

### **Check if Authenticated**
```dart
bool isAuth = context.read<AuthCubit>().isAuthenticated();
```

### **Manual Token Refresh**
```dart
bool success = await context.read<AuthCubit>().refreshTokens();
if (success) print('Tokens refreshed');
```

### **Logout**
```dart
await context.read<AuthCubit>().logout();
```

### **Access AppInitializer Directly**
```dart
// Restart service
AppInitializer().restartBackgroundRefresh();

// Cleanup
await AppInitializer().cleanup();
```

---

## 🎓 Summary

Your app now has a **production-ready background token management system** that:

1. **Starts automatically** when app launches (if user is logged in)
2. **Monitors tokens** in the background every 5 minutes
3. **Refreshes automatically** before tokens expire
4. **Handles errors** gracefully with 401 recovery
5. **Respects app lifecycle** (pause/resume/close)
6. **Cleans up properly** on logout
7. **Works seamlessly** without user interaction

**No more manual token management or "session expired" errors!** 🎉

---

## 📝 Files Changed

1. ✅ `lib/main.dart` — Async initialization
2. ✅ `lib/work.dart` — Lifecycle handling  
3. ✅ `lib/core/services/app_initializer.dart` — NEW global service manager
4. ✅ `lib/features/Auth/presentation/controller/auth_cubit.dart` — Already has refresh calls

**Ready to use!** The background token refresh is now fully integrated into your app. 🚀
