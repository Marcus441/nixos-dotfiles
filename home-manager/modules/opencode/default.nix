{...}: {
  imports = [
    ./style.nix
  ];
  programs.opencode = {
    enable = true;

    settings = {
      model = "opencode/minimax-m2.5-free";
      small_model = "opencode/minimax-m2.5-free";
      autoupdate = true;
      autoshare = false;
      default_agent = "tutor";
    };

    tui = {
      theme = "nix";
      keybinds = {
        # Optional: customize keybindings
        # leader = "alt+b";
      };
      scroll = {
        history = 10000;
      };
    };

    enableMcpIntegration = false;

    rules = ''
      # General Development Rules

      ## Environment & Context
      - **Environment Awareness:** You are working within a NixOS/Flake-managed development environment.
      - **Context Management:** When dealing with large files, prefer reading specific sections or using grep to minimize token usage. Avoid ingesting thousands of lines unless strictly necessary.
      - **Lazy Loading:** If the project has a specific @rules/ folder, load relevant files lazily on need-to-know basis.

      ## Code Quality Standards
      - **Readability:** Be concise, technical, and prioritize readability.
      - **Clean Code:** Follow Clean Code principles (SOLID, DRY) and design patterns appropriate for the language used.
      - **Minimal Diffs:** Minimize git diffs: Only modify lines necessary for the requested change.
      - **Logic first:** For complex tasks, think step-by-step and outline the logic before implementation.

      ## Security & Reliability
      - **Security First:** Always check for security vulnerabilities (injection, memory leaks, UB).
      - **NO SECRETS:** NEVER suggest or commit code containing hardcoded secrets, API keys, or PII. Use environment variables or secret management placeholders.
      - **Reliability:** If unsure of a library version or API, prioritize the standard library or explicitly state your uncertainty. Do not hallucinate version-specific features.

      ## Nix-Specific Guidelines
      - **Hermeticity:** Flag hardcoded absolute paths (e.g., /home/marcus) in favor of relative paths or Nix variables.
      - **Flake Awareness:** Understand the flake output schema and input system.
      - **Module System:** Follow home-manager module patterns when modifying Nix configurations.
    '';

    agents = {
      code-reviewer = builtins.readFile ./agents/code-reviewer.md;
      systems-programmer = builtins.readFile ./agents/systems-programmer.md;
      back-end-developer = builtins.readFile ./agents/back-end-developer.md;
      front-end-developer = builtins.readFile ./agents/front-end-developer.md;
      tutor = builtins.readFile ./agents/tutor.md;
    };

    commands = {
      commit = ''
        # Commit Message Generator
        Review the current staged changes and suggest a Conventional Commit message.
        Format: <type>(<scope>): <description>
        Types: fix, feat, docs, style, refactor, test, chore, perf, ci, revert
      '';
      explain = "Explain the selected code block in simple terms for a junior developer.";
      # Add more useful commands
      refactor = ''
        # Refactoring Assistant
        Analyze the selected code and suggest improvements for:
        - Code readability and maintainability
        - Performance optimization
        - Reducing technical debt
        Provide before/after comparisons.
      '';
    };

    # web = {
    #   enable = false;
    #   # Use environmentFile for secrets in production
    #   # environmentFile = /run/secrets/opencode-web;
    #   extraArgs = [
    #     "--hostname" "127.0.0.1"
    #     "--port" "4096"
    #   ];
    # };
  };
}
