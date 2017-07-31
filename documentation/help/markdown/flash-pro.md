---
title: Setting up Feathers in Adobe Animate CC  
author: Josh Tynjala

---
# Setting up Feathers in Adobe Animate CC

Let's get your [Adobe Animate](https://www.adobe.com/products/animate.html) development environment ready to use Feathers.

<aside class="info">These instructions apply to Animate CC. Minor variations may exist between different versions of Animate (or older versions of Flash Professional).</aside>

1. Download the latest stable versions of [Feathers](http://feathersui.com/download/) and [Starling Framework](http://gamua.com/starling/download/).

2. In Animate, create a new project. For mobile, you will want to create an **AIR for Android** or **AIR for iOS** project. For desktop, you will want to create an **AIR** project. For Flash Player in the browser, you will want to create an **ActionScript 3.0** project.

3. In the **Properties** panel, ensure that the **Target** is set to an appropriate version of the Flash runtime that you are targeting. Please check the Feathers README file to see which versions of the Flash runtimes are required for the version of Feathers that you are using.

	If the minimum version of Adobe AIR or Flash Player specified in the Feathers README file is not listed, go to the **Help** menu and select **Manage AIR SDK…** to manually add the appropriate version of the AIR SDK. You can [download the latest AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html) from Adobe's website.

4. Set up the `renderMode` or `wmode` for your target platform.

	a. If you are targeting *Adobe AIR*, click the button with the **Wrench icon** next to the **Target** in the **Properties** panel. Ensure that **Render mode** is set to **Direct**. Click **OK**.

	b. If you are targeting *Adobe Flash Player* in a web browser, you will need to ensure that the **wmode** value in your HTML and/or JavaScript is set to **direct**.

5. Click the button with the **Wrench icon** next to **Script** in the **Properties** panel. In the **Library path** tab, click the **Browse to SWC** button (the one with the Flash Player logo) and specify the location of **starling.swc**. Repeat this step to add **feathers.swc**.

6. An **FPS** value of **60** is recommended.

Your project is ready. If you're unsure how to proceed, start by using the code in the **Create your Game** section of the [Starling First Steps Tutorial](http://gamua.com/starling/first-steps/). Then take a look at the [Feathers Getting Started Tutorial](getting-started.html).

<aside class="warn">Animate's ability to properly simulate devices on AIR is limited compared to other development environments. Animate's AIR simulator does not provide the correct screen DPI/PPI for the mobile device that it is simulating. The value of `Capabilities.screenDPI` is used by Feathers themes to scale skins to an appropriate physical size for each device.

In order to use the DPI scaling capabilities of Feathers themes, you will need to run **ADL** from the AIR SDK on the command line or test on a real device. For more details, see [Why do the Feathers component skins and font sizes appear very small?](faq/display-density.html) in the [Feathers FAQ](faq/index.html).</aside>