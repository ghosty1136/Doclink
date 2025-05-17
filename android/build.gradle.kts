buildscript {
    repositories {
        google()  // Ensure that Google repository is included
        mavenCentral()
    }
    dependencies {
        // Add classpath for Google Services Plugin
        classpath("com.google.gms:google-services:4.3.15") // Make sure this is the latest version
        classpath("com.android.tools.build:gradle:7.4.1")  // Update to the latest Gradle version if needed
    }
}

allprojects {
    repositories {
        google()  // Google repository
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
