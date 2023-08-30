# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # <home-manager/nixos>
    ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  # boot.kernelParams = ["nvidia_drm.modeset=1"];
  networking.hostName = "root99"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.


  programs.dconf.enable = true;
  virtualisation.libvirtd.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.gvfs.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.gnome3.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;



environment.plasma5.excludePackages = with pkgs.libsForQt5; [
  elisa
  gwenview
  okular
  oxygen
  khelpcenter
  # konsole
  # plasma-browser-integration
  print-manager
  # xdg-desktop-portal-kde
];
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  environment.shells = with pkgs; [ zsh ];
  environment.sessionVariables = rec{
    PATH = [
      "/home/root99/bin"
      "/home/root99/bin/CustomScripts"
      "/home/root99/bin/themes/"
      "/home/root99/bin/appimages:$PATH"
      "/home/root99/bin/rofi-scripts:$PATH"
      "/home/root99/bin/scripts:$PATH"
      "/home/root99/bin/themes:$PATH"
    ];
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root99 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "input" "networkmanager" "disk" "libvirtd" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
      firefox
      tree
      kitty
      ventoy
      gparted
      brave
      zsh
      exa
      git
      fzf
      ripgrep
      lua
      gcc
      clang
      zig
      btop
      xclip
      virt-manager
      OVMF
      nixd
      # cudatoolkit
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    neovim
    wget
    killall
    exfat
    udisks
    gvfs
    ntfs3g
    nfs-utils
    gnome.seahorse
  ];
  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.root99 = import ./home.nix;
  # };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland];
  };
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      fira-code
      source-han-sans
      source-han-sans-japanese
      source-han-serif-japanese
      (nerdfonts.override { fonts = [ "Meslo" ]; })
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        # monospace = [ "Meslo LG M Regular Nerd Font Complete Mono" ];
        monospace = [ "Fira Code" ];
        serif = [ "Noto Serif" "Source Han Serif" ];
        sansSerif = [ "Noto Sans" "Source Han Sans" ];
      };
    };
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
#NOTE:removed because of flakes
  # system.copySystemConfiguration = true;
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

