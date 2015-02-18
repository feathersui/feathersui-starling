---
title: Setting up Feathers in Adobe Flash Builder  
author: Josh Tynjala

---
# Setting up Feathers in Adobe Flash Builder

Let's get your [Flash Builder](http://www.adobe.com/products/flash-builder.html) development environment setup to use Feathers.

<aside class="info">These instructions apply to Flash Builder 4.7. Minor variations may exist between different versions of Flash Builder.</aside>

1. Download the latest stable versions of [Feathers](http://feathersui.com/download/) and [Starling Framework](http://gamua.com/starling/download/).

2. In Flash Builder, select the **File** menu → **New** → **ActionScript Mobile Project**.

3. Enter your **Project name**. The default Project location is usually okay.

4. In the next section, select your preferred mobile platform settings for iOS and Android. Often, you will not need to change anything in this section. If you're unsure, you can update these values in the `-app.xml` file later. Click **Next**.

5. In the final **Build Paths** section of the wizard, go to the **Library path** tab.

6. Choose the **Add SWC…** button and select the location of **starling.swc**. Repeat for **feathers.swc**.

	Alternatively, you can choose **Add SWC Folder…** and select a folder where both Starling and Feathers SWCs are located.

7. Click **Finish**.

8. Open your project's **-app.xml** file. Inside the `<initialWindow>` section, add `<renderMode>direct</renderMode>`.

Your project is ready. If you're unsure how to proceed, start by using the code in the **Create your Game** section of the [Starling First Steps Tutorial](http://gamua.com/starling/first-steps/). Then take a look at the [Feathers Getting Started Tutorial](getting-started.html).