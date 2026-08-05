{inputs, ...}: {
  flake.modules.homeManager.maximal = [
    inputs.walker.homeManagerModules.default
    ./_walker
  ];
}
