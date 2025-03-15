#!/bin/bash

# Consts
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

# Function to handle brb logic
function brb() {
    # Initialize variables for parsing
    target_name=""
    declare -A versions  # Associative array to store key-value pairs
    push_str=""          # Default value for --push
    nocache_str=""       # Default value for --no-cache
    nodepends_str=" --with-dependencies"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--version)
                if [[ -n "$2" && "$2" != -* && "$2" == *=* ]]; then
                    key="${2%%=*}"  # Extract key (before '=')
                    value="${2#*=}"  # Extract value (after '=')
                    versions["$key"]="$value"
                    shift
                else
                    echo "Error: -v option requires an argument in the format KEY=VALUE."
                    return 1
                fi
                ;;
            --push)
                push_str=" --push"
                ;;
            --no-cache)
                nocache_str=" --no-cache"
                ;;
            --no-depends)
                nodepends_str=""
                ;;
            *)
                if [[ -z "$target_name" ]]; then
                    target_name="$1"
                else
                    echo "Unexpected argument: $1"
                    return 1
                fi
                ;;
        esac
        shift
    done

    if [ -z "$target_name" ]; then
        pushd $SCRIPT_DIR/compose/ >/dev/null
        output=$(ls *.compose.yml 2>/dev/null | sed 's/\.compose\.yml$//' | paste -sd '/')
        popd >/dev/null

        echo """
usage: brb [-v VERSIONS] [--push] [--no-depends] {uhd,build-runner}

positional arguments:
  {$output}    The name of the target you want built.

options:
  -v VERSIONS, --version VERSIONS 
                        A version for a specific dependancy in a KEY=VALUE format.
                        KEYS = IPP
                               CMake
                               CUDA
                               CUDA_Driver
                               Boost
                               MQ_C
                               AMPQ
                               UHDBuilder
                               UHD
                               BuildRunner

  --registry            Registry to push to.
  --push                Push images to registry.
  --no-depends          Build without dependencies.
"""
        return 1
    fi

    pushd $SCRIPT_DIR >/dev/null

    # Creating the env file
    touch .env
    for key in "${!versions[@]}"; do
        echo "${key}_VER=\"${versions[$key]}\"" >> .env
    done

    docker compose --env-file .env -f compose/compose.yml -f compose/$target_name.compose.yml build${nodepends_str} ${target_name}${push_str}${nocache_str}
    docker rmi $(docker images --filter dangling=true -aq) >/dev/null 2>/dev/null

    # Removing the env file
    rm .env
    popd >/dev/null
}

# Check if the script is already sourced in .bashrc
if ! grep -q "source $SCRIPT_PATH" ~/.bashrc; then
    echo "source $SCRIPT_PATH" >> ~/.bashrc
    echo "Restart your terminal or run 'source ~/.bashrc' to apply changes."
fi