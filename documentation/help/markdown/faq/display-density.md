---
title: Why do the Feathers component skins and font sizes appear very small?  
author: Josh Tynjala

---
# Why do the Feathers component skins and font sizes appear very small?

The Feathers themes that are included as examples scale the skins, fonts, and other assets based on the device's display density (also known as DPI or PPI) to ensure that the components and text display at the same physical size (as in inches or centimeters) on different devices. This value is reported by the Flash runtimes as [`Capabilities.screenDPI`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/system/Capabilities.html#screenDPI). Some IDEs don't seem to inform ADL (AIR Debug Launcher) that a specific device needs a custom display density value to be simulated properly. The instructions below should help you fix this issue in many IDEs.

Some sources have reported that the `Capabilities.screenDPI` value reported by Adobe AIR is not accurate for some mobile devices. Adobe AIR is providing the same screen density value that is used by native apps. In these cases, the manufacturer has chosen to report an incorrect value on purpose. It is best to respect the manufacturer's choice, in these rare cases.

#### Flash Builder

Ensure that the project type is an **ActionScript Mobile Project**. You can choose the simulated device in the **Run Configurations** and **Debug Configurations** dialogs.

#### Flash Professional

Unfortunately, Flash Professional does not provide a way to customize the display density of the testing environment to properly simulate a mobile device. Moreover, Flash Professional has no capability to test multiple screen resolutions without adjusting the stage width and height of your FLA file manually.

To properly simulate mobile devices with Feathers projects created in Flash Professional, it is recommended that you run ADL from the command line. Please follow the instructions for *Command Line* specified below.

#### IntelliJ IDEA

Ensure that the module type is an **ActionScript application for AIR mobile platform**. You can choose the simulated device in the **Run/Debug Configurations** dialog. For IntelliJ IDEA 11, follow the instructions below for *Other Environments*.

#### Other Environments

Add `-XscreenDPI [density]` to ADL's command line arguments. Your IDE should expose a field for this somewhere. Replace `[density]` with the appropriate display density value for the device that you want to simulate. For example, to simulate the display density of an iPhone with a Retina display, you would use `-XscreenDPI 326`. The Wikipedia article [List of displays by pixel density](http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density) provides a useful list of display density values (and screen resolutions) for many different devices that you might want to simulate.

#### Command Line

You can run [AIR Debug Launcher from the command line](http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html) to simulate various mobile devices. A couple of important command line arguments will allow you to specify any device's screen resolution and display density.

-   The `-screensize` argument will specify the device's screen resolution. A number of predefined strings are available to simulate popular devices. For instance, you can use `iPhone5Retina` to simulate an iPhone 5 with Retina display. The full list of predefined device strings is available in the [ADL documentation](http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html). If you want to simulate any device that doesn't have a predefined string, you can also pass in numeric values for the screen dimensions, in pixels. For example, the same iPhone device can be simulated by passing in `640×1096:640×1136` instead. The first set of dimensions is when the app is displayed with the OS chrome (status bars and things), and the second set of dimensions is when the app is displayed full screen.

-   The `-XscreenDPI` argument will specify the device's display density. For example, the display density of an iPhone 5 with Retina display is `326`. This is the value that is used to scale the skins in the Feathers example themes.

You will also need to pass the path to your AIR project's application XML file. Here are two examples of running ADL. The first uses a predefined device name and the second uses numeric values for the screen resolution.

``` code
adl -screensize iPhone5Retina -XscreenDPI 326 YourProject-app.xml
adl -screensize 640x1096:640x1136 -XscreenDPI 326 YourProject-app.xml
```

The Wikipedia article [List of displays by pixel density](http://en.wikipedia.org/wiki/List_of_displays_by_pixel_density) provides a useful list of display density values (and screen resolutions) for many different devices that you might want to simulate.