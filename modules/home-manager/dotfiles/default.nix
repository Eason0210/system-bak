{ config, pkgs, ... }: {
  home.file = {
    npmrc = {
      text = ''
        prefix = ${config.home.sessionVariables.NODE_PATH};
      '';
      target = ".npmrc";
    };
  };

  xdg.enable = true;
  xdg.configFile = {
    "nixpkgs/config.nix".source = ../../config.nix;
    karabiner = {
      source = ./karabiner;
      recursive = true;
    };
  };
}
