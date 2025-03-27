plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 35  

    defaultConfig {
        applicationId = "com.example.flutterapp"
        minSdk = 21 // Or your desired minimum SDK version
        targetSdk = 35 // Update this to 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    namespace = "com.example.my_project"

    // Set the NDK version to match the required one
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
