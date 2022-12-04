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
      git neovim chromium signal-desktop
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
        core = {
          excludesfile = "/home/jrylander/.gitignore_global";
	};
      };
    };
  };
}
