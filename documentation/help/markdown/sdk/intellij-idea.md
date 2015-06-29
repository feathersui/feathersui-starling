---
title: Setting up the Feathers SDK in IntelliJ IDEA  
author: Josh Tynjala

---
# Setting up the Feathers SDK in IntelliJ IDEA

Let's get your [IntelliJ IDEA](http://www.jetbrains.com/idea/) development environment ready to use the Feathers SDK.

<aside class="info">These instructions apply to IntelliJ IDEA 14. Minor variations may exist between different versions of IntelliJ IDEA.</aside>

## Add the Feathers SDK

1. Use the [Feathers SDK Installer](http://feathersui.com/sdk/installer/) to install the Feathers SDK.

2. In IDEA, select the **File** menu → **Project Structure...**. A new window will open.

3. Under **Platform Settings**, select **SDKs**.

4. Press the button with the **+** (plus) symbol and select **Flex/AIR SDK**.

5. Choose the folder where you installed the Feathers SDK.

## Import the file templates for the Feathers SDK

Next, we're going to import custom templates for new MXML files. The default templates provided by IntelliJ IDEA don't work with Feathers components, so these custom templates will provide the right settings.

1. Download the [Feathers SDK file templates for IntelliJ IDEA](javascript:alert("Not available yet.")).

<aside class="warn">This document is incomplete. These steps will be added later.</aside>

## Create a new Feathers SDK Module

2. In IDEA, select the **File** menu → **New** → **Module...**. A new window will open to customize the module's settings.

	<aside class="info">If you prefer, you may select **File** → **New** → **Project...** to create both a new project and a new module.</aside>

3. Select **Flash Module** and enter your **Project name**. The default Project location is usually okay. The Module name and Module location will update automatically when you set values for your project, and you may optionally change them. Click **Next**.

4. In the next section, select the approporite **Target platform** (Web, Desktop, or Mobile). **Pure ActionScript** should **not** be checked. This module will be treated like a Flex module. For **Output type**, select **Application**. In the **Flex/AIR SDK** field, select the Feathers SDK that you installed. Then, click **Finish**.

5. IntelliJ IDEA cannot automatically recognize certain components in MXML when using the Feathers SDK, which will cause the editor to incorrectly show errors. We can manually add the SDK SWC files to our module to work around this issue.

	Select the **File** menu → **Project Structure**. A new window will open. Under **Project Settings** choose **Modules**. Expand your new module in the tree, and select the default build configuration with the module's name. Navigate to the **Dependencies** tab.

6. Press the button with the **+** (plus) symbol and select **New Library**. Navigate to the directory where you installed the Feathers SDK. Then, add the **frameworks/libs** directory as a new library. This will add the required SWC files to your module.

7. Follow this step if you are targeting **Adobe AIR**. Skip to the next step if you are targeting Adobe Flash Player instead.

	Let's create the Adobe AIR *application descriptor* file. Select **Modules** in the same **Project Structure** window that should still be open from the previous step. Expand your new module in the tree and select the default build configuration with the module's name. For mobile AIR apps, you'll want to navigate to the **Android** tab. For desktop AIR apps, navigate to the **AIR Package** tab instead.

	Under **Application descriptor**, choose **Custom template** and click **Create…**. The default values for the application descriptor are usually okay, so simply click **Create**. You can open the application descriptor file later to make changes, if needed. For mobile apps, if IDEA asks if you want to use the created application descriptor template for both Android and iOS, click **Yes**. Click **OK** in the **Project Structure** window.

	Open your module's new **-app.xml** file. Inside the `<initialWindow>` section, add `<renderMode>direct</renderMode>` to enable Stage 3D.

	You may skip the next step and proceed to the conclusion.

8. Follow this step if you are targeting **Adobe Flash Player**. Skip to the conclusion if you are targeting Adobe AIR instead.

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

Your module is ready. If you're unsure how to proceed, take a look at the [Getting Started with Feathers and MXML tutorial](getting-started-mxml.html).