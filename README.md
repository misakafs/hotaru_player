# Hotaru Player


## 问题

1. 全屏铺满

- `android/app/src/main/res/values/styles.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    
    <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
        <item name="android:windowBackground">?android:colorBackground</item>
        <!-- 添加下面这一行 -->
        <item name="android:windowLayoutInDisplayCutoutMode">shortEdges</item>
    </style>
</resources>
```

2. 设置屏幕亮度和音量，需要提供下面的权限

```xml
<uses-permission android:name="android.permission.WRITE_SETTINGS" />
```