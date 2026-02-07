{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "cother";
      user.email = "cother@protonmail.com";
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}
