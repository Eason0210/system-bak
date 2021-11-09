{ inputs, config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  pyEnv = (pkgs.stable.python3.withPackages
    (ps: with ps; [ black pylint typer colorama shellingham ]));
  sysDoNixos =
    "[[ -d /etc/nixos ]] && cd /etc/nixos && ${pyEnv}/bin/python bin/do.py $@";
  sysDoDarwin =
    "[[ -d ${homeDir}/.nixpkgs ]] && cd ${homeDir}/.nixpkgs && ${pyEnv}/bin/python bin/do.py $@";
  sysdo = (pkgs.writeShellScriptBin "sysdo" ''
    (${sysDoNixos}) || (${sysDoDarwin})
  '');

in
{
  imports = [ ./git.nix ./zsh.nix ./dotfiles ];

  programs = {
    home-manager = {
      enable = true;
      path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
    };

    direnv.enable = true;
    gpg.enable = true;
    tmux.enable = true;
    ssh.enable = true;

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
        "--info=inline"
        "--border"
        "--exact"
      ];
    };

    neovim = {
      enable = true;
      vimAlias = true;
      # extraConfig = builtins.readFile ./home/extraConfig.vim;

      plugins = with pkgs.vimPlugins; [
        # Syntax / Language Support ##########################
        vim-nix
        # UI #################################################
        gruvbox # colorscheme
        vim-gitgutter # status in gutter
        # vim-devicons
        vim-airline
      ];
    };
  };

  home =
    let NODE_GLOBAL = "${config.home.homeDirectory}/.node-packages";
    in
    {
      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "20.09";
      sessionVariables = {
        GRAPHVIZ_DOT = "${pkgs.graphviz}/bin/dot";
        GPG_TTY = "/dev/ttys000";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        NODE_PATH = "${NODE_GLOBAL}/lib";
      };
      sessionPath = [ "${NODE_GLOBAL}/bin" ];

      # define package definitions for current user environment
      packages = with pkgs; let exe = haskell.lib.justStaticExecutables; in
      [
        # python with default packages
        (python3.withPackages
          (ps: with ps; [ black numpy scipy networkx matplotlib ]))

        # Haskell tools
        (exe haskellPackages.cabal-install)
        (exe haskellPackages.hpack)
        (exe haskellPackages.haskell-language-server)
        (exe haskellPackages.hlint)
        (exe haskellPackages.hindent)
        (exe haskellPackages.ormolu)
        (exe haskellPackages.hie-bios)
        (exe haskellPackages.implicit-hie)
        ghc
        aspell
        aspellDicts.en
        clang-tools
        cppcheck
        # comma
        coreutils-full
        curl
        # emacsGit
        fd
        gawk
        gdb
        git
        gnugrep
        gnumake
        gnupg
        gnuplot
        gnused
        gnutar
        graphviz-nox
        htop
        neofetch
        nixUnstable
        hugo
        imagemagick
        j
        jq
        less
        m-cli
        more
        mpv
        nix-scripts
        nixpkgs-fmt
        nixfmt
        nodejs
        nodePackages.eslint
        pandoc
        pstree
        poetry
        ripgrep
        rust-analyzer
        rustup
        (ruby.withPackages (ps: with ps; [ rufo solargraph ]))
        rsync
        sysdo
        shfmt
        sqlite
        tree
        treefmt
        unrar
        unzip
        wget
        xz
        yarn
        zip
      ];
    };
}
