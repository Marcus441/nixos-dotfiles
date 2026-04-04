{}: ''
  <?xml version="1.0" encoding="UTF-8"?>
  <interface>
    <requires lib="gtk" version="4.0"></requires>
    <object class="GtkWindow" id="Window">
      <style><class name="window"></class></style>
      <property name="resizable">true</property>
      <property name="title">Walker</property>
      <child>
        <object class="GtkBox" id="BoxWrapper">
          <style><class name="box-wrapper"></class></style>
          <property name="width-request">800</property>
          <property name="height-request">600</property>
          <property name="orientation">horizontal</property>
          <property name="valign">center</property>
          <property name="halign">center</property>
          <child>
            <object class="GtkBox" id="Box">
              <property name="orientation">vertical</property>
              <property name="hexpand">true</property>
              <property name="spacing">10</property>

              <child>
                <object class="GtkBox" id="SearchContainer">
                  <style><class name="search-container"></class></style>
                  <property name="orientation">horizontal</property>
                  <property name="hexpand">true</property>
                  <child>
                    <object class="GtkEntry" id="Input">
                      <style><class name="input"></class></style>
                      <property name="hexpand">true</property>
                    </object>
                  </child>
                </object>
              </child>

              <child>
                <object class="GtkBox" id="ContentContainer">
                  <property name="orientation">horizontal</property>
                  <property name="spacing">15</property>
                  <property name="vexpand">true</property>
                  <child>
                    <object class="GtkScrolledWindow" id="Scroll">
                      <property name="hexpand">true</property>
                      <property name="vexpand">true</property>
                      <property name="max-content-height">500</property>
                      <property name="min-content-height">400</property>
                      <property name="propagate-natural-height">true</property>
                      <child>
                        <object class="GtkGridView" id="List">
                          <property name="max_columns">1</property>
                        </object>
                      </child>
                    </object>
                  </child>

                  <child>
                    <object class="GtkBox" id="Preview">
                      <style><class name="preview-window"></class></style>
                      <property name="width-request">300</property>
                      <property name="hexpand">true</property>
                      <property name="vexpand">true</property>
                    </object>
                  </child>

                  <child>
                    <object class="GtkLabel" id="ElephantHint">
                      <property name="visible">false</property>
                    </object>
                  </child>
                </object>
              </child>

              <child>
                <object class="GtkBox" id="Keybinds">
                  <child>
                    <object class="GtkBox" id="GlobalKeybinds">
                      <property name="spacing">8</property>
                    </object>
                  </child>
                  <child>
                    <object class="GtkBox" id="ItemKeybinds">
                      <property name="hexpand">true</property>
                      <property name="halign">end</property>
                      <property name="spacing">8</property>
                    </object>
                  </child>
                </object>
              </child>

              <child>
                <object class="GtkLabel" id="Error">
                  <style><class name="error"></class></style>
                  <property name="visible">false</property>
                  <property name="xalign">0</property>
                </object>
              </child>

            </object>
          </child>
        </object>
      </child>
    </object>
  </interface>
''
