{
  programs.opencode = let
    shared = import ./shared.nix;
    importAgent = path: import path shared;
  in {
    enable = true;

    settings = {
      model = "google/gemini-flash-latest";
      small_model = "google/gemini-flash-lite-latest";
      autoupdate = true;
      autoshare = false;
      default_agent = "tutor";
    };

    rules = ''
      # General Development Rules
      - **Environment Awareness:** You are working within a NixOS/Flake-managed development environment.
      - **Readability:** Be concise, technical, and prioritize readability.
      - **Clean Code:** Follow Clean Code principles (SOLID, DRY) and design patterns appropriate for the language used.
      - **Security & Secrets:**
        - CRITICAL: Always check for security vulnerabilities (injection, memory leaks, UB).
        - **NO SECRETS:** NEVER suggest or commit code containing hardcoded secrets, API keys, or PII. Use environment variables or secret management placeholders.
      - **Reliability:** If unsure of a library version or API, prioritize the standard library or explicitly state your uncertainty. Do not hallucinate version-specific features.
      - **Context Management:** When dealing with large files, prefer reading specific sections or using grep to minimize token usage. Avoid ingesting thousands of lines unless strictly necessary.
      - **Logic first:** For complex tasks, think step-by-step and outline the logic before implementation.
      - **Lazy Loading:** If the project has a specific @rules/ folder, load relevant files lazily.
      - **Minimal Diffs:** Minimize git diffs: Only modify lines necessary for the requested change.
    '';

    agents = {
      code-reviewer = importAgent ./code-reviewer.nix;
      systems-programmer = importAgent ./systems-programmer.nix;
      back-end-developer = importAgent ./back-end-developer.nix;
      front-end-developer = importAgent ./front-end-developer.nix;
      tutor = importAgent ./tutor.nix;
    };

    commands = {
      commit = ''
        # Commit Message Generator
        Review the current staged changes and suggest a Conventional Commit message.
        Format: <type>(<scope>): <description>
      '';
      explain = "Explain the selected code block in simple terms for a junior developer.";
    };
  };
}
