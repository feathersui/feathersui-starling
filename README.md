# Foxhole

Built on [Starling](http://gamua.com/starling/) for Adobe AIR and Flash Player, Foxhole consists of various UI controls designed for mobile, developed by [Josh Tynjala](http://twitter.com/joshtynjala). Foxhole's name comes from the fact that the author develops these components "under fire" for real projects, mostly games. Documentation is sparse. APIs may change completely and on a whim. They're not necessarily fully-featured. Use at your own risk.

## Available Components

Foxhole includes The following UI controls:

### Label
A single-line, non-interactive text control. Uses bitmap fonts.

### Button
A typical button control, with optional toggle support. Includes a label and an icon, both optional.

### ToggleSwitch
A sliding on/off switch. A common alternative to a checkbox in mobile environments.

### Slider
A typical horizontal or vertical slider control.

### List
A touch-based, vertical list control. Has elastic edges and you can "fling" it.

### PickerList
A control similar to a combo box. Appears as a button when closed. The list is displayed as a fullscreen overlay on top of the stage.

## Dependencies

The following external libraries are required. Other versions of the same library may work, but the version displayed below is the one currently used by the author.

* [Starling](http://gamua.com/starling/) v1.0
* [GTween](http://gskinner.com/libraries/gtween/) v2.01
* [as3-signals](https://github.com/robertpenner/as3-signals) v0.9 BETA

# Tips

At this time, the components do not have default skins. All skins need to be set manually, and you're likely to see runtime errors if certain skins are omitted.

In most cases any Starling display object is acceptable. However, the ToggleSwitch control requires the use of scrollRect, which isn't currently available in Starling. Subclasses of Sprite and Image are included with simple (but unoptimized) implementations of scrollRect.

Bitmap fonts are required for all text displayed in these UI controls. Use BitmapFontTextFormat to customize the text.