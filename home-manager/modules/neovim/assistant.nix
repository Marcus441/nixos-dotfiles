{lib, ...}: {
  programs.nvf.settings.vim.assistant = {
    avante-nvim = {
      enable = false;
      setupOpts = {
        behaviour.auto_suggestions = true;
        auto_suggestions_provider = "ollama";

        suggestion = {
          debounce = 400;
          throttle = 400;
        };

        # Providers
        providers = {
          ollama = {
            endpoint = "http://192.168.55.2:8000";

            model = "qwen2.5-Coder-1.5b-instruct-GGUF";
            timeout = 15000;
            is_env_set = lib.mkLuaInline ''require(" avante.providers.ollama ").check_endpoint_alive'';
            extra_request_body = {
              options = {
                temperature = 0.0;
                num_ctx = 4096;
                num_predict = 64;
              };
            };
          };
        };
      };
    };
  };
}
