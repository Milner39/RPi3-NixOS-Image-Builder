{ config, pkgs, ... }:

let
  secrets = config.sops.secrets;
in
{
  # === Build (Remove when copying to RPi) ===

  # Current system (you might need to change this)
  nixpkgs.buildPlatform.system = "x86_64-linux";

  # Target system (RPi)
  nixpkgs.hostPlatform.system = "aarch64-linux";


  # Disable building docs
  documentation.nixos.enable = false;

  # Disable compressing image file
  sdImage.compressImage = false;

  # === Build ===



  # === Bootloader ===

  boot.loader = {
    # Disable default bootloader
    grub.enable = false;

    # Use RPi compatible bootloader
    generic-extlinux-compatible.enable = true;


    # Wait 3 seconds before booting
    timeout = 3;
  };

  # === Bootloader ===



  # === Hardware ===

  # Enable third-party firmware (drivers)
  hardware.enableRedistributableFirmware = true;

  # === Hardware ===



  # === Networking ===

  networking = {
    hostName = "NixPi";
    useDHCP = true;

    # Configure WiFi
    wireless = {
      enable = true;
      networks = {
        "${secrets."wifi/ssid"}" = {
          psk = secrets."wifi/psk";
        };
      };
    };
  };

  # OpenSSH options
  services.sshd = {
    enable = true;

    # "settings" option does not exist error even though it exists in this file
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/ssh/sshd.nix#L442
    # But it does not exist when searching in Nix options
    # https://search.nixos.org/options?channel=24.11&show=services.sshd
    # settings = {
    #   # Do not allow password auth, only key-based
    #   PasswordAuthentication = false;
    # };
  };

  # === Networking ===



  # === Users (edit this for your own setup) ===

  users.users.finnm = {
    # Automatically set various options like home directory etc.
    # https://search.nixos.org/options?show=users.users.%3Cname%3E.isNormalUser
    isNormalUser = true;

    # Add to groups to elevate permissions
    extraGroups = ["wheel"];

    # Configure OpenSSH for this user
    openssh = {
      authorizedKeys.keys = secrets."ssh/keys";
    };
  };

  # === Users ===



  # === Nix ===

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  # === Nix ===
}