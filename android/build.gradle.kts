allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // Fix for older packages missing the namespace property
    plugins.withId("com.android.library") {
        afterEvaluate {
            if (extensions.findByType<com.android.build.gradle.LibraryExtension>()?.namespace == null) {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val parser = javax.xml.parsers.SAXParserFactory.newInstance().newSAXParser()
                    val packageNameHolder = object {
                        var packageName: String? = null
                    }
                    
                    parser.parse(manifestFile, object : org.xml.sax.helpers.DefaultHandler() {
                        override fun startElement(uri: String?, localName: String?, qName: String?, attributes: org.xml.sax.Attributes?) {
                            if (qName == "manifest") {
                                packageNameHolder.packageName = attributes?.getValue("package")
                            }
                        }
                    })
                    
                    packageNameHolder.packageName?.let { packageName ->
                        extensions.findByType<com.android.build.gradle.LibraryExtension>()?.namespace = packageName
                        println("Set namespace for ${project.name} to: $packageName")
                    }
                }
            }
            
            // Fix for Kotlin JVM target compatibility issues
            project.tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                kotlinOptions {
                    jvmTarget = "11"
                }
            }
        }
    }
    
    // Set kotlin JVM target for all projects
    tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
        kotlinOptions {
            jvmTarget = "11"
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
