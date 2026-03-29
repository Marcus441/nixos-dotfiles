{
  makeMonitor = name: width: height: refresh: x: y: scale: {
    inherit name width height refresh x y scale;
    hyprland = "${name},${toString width}x${toString height}@${toString refresh},${toString x}x${toString y},${toString scale}";
  };
}
