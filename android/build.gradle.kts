allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    afterEvaluate {
        if (
            name != "app" &&
            plugins.hasPlugin("com.android.library")
        ) {
            val androidExt = extensions.findByName("android")
            if (androidExt != null) {
                // Remove package attribute from Manifest to satisfy AGP 8+
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    var content = manifestFile.readText()
                    if (content.contains("package=")) {
                        content = content.replace(Regex("package=\"[^\"]*\""), "")
                        manifestFile.writeText(content)
                        println("Patch: Removed package attribute from Manifest of $name")
                    }
                }

                val hasNamespace = try {
                    val ns = androidExt.javaClass
                        .getMethod("getNamespace")
                        .invoke(androidExt) as String?
                    !ns.isNullOrBlank()
                } catch (e: Exception) {
                    false
                }

                if (!hasNamespace) {
                    try {
                        androidExt.javaClass
                            .getMethod("setNamespace", String::class.java)
                            .invoke(
                                androidExt,
                                "com.sharel.plugins.${name.replace("-", "_")}"
                            )
                        println("Patch: Assigned namespace to $name")
                    } catch (e: Exception) {
                        println("Patch: Failed to assign namespace to $name: ${e.message}")
                    }
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
