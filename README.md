# fzxing

A Zxing flutter plugin project to wrap [zxing-android-embedded](https://github.com/journeyapps/zxing-android-embedded) for Android and [LBXScan](https://github.com/MxABC/LBXScan) for iOS

## Parameters' default value

```dart
    bool isBeep = true,
    bool isContinuous = false,
    int continuousInterval = 1000, // only works when isContinuous is true
```

## Destructive change

`scan` will return a `List<String>` instead of `String`
