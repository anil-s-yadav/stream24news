# Flutter Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Play Core optional deferred components
-dontwarn com.google.android.play.core.**

# Preserve line numbers and source file names for deobfuscated stack traces
-keepattributes SourceFile,LineNumberTable
-keepattributes *Annotation*

# Google / Firebase
-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.firebase.** { *; }

# Media / ExoPlayer / Video Player
-dontwarn androidx.media3.**
-keep class androidx.media3.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class com.google.android.exoplayer2.** { *; }

# Common optional network/annotation dependencies
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn org.checkerframework.**
