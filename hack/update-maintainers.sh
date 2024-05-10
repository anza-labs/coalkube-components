#!/usr/bin/env -S bash

set -eux
set -o pipefail

# Determine the appropriate `sed` command based on the operating system
if [[ "$(uname)" == "Darwin" ]]; then
    # If the operating system is Darwin (macOS), use `gsed`
    sed_command="gsed"
else
    # Otherwise, use `sed`
    sed_command="sed"
fi


# Define the directory containing the .yaml files
woodpecker_directory=".woodpecker"
input_file="MAINTAINERS"

function extract_current_value() {
    local tag_name="${1}"
    local source_file="${2}"
    grep "${tag_name}" "${source_file}" | "${sed_command}" -E "s/.*'(.*)'/\1/"
}

# Loop through each .yaml file in the .woodpecker directory
for yaml_file in "$woodpecker_directory"/*.yaml; do
    # Make sure the file exists
    if [ -f "${yaml_file}" ]; then
        # Extract the current value
        current_value="$(extract_current_value '&maintainers' "${yaml_file}")"

        # Get the maintainers' value
        maintainers="$(tr '\n' ', ' < "${input_file}" | sed 's/, $//')"

        # Replace the current value with the maintainers' value
        "${sed_command}" -i "s/'${current_value}'/\'${maintainers}\'/g" "${yaml_file}"
    fi
done
