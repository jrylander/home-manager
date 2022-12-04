{ config, pkgs, ... }:

{
  home = {
    # Home Manager needs a bit of information about you and the
    # paths it should manage.
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
      age
      age-plugin-yubikey
      sops
      git
      neovim
      chromium
      signal-desktop
      zsh
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

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
        url."git@git.svt.se:".insteadOf = "https://git.svt.se/";
      };
    };

    zsh = {
      enable = true;
    };
  };
}
