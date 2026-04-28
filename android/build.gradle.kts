allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Force all plugin subprojects to use Java 11 so older Kotlin plugins
// (e.g. network_info_plus) don't fail with "Unknown Kotlin JVM target: 21"
subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("kotlin-android")) {
            (extensions.findByName("android") as? com.android.build.gradle.BaseExtension)?.apply {
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_11
                    targetCompatibility = JavaVersion.VERSION_11
                }
                (this as? com.android.build.gradle.LibraryExtension)
                    ?.libraryVariants?.all {
                        // no-op, just triggers evaluation
                    }
            }
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                kotlinOptions.jvmTarget = "11"
            }
        }
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
