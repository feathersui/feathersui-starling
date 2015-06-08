---
title: Build the Feathers SDK from Source Code  
author: Josh Tynjala

---
# Build the Feathers SDK from Source Code

The document explains how to build the SDK from source code.

<aside class="warn">Most developers should use the [Feathers SDK Installer](http://feathersui.com/sdk/installer/) instead. This tutorial is meant for advanced developers who want to modify the Feathers SDK compiler source code to contribute or create a fork.</aside>

## Requirements

* [Apache Ant](http://ant.apache.org)
* playerglobal.swc for Flash Player 11.5 (Download from [Archived Flash Player versions](https://helpx.adobe.com/flash-player/kb/archived-flash-player-versions.html))
* Adobe AIR SDK 3.5 *without* the ASC 2.0 compiler (Download from [Archived Adobe AIR SDK versions](https://helpx.adobe.com/air/kb/archived-air-sdk-version.html))
* Adobe Flash Player projector content debugger (Download from [Adobe Flash Player Downloads](https://www.adobe.com/support/flashplayer/downloads.html))

Note: When you prepare the Feathers SDK for use in an IDE as the final step, you will be allowed to target newer versions of Flash Player and AIR. These older versions of Flash Player and AIR are only required when building the source code.

## Build Steps

1. Clone the repository from Github:

        git clone --recursive git@github.com:joshtynjala/flex-sdk.git ./feathers-sdk

    You must include the `--recursive` flag to load the required sub-modules for Starling Framework and Feathers.

1. Copy `env-template.properties` to a new file named `env.properties`. In this file, define the `env.PLAYERGLOBAL_HOME`, `env.AIR_HOME`, and `env.FLASHPLAYER_DEBUGGER` properties. These are required by the build script.

1. Run the following command:

        ant main

    When asked if you want to integrate with Adobe's embedded font support, type `n` and press the `Enter` key. We will do this in a later step.

1. Continue by following the instructions to [Build the Feathers SDK from a Binary Distribution](build-binary-distribution.html).