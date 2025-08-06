# Keep protobuf classes
-keep class com.google.protobuf.** { *; }
-dontwarn com.google.protobuf.**

# Keep MediaPipe related classes
-keep class com.google.mediapipe.** { *; }
-dontwarn com.google.mediapipe.**

# Keep your video thumbnail plugin classes
-keep class xyz.justsoft.video_thumbnail.** { *; }
