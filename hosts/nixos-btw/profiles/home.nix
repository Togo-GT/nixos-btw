{ ... }:

{
  # ==========================================================
  # HOME MANAGER VERSION
  # ==========================================================
  home.stateVersion = "25.05";

  # ==========================================================
  # ZSH CONFIGURATION
  # ==========================================================
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "systemd" "docker" "kubectl" ];
      theme = "agnoster";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ".." = "cd ..";
      nixos-rebuild = "sudo nixos-rebuild";
      hm = "home-manager";
    };

    initExtra = ''
      export EDITOR="kate"
      export VISUAL="kate"
    '';
  };

  # ==========================================================
  # GIT CONFIGURATION
  # ==========================================================
  home.file.".gitconfig".text = ''
    [user]
        name = Togo-GT
        email = michael.kaare.nielsen@gmail.com
    [init]
        defaultBranch = main
    [pull]
        rebase = false
    [color]
        ui = true
        branch = auto
        diff = auto
        status = auto
    [push]
        default = simple
    [fetch]
        prune = true
    [alias]
        co = checkout
        br = branch
        ci = commit
        st = status
        unstage = "reset HEAD --"
        last = "log -1 HEAD"
        bm = "branch --merged"
        bnm = "branch --no-merged"
        df = "diff --color-words"
        l5 = "log -5 --oneline --graph --decorate"
        lg = "log --graph --abbrev-commit --decorate --date=relative --pretty=format:'%C(auto)%h%Creset %C(bold blue)%d%Creset %s %C(cyan)(%cr) %Cgreen<%an>%Creset'"
        dashboard = "log --graph --abbrev-commit --decorate --all --date=relative --pretty=format:'%C(auto)%h%Creset %C(bold blue)%d%Creset %s %C(cyan)(%cr) %C(green)<%an>%Creset %C(red)%<(10,trunc)%cr%Creset %C(yellow)%<(10,trunc)%ar%Creset %C(magenta)%<(15,trunc)%an%Creset'"
  '';

  # ==========================================================
  # SSH CLIENT CONFIGURATION (simplified)
  # ==========================================================
  programs.ssh.enable = true;

  # ==========================================================
  # HOME MANAGER
  # ==========================================================
  programs.home-manager.enable = true;
}
