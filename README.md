# NixOS SD Image for Raspberry Pi 3


## How To Use


### Building

1.  Rename `./secrets.example.nix` to `./secrets.nix` the project's root, and 
    set the options.

<br>

2.  Build the image with:
    ```bash
    nix build -L .#nixosConfigurations.default.config.system.build.sdImage -o ./result --impure
    ```
    Tip: If the command fails and you see "Killed" in the terminal output: you 
    are running out of memory and the process is being killed early.

    Personally, increasing the size of my Swap Memory solved the problem.

<br>

3.  Use a tool like Rufus to burn the generated `.img` file to an SD card.

<br>

4.  Put the SD card back in the RPi and boot!