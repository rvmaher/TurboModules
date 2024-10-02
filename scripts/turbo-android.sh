#!/bin/bash

# Function to create a Kotlin file with content
create_kotlin_file() {
    local file_path="$1"
    local content="$2"
    echo -e "$content" > "$file_path"
    echo "Created: $file_path"
}

# Function to append new module to NativeModulesRegistry.kt
append_to_registry() {
    local module_name="$1"
    local registry_path="android/app/src/main/java/com/turbomodules/modules/registry/NativeModulesRegistry.kt"

    # Check if NativeModulesRegistry.kt already exists
    if [ ! -f "$registry_path" ]; then
        # Create the registry directory if it doesn't exist
        mkdir -p "android/app/src/main/java/com/turbomodules/modules/registry"
        echo "Created registry directory."

        # Create the initial NativeModulesRegistry.kt file
        local registry_content=$(cat <<EOF
package com.turbomodules.modules.registry
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.turbomodules.modules.${module_name}Package
class NativeModulesRegistry : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf(
            ${module_name}Package() // Add new module here
        )
    }
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
}
EOF
        )
        create_kotlin_file "$registry_path" "$registry_content"
        echo "NativeModulesRegistry.kt created with $module_name."
    else
        # # Append the new module to the existing NativeModulesRegistry.kt
        # local module_registration="${module_name}Package(),"
        
        # # Check if the module is already registered
        # if ! grep -q "$module_registration" "$registry_path"; then
        #     sed -i.bak "/return listOf($module_registration" "$registry_path"
        #     echo "Appended module registration for $module_name in NativeModulesRegistry.kt"
        # else
        #     echo "Module $module_name is already registered in NativeModulesRegistry.kt"
        # fi
        echo "*** turbo module registry already exist. skipping it. ***"
    fi
}

# Function to update MainApplication.kt only the first time
# update_main_application_if_needed() {
#     local module_name="$1"
#     local main_application_path="android/app/src/main/java/com/turbomodules/MainApplication.kt"

#     # Prepare the import statement and registration line
#     local import_line="import com.turbomodules.modules.${module_name,,}.${module_name}Package"
#     local register_line="        packages.add(${module_name}Package())"

#     # Add the import and package to MainApplication.kt only if it's the first time
#     if ! grep -q "$import_line" "$main_application_path"; then
#         sed -i.bak -e "2i\\$import_line" "$main_application_path"
#         echo "Added import for $module_name to MainApplication.kt"

#         sed -i.bak "/PackageList(this).packages.apply {/a\\$register_line" "$main_application_path"
#         echo "Added $module_name to the package list in MainApplication.kt"
#     else
#         echo "MainApplication.kt already contains this module. Please manually add the following:"
#         echo "Import: $import_line"
#         echo "Package registration: $register_line"
#     fi
# }

# Function to create TypeScript spec file
create_typescript_spec() {
    local module_name="$1"
    local spec_path="src/turbomodules/${module_name}Module.ts"

    # Create the turbomodules directory if it doesn't exist
    if [ ! -d "src/turbomodules" ]; then
        mkdir -p "src/turbomodules"
        echo "Created src/turbomodules directory."
    fi

    local ts_content=$(cat <<EOF
import { TurboModule, TurboModuleRegistry } from 'react-native';
export interface ${module_name}Spec extends TurboModule {
    exampleMethod:()=>Promise<void>
    // Define other method signatures here
}
const ${module_name}Module= TurboModuleRegistry.getEnforcing<${module_name}Spec>('${module_name}Module');
export default ${module_name}Module;
EOF
    )

    create_kotlin_file "$spec_path" "$ts_content"
}

# Main script logic
read -p "Enter the name of the TurboModule (e.g., Device): " module_name

# Capitalize the module name for class naming convention
module_name_capitalized="$(tr '[:lower:]' '[:upper:]' <<< ${module_name:0:1})${module_name:1}"

# Convert to lowercase for directory names
module_name_lowercase=$(echo "$module_name" | tr '[:upper:]' '[:lower:]')
echo ${module_name_lowercase}
# Define paths
module_dir="android/app/src/main/java/com/turbomodules/modules/${module_name_lowercase}"
module_file="$module_dir/${module_name_capitalized}Module.kt"
package_file="$module_dir/${module_name_capitalized}Package.kt"

# Create the module directory
mkdir -p "$module_dir"

# Create the Module Kotlin file
module_content=$(cat <<EOF
package com.turbomodules.modules.${module_name_lowercase}
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.Promise
import com.facebook.react.module.annotations.ReactModule
                        
@ReactModule(name = ${module_name_capitalized}Module.NAME)
class ${module_name_capitalized}Module(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
    companion object {
        const val NAME = "${module_name_capitalized}Module" // Name of the module to be used in JavaScript
    }
    override fun getName(): String {
        return NAME
    }
    @ReactMethod
    fun exampleMethod(promise: Promise) {
        // Implement your method logic here
        promise.resolve("Hello from ${module_name_capitalized}Module")
    }
}
EOF
)

create_kotlin_file "$module_file" "$module_content"

# Create the Package Kotlin file
package_content=$(cat <<EOF
package com.turbomodules.modules.$module_name_lowercase
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
class ${module_name_capitalized}Package : ReactPackage {
    override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
        return listOf(${module_name_capitalized}Module(reactContext))
    }
    override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
        return emptyList()
    }
}
EOF
)

create_kotlin_file "$package_file" "$package_content"

# Append the module to NativeModulesRegistry.kt
append_to_registry "$module_name_capitalized"

# Update the MainApplication.kt only if it's the first time
# update_main_application_if_needed "$module_name_capitalized"

# Create the TypeScript spec file
create_typescript_spec "$module_name_capitalized"

echo "TurboModule $module_name_capitalized created and registered successfully!"
# Add this in MainApplication.kt if you are running this first time.
# import com.turbomodules.modules.registry.NativeModulesRegistry;
# addAll(NativeModulesRegistry.getPackages());