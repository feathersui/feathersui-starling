---
title: Build the Feathers SDK from a Binary Distribution  
author: Josh Tynjala

---
# Build the Feathers SDK from a Binary Distribution

The document explains how to build the Feathers SDK from a binary distribution. The build process downloads the Adobe AIR SDK, playerglobal.swc, and some font embedding utilities from the Adobe Flex SDK that are not open source. When finished, the Feathers SDK will be ready to use with a supported IDE.

<aside class="warn">Most developers should use the [Feathers SDK Manager](installation-instructions.html) instead. This tutorial is meant for advanced developers who want to modify the Feathers SDK compiler source code to contribute or to create a fork.</aside>

## Requirements

* A *binary distribution* of the Feathers SDK
* [Apache Ant](http://ant.apache.org/)
* Java 8 (update 101 or newer)

## Build Steps

1. Extract the Feathers SDK binary distribution into a directory.

1. In the Feathers SDK directory, run the following command:

        ant -f installer.xml

    If you want to target a specific version of Flash Player and AIR, you may modify the command to specify the required versions:

        ant -f installer.xml -Dflash.sdk.version=22.0 -Dair.sdk.version=22.0

1. When prompted to install each dependency, type `y` and press Enter.

That's it! The Feathers SDK may now be used with Flash Builder 4.7 and other supported IDEs.