# 🚀 macOS Developer Cleanup Script

Tired of your macOS system data hogging all your disk space while developing? This script is designed to aggressively clean up common culprits like caches, logs, temporary files, and especially developer-specific junk (Xcode, simulators, Docker). It can free up significant space, giving you more room to work! In my experience, it cleared 15-20% of my system data, giving me at least 20% more space.

## ✨ Features

* **Clears User & System Caches:** Removes temporary files generated by applications and the system.
* **Deletes Logs:** Purges old system and user logs that can accumulate over time.
* **Removes Temporary Files:** Targets the `/private/var/folders` directory for quick space gains.
* **Thins Time Machine Local Snapshots:** Reclaims space by reducing the size of local Time Machine backups.
* **Deletes Sleep Image & Swap Files:** Recovers virtual memory space.
* **Xcode Cleanup:**
    * Cleans **DerivedData**, which can grow massively with project builds.
    * Deletes **unavailable simulators**.
    * Clears the **CoreSimulator** folder (warning: this deletes all simulator data!).
* **Docker System Prune:** Uses Docker's built-in command to remove stopped containers, unused images, volumes, and networks.
* **Lists Large Folders:** Helps you identify other significant space consumers for manual review.
* **Interactive Prompts:** Asks for confirmation before performing aggressive or potentially time-consuming operations.
* **Before & After Disk Space Report:** Shows you how much space was reclaimed.

## ⚠️ Important Warnings & Disclaimer

* **Administrator Password Required:** The script uses `sudo` for many operations, so you'll need to enter your administrator password when prompted.
* **Aggressive Cleanup:** This script performs aggressive deletions. While designed to be safe for typical developer workflows, always understand what it's doing.
* **Xcode & Docker Data:**
    * Cleaning **Xcode DerivedData** means your Xcode projects will need to be re-indexed and re-built, which can take time.
    * Cleaning the **CoreSimulator** folder means all your installed simulator runtimes and app data within them will be deleted. You'll need to re-download/re-install simulators if you use them.
    * **Docker Pruning** will remove stopped containers, unused images, and volumes. Ensure you don't have critical stopped containers or volumes you wish to preserve.
* **No Warranty:** Use this script at your own risk. The author is not responsible for any data loss or system issues. **It's always a good idea to have a recent backup of your system (e.g., via Time Machine) before running any system-modifying script.**

## ⚙️ How to Use

1.  **Save the Script:**
    * Copy the entire script content from `mac_cleanup.sh` (or the content provided in the discussion).
    * Open a plain text editor (like TextEdit, VS Code, Sublime Text).
    * Paste the content and save the file as `mac_cleanup.sh` (ensure no `.txt` extension is added). You can save it in your home directory or a dedicated `Scripts` folder.

2.  **Open Terminal:**
    * Launch the **Terminal** application (find it in `Applications/Utilities/` or search with Spotlight `Cmd + Space`).

3.  **Navigate to the Script:**
    * Change your directory to where you saved the script. For example, if you saved it in your home directory:
        ```bash
        cd ~
        ```
    * If you saved it in `~/Scripts`:
        ```bash
        cd ~/Scripts
        ```

4.  **Make it Executable:**
    * Run the following command to give the script permission to run:
        ```bash
        chmod +x mac_cleanup.sh
        ```

5.  **Run the Script:**
    * Execute the script:
        ```bash
        ./mac_cleanup.sh
        ```

6.  **Follow Prompts:**
    * Enter your **administrator password** when prompted.
    * Pay attention to the interactive prompts (`y/N`) for aggressive cleanup steps and confirm `y` if you wish to proceed.

7.  **Final Steps:**
    * The script will remind you to **empty your Trash manually** after it completes.
    * It's **highly recommended to reboot your Mac** to fully reclaim all freed-up swap space and finalize the cleanup process.

## 🛠️ Customization

Feel free to open the `mac_cleanup.sh` file in a text editor and customize it to your needs:

* **Comment out sections:** If you don't want to clean specific areas (e.g., Docker), simply add a `#` at the beginning of the corresponding function call near the end of the script (e.g., `# cleanup_docker`).
* **Add your own cleanups:** You can extend the script with additional `rm -rf` commands for specific directories you know accumulate junk (e.g., specific project folders, old downloads).
* **Adjust prompts:** Modify the `read -p` messages or remove prompts if you want a fully automated (but less safe) run.

## 🤝 Contributing

Contributions are welcome! If you have ideas for improvements, discover more areas that can be safely cleaned, or find bugs, please feel free to:

1.  **Fork** this repository.
2.  **Create a new branch** (`git checkout -b feature/your-feature-name`).
3.  **Make your changes.**
4.  **Commit your changes** (`git commit -m 'Add new feature'`).
5.  **Push to the branch** (`git push origin feature/your-feature-name`).
6.  **Open a Pull Request** (PR).

## 📄 License

This software is distributed under the terms of the GNU Lesser General Public License, Version 2.1 (LGPLv2.1). A copy of the full license text is included in the `LICENSE` file within this distribution.

---

### Disclaimer of Warranty and Limitation of Liability

This program is distributed in the hope that it will be useful, but **WITHOUT ANY WARRANTY**; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

In no event shall the authors or copyright holders be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods and services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this software, even if advised of the possibility of such damage.

**USE THIS SOFTWARE AT YOUR OWN RISK.** You are solely responsible for any damage to your machine or loss of data that results from the use of this software.
