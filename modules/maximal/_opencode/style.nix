{config, ...}: let
  inherit
    (config.lib.stylix.colors)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base07
    base08
    base09
    base0A
    base0B
    base0C
    base0D
    base0E
    base0F
    ;
in {
  xdg.configFile."opencode/themes/nix.json".text = ''
    {
      "$schema": "https://opencode.ai/theme.json",
      "defs": {
        "base00": "#${base00}",
        "base01": "#${base01}",
        "base02": "#${base02}",
        "base03": "#${base03}",
        "base04": "#${base04}",
        "base05": "#${base05}",
        "base06": "#${base06}",
        "base07": "#${base07}",
        "base08": "#${base08}",
        "base09": "#${base09}",
        "base0A": "#${base0A}",
        "base0B": "#${base0B}",
        "base0C": "#${base0C}",
        "base0D": "#${base0D}",
        "base0E": "#${base0E}",
        "base0F": "#${base0F}"
      },
      "theme": {
        "primary": {
          "dark": "base0D",
          "light": "base0D"
        },
        "secondary": {
          "dark": "base0C",
          "light": "base0C"
        },
        "accent": {
          "dark": "base0E",
          "light": "base0E"
        },
        "error": {
          "dark": "base08",
          "light": "base08"
        },
        "warning": {
          "dark": "base0A",
          "light": "base0A"
        },
        "success": {
          "dark": "base0B",
          "light": "base0B"
        },
        "info": {
          "dark": "base0D",
          "light": "base0D"
        },
        "text": {
          "dark": "base05",
          "light": "base05"
        },
        "textMuted": {
          "dark": "base03",
          "light": "base03"
        },
        "background": {
          "dark": "base00",
          "light": "base00"
        },
        "backgroundPanel": {
          "dark": "base01",
          "light": "base01"
        },
        "backgroundElement": {
          "dark": "base02",
          "light": "base02"
        },
        "border": {
          "dark": "base02",
          "light": "base02"
        },
        "borderActive": {
          "dark": "base03",
          "light": "base03"
        },
        "borderSubtle": {
          "dark": "base01",
          "light": "base01"
        },
        "diffAdded": {
          "dark": "base0B",
          "light": "base0B"
        },
        "diffRemoved": {
          "dark": "base08",
          "light": "base08"
        },
        "diffContext": {
          "dark": "base03",
          "light": "base03"
        },
        "diffHunkHeader": {
          "dark": "base04",
          "light": "base04"
        },
        "diffHighlightAdded": {
          "dark": "base0B",
          "light": "base0B"
        },
        "diffHighlightRemoved": {
          "dark": "base08",
          "light": "base08"
        },
        "diffAddedBg": {
          "dark": "base01",
          "light": "base01"
        },
        "diffRemovedBg": {
          "dark": "base01",
          "light": "base01"
        },
        "diffContextBg": {
          "dark": "base00",
          "light": "base00"
        },
        "diffLineNumber": {
          "dark": "base03",
          "light": "base03"
        },
        "diffAddedLineNumberBg": {
          "dark": "base01",
          "light": "base01"
        },
        "diffRemovedLineNumberBg": {
          "dark": "base01",
          "light": "base01"
        },
        "markdownText": {
          "dark": "base05",
          "light": "base05"
        },
        "markdownHeading": {
          "dark": "base0D",
          "light": "base0D"
        },
        "markdownLink": {
          "dark": "base09",
          "light": "base09"
        },
        "markdownLinkText": {
          "dark": "base08",
          "light": "base08"
        },
        "markdownCode": {
          "dark": "base0B",
          "light": "base0B"
        },
        "markdownBlockQuote": {
          "dark": "base03",
          "light": "base03"
        },
        "markdownEmph": {
          "dark": "base09",
          "light": "base09"
        },
        "markdownStrong": {
          "dark": "base0A",
          "light": "base0A"
        },
        "markdownHorizontalRule": {
          "dark": "base02",
          "light": "base02"
        },
        "markdownListItem": {
          "dark": "base08",
          "light": "base08"
        },
        "markdownListEnumeration": {
          "dark": "base09",
          "light": "base09"
        },
        "markdownImage": {
          "dark": "base0C",
          "light": "base0C"
        },
        "markdownImageText": {
          "dark": "base08",
          "light": "base08"
        },
        "markdownCodeBlock": {
          "dark": "base05",
          "light": "base05"
        },
        "syntaxComment": {
          "dark": "base03",
          "light": "base03"
        },
        "syntaxKeyword": {
          "dark": "base0E",
          "light": "base0E"
        },
        "syntaxFunction": {
          "dark": "base0D",
          "light": "base0D"
        },
        "syntaxVariable": {
          "dark": "base08",
          "light": "base08"
        },
        "syntaxString": {
          "dark": "base0B",
          "light": "base0B"
        },
        "syntaxNumber": {
          "dark": "base09",
          "light": "base09"
        },
        "syntaxType": {
          "dark": "base0A",
          "light": "base0A"
        },
        "syntaxOperator": {
          "dark": "base05",
          "light": "base05"
        },
        "syntaxPunctuation": {
          "dark": "base05",
          "light": "base05"
        }
      }
    }
  '';
}
