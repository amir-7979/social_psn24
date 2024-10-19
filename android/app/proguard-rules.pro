-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers class * {
   @com.google.firebase.messaging.FirebaseMessagingService <methods>;
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keepnames @com.google.firebase.* class *
-dontwarn com.google.firebase.messaging.**
