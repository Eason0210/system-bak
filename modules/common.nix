{ inputs, config, lib, pkgs, ... }: {
  imports = [ ./primary.nix ./nixpkgs.nix ./overlays.nix ];

  # programs.zsh = {
  #   # enable = true;
  #   # enableCompletion = true;
  #   # enableBashCompletion = true;
  # };

  user = {
    description = "Eason Huang";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  hm = import ./home-manager;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    extraSpecialArgs = { inherit inputs lib; };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # environment setup
  environment = {
    systemPackages = with pkgs; [
      # editors
      neovim

      # standard toolset
      coreutils
      curl
      wget
      git
      jq

      # helpful shell stuff
      bat
      fzf
      ripgrep
      # zsh

      # languages
      python3
      ruby
    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
  };
}
