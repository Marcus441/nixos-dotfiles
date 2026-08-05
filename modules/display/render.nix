{lib, ...}: {
  flake.lib.monitors = rec {
    # Hyprland resolves `desc:` against EDID, which survives a monitor moving
    # port. wlr-randr and dwl have no equivalent, so they always take the
    # connector.
    identify = m:
      if m.description != null
      then "desc:${m.description}"
      else m.name;

    toHyprland = m: {
      _args = [
        {
          output = identify m;
          inherit (m) mode scale;
          position = "${toString m.x}x${toString m.y}";
        }
      ];
    };

    toWlrRandr = m: ''
      wlr-randr --output ${m.name} \
        --mode ${m.mode}Hz \
        --pos ${toString m.x},${toString m.y} \
        --scale ${toString m.scale} --on
    '';

    # For a module's `assertions`. Monitors are only ever read by home modules,
    # so this is where a bad layout gets caught.
    assertionsFor = hostname: ms: let
      names = map (m: m.name) ms;
      descriptions = lib.filter (d: d != null) (map (m: m.description) ms);
    in [
      {
        assertion = lib.length (lib.unique names) == lib.length names;
        message = "host ${hostname}: duplicate connector in monitors: ${lib.concatStringsSep ", " names}";
      }
      {
        assertion = lib.length (lib.unique descriptions) == lib.length descriptions;
        message = "host ${hostname}: two monitors share a description, so desc: matching is ambiguous";
      }
    ];
  };
}
