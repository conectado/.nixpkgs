{ config, pkgs, ... }:

{
  imports = [<home-manager/nix-darwin>];

  users.users.conectado = {
    name = "conectado";
    home = "/Users/conectado";
  };
  
  users.users.conectado.shell = pkgs.nushell;

  home-manager.useUserPackages = true;
  home-manager.users.conectado = {pkgs, ...}: {
    home.stateVersion = "23.05";

    programs = {
      git = {
        enable = true;
        extraConfig = {
          user.name = "conectado";
          user.email = "gabrielalejandro7@gmail.com";
        };
      };

      zellij = {
        enable = true;
      };

      alacritty = {
        enable = true;
        settings = {
          env = {
            TERM = "alacritty";
          };
        };
      };

      helix = {
        enable = true;
        languages = [{
          auto-format = true;
          name = "rust";
          language-server = {
            command = "rustup";
            args = ["run" "stable" "rust-analyzer"];
          };
          config.check = { command = "clippy"; };
        }];
        settings = {
          theme = "varua";
        };
      };

      # remember to download alacritty/extra and do:
      # sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
      # https://unix.stackexchange.com/a/678901
      # this shouldn't be needed. but a lot of things here need to be fixed!
      nushell = {
        enable = true;
      	configFile.source = ./config.nu;
      	envFile.source = ./env.nu;
      };
    };
  };
 
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.rustup
      pkgs.llvmPackages_15.libllvm
    ];

  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  security.pam.enableSudoTouchIdAuth = true;
}
