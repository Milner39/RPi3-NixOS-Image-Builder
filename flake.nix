{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, nixpkgs, nixos-hardware } @ inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {

      # Target architecture
      system = "aarch64-linux";

      modules = [
        # Generates SD card images (with extra aarch64 settings)
        # May want to swap to the base package and set up my own settings?
        # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/sd-card/sd-image.nix
        # Also makes the option: "sdImage" available
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

        # Configures the kernel and bootloader
        # https://github.com/NixOS/nixos-hardware/blob/master/raspberry-pi/3/default.nix
        "${nixos-hardware}/raspberry-pi/3"

        # My image config
        ./configuration.nix
      ];
    };
  };
}