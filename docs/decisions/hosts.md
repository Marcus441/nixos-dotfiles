# Hosts

Machine facts that need a reason. Aspects are host-agnostic (Inv. 7), so
anything here is deliberately *not* in an aspect.

<a id="nix-ld-emulator"></a>
## `hosts/UM790pro.nix` — what `nix-ld.libraries` carries, and why

**Why** Google's prebuilt Android SDK binaries are FHS ELFs run through
nix-ld. `adb` and the build tools need nothing beyond glibc; the emulator is a
Qt app that bundles Qt and the xcb extensions under `lib64/qt/lib` and expects
the rest from the system. The list is every `DT_NEEDED` soname under
`$ANDROID_HOME/emulator` that the tree does not ship itself, plus the
GL/Vulkan/Wayland stack it `dlopen`s at runtime — so it is not reducible by
inspection of the config, only by re-running `ldd` over the emulator tree.
**Breaks** *Silently, and only in the emulator.* A missing `dlopen` entry
produces a black window or a software-rendered one rather than a link error,
because the loader never fails — the emulator just falls back.
**Also** three entries carry sonames that do not match the attribute name, and
are the ones most likely to look removable: `nspr` provides `libnspr4`,
`libplc4`, `libplds4`; `nss` provides `libnss3`, `libnssutil3`, `libsmime3`;
`libglvnd` provides `libGL`, `libEGL`, `libGLESv1_CM`, `libGLESv2`.
