_: {
  flake.modules.homeManager.apps = [
    {
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
          };
          scroll = {
            history = 10000;
          };
        };

        enableMcpIntegration = false;

        context = ''
          A repository's own AGENTS.md outranks every line here.

          - Read the sections you need. Do not ingest a large file whole.
          - Change only the lines the request needs.
          - Never write a hardcoded secret, API key or PII.
          - Say you are unsure of an API rather than inventing one.
          - Absolute paths under /home are a smell in anything checked in.
        '';

        agents = {
          code-reviewer = builtins.readFile ./opencode/agents/code-reviewer.md;
          systems-programmer = builtins.readFile ./opencode/agents/systems-programmer.md;
          back-end-developer = builtins.readFile ./opencode/agents/back-end-developer.md;
          front-end-developer = builtins.readFile ./opencode/agents/front-end-developer.md;
          tutor = builtins.readFile ./opencode/agents/tutor.md;
        };

        commands = {
          commit = ''
            # Commit Message Generator
            Review the current staged changes and suggest a Conventional Commit message.
            Format: <type>(<scope>): <description>
            Types: fix, feat, docs, style, refactor, test, chore, perf, ci, revert
          '';
          explain = "Explain the selected code block in simple terms for a junior developer.";
          refactor = ''
            # Refactoring Assistant
            Analyze the selected code and suggest improvements for:
            - Code readability and maintainability
            - Performance optimization
            - Reducing technical debt
            Provide before/after comparisons.
          '';
        };
      };
    }
  ];
}
