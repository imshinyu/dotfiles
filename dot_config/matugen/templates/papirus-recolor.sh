#!/bin/bash
ICON_DIR="$HOME/.local/share/icons/Papirus-Matugen"
NEW_HEX="{{colors.primary.default.hex}}"

# Restore: base from Papirus, then overlay places from Papirus-Dark
rsync -a /usr/share/icons/Papirus/ "$ICON_DIR/"
rsync -a /usr/share/icons/Papirus-Dark/16x16/places/ "$ICON_DIR/16x16/places/"
rsync -a /usr/share/icons/Papirus-Dark/22x22/places/ "$ICON_DIR/22x22/places/"
rsync -a /usr/share/icons/Papirus-Dark/24x24/places/ "$ICON_DIR/24x24/places/"

# Update ColorScheme-Text definition
find "$ICON_DIR" -name "*.svg" -type f -exec sed -i \
  "s/\.ColorScheme-Text { color:#[0-9a-fA-F]\{6\}; }/.ColorScheme-Text { color:$NEW_HEX; }/g" {} +

# Update hardcoded blue in folder-blue variants
find "$ICON_DIR" -name "*.svg" -type f -exec sed -i \
  "s/fill:#5294e2/fill:$NEW_HEX/gi" {} +

gtk-update-icon-cache -f -t "$ICON_DIR"
