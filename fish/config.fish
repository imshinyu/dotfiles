if status is-interactive
    # Commands to run in interactive sessions can go here
end
#fish_config theme choose "Matugen"

alias vim="helix"
alias hx="helix"
alias rgcc="gcc -lraylib"
export HSA_OVERRIDE_GFX_VERSION=8.0.3
export OLLAMA_VULKAN=1
export ROC_ENABLE_PRE_VEGA=1
set EDITOR nvim
set -g theme_color_scheme Matugen

# Created by `pipx` on 2025-11-09 19:10:06
set PATH $PATH /home/shinyu/.local/bin
set PATH $PATH ~/Applications
set -U fish_greeting
function fish_greeting
    echo " ｀、ヽ(↼_↼)(↼_↼)(↼_↼)(↼_↼)(↼_↼)｀、"
    echo "｀、ヽ  ＼(￣▽￣)／＼(￣▽￣)／  ｀、ヽ"
    echo "｀、ヽ  ＼(￣▽￣)／＼(￣▽￣)／  ｀、ヽ"
    echo "｀、ヽ  ＼(￣▽￣)／＼(￣▽￣)／  ｀、ヽ"
    echo " ｀、ヽ(↼_↼)(↼_↼)(↼_↼)(↼_↼)(↼_↼)｀、"
end
