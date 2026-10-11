Instructions

- Rely on this script for installing Sikarugir, or install from https://github.com/Sikarugir-App/Sikarugir (DO NOT use sikarugir.com - it's not theirs)
- Using Sikarugir Creator, download the "WS12WineSikarugir11.0_1" (or latest equivalent) engine
  - WS12 == WineSkin v12, 11.0 == Upstream Wine Version, "\_1" suffix == Sikarugi custom revision
- Download the template
- Create a Steam.app (or "Steam (Windows).app")

- Open Steam.app - which will launch the nested Configure.app
- Launch Winetricks and use it to install Steam
- In "Configuration"
  - Set "Windows app" to "C:\Program Files (x86)\Steam\steam.exe"
  - Tick "Direct3D to Metal translation layer - (D3DMetal)"
    - This is the Direct X 12 to Metal converter needed for TLOU etc)
- In "Options" tick "mach semaphore-based synchronization (msync)"

--

To optimise for DirectX12 games like TLOU, a few more tweaks are required.
These will fix framerate drops, crackling audio, and crashes on intense renders.
Note: these tweaks are all built into CrossOver but there is no open source equivalent currently that configures this automatically, hence this must be done manually for now.
CrossOver pre-bakes these optimizations into its "bottles," but on a clean Wine build, you can activate them using Winetricks and Winecfg.

To do so, follow these instructions to complete the CrossOver feature match:

## 1. Install Essential Windows Performance Media Libraries

Heavy modern games rely on underlying Microsoft media frameworks for processing spatial audio, controller vibrations, and video cutscenes.

1.  Open Winetricks in your configuration panel.
2.  Go to the search bar and install these two critical packages (check them and hit Run):

- faudio: Implements DirectX audio processing. This completely stops audio stuttering and crackling in game chapters heavy with dialogue and action.
- csmt=force: This is the actual vulkan-1 implementation setup. It forces the translation layer to hook directly into the Mac's native MoltenVK/Vulkan engine rather than fallback OpenGL.
- renderer=vulkan: Forces command-stream multi-threading. This handles the heavy CPU thread demands that The Last of Us requires to keep your Mac's performance cores fed.

## 2. Boost the Multi-Threading Limits (The High-Core Count Tweak)

By default, standard Wine treats CPU thread pools conservatively. CrossOver overrides this to aggressively feed instructions to Apple Silicon's performance cores. You can match this manually by telling the engine to act like a high-end Windows PC thread scheduler.

1.  In the Configure app, click Winecfg (this opens the default Windows system configuration panel).
2.  Go to the Libraries tab.
3.  In the "New override for library" text box, type ntdll and click Add.
4.  Select ntdll from your list below, click Edit, set it to Native then Builtin, and click Apply. (This ensures low-level processor scheduling relies directly on native translation rather than fallback emulation code).

## 3. Hide Wine from the Game (Spoofing Windows 10/11)

Games like The Last of Us will actively monitor your system files to check if they are running inside a virtual environment or emulator, sometimes artificially capping performance or throwing dynamic memory errors if they detect "Wine."

1.  In the Winecfg panel, go to the Applications tab.
2.  Look at the bottom dropdown menu labeled Windows Version.
3.  Ensure this is explicitly set to Windows 10 or Windows 11 (do not leave it on Windows 7, or the DirectX 12 instructions will bottleneck).

## 4. Isolate Your Core Toggles

As a final check, make sure your primary Sikarugir GUI toggles are clean under Configure:

-
- D3DMetal: ON (To handle the heavy DX12 pipeline).
- MSYNC: ON (To prevent CPU bottlenecking).
- DXVK / DXMT: Keep both strictly OFF. [1, 2]
-

Once these tweaks are saved, your Wine 11 setup will essentially run with the same low-latency thread handling and audio structures as a commercial CrossOver wrapper, all while letting you use your Steam library interface completely natively!
Give the game a boot with these new settings applied!

Shaders should build faster FYI
