# ▖ ▖▘  ▄▖▄▖  ▄▖    ▗   ▜ ▜
# ▛▖▌▌▚▘▌▌▚   ▐ ▛▌▛▘▜▘▀▌▐ ▐ █▌▛▘
# ▌▝▌▌▞▖▙▌▄▌  ▟▖▌▌▄▌▐▖█▌▐▖▐▖▙▖▌

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; #FIXME

  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs.config.allowUnfree = true;

  security.sudo.wheelNeedsPassword = false;

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    kernelParams = [
      "nowatchdog"
    ];
    kernelPackages = pkgs.linuxPackages_zen;
  };

  time.timeZone = "Asia/Shanghai";

  console = {
    keyMap = "colemak";
  };

  networking = {
    hostName = "NixOS";
    enableIPv6 = false;
    firewall.enable = false;
    networkmanager.enable = true;
  };

  services.openssh.enable = true;

  users.users.nix = {
    password = "nix";
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    btop
    git
    github-cli
    wget
    curl
    tree
    vim
    neovim
    fastfetch
  ];
}
