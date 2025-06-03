{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.windowManager.qtile.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
  #  xwallpaper --zoom ~/Pictures/wolf_moon_art.jpg
    xwallpaper --output HDMI-0 --zoom /home/quaithejedi/Pictures/wolf_moon_art.jpg --output eDP-1-1 --zoom /home/quaithejedi/Pictures/164523-wolf-digital-art-art-horse-canivore-1280x720.jpg
    xset r rate 200 35 &
  '';
  
  services.picom = { 
    enable = true;
    backend = "glx";
    fade = true;
  };
  
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override {fonts = ["Meslo"];})
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    arc-theme
    mullvad-browser
    nerdfonts
    adwaita-qt
    papirus-icon-theme
    inhibridge
    playerctl
    pamixer
    gnome-calendar
    mpc123
    xfce.xfce4-power-manager
    xfce.xfce4-settings
    kdePackages.ark
    libsForQt5.ark
    tauon
    acpi
    upower
    jq
    ffmpeg
    tgpt
    brightnessctl
    mpc
    xterm
    mpd
    i3lock
    betterlockscreen
    st
    rofi-power-menu
    #rofi-network-manager
    rofi-vpn
    rofi-bluetooth
    alacritty
    dmenu
    eww
    picom  # kompozitor
    networkmanagerapplet  # GUI hálózatkezelő
    blueman  # Bluetooth GUI
    pavucontrol  # hangerő szabályozás
    gnome-calculator
    xfce.thunar 
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    #xfce.thunar-vcs-plugin
    xfce.thunar-media-tags-plugin
    dunst
    lxqt.qterminal
    gnome-power-manager
    xfce.xfce4-taskmanager
    file  # fájlkezeléshez
    rofi  # választható dmenu alternatíva
    lxappearance  # GTK stílusválasztó
    feh  # háttérkép beállításhoz
    xwallpaper
  ];
}
