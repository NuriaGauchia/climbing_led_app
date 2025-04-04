buildscript {
    dependencies {
        // Asegura que el compilador de Kotlin sea compatible con Firebase
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.0.0")
    }
}

plugins {
    // Kotlin plugin compatible con Firebase y librerías modernas
    kotlin("android") version "2.0.0" apply false

    // Plugin de Firebase (Google Services)
    id("com.google.gms.google-services") version "4.3.15" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

