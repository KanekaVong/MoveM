import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val localProperties = Properties().apply {
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        load(FileInputStream(localPropertiesFile))
    }
}
val mapsApiKey: String = localProperties.getProperty("MAPS_API_KEY") ?: ""

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    namespace = "com.example.movem"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.example.movem"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
        ndk {
            abiFilters.clear()
            abiFilters.add("arm64-v8a")
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("dev") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "MoveM Dev")
        }
        create("prod") {
            dimension = "default"
            resValue("string", "app_name", "MoveM")
        }
    }

    signingConfigs {
        create("release") {
            val keyAliasProp = keystoreProperties.getProperty("keyAlias")
            val keyPasswordProp = keystoreProperties.getProperty("keyPassword")
            val storeFileProp = keystoreProperties.getProperty("storeFile")
            val storePasswordProp = keystoreProperties.getProperty("storePassword")

            if (storeFileProp != null && rootProject.file(storeFileProp).exists()) {
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp
                storeFile = rootProject.file(storeFileProp)
                storePassword = storePasswordProp
            } else {
                val debugConfig = signingConfigs.getByName("debug")
                keyAlias = debugConfig.keyAlias
                keyPassword = debugConfig.keyPassword
                storeFile = debugConfig.storeFile
                storePassword = debugConfig.storePassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
            excludes += setOf(
                "lib/armeabi/**",
                "lib/armeabi-v7a/**",
                "lib/x86/**",
                "lib/x86_64/**",
            )
        }
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_21)
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

tasks.register("cleanOldApks") {
    doFirst {
        val outDir = file("${project.layout.buildDirectory.get().asFile}/outputs/flutter-apk")
        if (outDir.exists()) {
            outDir.listFiles()?.forEach { file ->
                if (file.isFile && (file.name.endsWith(".apk") || file.name.endsWith(".sha1"))) {
                    file.delete()
                }
            }
        }
    }
}

tasks.register("copyReleaseApk") {
    doLast {
        val outDir = file("${project.layout.buildDirectory.get().asFile}/outputs/flutter-apk")
        val prodApk = file("$outDir/app-prod-release.apk")
        val defaultApk = file("$outDir/app-release.apk")
        if (prodApk.exists()) {
            prodApk.copyTo(defaultApk, overwrite = true)
        } else {
            val devApk = file("$outDir/app-dev-release.apk")
            if (devApk.exists()) {
                devApk.copyTo(defaultApk, overwrite = true)
            }
        }
    }
}

tasks.matching { it.name.startsWith("assemble") }.configureEach {
    dependsOn("cleanOldApks")
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy("copyReleaseApk")
}
