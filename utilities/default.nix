{
  makeMonitor = name: width: height: refresh: x: y: scale: {
    inherit name width height refresh x y scale;

    # For hyprlang configType
    hyprland = "${name},${toString width}x${toString height}@${toString refresh},${toString x}x${toString y},${toString scale}";

    # For lua configType — attrset, not a string.
    # home-manager renders this as hl.monitor({ output = "...", mode = "...", ... })
    hyprlandLua = {
      _args = [
        {
          output = name;
          mode = "${toString width}x${toString height}@${toString refresh}";
          position = "${toString x}x${toString y}";
          inherit scale;
        }
      ];
    };
  };
}
