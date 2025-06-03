# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/firewall.nix
      ./modules/qtile.nix
    ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelModules = ["tcp_bbr"];
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.core.wmem_max" = 1073741824;
    "net.core.rmem_max" = 1073741824;
    "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
    "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
  };

  networking.hostName = "nixos-btw"; # Define your hostname.
  networking.enableIPv6 = false;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Budapest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "hu_HU.UTF-8";
    LC_IDENTIFICATION = "hu_HU.UTF-8";
    LC_MEASUREMENT = "hu_HU.UTF-8";
    LC_MONETARY = "hu_HU.UTF-8";
    LC_NAME = "hu_HU.UTF-8";
    LC_NUMERIC = "hu_HU.UTF-8";
    LC_PAPER = "hu_HU.UTF-8";
    LC_TELEPHONE = "hu_HU.UTF-8";
    LC_TIME = "hu_HU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  #services.xserver.windowManager.dwm.enable = true;
  #services.xserver.windowManager.qtile.enable = true;
  #services.xserver.displayManager.sessionCommands = ''
  #  xwallpaper --zoom ~/Pictures/wolf_moon_art.jpg
  #  xset r rate 200 35 &
  #'';

  
  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "hu";
    variant = "standard";
  };

  # Configure console keymap
  console.keyMap = "hu";
  
  # Nix package overlay a dwm-hez
  #nixpkgs.overlays = [
  #  (final: prev: {
  #    dwm = prev.dwm.overrideAttrs (old: {src = /home/quaithejedi/dwm-btw/dwm-titus;});
  #  })
  #];

  # Nvidia cumók engedélyezése X11-hez
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";     # pontos értéket lsd. `lspci | grep VGA`
      #intelBusId = "PCI:00:02.0";
      #nvidiaBusId = "PCI:01:00.0";
      nvidiaBusId = "PCI:1:0:0";    # szintén `lspci` kimenet alapján
    };

  };
  
  # Extra hardware related cuccok Nvidia + Steam miatt
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  
  #security.rtkit.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  # VBox host modul engedélyezés
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "quaithejedi" ];

  # Docker engedélyezés
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "quaithejedi" ];

  # Steam related cuccok
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

  };
  
  # FHS workaround Steam-hez
  programs.nix-ld.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.quaithejedi = {
    isNormalUser = true;
    description = "QuaiTheJedi";
    extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    packages = with pkgs; [
    #  thunderbird
      keepassxc
      brave
      ungoogled-chromium
      bitwarden
      gh
      vscodium-fhs
      curl
      python3
      python3Packages.pip
      lsof
      file
      zip
      unzip
      nettools
      termius
      qbittorrent
      freetube
      teams-for-linux
      slack
      lutris-free
      ansible
      opentofu
      vagrant
      docker-compose
      glxinfo
      vulkan-tools
      pciutils
      steam
      proxychains
      tmux
      zsh
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    #binfmt
    proot
    qemu
    neovim
    curl
    cargo
    rustup
    nomachine-client
    #lxqt.qterminal
    #eww
    #xwallpaper
    chatterino2
    flameshot
    ninja
    #nemo-with-extensions
    git
    fastfetch
    #dmenu
    st
    gnome-tweaks
    #bubblemail
    gnomeExtensions.extension-list
    gnome-shell-extensions
    gnome-extensions-cli
    gnomeExtensions.open-bar
    #gnomeExtensions.wintile-beyond
    gnomeExtensions.user-themes
    gnomeExtensions.tiling-shell
    gnomeExtensions.tweaks-in-system-menu
    gnomeExtensions.dock-reloaded
    gnomeExtensions.pop-shell
    #gnomeExtensions.bubblemail
    w3m
    tldr
    gcc
    elinks
    gnumake
    stdenv
    alacritty
    killall
    python3
    python3Packages.pip
    gobject-introspection
    python3Packages.pygobject3
    #libgirepository
    glib
    git
    gh
    tcpdump
    bash
    gawk
    nftables
    awscli2
    fastfetch
    btop
    bat
    cachix
    anydesk
    x2goclient
    proxychains
    inetutils
    mpv
    celluloid
    rofi
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xorg.xinput
  ];
  
  # Shell alias-ok
  environment.shellAliases = {
  nixconf = "sudo nano -l /etc/nixos/configuration.nix";
  qtilenix = "sudo nano -l /etc/nixos/modules/qtile.nix";
  ll = "ls -lah";
  rebuild = "sudo nixos-rebuild switch";
  qtileconf = "nano -l /home/quaithejedi/.config/qtile/config.py";
  nebula01 = "ssh -i /home/quaithejedi/DB/atlona.pem -o ServerAliveInterval=5 ubuntu@nebula01.cloud.bigbang.atlona.com";
  nebula02 = "ssh -i /home/quaithejedi/DB/atlona.pem -o ServerAliveInterval=5 ubuntu@nebula02.cloud.bigbang.atlona.com";
  nebula03 = "ssh -i /home/quaithejedi/DB/atlona.pem -o ServerAliveInterval=5 ubuntu@nebula03.cloud.bigbang.atlona.com";
  nginx01 = "ssh -i /home/quaithejedi/DB/atlona.pem -o ServerAliveInterval=5 ubuntu@nginx01.cloud.bigbang.atlona.com";
  nginx02 = "ssh -i /home/quaithejedi/DB/atlona.pem -o ServerAliveInterval=5 ubuntu@nginx02.cloud.bigbang.atlona.com";
  };  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
  # Firewall/nftables engedélyezés, plusz nyitott portok (ha kell)
  customFirewall = {
  enable = true;
  allowedTCPPorts = [ 22 80 443 719 8080 ];
  allowedUDPPorts = [ 53 67 68 ];
  portRangesUDP = [
    { from = 4000; to = 4010; }
    { from = 8000; to = 8010; }
    ];
  };
  
  # Security script-ek - systemd service unit fájlok
  systemd.services.dfr-firewall = {
  enable = true;
  description = "TCP/UDP scan protection";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];

  path = with pkgs; [
  nftables
  tcpdump
  ];

  serviceConfig = {
    ExecStart = "${pkgs.python3}/bin/python3 /home/quaithejedi/.scripts/tcp_udp_scan_blocker.py";
    Restart = "always";
    User = "root";
    };
  };
  

  systemd.services.ssh-brute-force-protection = {
  enable = true;
  description = "SSH Brute Force Protection";
  after = [ "network.target" ];
  wantedBy = [ "multi-user.target" ];

  path = with pkgs; [
  nftables
  gawk  # vagy gawkInteractive, mindkettő jó, de a sima gawk elég
  coreutils  # csak biztos, hogy minden standard bin elérhető legyen
  ];

  serviceConfig = {
    ExecStart = "${pkgs.bash}/bin/bash /home/quaithejedi/.scripts/ssh_brute_force_protection.sh";
    Restart = "always";
    User = "root";
    };
  };

  # Snapshot cleanup
  systemd.timers.nix-gc = {
  wantedBy = [ "timers.target" ];
  timerConfig = {
    OnCalendar = "weekly";
    Persistent = true;
    };
  };

  systemd.services.nix-gc = {
  script = ''
    nix-collect-garbage --delete-older-than 7d
    #nix-env --delete-generations +7
    '';
  };
  
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
