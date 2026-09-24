# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# GetX / reflection
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Gson / JSON models
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Google Maps / location
-keep class com.google.android.libraries.maps.** { *; }
-keep class com.google.maps.android.** { *; }
-keep class com.google.android.gms.maps.** { *; }
-keep class com.google.android.gms.location.** { *; }

# ML Kit pose detection
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_pose_** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_common.** { *; }
-dontwarn com.google.mlkit.**

# CameraX / camera
-keep class androidx.camera.** { *; }
-keep class io.flutter.plugins.camera.** { *; }

# Isar
-keep class io.isar.** { *; }
-keepclassmembers class * {
    @io.isar.Id <fields>;
    @io.isar.Index <fields>;
}

# Play services / desugar
-dontwarn java.lang.invoke.**
-dontwarn javax.annotation.**

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Crash stack traces
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
