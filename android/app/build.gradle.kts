plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ usa este en lugar de "kotlin-android" para mayor compatibilidad
    id("com.google.gms.google-services") // Firebase plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.climbing_led_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.climbing_led_app"
        minSdk = 23 // ✅ actualizado para Firebase Auth
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (Bill of Materials)
    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))

    // Servicios de Firebase que estás usando
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
}
