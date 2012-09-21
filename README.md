# Feathers

Say hello to [Feathers](http://feathersui.com/). Light-weight, skinnable, and extensible UI components for mobile and desktop. Feathers puts it all together in one package — along with blazing fast GPU powered graphics (courtesy of [Starling Framework](http://starling-framework.org/)) to create a smooth and responsive experience.

Created by [Josh Tynjala](http://twitter.com/joshtynjala), Feathers is free and open source. Feathers runs on Starling Framework and the [Adobe Flash runtimes](http://gaming.adobe.com/technologies/), including Adobe AIR on iOS, Android, Windows, and Mac OS X and Adobe Flash Player in desktop browsers.

## Quick Links

* [Feathers Website](http://feathersui.com/)
* [Features](http://wiki.starling-framework.org/feathers/features)
* [Documentation](http://wiki.starling-framework.org/feathers/start)
* [Examples](http://feathersui.com/examples/) (and [source code](https://github.com/joshtynjala/feathers-examples))
* [Support Forum](http://forum.starling-framework.org/forum/feathers)

## Dependencies

The following external libraries are required by Feathers. Other versions of the same library may work, but the version displayed below is the one currently recommended for use with Feathers.

* [Starling](http://gamua.com/starling/) v1.2
* [GTween](http://gskinner.com/libraries/gtween/) v2.01
* [as3-signals](https://github.com/robertpenner/as3-signals) v0.9 BETA

## Important Note

Stable builds of Feathers are coming soon. Currently, all APIs remain subject to change, and updating to a new revision can often result in compiler errors caused by modified APIs. If something breaks in your app after you update to the latest revision, and you can't figure out the new way to do what you were doing before, please ask in the [Feathers Forum](http://forum.starling-framework.org/forum/feathers) over at the Starling Forums.

## Tips

* The components do not have default skins, and often they will display nothing (or possibly throw a runtime error) if no skin is provided. A number of themes are included the [Feathers Examples](http://feathersui.com/examples/), and they can usually be instantiated with one line of code to skin all standard Feathers components. Many of the example apps use [MetalWorksMobileTheme](https://github.com/joshtynjala/feathers-examples/tree/master/MetalWorksMobileTheme). Give it a try!

* An Ant build script is included. Add a file called `sdk.local.properties` to override the location of the Flex SDK and `build.local.properties` to override the locations of the required third-party libraries.