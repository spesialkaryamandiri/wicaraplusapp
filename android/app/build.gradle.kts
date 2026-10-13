import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use(keystoreProperties::load)
}

val releaseKeyAlias = keystoreProperties.getProperty("keyAlias")?.takeIf(String::isNotBlank)
val releaseKeyPassword =
    keystoreProperties.getProperty("keyPassword")?.takeIf(String::isNotBlank)
val releaseStorePassword =
    keystoreProperties.getProperty("storePassword")?.takeIf(String::isNotBlank)
val releaseStoreFilePath =
    keystoreProperties.getProperty("storeFile")?.takeIf(String::isNotBlank)
val releaseStoreFile = releaseStoreFilePath?.let { file(it) }
val releaseSigningConfigured =
    releaseKeyAlias != null &&
        releaseKeyPassword != null &&
        releaseStorePassword != null &&
        releaseStoreFile?.isFile == true

android {
    namespace = "com.spesialkaryamandiri.wicaraplusapp"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.spesialkaryamandiri.wicaraplusapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (releaseSigningConfigured) {
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
                storePassword = releaseStorePassword
                storeFile = releaseStoreFile
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

val validateReleaseSigning by tasks.registering {
    doLast {
        val missingProperties = buildList {
            if (releaseKeyAlias == null) add("keyAlias")
            if (releaseKeyPassword == null) add("keyPassword")
            if (releaseStorePassword == null) add("storePassword")
            if (releaseStoreFilePath == null) add("storeFile")
        }

        if (missingProperties.isNotEmpty()) {
            throw GradleException(
                "Release signing is incomplete. Check android/key.properties; " +
                    "missing or blank values: ${missingProperties.joinToString()}."
            )
        }

        if (releaseStoreFile?.isFile != true) {
            throw GradleException(
                "Release keystore not found. Check the storeFile path in " +
                    "android/key.properties."
            )
        }
    }
}

tasks.configureEach {
    if (name == "assembleRelease" || name == "bundleRelease") {
        dependsOn(validateReleaseSigning)
    }
}
