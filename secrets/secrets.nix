{ sops-nix, ... }:

{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    # File to decrypt
    defaultSopsFile = ./secrets.json;
    defaultSopsFormat = "json";

    # Path to private key paired to the public key used to encrypt
    age.sshKeyPaths = [
      "${builtins.getEnv "HOME"}/.ssh/id_ed25519"
    ];

    # Define secrets
    secrets = {
      "ssh/keys" = {};
      "wifi/ssid" = {};
      "wifi/psk" = {};
    };
  };
}