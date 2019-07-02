---
title: Setting up Feathers in IntelliJ IDEA  
author: Josh Tynjala

---
# Setting up Feathers in IntelliJ IDEA

Let's get your [IntelliJ IDEA](http://www.jetbrains.com/idea/) development environment ready to use Feathers.

<aside class="info">These instructions apply to IntelliJ IDEA 12. Minor variations may exist between different versions of IntelliJ IDEA.</aside>

1. Download the latest stable versions of [Feathers](http://feathersui.com/download/) and [Starling Framework](http://gamua.com/starling/download/).

2. In IDEA, select the **File** menu → **New Project**. A wizard will guide you through the creation process.

3. Select **Flash Module** and enter your **Project name**. The default Project location is usually okay. The Module name and Module location will update automatically when you set values for your project, and the default values are usually okay. Click **Next**.

4. In the next section, select the approporite **Target platform** (Web, Desktop, or Mobile) and select **Pure ActionScript**. For **Output type**, select **Application**. Select an appropriate **Flex/AIR SDK** (see below where to download the latest version of the AIR SDK). Then click **Finish**.

	You can download the latest [Adobe AIR SDK and Compiler](http://www.adobe.com/devnet/air/air-sdk-download.html) from Adobe's website. This SDK can be used to target both Adobe AIR and Adobe Flash Player in the browser. Check the Feathers README file to see the minimum required versions of Adobe AIR and Flash Player for the version of Feathers that you are using.

5. Now that the project is created, you will need to add Feathers and Starling Framework to the project. Select the **File** menu → **Project Structure**, then under **Project Settings** choose **Libraries**. Click the **+** (plus sign) at the top. Next, select **ActionScript/Flex** and specify the location of **starling.swc**.

6. Follow the same steps to add **feathers.swc** as a library.

7. Follow this step if you are targeting **Adobe AIR**. Skip to the next step if you are targeting Adobe Flash Player instead.

	Let's create create the Adobe AIR *application descriptor* file. Select **Modules** in the same **Project Structure** window that should still be open from the previous step. Expand your new module in the tree and select the default build configuration with the module's name. For mobile AIR apps, you'll want to navigate to the **Android** tab. For desktop AIR apps, navigate to the **AIR Package** tab instead.

	Under **Application descriptor**, choose **Custom template** and click **Create…**. The default values for the application descriptor are usually okay, so simply click **Create**. You can open the application descriptor file later to make changes, if needed. For mobile apps, if IDEA asks if you want to use the created application descriptor template for both Android and iOS, click **Yes**. Click **OK** in the **Project Structure** window.

	Open your module's new **-app.xml** file. Inside the `<initialWindow>` section, add `<renderMode>direct</renderMode>` to enable Stage 3D.

	You may skip the next step and proceed to the conclusion.

8. Follow this step if you are targeting **Adobe Flash Player**. Skip to the conclusion if you are targeting Adobe AIR instead.

	Open your modules **index.template.html** file in the **html-template** folder. Search for the following line of JavaScript:

	``` javascript
var params = {};
```

	Add the following line after it:

	``` javascript
params.wmode = "direct";
```

	Next, look for the `<object>` HTML elements near the bottom of the document. Add the following `<param>` element inside *both* `<object>` elements.

	``` xml
<param name="wmode" value="direct" />
```

## Conclusion

Your project is ready. If you're unsure how to proceed, start by using the code in the **Create your Game** section of the [Starling First Steps Tutorial](http://gamua.com/starling/first-steps/). Then, take a look at the [Feathers Getting Started Tutorial](getting-started.html).