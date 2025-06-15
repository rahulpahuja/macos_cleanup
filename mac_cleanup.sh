#!/bin/bash

# Configuration and Safety
set -e # Exit immediately if a command exits with a non-zero status.

# Function to get disk space
get_disk_space() {
    df -h / | awk 'NR==2 {print $4}'
}

echo "🔧 Starting macOS System Data Cleanup..."
echo "🔐 Admin password required for some operations."
sudo -v # Request admin password upfront and keep the timestamp updated

# Display initial disk space
echo "Initial free space: $(get_disk_space)"
echo "-------------------------------------"

# --- Functions for specific cleanup tasks ---

cleanup_caches() {
    echo "🧹 Clearing User Library Caches..."
    rm -rf ~/Library/Caches/* || echo "Failed to clear user caches."

    echo "🧹 Clearing System-wide Library Caches..."
    sudo rm -rf /Library/Caches/* || echo "Failed to clear system caches."
}

cleanup_logs() {
    echo "🧻 Deleting user logs..."
    rm -rf ~/Library/Logs/* || echo "Failed to clear user logs."

    echo "🧻 Deleting system logs..."
    sudo rm -rf /Library/Logs/* || echo "Failed to clear system logs."
}

cleanup_temp_files() {
    echo "🧯 Removing temp files from /private/var/folders..."
    sudo rm -rf /private/var/folders/* || echo "Failed to remove temp files."
}

cleanup_time_machine_snapshots() {
    echo "🕒 Thinning local Time Machine snapshots."
    read -p "This will remove local Time Machine backups to free space. Are you sure? (y/N) " -n 1 -r
    echo # Newline for readability
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo tmutil thinlocalsnapshots / 100000000000 4 || echo "Failed to thin Time Machine snapshots."
        echo "Local Time Machine snapshots thinned."
    else
        echo "Skipping Time Machine snapshot thinning."
    fi
}

cleanup_vm_files() {
    if [ -f /private/var/vm/sleepimage ]; then
        echo "💤 Deleting sleep image..."
        sudo rm /private/var/vm/sleepimage || echo "Failed to delete sleep image."
    else
        echo "Sleep image not found."
    fi

    echo "🧠 Removing swap files..."
    sudo rm -f /private/var/vm/swapfile* || echo "Failed to remove swap files."
}

cleanup_xcode() {
    if [ -d ~/Library/Developer/Xcode/DerivedData ]; then
        echo "🧼 Cleaning Xcode DerivedData..."
        read -p "This will delete all Xcode DerivedData (can be very large but requires re-builds). Continue? (y/N) " -n 1 -r
        echo # Newline for readability
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            rm -rf ~/Library/Developer/Xcode/DerivedData/* || echo "Failed to clean Xcode DerivedData."
        else
            echo "Skipping Xcode DerivedData cleanup."
        fi
    else
        echo "Xcode DerivedData not found."
    fi

    if command -v xcrun &> /dev/null; then
        echo "🧽 Deleting unavailable Xcode simulators..."
        xcrun simctl delete unavailable || echo "Failed to delete unavailable simulators."
    else
        echo "Xcode command-line tools not found (skipping simulator cleanup)."
    fi

    if [ -d ~/Library/Developer/CoreSimulator ]; then
        echo "🧨 Clearing CoreSimulator folder (can be massive)..."
        read -p "This will delete all simulator data (images, apps). Are you sure? (y/N) " -n 1 -r
        echo # Newline for readability
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            rm -rf ~/Library/Developer/CoreSimulator/* || echo "Failed to clear CoreSimulator folder."
        else
            echo "Skipping CoreSimulator folder cleanup."
        fi
    else
        echo "CoreSimulator folder not found."
    fi
}

cleanup_docker() {
    if command -v docker &> /dev/null; then
        echo "🐳 Cleaning Docker system (pruning images, containers, volumes)..."
        read -p "This will remove all stopped containers, dangling images, unused volumes and networks. Continue? (y/N) " -n 1 -r
        echo # Newline for readability
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            docker system prune -a --force || echo "Failed to prune Docker system." # --force to avoid interactive prompt
        else
            echo "Skipping Docker system cleanup."
        fi
    else
        echo "Docker not installed or not in PATH."
    fi
}

list_large_folders() {
    echo "📦 Top 20 space-consuming folders in /System, /Library, /private, and ~/Downloads for manual review:"
    sudo du -hxd1 /System /Library /private ~/Downloads 2>/dev/null | sort -hr | head -n 20
}

# --- Execute Cleanup Functions ---
cleanup_caches
cleanup_logs
cleanup_temp_files
cleanup_time_machine_snapshots
cleanup_vm_files
cleanup_xcode
cleanup_docker
list_large_folders

echo "-------------------------------------"
# Display final disk space
echo "Final free space: $(get_disk_space)"

echo ""
echo "🗑 Please empty your Trash manually to finalize some deletions."
echo "🔁 Recommended: Reboot your Mac to reclaim swap space and finalize cleanup."

echo "✅ Cleanup Complete. Your system should now have more free space."
