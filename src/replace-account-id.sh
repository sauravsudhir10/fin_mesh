#!/bin/bash

# Script to replace YOUR_ACCOUNT_ID placeholder at runtime without editing source files

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the project root (parent of src)
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

CONFIG_FILE="$PROJECT_ROOT/config.yaml"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: $CONFIG_FILE not found!"
    exit 1
fi

# Extract account ID from config.yaml
ACCOUNT_ID=$(grep "accountId:" "$CONFIG_FILE" | awk '{print $2}')

# Export so it's available to parent shell
export ACCOUNT_ID

# Validate account ID
if [ -z "$ACCOUNT_ID" ] || [ "$ACCOUNT_ID" = "YOUR_ACCOUNT_ID" ]; then
    echo "Error: Invalid or placeholder account ID in $CONFIG_FILE"
    echo "Please update the 'accountId' field in config.yaml with your actual AWS account ID"
    exit 1
fi

echo "Using Account ID: $ACCOUNT_ID"
echo ""

# Function to read and replace placeholders at runtime
run_with_substitution() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "Error: $file not found!"
        return 1
    fi
    
    echo "Executing commands from: $file"
    echo "=================================================="
    sed "s/YOUR_ACCOUNT_ID/$ACCOUNT_ID/g" "$file" | while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        echo "→ $line"
    done
    echo "=================================================="
}

# Display what would be executed
run_with_substitution "$PROJECT_ROOT/src/resources/finmesh-lf-admin-trust.json"

echo ""
echo "To execute these commands, pipe the substituted output to bash:"
echo "sed \"s/YOUR_ACCOUNT_ID/$ACCOUNT_ID/g\" $PROJECT_ROOT/src/resources/finmesh-lf-admin-trust.json | bash"
