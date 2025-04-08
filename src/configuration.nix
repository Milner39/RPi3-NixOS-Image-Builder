{ pkgs, ... }:

let
  secrets = import ./secrets.nix;
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
  sdImage.imageName = "NixPi.img";

  # === Build ===



  # === Bootloader ===

  # Wait 3 seconds before booting
  boot.loader.timeout = 3;

  # === Bootloader ===



  # === Hardware ===

  # Enable third-party firmware (drivers)
  hardware.enableRedistributableFirmware = true;

  # === Hardware ===



  # === Performance ===

  # Use RAM as compressed Swap space
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # === Performance ===



  # === Networking ===

  networking = {
    hostName = "NixPi";
    useDHCP = true;

    # Configure WiFi
    wireless = {
      enable = true;
      networks = {
        "${secrets.wifi.ssid}" = {
          psk = secrets.wifi.psk;
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

  users.users."${secrets.user.username}" = {
    # Automatically set various options like home directory etc.
    # https://search.nixos.org/options?show=users.users.%3Cname%3E.isNormalUser
    isNormalUser = true;

    # Add to groups to elevate permissions
    extraGroups = ["wheel"];

    # Login Methods
    hashedPassword = secrets.user.auth.hashedPassword;
    openssh.authorizedKeys.keys = secrets.user.auth.sshKeys;
  };

  # === Users ===



  # === Nix ===

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  # === Nix ===



  # === Environment ===

  # Add globally available packages
  environment.systemPackages = with pkgs; [
    # Version control
    git

    # Secrets
    sops
    ssh-to-age
  ];

  # === Environment ===
}