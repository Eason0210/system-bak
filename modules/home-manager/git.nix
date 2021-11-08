{ config, lib, pkgs, ... }: {
  home.packages = [ pkgs.github-cli ];
  programs.git = {
    userName = "Eason Huang";
    userEmail = "aqua0210@163.com";
    extraConfig = {
      credential.helper =
        if pkgs.stdenvNoCC.isDarwin then
          "osxkeychain"
        else
          "cache --timeout=1000000000";
      http.sslVerify = true;
      pull.rebase = false;
      commit.verbose = true;
      init.defaultBranch = "master";
      hub.protocol = "https";
      github.user = "Eason0210";
      color.ui = true;
      merge.conflictstyle = "diff3";
      diff.algorithm = "patience";
      protocol.version = "2";
      core.commitGraph = true;
      gc.writeCommitGraph = true;
    };
    aliases = {
      fix = "commit --amend --no-edit";
      oops = "reset HEAD~1";
    };
  };
}
