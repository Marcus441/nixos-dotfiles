{
  programs.gemini-cli = {
    enable = true;
    settings = {
      tools = {
        autoAccept = true;
      };
      general = {
        preferredEditor = "nvim";
        vimMode = true;
        previewFeatures = true;
      };
      ui = {
        theme = "Default";
      };
      security = {
        auth = {
          selectedType = "gemini-api-key";
        };
      };
    }; 
  };
}
