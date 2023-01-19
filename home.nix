{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  home = {
    username = "jrylander";
    homeDirectory = "/home/jrylander";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "22.11";

    packages = with pkgs; [
      bind
      fd
      git
      killall
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bat.enable = true;

    tmux = {
      enable = true;
      shortcut = "w";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
    };

    git = {
      enable = true;
      userEmail = "johan@rylander.cc";
      userName = "Johan Rylander";
      delta = {
        enable = true;
      };
      extraConfig = {
        core.excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        init.defaultBranch = "master";
        safe.directory = "/etc/nixos";
      };
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
      };
      initExtra = ''
        source ~/.zshrc-local || true
      '';
    };

    fzf = {
      enable = true;
    };

    neovim = {
      enable = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        fzf-vim
      ];

      extraConfig = ''
        syntax on
        set autochdir
        filetype plugin indent on
        set shiftwidth=2
        set expandtab
        let mapleader=' '
      '';
    };
  };
}
