_: {
  flake.modules.homeManager.core = [
    (
      {lib, ...}: {
        options.media = {
          playPause = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Shell command that toggles playback on the player the session considers current. Empty when no aspect provides one.";
          };

          next = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Shell command that skips to the next track on the player the session considers current. Empty when no aspect provides one.";
          };

          previous = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Shell command that returns to the previous track on the player the session considers current. Empty when no aspect provides one.";
          };
        };
      }
    )
  ];
}
