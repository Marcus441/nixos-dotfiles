_: {
  flake.modules.homeManager.quickshell = [
    {
      services.network-manager-applet.enable = true;
      xsession.preferStatusNotifierItems = true;
    }
  ];
}
