---
title: Why does the compiler throw errors that some classes cannot be found when I use the Feathers SWC?  
author: Josh Tynjala

---
# Why does the compiler throw errors that some classes cannot be found when I use the Feathers SWC?

Double check that your development environment has been set up correctly. Instructions are provided for setting up [Flash Builder](../flash-builder.html), [IntelliJ IDEA](../intellij-idea.html), [Flash Professional](../flash-pro.html), and [FlashDevelop](../flashdevelop.html).

Confirm that you added Feathers to your project's build settings. The SWC should be added to your project's library path. Where to find this information depends on which IDE that you are using, so please take a look at the appropriate instructions for details.

Check the minimum required versions of Starling Framework, Adobe Flash Player, and Adobe AIR in the Feathers README file. You may need to specify an appropriate `-swf-version` argument in the compiler settings if you are using an older SDK. If you are targeting Adobe AIR, double-check that you are using the correct version in the namespace in your application's `*-app.xml` file.

The Feathers SWC has been tested using both 1) the [Adobe Flex SDK 4.6](http://www.adobe.com/go/flex_sdk) merged with the latest version of "the original AIR SDK without the new compiler" and 2) the latest [Adobe AIR SDK & Compiler](http://www.adobe.com/go/air_sdk). Again, be sure to double check the Feathers README file to see which version of Adobe Flash Player, Adobe AIR, and Starling Framework are required.

Flash Builder 4.6 and Flash Builder 4.7 have both been tested and confirmed to work correctly. If you are still using Flash Builder 4.5, please consider upgrading to at least Flash Builder 4.6. Your serial number from Flash Builder 4.5 is fully compatible with Flash Builder 4.6 without paying an upgrade fee.