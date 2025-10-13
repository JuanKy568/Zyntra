plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ usa este id completo en lugar de kotlin-android
    id("com.google.gms.google-services") // ✅ debe ir aquí, pero después de los de Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin") // ✅ el plugin de Flutter siempre al final
}

android {
    namespace = "com.example.kraft_drive"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // ✅ Firebase requiere Java 17 o superior
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17" // ✅ aseguramos compatibilidad con las nuevas librerías
    }

    defaultConfig {
        applicationId = "com.example.kraft_drive"
        minSdk = flutter.minSdkVersion // ✅ Firebase necesita al menos API 23
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
