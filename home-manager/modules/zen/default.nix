{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    languagePacks = ["en-US"];
    policies = import ./policies.nix;

    profiles."default" = {
      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.workspaces.natural-scroll" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = true;
        "zen.view.compact.animate-sidebar" = false;
        "zen.welcome-screen.seen" = true;
        "zen.urlbar.behavior" = "float";
      };

      mods = [
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
        "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
        "c6813222-6571-4ba6-8faf-58f3343324f6" # Disable Rounded Corners
        "c8d9e6e6-e702-4e15-8972-3596e57cf398" # Zen Back Forward
        "cb15abdb-0514-4e09-8ce5-722cf1f4a20f" # Hide Extension Name
        "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better Active Tab
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
        "f7c71d9a-bce2-420f-ae44-a64bd92975ab" # Better Unloaded Tabs
        "fd24f832-a2e6-4ce9-8b19-7aa888eb7f8e" # Quietify
      ];
      search = import ./search.nix {inherit pkgs;};

      pinsForce = true;
      pins = {
        "GitHub" = {
          id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
          url = "https://github.com";
          isEssential = true;
        };
        "Messenger" = {
          id = "2d9b1c5a-3e8d-4f7a-9c2b-8a4e1d5c6f3b";
          url = "https://www.messenger.com";
          isEssential = true;
        };
        "Google Calendar" = {
          id = "7b8a1c9e-5f2d-4b3a-8d6c-1e9f2a3b4c5d";
          url = "https://calendar.google.com";
          isEssential = true;
        };
        "YouTube Music" = {
          id = "a1b2c3d4-e5f6-4a5b-9c8d-7e6f5a4b3c2d";
          url = "https://music.youtube.com";
          isEssential = true;
        };
      };

      keyboardShortcutsVersion = 14;
      keyboardShortcuts = [
        {
          id = "zen-compact-mode-toggle";
          key = "c";
          modifiers.control = true;
          modifiers.alt = true;
        }
        {
          id = "zen-toggle-sidebar";
          key = "x";
          modifiers.control = true;
          modifiers.alt = true;
        }
        {
          id = "key_savePage";
          key = "s";
          modifiers.control = true;
        }
        {
          id = "key_quitApplication";
          disabled = true;
        }
      ];
    };
  };
}
