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
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "root99"; # Define your hostname.
  # Pick only one of the below networking options.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  # services.xserver.videoDrivers = ["intel"];
  services.xserver.videoDrivers = [  "intel" "nvidia"];
  hardware.nvidia = {

    # Modesetting is needed most of the time
    modesetting.enable = true;

	# Enable power management (do not disable this unless you have a reason to).
	# Likely to cause problems on laptops and with screen tearing if disabled.
	powerManagement.enable = true;

    # Use the NVidia open source kernel module (which isn't “nouveau”).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
	hardware.nvidia.prime = {
        offload = {
            enable = true;
            enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
	};
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
  # services.udisks2.enable = true;
  # services.devmon.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.windowManager.awesome.enable = true;
  # services.xserver.windowManager.i3.enable = true;
  # services.xserver.windowManager.i3.extraSessionCommands = ''
  #   eval $(gnome-keyring-daemon --daemonize)
  #   export SSH_AUTH_SOCK
  # '';
  # services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.swaylock = {
      text = ''
          auth include login
          '';
  };
  services.dbus.enable = true;
  # security.pam.services.sddm.gnupg.enable=true;
  # security.pam.services.root99.gnupg.enable=true;
  # security.pam.services.sddm = {
  #   enableKwallet = true;
  #   text = ''
  #           auth include login
  #           '';
  # };
  # security.pam.services.kwallet = {
  #     name = "kwallet";
  #     enableKwallet = true;
  # };
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  security.polkit.enable = true;
  # programs.seahorse.enable = true;
  xdg.portal = {
    enable = true;
    # wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };
  # security.pam.services.root99.enableKwallet = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  programs.gnupg.agent.pinentryFlavor="qt";
  services.pcscd.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    oxygen
    khelpcenter
    konsole
    ksshaskpass
    # plasma-browser-integration
    print-manager
    xdg-desktop-portal-kde
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

    GNUPGHOME="/home/root99/.config/GNU/";
    PASSWORD_STORE_DIR="/home/root99/.config/pass";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";

    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND="1";
    # QT_QPA_PLATFORMTHEME="qt5ct";
    QT_QPA_PLATFORMTHEME="kde";
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root99 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "input" "networkmanager" "disk" "libvirtd" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    packages = with pkgs; [
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
    # gvfs
    ntfs3g
    nfs-utils
    gnome.seahorse
    gnome.gnome-keyring
    libsecret
    gcr
    xorg.xhost
    nodejs
    jdk17
    xorg.xinit
    libinput # i dont knoe why i put this
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

