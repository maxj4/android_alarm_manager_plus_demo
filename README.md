# Flutter Timer App

## Description

This Flutter Timer App demonstrates how to create a background timer that continues running even when the app is closed, using the `android_alarm_manager_plus` package. It also showcases how to send local notifications when the timer completes and how to handle permissions for exact alarms on Android 12 and above.

## Features

- Set a timer that runs in the background
- Receive a notification when the timer completes
- Proper permission handling for Android 12+
- Simple and intuitive user interface

## Prerequisites

Before you begin, ensure you have met the following requirements:

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- Android Studio / VS Code
- An Android device or emulator (API level 16 or higher)

## Installation

1. Clone this repository:
``` git clone https://github.com/maxj4/flutter_timer_app.git ```

2. Navigate to the project directory:
```cd flutter_timer_app```

3. Install dependencies:
```flutter pub get```


## Configuration

### Android

1. Ensure your `android/app/src/main/AndroidManifest.xml` file includes the following permissions and service declarations:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

<application ...>
    <!-- Your existing application configuration -->

    <service
        android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmService"
        android:permission="android.permission.BIND_JOB_SERVICE"
        android:exported="false"/>
    <receiver
        android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmBroadcastReceiver"
        android:exported="false"/>
    <receiver
        android:name="dev.fluttercommunity.plus.androidalarmmanager.RebootBroadcastReceiver"
        android:enabled="false"
        android:exported="false">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED" />
        </intent-filter>
    </receiver>
</application>
```

## iOS
This app is primarily designed for Android due to the use of android_alarm_manager_plus. Additional configuration would be needed for iOS compatibility.

## Usage
1. Run the app on an Android device or emulator:
```flutter run```

2. Enter the desired timer duration in seconds.
3. Tap the "Start Timer" button to begin the countdown.
4. The timer will continue running in the background, and you'll receive a notification when it completes.

## Dependencies
- [android_alarm_manager_plus](https://pub.dev/packages/android_alarm_manager_plus): ^3.0.1
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications): ^15.1.0+1
- [permission_handler](https://pub.dev/packages/permission_handler): ^11.3.1

## Contributing
Contributions to this project are welcome. Please feel free to fork the repository and submit pull requests.

## License
This project is open source and available under the MIT License.