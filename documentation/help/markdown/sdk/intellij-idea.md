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

1. Open the IntelliJ IDEA preferences on Mac OS X by going to the **IntelliJ IDEA** menu → **Preferences**. On Windows, select the **File** menu → **Settings...**.

2. Expand the **Editor** node on the list to the left of the preferences window, and select **File and Code Templates**.

3. Click the button with the **+** (plus) symbol to create a new template.

4. Enter `Feathers Component` for the **Name** and `mxml` for the **Extension**. Then, enter the following code for the template:

	``` code
	<?xml version="1.0"?>
	<${Superclass} xmlns:f="library://ns.feathersui.com/mxml" xmlns:fx="http://ns.adobe.com/mxml/2009">
	</${Superclass}>
	```

5. Click **OK** to save the new template.

To use this template at any time, choose the **File** menu → **New** → **MXML Component**. In the new window's **Template** drop-down, choose **Feathers Component**.

## How to create a new module for a Feathers SDK application

1. Select the **File** menu → **New** → **Module...**. A new window will open to customize the module's settings.

	<aside class="info">If you prefer, you may select **File** → **New** → **Project...** to create both a new project and a new module.</aside>

2. Select the **Flash** module type from the list on the left.

3. On the right, select the approporite **Target platform** (Web, Desktop, or Mobile).

	Uncheck **Pure ActionScript**, if it is checked.

	For **Output type**, select **Application**.

	In the **Flex/AIR SDK** drop-down, select the Feathers SDK that we installed earlier.

	Uncheck **Create sample app**. The new module wizard in IntelliJ IDEA uses a template for Flex that we cannot customize. We'll create the main MXML application file in a later step.

	Click **Next**.

4. In the next section, enter the **Module name**. The default **Content root** and **Module file location** are usually okay. Click **Finish**.

5. Next, we will create the main application MXML file. Select the **src** directory in the new module. Then, select the **File** menu → **New** → **MXML Component**. A new window will open to customize the new component.

6. Enter the **Name** of the main application class.

	Leave the **Package** blank.

	In the **Template** drop-down, select the **Feathers Component** template that we added earlier.

	For **Parent Component**, start typing `Application` and choose **feathers.core.Application**.

	<aside class="info">You may use one of the other Feathers application classes, like `StackScreenNavigatorApplication` or `DrawersApplication`, if you prefer.</aside>

	Click the **Create** button.

7. Now, we need to tell the module to use this new MXML file as its main class. Select the **File** menu → **Project Structure**. A new window will open. Under **Project Settings** choose **Modules**. Expand the new module in the tree, and select the default build configuration with the module's name. In the **Main class** field, type in the name of the MXML file that we just created.

	Don't close the **Project Structure** window yet. We'll need it open in the next step.

8. IntelliJ IDEA has a bug where we can reference Feathers SDK components in ActionScript, but the editor shows errors in MXML. Thankfully, we can manually add the SWC files in the Feathers SDK to our module's dependencies as a workaround. With the module still selected in the **Project Structure** window, navigate to the **Dependencies** tab.

	Press the button with the **+** (plus) symbol and select **New Library**. Navigate to the directory where we installed the Feathers SDK. Then, add the **frameworks/libs** directory as a new library. This will add the required SWC files to the module.

	If the module is an AIR application, don't close the **Project Structure** window yet. We'll need it open in the next step. If the module is a Flash Player application, click **OK** to save all of our changes. This will close the Project Structure window.

9. Follow this step if the module targets **Adobe AIR**. Skip to the next step if the module targets Adobe Flash Player instead.

	If the module is a mobile AIR application, navigate to the **Compiler Options** tab. In the **Additional compiler options** field, type `-preloader=`. We're clearing this compiler argument that IntelliJ IDEA sets for Flex, so it should be left blank on the right of the equals sign.

	For all types of AIR applications, we must create the Adobe AIR *application descriptor* file. With the module still selected in the **Project Structure** window, navigate to the **Android** tab for a mobile AIR application, or navigate to the **AIR Package** tab for a desktop AIR application.

	Under **Application descriptor**, choose **Custom template** and click **Create...**. The default values for the application descriptor are usually okay, so simply click **Create**. You can open the application descriptor file later to make changes, if needed. For mobile apps, if IntelliJ IDEA asks to use the created application descriptor template for both Android and iOS, click **Yes**.

	Click **OK** to save all of our changes. This will close the **Project Structure** window.

	Open the module's new **-app.xml** file. Inside the `<initialWindow>` section, add `<renderMode>direct</renderMode>` to enable Stage 3D.

	Skip the next step and proceed to the conclusion.

10. Follow this step if the module targets **Adobe Flash Player**. Skip to the conclusion if the module targets Adobe AIR instead.

	Open the module's **index.template.html** file in the **html-template** folder. Search for the following line of JavaScript:

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

The new module is ready. If you're unsure how to proceed, take a look at the [Getting started with MXML in the Feathers SDK](getting-started-mxml.html) tutorial.

## Known Issues

* Unless the **frameworks/libs** folder from the Feathers SDK is added to the module as a dependency, the editor will highlight all Feathers components in MXML files in red, as if they don't exist. The compiler will compile these same MXML files without errors. This is a bug in IntelliJ IDEA. Add the **frameworks/libs** folder as a dependency in the module's settings to avoid this issue.

* In an MXML file that is based on `<f:Application>`, the editor will highlight the `theme` property in red, as if it doesn't exist. However, the compiler will compile this file without issues. This is not an error, and it may be ignored. This issue will be fixed in a future version of the Feathers SDK.

* In an MXML file, the editor will highlight an `<fx:Component>` element used to create a sub-component factory in red, as if it were a syntax error. Additionally, the root element of the inline component will be highlighted in red. However, the compiler will compile this file without issues, and code hinting will work properly too. This is not an error, and it may be ignored.

* With a module for a mobile AIR application, the compiler may report some errors:

	> Error code 1120: Access to undefined property SplashScreen
	> Error code: 1172: Definition spark.preloaders:SplashScreen could not be found.

	In the module's **Compiler Options** tab, add `-preloader=` (leave the right side of the equals sign blank) to the **Additional compiler options**.