{pkgs, ...}: {
  programs.bat = {
    enable = true;
    config = {
      theme = "kanagawa-dragon";
    };
    themes = {
      kanagawa-dragon = {
        src = pkgs.writeTextDir "kanagawa-dragon.tmTheme" ''
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
          <plist version="1.0">
            <dict>
              <key>name</key>
              <string>Kanagawa Dragon</string>
              <key>settings</key>
              <array>

                <dict>
                  <key>settings</key>
                  <dict>
                    <key>background</key>
                    <string>#181616</string>
                    <key>caret</key>
                    <string>#c5c9c5</string>
                    <key>foreground</key>
                    <string>#c5c9c5</string>
                    <key>invisibles</key>
                    <string>#625e5a</string>
                    <key>lineHighlight</key>
                    <string>#282727</string>
                    <key>selection</key>
                    <string>#282727</string>
                    <key>gutterForeground</key>
                    <string>#625e5a</string>
                  </dict>
                </dict>

                <!-- GENERAL -->

                <dict>
                  <key>name</key>
                  <string>Self / This</string>
                  <key>scope</key>
                  <string>variable.language.self, variable.language.this</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8992a7</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Operator</string>
                  <key>scope</key>
                  <string>keyword.operator</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4746e</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Punctuation</string>
                  <key>scope</key>
                  <string>punctuation.definition.variable, punctuation.definition.parameters, punctuation.definition.array</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#949fb5</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Comment</string>
                  <key>scope</key>
                  <string>comment</string>
                  <key>settings</key>
                  <dict>
                    <key>fontStyle</key>
                    <string>italic</string>
                    <key>foreground</key>
                    <string>#625e5a</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>String</string>
                  <key>scope</key>
                  <string>string</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#87a987</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>String interpolation</string>
                  <key>scope</key>
                  <string>meta.interpolation, constant.other.placeholder</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Number</string>
                  <key>scope</key>
                  <string>constant.numeric</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#a292a3</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Constant</string>
                  <key>scope</key>
                  <string>constant.language, constant.other.caps</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#a292a3</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Keyword</string>
                  <key>scope</key>
                  <string>keyword, storage.type, storage.modifier</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8992a7</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Type</string>
                  <key>scope</key>
                  <string>entity.name.type, entity.name.class, support.type</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#949fb5</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Module / Namespace</string>
                  <key>scope</key>
                  <string>entity.name.module, entity.name.namespace</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Function</string>
                  <key>scope</key>
                  <string>entity.name.function, support.function, support.function.macro, entity.name.macro</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ba4b0</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Invalid</string>
                  <key>scope</key>
                  <string>invalid, invalid.illegal</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4746e</string>
                  </dict>
                </dict>

                <!-- RUST -->

                <dict>
                  <key>name</key>
                  <string>Rust – primitive types</string>
                  <key>scope</key>
                  <string>storage.type.rust, support.type.primitive.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#949fb5</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – trait</string>
                  <key>scope</key>
                  <string>entity.name.trait.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – lifetime</string>
                  <key>scope</key>
                  <string>entity.name.lifetime.rust, punctuation.definition.lifetime.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4746e</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – unsafe</string>
                  <key>scope</key>
                  <string>keyword.other.unsafe.rust, storage.modifier.unsafe.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4746e</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – attribute</string>
                  <key>scope</key>
                  <string>meta.attribute.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#625e5a</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – attribute name</string>
                  <key>scope</key>
                  <string>meta.attribute.rust entity.name.function.attribute.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8992a7</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – generics</string>
                  <key>scope</key>
                  <string>meta.generic.rust, entity.name.type.parameter.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Rust – format placeholders</string>
                  <key>scope</key>
                  <string>meta.format-string.rust, constant.other.placeholder.rust</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <!-- C++ -->

                <dict>
                  <key>name</key>
                  <string>C++ – storage types</string>
                  <key>scope</key>
                  <string>storage.type.cpp, storage.type.c, support.type.sys-types.cpp, support.type.sys-types.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#949fb5</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – class / struct names</string>
                  <key>scope</key>
                  <string>entity.name.type.class.cpp, entity.name.type.struct.cpp, entity.name.type.class.c, entity.name.type.struct.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#949fb5</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – template / namespace</string>
                  <key>scope</key>
                  <string>entity.name.type.template.cpp, meta.template.cpp, entity.name.namespace.cpp, entity.name.type.namespace.cpp</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – constructor / destructor</string>
                  <key>scope</key>
                  <string>entity.name.function.constructor.cpp, entity.name.function.destructor.cpp</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ba4b0</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – constants</string>
                  <key>scope</key>
                  <string>constant.language.cpp, constant.language.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#a292a3</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – preprocessor</string>
                  <key>scope</key>
                  <string>meta.preprocessor.cpp, meta.preprocessor.c, keyword.control.import.cpp, keyword.control.import.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8992a7</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – preprocessor macro names</string>
                  <key>scope</key>
                  <string>entity.name.other.preprocessor.macro.cpp, entity.name.other.preprocessor.macro.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ba4b0</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>C++ – include path</string>
                  <key>scope</key>
                  <string>string.quoted.other.lt-gt.include.cpp, string.quoted.other.lt-gt.include.c</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#87a987</string>
                  </dict>
                </dict>

                <!-- MARKUP -->

                <dict>
                  <key>name</key>
                  <string>Markup heading</string>
                  <key>scope</key>
                  <string>markup.heading</string>
                  <key>settings</key>
                  <dict>
                    <key>fontStyle</key>
                    <string>bold</string>
                    <key>foreground</key>
                    <string>#8ba4b0</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Markup bold</string>
                  <key>scope</key>
                  <string>markup.bold</string>
                  <key>settings</key>
                  <dict>
                    <key>fontStyle</key>
                    <string>bold</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Markup italic</string>
                  <key>scope</key>
                  <string>markup.italic</string>
                  <key>settings</key>
                  <dict>
                    <key>fontStyle</key>
                    <string>italic</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Markup link</string>
                  <key>scope</key>
                  <string>markup.underline.link</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#8ea4a2</string>
                  </dict>
                </dict>

                <!-- DIFF -->

                <dict>
                  <key>name</key>
                  <string>Diff deleted</string>
                  <key>scope</key>
                  <string>markup.deleted</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4746e</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Diff inserted</string>
                  <key>scope</key>
                  <string>markup.inserted</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#87a987</string>
                  </dict>
                </dict>

                <dict>
                  <key>name</key>
                  <string>Diff changed</string>
                  <key>scope</key>
                  <string>markup.changed</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>#c4b28a</string>
                  </dict>
                </dict>

              </array>
              <key>colorSpaceName</key>
              <string>sRGB</string>
              <key>semanticClass</key>
              <string>theme.dark.kanagawa-dragon</string>
            </dict>
          </plist>
        '';
        file = "kanagawa-dragon.tmTheme";
      };
    };
  };
}
