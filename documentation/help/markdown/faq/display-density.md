---
title: Why do the Feathers component skins and font sizes appear very small?  
author: Josh Tynjala

---
# Why do the Feathers component skins and font sizes appear very small?

Unfortunately, while many IDEs provide a list of common mobile devices to simulate, some will only simulate the stage dimensions of these devices, but not the screen density (also referred to as DPI or PPI) or the name of the platform. In those cases, your computer's screen density (which is often very different from a phone or tablet) and your desktop platform (Windows or Mac instead of iOS or Android) will be reported during testing. This can make Feathers behave in unexpected ways, such as scaling components incorrectly.

Adobe AIR allows you to provide custom values for the screen density and platform name when testing a mobile app on your computer. This makes it easy to quickly simulate a variety of mobile devices. In most IDEs, you can customize the arguments passed to ADL (AIR Debug Launcher) to manually take advantage of this feature, even if the IDE doesn't support it automatically. The instructions below will walk you through this process for several popular development environments. You'll also find tips for other environments, including launching ADL from the command line.

#### Adobe Flash Builder

Ensure that the project type is an **ActionScript Mobile Project**. You can choose the simulated device in the **Run Configurations** and **Debug Configurations** dialogs. The screen density and platform name will be provided automatically for common devices.

#### Adobe Animate CC

Unfortunately, Animate CC (formerly known as Flash Professional CC) does not provide advanced options to customize the ADL testing environment with a screen density and platform name. In fact, to switch between different screen resolutions during testing, you need to manually adjust the stage width and height of your FLA file before you choose Test Movie. It's very cumbersome, and building Feathers apps with Animate is supported, but not recommended.

For best results, run ADL from the command line after you compile your SWF in Animate. Please follow the instructions for [*Other Environments*](#other-environments), specified below.

#### IntelliJ IDEA

Ensure that the module type is an **ActionScript application for AIR mobile platform**. You can choose the simulated device in the **Run/Debug Configurations** dialog. The screen density and platform name will be provided automatically for common devices, and you can specify custom values, if needed.

#### Other Environments

[AIR Debug Launcher](http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html) offers a few important command line options that will allow you to simulate any device's screen resolution, screen density, and platform name.

-   The `-screensize` argument will specify the device's screen resolution. Some IDEs may provide this automatically, but it should always be specified on the command line.

	A number of predefined strings are available to simulate common devices. For instance, you can use `iPhone5Retina` to simulate an iPhone 5 with Retina display. The full list of predefined device strings is available in the [ADL documentation](http://help.adobe.com/en_US/air/build/WSfffb011ac560372f-6fa6d7e0128cca93d31-8000.html).

	If you want to simulate any device that doesn't have a predefined string, you can also pass in numeric values for the screen dimensions, in pixels. For example, the same iPhone device can be simulated by passing in `640×1096:640×1136` instead. The first set of dimensions is when the app is displayed with the OS chrome (status bars and things), and the second set of dimensions is when the app is displayed full screen.

-   The `-XscreenDPI` argument will specify the simulated device's screen density. For example, the screen density of an iPhone 5 with Retina display is `326`.

-   The `-XversionPlatform` argument will specify the simulated device's operating system. For example, you may use `IOS` or `AND`.

### Command Line

Using the arguments we learned about above, let's see a couple of examples of how to launch ADL from the command line to simulate a mobile device.

In the following example, a predefined device name is used, along with the screen density and the platform name used on Apple devices:

``` code
adl -screensize iPhone5Retina -XscreenDPI 326 -XversionPlatform IOS YourProject-app.xml
```

At the end of the command, you must specify the path to your AIR application descriptor.

In the next example, we specify the screen resolution, density, and platform name of an Android phone:

``` code
adl -screensize 768x1240:768x1280 -XscreenDPI 318 -XversionPlatform AND YourProject-app.xml
```

## Related Links

-   [`feathers.utils.ScreenDensityScaleFactorManager` API Documentation](../../api-reference/feathers/utils/ScreenDensityScaleFactorManager.html)