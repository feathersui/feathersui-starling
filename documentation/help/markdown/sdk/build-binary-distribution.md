---
title: Build the Feathers SDK from a Binary Distribution  
author: Josh Tynjala

---
# Build the Feathers SDK from a Binary Distribution

The Feathers SDK requires certain third-party dependencies with licenses that require them to be distributed separately. Adding these third-party dependencies requires running one simple task on the command line.

## Requirements

* A *binary distribution* of the Feathers SDK
* [Apache Ant](http://ant.apache.org/)

## Build Steps

1. Extract the Feathers SDK binary distribution into a directory.

1. In the Feathers SDK directory, run the following command:

        ant -f installer.xml

    If you want to target a specific version of Flash Player and AIR, you may modify the command to specify the required versions:

        ant -f installer.xml -Dflash.sdk.version=15.0 -Dair.sdk.version=15.0

1. When prompted to install each dependency, type `y` and press Enter.

That's it! The Feathers SDK may now be used with Flash Builder 4.7 and other supported IDEs.