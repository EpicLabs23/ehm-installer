#!/bin/bash

# Function to prompt the user for input
prompt_for_input() {
  local prompt_message=$1
  local input_variable
  read -p "$prompt_message" input_variable
  echo $input_variable
}

# Prompt for NEW_EHM_VERSION
NEW_EHM_VERSION=$(prompt_for_input "Enter the new EHM version (e.g. v0.0.3): ")

# Prompt for MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=$(prompt_for_input "Enter the MySQL root password: ")

# Prompt for EHM_API_PUBLIC_URL
EHM_API_PUBLIC_URL=$(prompt_for_input "Enter the EHM API public URL (e.g. http://eh.epiclabs23.com:2326): ")

# Define the URL and target directories
URL="http://epiclabs23.com/${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz"
TARGET_DIR="/epiclabs23/eh/ehm"
EXTRACT_DIR="${TARGET_DIR}/${NEW_EHM_VERSION}"
EHM_API_DIR="${EXTRACT_DIR}/ehm-api"

# remove EXTRACT_DIR if it exists, so that it can be recreated with only new files
rm -rf $EXTRACT_DIR

# Create the target directory if it doesn't exist
mkdir -p $TARGET_DIR

# Download the file
echo "Downloading $URL..."
curl -o "${TARGET_DIR}/${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz" $URL

# Check if the download was successful
if [ $? -ne 0 ]; then
  echo "Failed to download ${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz"
  exit 1
fi

# Extract the file
echo "Extracting ${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz to $TARGET_DIR..."
tar -xzvf "${TARGET_DIR}/${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz" -C $TARGET_DIR

# Check if extraction was successful
if [ $? -ne 0 ]; then
  echo "Failed to extract ${NEW_EHM_VERSION}_ubuntu_22.04.tar.gz"
  exit 1
fi

# Run the install script
INSTALL_SCRIPT="${EXTRACT_DIR}/${NEW_EHM_VERSION}_update.sh"
if [ -f "$INSTALL_SCRIPT" ]; then
  echo "Running install script from ${EXTRACT_DIR}..."
  bash "$INSTALL_SCRIPT" "$NEW_EHM_VERSION" "$MYSQL_ROOT_PASSWORD" "$EHM_API_PUBLIC_URL"
else
  echo "Install script not found in ${EXTRACT_DIR}"
  exit 1
fi

echo "Installation of ${NEW_EHM_VERSION} completed successfully."
