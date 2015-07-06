---
title: Set up the Feathers SDK in IntelliJ IDEA  
author: Josh Tynjala

---
# Set up the Feathers SDK in IntelliJ IDEA

Let's get your [IntelliJ IDEA](http://www.jetbrains.com/idea/) development environment ready to use the Feathers SDK.

<aside class="info">These instructions apply to IntelliJ IDEA 14. Minor variations may exist between different versions of IntelliJ IDEA.</aside>

## Add the Feathers SDK to IntelliJ IDEA

1. [Install the Feathers SDK](installation-instructions.html) somewhere on your computer.

2. In IntelliJ IDEA, select the **File** menu → **Project Structure...**. A new window will open.

3. Under **Platform Settings**, select **SDKs**.

4. Press the button with the **+** (plus) symbol and select **Flex/AIR SDK**.

5. Choose the folder where you installed the Feathers SDK.

## Create a file template for a new Feathers Component

Next, we're going to create a custom template for new Feathers MXML files. The default **Flex 4 Component** template provided by IntelliJ IDEA works decently with Feathers components, but we can make a new one that works a bit better.

1. Open the IntelliJ IDEA preferences on Mac OS X by going to the **IntelliJ IDEA** menu → **Preferences**. On Windows, select the **Window** menu → **Preferences...**.

2. Expand the **Editor** node on the list to the left of the preferences window, and select **File and Code Templates**.

3. Click the button with the **+** (plus) symbol to create a new template.

4. Enter `Feathers Component` for the **Name** and `mxml` for the **Extension**. Then, enter the following code for the template:

	``` code
	<?xml version="1.0"?>
	<${Superclass} xmlns:f="library://ns.feathersui.com/mxml" xmlns:fx="http://ns.adobe.com/mxml/2009">
	</${Superclass}>
	```

5. Click **OK** to save the new template.

To use this template, choose the **File** menu → **New** → **MXML Component**. In the new window's **Template** drop-down, choose **Feathers Component**.

## How to create a new module for a Feathers SDK application

1. Select the **File** menu → **New** → **Module...**. A new window will open to customize the module's settings.

	<aside class="info">If you prefer, you may select **File** → **New** → **Project...** to create both a new project and a new module.</aside>

2. Select the **Flash** module type from the list on the left.

3. On the right, select the approporite **Target platform** (Web, Desktop, or Mobile).

	Uncheck **Pure ActionScript**, if it is checked.

	For **Output type**, select **Application**.

	In the **Flex/AIR SDK** field, select the Feathers SDK that you installed.

	Uncheck **Create sample app**. The new module wizard in IntelliJ IDEA uses a template for Flex that we cannot customize. We'll create the main MXML application file in a later step.

	Click **Next**.

4. In the next section, enter your **Module name**. The default **Content root** and **Module file location** are usually okay. Click **Finish**.

5. IntelliJ IDEA cannot automatically recognize certain components in MXML when using the Feathers SDK, which will cause the editor to incorrectly show errors. We can manually add the SDK SWC files to our module to work around this issue.

	Select the **File** menu → **Project Structure**. A new window will open. Under **Project Settings** choose **Modules**. Expand your new module in the tree, and select the default build configuration with the module's name. Navigate to the **Dependencies** tab.

	Press the button with the **+** (plus) symbol and select **New Library**. Navigate to the directory where you installed the Feathers SDK. Then, add the **frameworks/libs** directory as a new library. This will add the required SWC files to your module.

6. Now, let's create the main MXML application file. Select the **src** directory in the new module. Then select the **File** menu → **New** → **MXML Component**. A new window will open to customize the new component.

7. Enter the **Name** of your application. Leave the **Package** blank. In the **Template** field, select the **Feathers Component** template that we added earlier. For **Parent Component**, type `Application` and choose **feathers.core.Application**.

8. Follow this step if you are targeting **Adobe AIR**. Skip to the next step if you are targeting Adobe Flash Player instead.

	Let's create the Adobe AIR *application descriptor* file. Select **Modules** in the same **Project Structure** window that should still be open from the previous step. Expand your new module in the tree and select the default build configuration with the module's name. For mobile AIR apps, you'll want to navigate to the **Android** tab. For desktop AIR apps, navigate to the **AIR Package** tab instead.

	Under **Application descriptor**, choose **Custom template** and click **Create…**. The default values for the application descriptor are usually okay, so simply click **Create**. You can open the application descriptor file later to make changes, if needed. For mobile apps, if IDEA asks if you want to use the created application descriptor template for both Android and iOS, click **Yes**. Click **OK** in the **Project Structure** window.

	Open your module's new **-app.xml** file. Inside the `<initialWindow>` section, add `<renderMode>direct</renderMode>` to enable Stage 3D.

	You may skip the next step and proceed to the conclusion.

9. Follow this step if you are targeting **Adobe Flash Player**. Skip to the conclusion if you are targeting Adobe AIR instead.

	Open your modules **index.template.html** file in the **html-template** folder. Search for the following line of JavaScript:

	``` code
	var params = {};
	```

	Add the following line after it:

	``` code
	params.wmode = "direct";
	```

	Next, look for the `<object>` HTML elements near the bottom of the document. Add the following `<param>` element inside *both* `<object>` elements.

	``` code
	<param name="wmode" value="direct" />
	```

## Conclusion

Your module is ready. If you're unsure how to proceed, take a look at the [Getting started with MXML in the Feathers SDK](getting-started-mxml.html) tutorial.

## Known Issues

* Unless the **frameworks/libs** folder from the Feathers SDK is added to your module as a dependency, the editor will highlight all Feathers components in MXML files in red, as if they don't exist. The compiler will compile these same MXML files without errors. This is a bug in IntelliJ IDEA. Add the **frameworks/libs** folder as a dependency to your module to avoid this issue.

* In an MXML file that is based on `<f:Application>`, the editor will highlight the `theme` property in red, as if it doesn't exist. However, the compiler will compile this file without error. This issue will be fixed in a future version of the Feathers SDK.