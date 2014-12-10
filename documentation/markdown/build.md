# Building the Feathers SWC from Source Code

Whether you're using the latest unstable version of Feathers or you've made changes to the core Feathers library, you may want to build the Feathers SWC locally.

## Requirements

-   [Feathers source code from Github](https://github.com/joshtynjala/feathers) (the main build target does **not** use the Flex SDK)

-   [Starling Framework source code from Github](https://github.com/Gamua/Starling-Framework)

-   [Apache Ant](http://ant.apache.org/)

-   [Adobe AIR SDK with Compiler](http://www.adobe.com/go/air_sdk)

## Build Instructions

The main build script is `build.xml`, located in the root of the source tree. This file is only available if you download the full project source code for [Feathers on Github](https://github.com/joshtynjala/feathers). The build script is **not** included in the ZIP file that is downloadable from the [Feathers website](http://feathersui.com/).

Two other files in the same directory, `build.properties` and `sdk.properties`, set up the environment for the build script. If you need to override any properties from these files, you can create new files named `build.local.properties` and `sdk.local.properties`. The build script will automatically detect if these files are present and use their values instead of the defaults.

1. Create a file named `sdk.local.properties` in the same directory as `build.xml`. Inside, override the `airsdk.root` property to point to the location of your local AIR SDK with ASC 2.0:

``` code
airsdk.root = C:/Development/AIR_SDK
```

Use the path on your local computer rather than the one above. The path above is for a location on Windows, but paths on Macs are supported too. Make sure that you use forward slashes, regardless of which platform you're on.

2. build.properties creates a property named `starling.root` that points to `third-party/starling`. From the Starling Framework, copy the contents of `starling/src` into this directory.

Alternatively, you may create a `build.local.properties` file and override the value of `starling.root`.

3. Open a command prompt in the directory where build.xml is located.

4. Run the command `ant quick`.

5. `feathers.swc` will be compiled and placed in an directory named `output`.

Most likely, you will only need the `quick` target, which simply builds the SWC and does nothing else. There are several targets available that you may find useful.

-   `swc` compiles the Feathers SWC.

-   `docs` generates the Feathers API documentation.

-   `full` compiles the SWC, generates the API documentation, and copies all of the supporting files into the `output` directory to create a full release build of Feathers.

-   `package` creates a full release build of Feathers, and then it packages everything into a ZIP file.

For more tutorials, return to the [Feathers Documentation](index.html).


