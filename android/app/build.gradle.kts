plugins {
id("com.android.application")
id("kotlin-android")
id("dev.flutter.flutter-gradle-plugin")
id("com.google.gms.google-services")
}

android {
namespace = "com.radyobilecik.radyoapp"
compileSdk = flutter.compileSdkVersion
ndkVersion = flutter.ndkVersion

compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlinOptions {
    jvmTarget = JavaVersion.VERSION_17.toString()
}

defaultConfig {
    applicationId = "com.radyobilecik.radyoapp"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
}

signingConfigs {
    create("release") {
        storeFile = file(System.getenv("CM_KEYSTORE_PATH") ?: (System.getProperty("user.home") + "/keystore.keystore"))
        storePassword = System.getenv("CM_KEYSTORE_PASSWORD") ?: ""
        keyAlias = System.getenv("CM_KEY_ALIAS") ?: ""
        keyPassword = System.getenv("CM_KEY_PASSWORD") ?: ""
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        isMinifyEnabled = false
        isShrinkResources = false
    }
}
}

flutter {
source = "../.."
}