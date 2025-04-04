{ config, pkgs, ... }:

# Some options have already been set by Flake Inputs but the most important 
# ones are refined here, just in case.
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



  # === Kernel ===

  # Reduce CMA to improve stability, Default is 64M which is too much
  boot.kernelParams = ["cma=32M"];

  # === Kernel ===



  # === Hardware ===

  # Enable redistributable third-party firmware (drivers)
  hardware.enableRedistributableFirmware = true;

  # === Hardware ===



  # === File Systems ===

  fileSystems = {
    # No need to manually add "/boot/firmware" since using uboot

    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # === File Systems ===



  # === Nix ===

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";

  # === Nix ===
}