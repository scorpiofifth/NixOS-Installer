# ▖ ▖▘  ▄▖▄▖  ▄▖    ▗   ▜ ▜
# ▛▖▌▌▚▘▌▌▚   ▐ ▛▌▛▘▜▘▀▌▐ ▐ █▌▛▘
# ▌▝▌▌▞▖▙▌▄▌  ▟▖▌▌▄▌▐▖█▌▐▖▐▖▙▖▌

{ pkgs, ... }:
let
  hostname = "Chromebox";
  username = "nix";
in
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
  # FIXME: change when installing new one
  system.stateVersion = "26.05";

  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };

  time.timeZone = "Asia/Shanghai";
  console.keyMap = "colemak";
  security.sudo.wheelNeedsPassword = false;

  networking = {
    hostName = "${hostname}";
    enableIPv6 = false;
    firewall.enable = false;
    networkmanager.enable = true;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  users.users."${username}" = {
    password = "${username}";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    github-cli
    wget
    curl
    vim
  ];
}
