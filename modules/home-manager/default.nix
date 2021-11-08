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
  imports = [ ./git.nix ];

  programs.home-manager = {
    enable = true;
    path = "${config.home.homeDirectory}/.nixpkgs/modules/home-manager";
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
        GPG_TTY = "/dev/ttys000";
        EDITOR = "nvim";
        VISUAL = "nvim";
        CLICOLOR = 1;
        LSCOLORS = "ExFxBxDxCxegedabagacad";
        JAVA_HOME = "${pkgs.openjdk.home}";
        NODE_PATH = "${NODE_GLOBAL}/lib";
      };
      sessionPath = [ "${NODE_GLOBAL}/bin" ];

      # define package definitions for current user environment
      packages = with pkgs; let exe = haskell.lib.justStaticExecutables; in
      [
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
        # python with default packages
        (python3.withPackages
          (ps: with ps; [ black numpy scipy networkx matplotlib ]))
        # comma
        coreutils-full
        curl
        # emacsGit
        fd
        git
        gnugrep
        gnumake
        gnugrep
        gnupg
        gnused
        htop
        neofetch
        nixUnstable
        python3Packages.poetry
        ripgrep
        rsync
        sysdo
        treefmt
        yarn
        gawk
        gdb
        gnuplot
        gnutar
        graphviz-nox
        hugo
        imagemagick
        j
        jq
        less
        m-cli
        more
        mpv
        # nix-scripts
        nixpkgs-fmt
        nixfmt
        nodejs
        nodePackages.eslint
        pandoc
        pstree
        ruby
        rust-analyzer
        rustup
        shfmt
        sqlite
        tree
        unrar
        unzip
        wget
        xz
        zip
      ];
    };
}
