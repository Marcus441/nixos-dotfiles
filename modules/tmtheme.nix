_: {
  flake.modules.homeManager.core = [
    (
      {
        config,
        lib,
        pkgs,
        ...
      }: let
        inherit
          (config.desktop.colors)
          base00
          base01
          base02
          base03
          base05
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          base0F
          ;

        fg = name: scope: foreground: {
          inherit name scope;
          settings = {inherit foreground;};
        };

        on = name: scope: background: foreground: {
          inherit name scope;
          settings = {inherit background foreground;};
        };

        emph = name: scope: fontStyle: foreground: {
          inherit name scope;
          settings = {inherit fontStyle foreground;};
        };
      in {
        # bat and yazi's file preview both highlight with syntect, which takes a
        # tmTheme and not ANSI -- the one place the palette has to be handed over
        # as hex. One theme so the same file looks the same in both.
        options.desktop.syntaxTheme = lib.mkOption {
          type = lib.types.path;
          readOnly = true;
          description = "syntect theme rendered from desktop.colors.";
        };

        # The base16 tmTheme template (bat's assets/themes/base16.tmTheme, MIT,
        # (c) 2018-2023 bat-developers) as data, rendered to plist by nixpkgs
        # rather than carried as 540 lines of XML.
        config.desktop.syntaxTheme = pkgs.writeText "kanagawa-dragon.tmTheme" (
          lib.generators.toPlist {escape = true;} {
            name = "Kanagawa Dragon";
            author = "Template: Chris Kempson; scheme: base24 Kanagawa Dragon";
            colorSpaceName = "sRGB";

            settings = [
              # No scope: the editor chrome syntect draws around the buffer.
              {
                settings = {
                  background = base00;
                  caret = base05;
                  foreground = base05;
                  invisibles = base03;
                  lineHighlight = base03;
                  selection = base02;
                  gutter = base01;
                  gutterForeground = base03;
                };
              }

              (fg "Text" "variable.parameter.function" base05)
              (fg "Comments" "comment, punctuation.definition.comment" base03)
              (fg "Punctuation" "punctuation.definition.string, punctuation.definition.variable, punctuation.definition.string, punctuation.definition.parameters, punctuation.definition.string, punctuation.definition.array" base05)
              (fg "Operators" "keyword.operator" base05)
              (fg "Keywords" "keyword" base0E)
              (fg "Variables" "variable" base05)
              (fg "Functions" "entity.name.function, meta.require, support.function.any-method" base0D)
              (fg "Labels" "entity.name.label" base0F)
              (fg "Classes" "support.class, entity.name.class, entity.name.type.class, entity.name" base0A)
              (fg "Classes" "meta.class" base05)
              (fg "Methods" "keyword.other.special-method" base0D)
              (fg "Storage" "storage" base0E)
              (fg "Support" "support.function" base0C)
              (fg "Strings, Inherited Class" "string, constant.other.symbol, entity.other.inherited-class" base0B)
              (fg "Integers" "constant.numeric" base09)
              (fg "Constants" "constant" base09)
              (fg "Tags" "entity.name.tag" base08)
              (fg "Attributes" "entity.other.attribute-name" base09)
              (fg "Attribute IDs" "entity.other.attribute-name.id, punctuation.definition.entity" base0D)
              (fg "Selector" "meta.selector" base0E)
              (emph "Headings" "markup.heading, punctuation.definition.heading, entity.name.section" "" base0D)
              (fg "Units" "keyword.other.unit" base09)
              (emph "Bold" "markup.bold, punctuation.definition.bold" "bold" base0A)
              (emph "Italic" "markup.italic, punctuation.definition.italic" "italic" base0E)
              (fg "Code" "markup.raw.inline" base0B)
              (fg "Link Text" "string.other.link, punctuation.definition.string.end.markdown, punctuation.definition.string.begin.markdown" base08)
              (fg "Link Url" "meta.link" base09)
              (fg "Quotes" "markup.quote" base09)
              (on "Separator" "meta.separator" base02 base05)
              (fg "Inserted" "markup.inserted" base0B)
              (fg "Deleted" "markup.deleted" base08)
              (fg "Changed" "markup.changed" base0E)
              (fg "Colors" "constant.other.color" base0C)
              (fg "Regular Expressions" "string.regexp" base0C)
              (fg "Escape Characters" "constant.character.escape" base0C)
              (fg "Embedded" "punctuation.section.embedded, variable.interpolation" base0E)
              (on "Illegal" "invalid.illegal" base08 base05)
              (on "Broken" "invalid.broken" base09 base00)
              (on "Deprecated" "invalid.deprecated" base0F base05)
              (on "Unimplemented" "invalid.unimplemented" base03 base05)

              # `none` matches nothing. Upstream carries these to record which
              # slot each kind would take if a grammar ever scoped it; kept for
              # the same reason.
              (fg "Delimiters" "none" base05)
              (fg "Floats" "none" base09)
              (fg "Boolean" "none" base09)
              (fg "Values" "none" base09)
            ];
          }
        );
      }
    )
  ];
}
