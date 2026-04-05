#!/bin/bash

# Shell script to execute AWS commands with account ID and path substitution

set -e  # Exit on any error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# First, source the replace-account-id script to get the account ID
source "$SCRIPT_DIR/replace-account-id.sh"

# Define file paths
COMMANDS_FILE="$SCRIPT_DIR/resources/create_role_commands"
TRUST_POLICY_SRC="$SCRIPT_DIR/resources/finmesh-lf-admin-trust.json"
TEMP_TRUST_POLICY="$SCRIPT_DIR/resources/.trust-policy-temp.json"

# Convert to Windows path if using git bash (cygwin)
if [[ "$TEMP_TRUST_POLICY" =~ ^/[a-z]/ ]]; then
    # Convert /d/Projects/... to d:/Projects/...
    TEMP_TRUST_POLICY_WIN=$(echo "$TEMP_TRUST_POLICY" | sed 's|^/\([a-z]\)/|\1:/|')
else
    TEMP_TRUST_POLICY_WIN="$TEMP_TRUST_POLICY"
fi

# Check if the commands file exists
if [ ! -f "$COMMANDS_FILE" ]; then
    echo "Error: $COMMANDS_FILE not found!"
    exit 1
fi

echo ""
echo "Starting execution of commands from: $COMMANDS_FILE"
echo "Using Account ID: $ACCOUNT_ID"
echo "=================================================="

# Create temporary trust policy with account ID substituted
sed "s/YOUR_ACCOUNT_ID/$ACCOUNT_ID/g" "$TRUST_POLICY_SRC" > "$TEMP_TRUST_POLICY"

# Execute commands with trust policy file swapped for temp file (using Windows path)
sed "s|TRUST_POLICY_FILE|$TEMP_TRUST_POLICY_WIN|g" "$COMMANDS_FILE" | bash

# Cleanup
rm -f "$TEMP_TRUST_POLICY"

echo "=================================================="
echo "All commands executed successfully!"
