# =====================================
# SYSTEM FONTS CONFIGURATION
# =====================================
# Misc module: fonts.nix

{ config, pkgs, lib, ... }:
{
  fonts = {
    # =====================================
    # DEFAULT FONT PACKAGES
    # =====================================
    enableDefaultPackages = true;  # Enable standard NixOS font packages (DejaVu, Noto)

    # =====================================
    # FONT DIRECTORY AND CACHE OPTIMIZATIONS
    # =====================================
    fontDir.enable = true;           # Enable font directory for faster system startup
    enableGhostscriptFonts = true;   # Pre-build font cache for faster startup

    # =====================================
    # FONT PACKAGES TO INSTALL
    # =====================================
    packages = with pkgs; [
      # =====================================
      # CORE NOTO FONTS (UNIVERSAL SUPPORT)
      # =====================================
      noto-fonts           # Standard Noto fonts for Western languages
      noto-fonts-extra     # Extra Noto fonts: symbols, character sets, extended unicode
      noto-fonts-cjk-sans  # Sans-serif for Chinese, Japanese, Korean
      noto-fonts-cjk-serif # Serif version for CJK languages
      noto-fonts-emoji     # Mono-style emojis
      noto-fonts-color-emoji # Color emojis for modern applications

      # =====================================
      # NERD FONTS (TERMINAL-FRIENDLY WITH ICONS)
      # =====================================
      nerd-fonts.fira-code      # Fira Code with programming ligatures
      nerd-fonts.jetbrains-mono # JetBrains Mono with icons
      nerd-fonts.iosevka        # Iosevka with narrow design

      # =====================================
      # SYSTEM FONTS (LEGACY APPLICATION COMPATIBILITY)
      # =====================================
      dejavu_fonts         # DejaVu font family
      liberation_ttf       # Liberation fonts (Arial/Times/Courier replacements)
      ubuntu_font_family   # Ubuntu font family
      corefonts            # Microsoft core fonts

      # =====================================
      # MODERN GUI FONTS
      # =====================================
      inter               # Inter font family
      roboto              # Roboto font (Google)
      open-sans           # Open Sans font
      source-sans-pro     # Source Sans Pro
      source-serif-pro    # Source Serif Pro
      source-code-pro     # Source Code Pro monospace

      # =====================================
      # ADDITIONAL CJK LANGUAGE SUPPORT
      # =====================================
      source-han-sans     # Source Han Sans (CJK)
      source-han-serif    # Source Han Serif (CJK)

      # =====================================
      # ICON FONTS
      # =====================================
      font-awesome        # Font Awesome icons
      material-design-icons # Material Design icons

      # =====================================
      # PERSONAL FAVORITES
      # =====================================
      comic-neue          # Comic Neue (improved Comic Sans)
      cascadia-code       # Cascadia Code monospace

      # =====================================
      # RECOMMENDED ADDITIONAL FONTS
      # =====================================
      cozette             # Bitmap font for terminals
      unifont             # Very broad Unicode coverage
      symbola             # Unicode symbols
      powerline-fonts     # Powerline symbols for terminals
    ];

    # =====================================
    # FONTCONFIG SYSTEM SETTINGS
    # =====================================
    fontconfig = {
      enable = true;  # Enable global fontconfig

      # =====================================
      # CACHE OPTIMIZATIONS
      # =====================================
      cache32Bit = true;  # Cache optimization for 32-bit applications

      # =====================================
      # DEFAULT FONT FALLBACK ORDER
      # =====================================
      defaultFonts = {
        # Monospace fonts: terminals and code editors
        monospace = [
          "JetBrainsMono Nerd Font"  # Primary choice
          "Iosevka Nerd Font"        # Fallback option
          "Cascadia Code"
          "Source Code Pro"
          "Noto Sans Mono"
          "DejaVu Sans Mono"
        ];

        # Sans-serif fonts: GUI and documents
        sansSerif = [
          "Inter"
          "Roboto"
          "Open Sans"
          "Noto Sans"
          "Source Han Sans"  # CJK fallback
          "DejaVu Sans"
        ];

        # Serif fonts: text and documents
        serif = [
          "Source Serif Pro"
          "Noto Serif"
          "Source Han Serif"  # CJK fallback
          "Liberation Serif"
          "DejaVu Serif"
        ];

        # Emoji fonts: color vs mono fallback
        emoji = [
          "Noto Color Emoji"  # Modern color emoji
          "Noto Emoji"        # Mono fallback for older applications
        ];
      };

      # =====================================
      # FONT RENDERING SETTINGS
      # =====================================
      antialias = true;  # Smooth font edges for better readability

      hinting = {
        enable = true;    # Enable font hinting for better readability
        style = "full";   # Maximum pixel adjustment
        # Available styles:
        # "full"   = maximum pixel adjustment (may change proportions)
        # "slight" = light hinting, preserves proportions
        # "none"   = no hinting, more aesthetic but less sharp
      };

      # =====================================
      # SUBPIXEL RENDERING (LCD SCREEN OPTIMIZATION)
      # =====================================
      subpixel = {
        lcdfilter = "default";  # Font edge pixel filtering
        rgba = "rgb";           # Screen color order
      };

      # =====================================
      # BITMAP FONT HANDLING
      # =====================================
      useEmbeddedBitmaps = true;  # Use bitmap glyphs when available
      allowBitmaps = false;       # Generally disable for better scalability

      # =====================================
      # CUSTOM FONTCONFIG RULES
      # =====================================
      localConf = ''
        # =====================================
        # USER FONT DIRECTORIES
        # =====================================
        <dir>~/.local/share/fonts</dir>
        <dir>~/.fonts</dir>  # Add traditional path for compatibility

        # =====================================
        # HIGH-DPI AND RENDERING OPTIMIZATION
        # =====================================
        <!-- Auto-DPI detection for mixed monitor setups -->
        <match target="font">
          <edit name="dpi" mode="assign_if_not_matched">
            <double>96</double>
          </edit>
          <!-- Improved subpixel rendering -->
          <edit name="rgba" mode="assign_if_not_matched">
            <const>rgb</const>
          </edit>
          <edit name="lcdfilter" mode="assign_if_not_matched">
            <const>lcddefault</const>
          </edit>
        </match>

        # =====================================
        # INTELLIGENT EMOJI HANDLING
        # =====================================
        <!-- Prioritize color emoji for all font families -->
        <alias binding="strong">
          <family>sans-serif</family>
          <prefer>
            <family>Noto Color Emoji</family>
            <family>Apple Color Emoji</family>
            <family>Segoe UI Emoji</family>
          </prefer>
        </alias>

        <alias binding="strong">
          <family>serif</family>
          <prefer>
            <family>Noto Color Emoji</family>
            <family>Apple Color Emoji</family>
          </prefer>
        </alias>

        <alias binding="strong">
          <family>monospace</family>
          <prefer>
            <family>Noto Color Emoji</family>
          </prefer>
        </alias>

        # =====================================
        # FONT SUBSTITUTION RULES
        # =====================================
        <!-- Automatic substitution for missing characters -->
        <alias>
          <family>Helvetica</family>
          <accept><family>Arial</family></accept>
        </alias>
        <alias>
          <family>Times</family>
          <accept><family>Times New Roman</family></accept>
        </alias>
        <alias>
          <family>Courier</family>
          <accept><family>Courier New</family></accept>
        </alias>

        # =====================================
        # PERFORMANCE OPTIMIZATION
        # =====================================
        <!-- Pre-load frequently used fonts -->
        <cachedir>~/.cache/fontconfig</cachedir>
        <cachedir prefix="xdg">fontconfig</cachedir>

        <!-- Match to improve rendering of small font sizes -->
        <match target="font">
          <test name="size" compare="less_eq">
            <double>12</double>
          </test>
          <edit name="antialias" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hinting" mode="assign">
            <bool>true</bool>
          </edit>
          <edit name="hintstyle" mode="assign">
            <const>hintslight</const>
          </edit>
        </match>

        # =====================================
        # BITMAP FONT HANDLING
        # =====================================
        <selectfont>
          <rejectfont>
            <pattern>
              <patelt name="scalable"><bool>false</bool></patelt>
            </pattern>
          </rejectfont>
        </selectfont>

        <!-- Allow bitmap fonts only for specific use cases -->
        <match target="pattern">
          <test name="family" qual="any">
            <string>Cozette</string>  # Allow bitmap font for terminals
          </test>
          <edit name="scalable" mode="assign">
            <bool>true</bool>  # Treat it as scalable anyway
          </edit>
        </match>

        # =====================================
        # DEBUGGING AND LOGGING (CAN BE DISABLED)
        # =====================================
        <!--
        <match target="pattern">
          <edit name="family" mode="append_last">
            <string>monospace</string>
          </edit>
        </match>
        -->
      '';
    };
  };
}
