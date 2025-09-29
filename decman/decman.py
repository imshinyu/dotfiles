import socket
import os
# Note: Do NOT use from imports for global variables
# BAD: from decman import packages/modules/etc
import decman
import decman.config

# This is fine since the thing being imported is a class and not a global variable.
# from decman import UserPackage, File, Directory, UserRaisedError
if socket.gethostname() == "ruby":
    # add brightness controls to your laptop
    decman.packages += [
        "sddm",
        "brightnessctl",
        "plasma-meta",
        "google-chrome",
        "plymouth-theme-monoarch"
    ]
if socket.gethostname() == "sapphire":
    decman.packages += [
        "bakkesmod-legendary",
        "docker",
        "qbittorrent",
        "docker-compose",
        "elyprismlauncher-bin",
        "jetbrains-toolbox",
        "tailscale",
        "cfitsio",
        "electron36",
        "gamescope",
        "imath",
        "libcgif",
        "libdeflate",
        "libvips",
        "openexr",
        "plasma-desktop",
        "r2modman-bin",
        "upscayl-bin",
        "xboxdrv",
        "evtest",
        "ly",
        "vulkan-radeon",
        "xf86-video-amdgpu",
        "xf86-video-ati",
        "steam",
        "vesktop-bin",
        "bottles",
        "heroic-games-launcher-bin",
        "protonup-qt-bin",
        "millennium",
        "xdg-desktop-portal-kde",
        "partitionmanager",
        "dosfstools",
        "pavucontrol-qt",
        "ab-download-manager-bin",
        "ludusavi-bin",
        "python-rapidfuzz",
        "steam-rom-manager-bin",
        "wine",
        "waydroid-helper",
        "obs-studio",
        "plymouth-theme-monoarch",
        "sgdboop-bin",
        "umu-launcher",
        "waydroid"
    ]
# Configuring what packages are installed is easy.
# Duplicates are OK, so if you have multiple modules that want to ensure a package is installed,
# you can add the same package multiple times.
decman.packages += [
    "decman",
    "mpv",
    "unzip",
    "python-pywalfox",
    "paru",
    "paru-debug",
    "kitty",
    "wezterm",
    "alacritty",
    "win11-icon-theme-git",
    "ttf-dejavu",
    "wallhaven-cli",
    "ttf-jetbrains-mono-nerd",
    "windows8-cursor",
    "google-breakpad",
    "jemalloc",
    "quickshell",
    "waypaper",
    "clipse-bin",
    "clipse-gui",
    "otf-font-awesome",
    "matugen-bin",
    "python-imageio",
    "python-imageio-ffmpeg",
    "python-pillow",
    "python-screeninfo",
    "reflector",
    "qt6ct-kde",
    "qt5ct-kde",
    "xremap-hypr-bin",
    "youtube-music-bin",
    "wl-clipboard",
    "adw-gtk-theme",
    "archlinux-xdg-menu",
    "ark",
    "base",
    "base-devel",
    "bluez",
    "bluez-utils",
    "breeze",
    "breeze-gtk",
    "breeze-icons",
    "breeze5",
    "btop",
    "btrfs-progs",
    "cantarell-fonts",
    "cups",
    "decman",
    "dolphin",
    "dunst",
    "edk2-shell",
    "efibootmgr",
    "evince",
    "fastfetch",
    "fd",
    "firefox",
    "fish",
    "flatpak",
    "fuzzel",
    "git",
    "gnome-keyring",
    "gst-plugin-pipewire",
    "gst-plugins-good",
    "gvfs",
    "gvfs-mtp",
    "gvfs-smb",
    "hyprpicker",
    "jre21-openjdk",
    "ghostty",
    "lact",
    "loupe",
    "man-db",
    "ncdu",
    "neovim",
    "network-manager-applet",
    "networkmanager",
    "niri",
    "noto-fonts",
    "noto-fonts-cjk",
    "ntfs-3g",
    "nwg-look",
    "openssh",
    "plymouth",
    "polkit-kde-agent",
    "power-profiles-daemon",
    "proton-vpn-gtk-app",
    "python",
    "qt5-wayland",
    "qt6-wayland",
    "seahorse",
    "slurp",
    "swww",
    "ttf-jetbrains-mono",
    "unrar",
    "vim",
    "vulkan-intel",
    "wf-recorder",
    "wget",
    "wlsunset",
    "xdg-desktop-portal-gtk",
    "xdg-desktop-portal-wlr",
    "xdg-desktop-portal",
    "xdg-utils",
    "xorg-server",
    "xorg-xinit",
    "xorg-xhost",
    "xwayland-satellite",
    "zed",
    "zip",
    "zram-generator",
    "bat"
]

# Decman matches installed packages to those defined in the configuration.
# This means that:
# - all packages not installed on the system but defined in the source are installed
# - all packages installed on the system but not defined in the source are removed
# To make decman not care if a package is installed or not, add it to ignored_packages.
# Ignored packages can be normal packages or aur packages.
decman.ignored_packages += [
        "pipewire-alsa",
        "pipewire-audio",
        "pipewire-jack",
        "pipewire-pulse",
        "mesa",
        "rustup",
        "pipewire",
        "libva-intel-driver",
        "linux-firmware",
        "linux-zen",
        "intel-media-driver",
        "intel-ucode"
]

# Installing AUR packages is easy.
# decman.aur_packages += [
#         "decman",
# ]

# To import GPG keys, set the GNUPGHOME environment variable.
# It can easily be done with python as well.
#os.environ["GNUPGHOME"] = "/home/shinyu/.gnupg/"
# You then must set the user that builds the packages to the owner of the GPG home.
decman.config.makepkg_user = "shinyu"


# Managing only packages with decman is not that interesting.
# Decman also has really powerful ways of managing config files, scripts etc.

# IMPORTANT: Decman will remove files that were created by decman, but are no longer in the decman source.
# Keep your files in version control to avoid losing important files accidentally.

# Define file content inline.
# Default text file encoding is utf-8 but it can be changed.
# decman.files["/etc/vconsole.conf"] = File(content="KEYMAP=us", encoding="utf-8")

# Include file content from another file, set the file owner and permissions.
# The source_file is relative to the directory where the main decman source.py is located.
# By default, the file group is set to the group of the owner, but it can be overridden with the group argument.
# decman.files["/home/shinyu/.bin/user-script.sh"] = File(
#    source_file="files/user-script.sh", owner="shinyu", permissions=0o744
# )

# Non-text files such as images can also be managed.
# decman.files["/home/shinyu/.background.png"] = File(
#     source_file="files/i-dont-actually-exist.png", bin_file=True, owner="shinyu"
# )

# If you need to install multiple files at once, use directories.
# All files from the source directory will be copied recursively to the target.
# decman.directories["/home/shinyu/.config/app/"] = Directory(
#     source_directory="files/app-config", owner="shinyu"
# )

# Decman has built in support for managing systemd units as well.
# Decman will enable services declared here, and disable services removed from here.
# If you don't want decman to manage a service, don't add it here. It will ignore all units that
# weren't enabled here.
# decman.enabled_systemd_units += [
#         "NetworkManager.service"
# ]

# You can manage units for users as well.

# Ensure that previous user unit declarations aren't overwritten and they are initialized.
decman.enabled_systemd_user_units["shinyu"] = decman.enabled_systemd_user_units.get(
    "shinyu", []
)
# Add user unit.
# decman.enabled_systemd_user_units["shinyu"].append("syncthing.service")

# Most powerful feature of decman are modules.
# In this file you see how to include your module, but to really see what modules are capable of
# look at the MyModule class.
# from my_module import MyModule

# my_own_mod = MyModule()

# You have full access to python, which makes your configuration very dynamic.
# For example: do something if the computers hostname is arch-1

# decman.modules += [my_own_mod]

# Configuring the behavior of decman is also done here.
# These are the default values.

# Note: you probably don't want to change these 2 settings and instead you'll want to to use the --debug CLI option.
# Show debug output
decman.config.debug_output = False
# Suppress output of some commands that you probably don't want to see.
decman.config.suppress_command_output = True

# Make output less verbose. Summaries are still printed.
decman.config.quiet_output = False

# Decman captures pacman command output, and any line (and adjacent lines) that contains any of
# the following keywords (case-insensetive) will be printed after the pacman command finishes.
#
# REMEMBER: You should still generally pay attention to pacman output
# since these keywords may not catch all cases.
decman.config.pacman_output_keywords = [
    "pacsave",
    "pacnew",
    # Additional keywords can be:
    # "warning",
    # "error",
    # "note",
    # They might cause too many highlights however.
]
# If you don't want to print lines that contain keywords, set this to False
decman.config.print_pacman_output_highlights = True

# The user which builds aur and user packages.
# decman.config.makepkg_user = "nobody" # This was set in a previous example. Let's not override it.

# The build directory decman uses for creating a chroot etc.
decman.config.build_dir = "/tmp/decman/build"

# Built packages are stored here.
decman.config.pkg_cache_dir = "/var/cache/decman"

# Changing the default commands decman uses for things is a bit more complex.
# Create a child class of the decman.config.Commands class and override methods.
# These are the defaults.
class MyCommands(decman.config.Commands):
    def list_pkgs(self) -> list[str]:
        return ["pacman", "-Qeq", "--color=never"]

    def list_foreign_pkgs_versioned(self) -> list[str]:
        return ["pacman", "-Qm", "--color=never"]

    # --color=always is used in many commands since --color=auto results in no color.
    # It seems a sensible default for me, since decman already uses color and it can't be disabled.

    def install_pkgs(self, pkgs: list[str]) -> list[str]:
        return ["pacman", "-S", "--color=always", "--needed"] + pkgs

    def install_files(self, pkg_files: list[str]) -> list[str]:
        return ["pacman", "-U", "--color=always", "--asdeps"] + pkg_files

    def set_as_explicitly_installed(self, pkgs: list[str]) -> list[str]:
        return ["pacman", "-D", "--asexplicit"] + pkgs

    def install_deps(self, deps: list[str]) -> list[str]:
        return ["pacman", "-S", "--color=always", "--needed", "--asdeps"] + deps

    def is_installable(self, pkg: str) -> list[str]:
        return ["pacman", "-Sddp", pkg]

    def upgrade(self) -> list[str]:
        return ["pacman", "-Syu", "--color=always"]

    def remove(self, pkgs: list[str]) -> list[str]:
        return ["sh", "-c", "pacman -D --asdeps %s && pacman -Qdtq | sudo pacman -Rns -" % " ".join(pkgs)]

    def enable_units(self, units: list[str]) -> list[str]:
        return ["systemctl", "enable"] + units

    def disable_units(self, units: list[str]) -> list[str]:
        return ["systemctl", "disable"] + units

    def enable_user_units(self, units: list[str], user: str) -> list[str]:
        return ["systemctl", "--user", "-M", f"{user}@", "enable"] + units

    def disable_user_units(self, units: list[str], user: str) -> list[str]:
        return ["systemctl", "--user", "-M", f"{user}@", "disable"] + units

    def compare_versions(self, installed_version: str, new_version: str) -> list[str]:
        return ["vercmp", installed_version, new_version]

    def git_clone(self, repo: str, dest: str) -> list[str]:
        return ["git", "clone", repo, dest]

    def git_diff(self, from_commit: str) -> list[str]:
        return ["git", "diff", from_commit]

    def git_get_commit_id(self) -> list[str]:
        return ["git", "rev-parse", "HEAD"]

    def git_log_commit_ids(self) -> list[str]:
        return ["git", "log", "--format=format:%H"]

    def review_file(self, file: str) -> list[str]:
        return ["less", file]

    def make_chroot(self, chroot_dir: str, with_pkgs: list[str]) -> list[str]:
        return ["mkarchroot", chroot_dir] + with_pkgs

    def install_chroot_packages(self, chroot_dir: str, packages: list[str]):
        return [
            "arch-nspawn",
            chroot_dir,
            "pacman",
            "-S",
            "--needed",
            "--noconfirm",
        ] + packages

    def resolve_real_name(self, chroot_dir: str, pkg: str) -> list[str]:
        return [
            "arch-nspawn",
            chroot_dir,
            "pacman",
            "-Sddp",
            "--print-format=%n",
            pkg,
        ]

    def remove_chroot_packages(self, chroot_dir: str, packages: list[str]):
        return ["arch-nspawn", chroot_dir, "pacman", "-Rsu", "--noconfirm"] + packages

    def make_chroot_pkg(
        self, chroot_wd_dir: str, user: str, pkgfiles_to_install: list[str]
    ) -> list[str]:
        makechrootpkg_cmd = ["makechrootpkg", "-c", "-r", chroot_wd_dir, "-U", user]

        for pkgfile in pkgfiles_to_install:
            makechrootpkg_cmd += ["-I", pkgfile]

        return makechrootpkg_cmd


# To apply your overrides, set the commands variable.
# decman.config.commands = MyCommands()

# Alternative to the built in AUR support:
# If you don't want to use the built in AUR helper, you can use some pacman wrapper that can run as root, such as paru.
# To do this, override commands and disable fpm.


class ParuWrapperCommands(decman.config.Commands):
   def list_pkgs(self) -> list[str]:
        return ["paru", "-Qeq"]

   def install_pkgs(self, pkgs: list[str]) -> list[str]:
        return ["paru", "-S"] + pkgs

   def upgrade(self) -> list[str]:
        return ["paru", "-Syu"]

   def remove(self, pkgs: list[str]) -> list[str]:
        return ["paru", "-Rs"] + pkgs

    # it doesn't matter if all pacman commands aren't overridden since they wont be used when fpm is disabled.


decman.config.enable_fpm = False
decman.config.commands = ParuWrapperCommands()

# Then simply add all AUR packages to decman.packages
# decman.packages += ["paru"]
