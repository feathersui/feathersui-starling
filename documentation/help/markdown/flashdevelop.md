---
title: Setting up Feathers in FlashDevelop  
author: Josh Tynjala

---
# Setting up Feathers in FlashDevelop

Let's get your [FlashDevelop](http://www.flashdevelop.org/) development environment ready to use Feathers.

These instructions apply to FlashDevelop 4.2.2. Minor variations may exist between different versions of FlashDevelop.

1. Download the latest stable versions of [Feathers](http://feathersui.com/download/) and [Starling Framework](http://gamua.com/starling/download/).

2. In FlashDevelop, select the **Project** menu → **New Project**. Select to **ActionScript 3 - AIR Mobile AS3 App** project type. Enter your project **Name**, and project **Location** in your system. Then click **Ok**.

3. Next, select the **Project** menu → **Properties…**. Go to the **SDK** tab and select the appropriate combined Flex SDK and AIR SDK to use.

*Adobe AIR 3.2* is the minimum runtime version required to use Starling on a mobile device. See the [Starling installation intructions](http://wiki.starling-framework.org/manual/installation) for details about how to merge Flex and AIR SDKs to create a valid SDK that supports Starling and Feathers.

4. Edit `bat/SetupSDK.bat` to point to your SDK folder.

``` code
set FLEX_SDK=C:\flex-sdk-4.9.0
```

5. Make sure in **Project** menu → **Properties…**, in **Output** tab that you have correct Adobe AIR version selected. It should be at least 3.2, but the newest version of AIR is recommended.

6. Edit the **application.xml** file to use correct Adobe AIR namespace. For example, to target Adobe AIR 3.5, the namespace should read:

``` code
<application xmlns="http://ns.adobe.com/air/application/3.5">
```

7. Now that the project is created, you will need to add Feathers and Starling Framework to the project. Move **starling.swc** and **feathers.swc** into **lib** folder. Then select starling.swc file in Project pane and open menu(right mouse click), select **Add to library** - file should change color to blue. Do the same with feathers.swc file.

8. In order to test locally - just click **Test Project** button, or [CTRL + ENTER].

Your project is ready. If you're unsure how to proceed, start by using the code in the **Create your Game** section of the [Starling First Steps Tutorial](http://gamua.com/starling/first-steps/). Then take a look at the [Feathers Getting Started Tutorial](getting-started.html).

For more tutorials, return to the [Feathers Documentation](index.html).


