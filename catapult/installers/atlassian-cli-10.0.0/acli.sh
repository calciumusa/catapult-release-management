#!/bin/bash
# Remember the directory path to this script file
directory=$(dirname "$0")

if [[ $# -lt 2 ]]; then       # For 0 or 1 parameters, find appropriate app executable if available for this system
    prefix="${directory}/bin/ash"
    case $(uname -ms) in
        "Darwin x86_64") exec="${prefix}-macos-amd64";;
        "Linux x86_64")  exec="${prefix}-linux-amd64";;
        "Darwin arm64")  exec="${prefix}-macos-arm64";;
    esac
fi
if [[ ("${exec}" != "") && (-e ${exec}) ]]; then  # Run app if exec exists
    "${exec}" "${@:1}"
else # Find and run acli jar in the lib directory
    # Optionally customize settings like location of configuration properties, default encoding, or time zone
    # To customize time zone setting, use something like: -Duser.timezone=America/New_York
    # To customize configuration location, use the ACLI_CONFIG environment variable or property setting (like: -DACLI_CONFIG=...)
    # If not set, default is to look for acli.properties in the installation directory.
    # Similarly for acli-service.properties and ACLI_SERVICE_CONFIG.
    settings="-Dfile.encoding=UTF-8 ${ACLI_JAVA_OPTS}"
    cliJar=$(find "${directory}/lib" -name 'acli-*.jar')  # Find the jar file in the same directory as this script
    java ${settings} -jar "${cliJar}" "${@:1}"
fi
