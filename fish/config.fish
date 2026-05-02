if status is-interactive
    # Commands to run in interactive sessions can go here
end
#fish_config theme choose "Matugen"

alias qmlls="qmlls6"
alias rgcc="gcc -lraylib"
alias dot='git --git-dir=$HOME/.dotfiles --work-tree=$HOME/.config'
function jrun
    # Compiles the .java file passed as the first argument
    javac $argv[1]

    # If compilation succeeded, run the class (stripping the .java extension)
    if test $status -eq 0
        set -l class_name (string replace -r '\.java$' '' $argv[1])
        java $class_name
    end
end
export HSA_OVERRIDE_GFX_VERSION=8.0.3
export OLLAMA_VULKAN=1
export ROC_ENABLE_PRE_VEGA=1
export EDITOR=helix
set -g theme_color_scheme Matugen

# Created by `pipx` on 2025-11-09 19:10:06
set PATH $PATH ~/.local/bin
set PATH $PATH ~/.local/share/cargo/bin
set PATH $PATH ~/Applications
set PATH $PATH ~/Scripts
set PATH $PATH ~/.nix-profile/bin
set PATH $PATH $(go env GOPATH)/bin
set PATH $PATH .local/share/soar/bin
set -U fish_greeting
# set -gx ANDROID_USER_HOME "$XDG_DATA_HOME/android"
# set -gx ANDROID_HOME "$XDG_DATA_HOME/android/sdk"
# set -gx HISTFILE "$XDG_STATE_HOME/bash/history"
# set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
# set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
# set -gx GOPATH "$XDG_DATA_HOME/go"
# set -gx GRADLE_USER_HOME "$XDG_DATA_HOME/gradle"
# set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
# set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
# set -gx _JAVA_OPTIONS "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME/java\""
# set -gx WINEPREFIX "$XDG_DATA_HOME/wine"
# alias adb 'HOME="$XDG_DATA_HOME/android" adb'
# alias wget 'wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
# alias yarn 'yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

function fish_greeting
    echo "⠣⡻⣿⣿⣿⣿⣾⣫⣿⣿⣿⣵⣆⣤⣿⣿⣿⣿⣿⣿⣿⣿⣷⣾⣿⣿⢿⣿⣿⣧⠀⠉⣻⣿⣿⣏⣽⣿⣿⡿⡿⣿⣿⣷⣷⣿⣶⣿⣿⡿⢣⡿⣸⣾⣿⡿
⠀⠈⣻⠻⣿⣟⣿⣿⣿⣿⡋⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⢺⣻⣿⣿⣧⣴⣿⣿⣿⣿⣿⡿⣿⣿⡿⣿⣿⠿⠿⠟⠛⠋⠁⢤⣾⣵⣿⢟⣉⠀
⣶⢓⣌⣸⢟⣥⡶⣿⣟⠯⠈⠀⢹⡟⡟⢿⣟⣿⣿⣻⣿⣿⣿⣿⣿⣿⣶⣝⠿⣿⣿⣿⣿⣻⣿⣿⣿⣿⣿⠿⠿⣿⣥⠤⣤⣤⣤⣤⣴⣿⣿⠋⠀⠀⠀⢙
⡹⣿⣿⣵⡿⡝⡷⠣⠛⠿⡄⠀⠘⠓⢿⣞⣳⣽⡿⢽⡿⣿⣿⣿⣿⣿⣿⣿⣿⡛⠛⣛⣵⣿⣿⣯⣭⣤⡶⠛⠛⠒⠒⠒⣒⣬⢝⡿⣿⣿⣿⣶⣶⠶⠛⠛
⠿⣿⣿⠈⣽⠋⠓⠤⠀⠀⠈⠐⠲⣤⣼⠿⢧⡘⠀⣷⣿⣿⣿⣿⣿⣿⣿⣿⣷⣻⣿⣿⣿⣿⣛⣛⣛⣽⣿⣿⣯⠶⠚⠉⠁⠀⠀⠉⠻⣿⣿⡗⠘⣧⠀⣀
⠀⢻⣷⣾⣿⣆⠀⠀⠀⠀⢀⡴⠚⠉⠉⣻⣶⣽⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⠛⠛⠚⠋⠉⠁⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⢹⣿⡡⠔⠉⠉⠀
⠀⠀⣿⣿⡻⡿⢿⣦⣄⡠⢥⣲⣶⣾⣿⡿⠛⠛⠿⠿⣉⣛⣋⣽⣾⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠚⠀⠀⠰⣄⡀⠀⣠⡾⠋⠀⠀⠀⠀⠀
⠉⣑⣿⣿⡿⡍⢉⣿⣴⣾⣟⡩⠞⣽⠋⠉⠈⠙⣿⣆⣉⣹⣿⣿⣿⣟⣾⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠤⠯⠛⠁⠀⠀⠀⠀⠀⠀⠀
⣿⣿⣿⣿⣿⣿⡿⣻⢿⢯⡉⠴⠊⠘⠤⠀⠀⣼⣿⣿⡿⣿⣿⡿⡏⢸⠛⣱⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣻⣿⣿⡟⠁⠹⣯⣷⡆⠀⠀⠰⢦⡀⠀⡀⠿⠛⣿⣿⣿⣿⢿⠀⡸⣿⠏⠀⠀⢀⣀⡠⠤⠄⠒⠒⠒⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣷⣿⣿⣻⠀⢀⠀⢉⡻⢿⡂⠀⠀⠀⢻⠅⣀⠔⠋⠘⢿⣿⣿⣼⠋⣀⣀⣤⡶⠛⠻⢤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣿⠘⠯⠲⢞⡷⠋⠀⠀⢱⣴⠶⠒⡺⠯⠀⠀⠀⠀⠘⣿⣿⣿⠿⠏⣉⠉⠻⢦⡀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⣿⣍⣢⣤⠞⠋⠀⠀⠀⣠⡼⡽⣤⡋⠀⠀⠀⠀⢀⣴⡟⢫⠟⠉⠓⠤⣀⠈⠻⣶⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠛⠋⠁⠀⠀⠀⢀⡴⡾⢅⡙⠷⠭⣾⣆⠀⢀⣴⡿⠋⡰⠁⠀⠀⠀⠀⠀⠉⠉⢪⣻⣿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
end
