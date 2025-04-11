#!/usr/bin/env bash

rm -rf * .*
git clone https://github.com/catppuccin/rofi.git .
patch -p1 <<EOS
diff --git a/catppuccin-default.rasi b/catppuccin-default.rasi
index da0e819..7341dd2 100644
--- a/catppuccin-default.rasi
+++ b/catppuccin-default.rasi
@@ -1,4 +1,4 @@
-@import "catppuccin-mocha"
+@import "~/.local/share/rofi/catppuccin/themes/catppuccin-mocha"
 
 * {
   selected-active-foreground:  @background;
EOS
