# Foxhole

Built on [Starling](http://gamua.com/starling/) for Adobe AIR and Flash Player, Foxhole consists of various UI controls designed for mobile, developed by [Josh Tynjala](http://twitter.com/joshtynjala). The author develops Foxhole to support real-world mobile applications that he develops, mostly games.

To get started, you might want to check out the [API Documentation](http://www.flashtoolbox.com/foxhole-starling/documentation/) and the [Foxhole for Starling Examples](https://github.com/joshtynjala/foxhole-starling-examples).

## Available Components

Foxhole includes the following UI controls:

### Label
A single-line, non-interactive text control. Uses bitmap fonts. A simplified replacement for `starling.text.TextField` that is built on `FoxholeControl`.

### Button
A typical button control, with optional toggle support. Includes a label and an icon, both optional.

### ToggleSwitch
A sliding on/off switch. A common alternative to a checkbox in mobile environments.

### Slider
A typical horizontal or vertical slider control.

### List
A touch-based, vertical list control. Has elastic edges and you can "throw" it.

### PickerList
A control similar to a combo box. Appears as a button when closed. The list is displayed as a fullscreen overlay on top of the stage.

### TabBar
A line of tabs, where one may be selected at a time.

### ScreenNavigator
A state machine for menu systems. Uses events or signals to trigger navigation between screens or to call functions. Includes very simple dependency injection.

### Screen
An abstract class for implementing a single screen within a menu developed with `ScreenNavigator`. Includes common helper functionality, including back/menu/search hardware key callbacks, calculating scale from original resolution to current stage size, and template functions for initialize, layout and destroy.

### ScreenHeader
A header that displays a title along with a horizontal regions on the sides for additional UI controls. The left side is typically for navigation (to display a back button, for example) and the right for additional actions.

## Dependencies

The following external libraries are required. Other versions of the same library may work, but the version displayed below is the one currently used by the author.

* [Starling](http://gamua.com/starling/) v1.0
* [GTween](http://gskinner.com/libraries/gtween/) v2.01
* [as3-signals](https://github.com/robertpenner/as3-signals) v0.9 BETA

## Quick Links

* [Foxhole for Starling Examples](https://github.com/joshtynjala/foxhole-starling-examples)
* [API Documentation](http://www.flashtoolbox.com/foxhole-starling/documentation/)
* [Getting Started Article](https://github.com/joshtynjala/foxhole-starling/wiki/Getting-Started)
* [Official Foxhole Q&A thread on the Starling Forums](http://forum.starling-framework.org/topic/official-foxhole-components-qa)

## Important Note

The core architecture and non-private APIs of Foxhole for Starling are still under active design and development. Basically, for the time being, absolutely everything is subject to change, and updating to new revisions may result in broken content. If something breaks after you update to the latest revision, and you can't figure out the new way to do something, please ask in the [Q&A thread](http://forum.starling-framework.org/topic/official-foxhole-components-qa) I have set up at the Starling Forum.

## Tips

* The components do not have default skins. However, you can try out one of the themes included with the [Foxhole for Starling Examples](https://github.com/joshtynjala/foxhole-starling-examples).

* In most cases any Starling display object is acceptable as a skin. However, the `ToggleSwitch` control works best with skins that supports `scrollRect` (it's not required, but recommended). Starling's core display objects do not implement `scrollRect` at this time. Subclasses of `Sprite` and `Image` with basic (but somewhat incomplete) implementations are included with Foxhole.

* Bitmap fonts are required for all text displayed in these UI controls. Use `BitmapFontTextFormat` to customize the text styles. `BitmapFont` from Starling has been subclassed to add the missing `base` property defined in `*.fnt` files.

* An Ant build script is included. Add a file called `sdk.local.properties` to override the location of the Flex SDK and `build.local.properties` to override the locations of the required third-party libraries.