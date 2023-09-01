{ config, pkgs, ... }:

{
  home.username = "root99";
  home.homeDirectory = "/home/root99";
  home.stateVersion = "23.05";
  home.packages = with pkgs; [
    home-manager
    wl-clipboard
    wofi
    rofi-wayland
    dmenu
    rofi-pass
    rofi-emoji
    grim
    slurp
    cliphist
    exa
    swww
    vscode
    jq
    nodePackages_latest.bash-language-server
    sxiv
    pywal
    pcmanfm
    hyprland
    i3
    # gnome3.gnome-tweaks
    lua
    lua-language-server
    exa
    mako
    libnotify
    dbus
    # dbus-sway-environment
    # configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    # dracula-theme # gtk theme
    # gnome3.adwaita-icon-theme  # default gnome cursors
    # swaylock
    swayidle
    pass-wayland
    # sway
    pavucontrol
    # configure-gtk
    #  thunderbird
    discord
  ];
  programs.waybar.enable = true;
  programs.git = {
    enable = true;
    userName = "pavanbhat1999";
    userEmail = "prbhat07@gmail.com";
  };

  # programs.zsh = {
  #   enable = true;
  #   initExtra = "export PATH=/home/root99/bin/scripts:$PATH";
  # };
  programs.waybar.package = pkgs.waybar.overrideAttrs (oa: {
    mesonFlags = (oa.mesonFlags or  [ ]) ++ [ "-Dexperimental=true" ];
    patches = (oa.patches or [ ]) ++ [
      (pkgs.fetchpatch {
        name = "fix waybar hyprctl";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
        sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
      })
    ];
  });
  programs.home-manager.enable = true;
}

