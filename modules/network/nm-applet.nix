_: {
  flake.modules.homeManager.quickshell = [
    {
      services.network-manager-applet.enable = true;
      # load-bearing: docs/decisions/sessions.md#applet-sni
      xsession.preferStatusNotifierItems = true;
    }
  ];
}
