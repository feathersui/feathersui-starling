---
title: Set up the Feathers SDK in Adobe Flash Builder  
author: Josh Tynjala

---
# Set up the Feathers SDK in Adobe Flash Builder

Let's get your [Flash Builder](http://www.adobe.com/products/flash-builder.html) development environment setup to use the Feathers SDK.

<aside class="info">These instructions apply to both Flash Builder 4.6 and Flash Builder 4.7.</aside>

## Create a new workspace for Feathers SDK projects

First, we should to create a new workspace in Flash Builder. We're going to make some changes to the workspace settings so that Flash Builder works a little more smoothly with the Feathers SDK. We don't want to do that in a workspace that contains any Flex projects.

1. Create a new workspace in Flash Builder by selecting **File** menu → **Switch workspace** → **Other...**.

2. Choose a directory for the new workspace.

Don't create a new project yet! We have a couple of things to tweak first.

## Import the file templates for the Feathers SDK

Next, we're going to import custom templates for new MXML files. The default templates provided by Flash Builder don't work with Feathers components, so these custom templates will provide the right settings.

1. Download the [Feathers SDK file templates for Flash Builder](javascript:alert("Not available yet.")).

2. Open the Flash Builder preferences on Mac OS X by going to the **Flash Builder** menu → **Preferences**. On Windows, select the **Window** menu → **Preferences...**.

3. Expand the **Flash Builder** node on the list to the left of the preferences window and select **File Templates**.

4. Click the **Import...** button and choose the file templates that were downloaded in step 1.

## Create a new Feathers SDK project

1. In Flash Builder, select the **File** menu → **New** → **Flex Project**. A new window will open to customize the project's settings.

2. Enter your **Project name**. The default **Project location** is usually okay.

3. Click **Finish**.

Your project is ready. If you're unsure how to proceed, take a look at the [Getting started with MXML in the Feathers SDK](getting-started-mxml.html) tutorial.