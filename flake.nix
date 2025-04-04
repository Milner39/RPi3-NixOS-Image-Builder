{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        # Makes the option: "sdImage"
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"

        "${nixos-hardware}/raspberry-pi/3"

        # My system config
        ./configuration.nix
      ];
    };
  };
}