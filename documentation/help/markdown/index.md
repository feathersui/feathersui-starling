---
title: Feathers  
author: Josh Tynjala

---
# Feathers

Get started with [Feathers](http://feathersui.com/), the open source library of user interface components for the hardware-accelerated [Starling Framework](http://gamua.com/starling/). A robust skinning system enables your creativity, fluid layouts make it easy to deploy to a variety of screens, and support for both touch and mouse interaction puts your apps on mobile and desktop. With Feathers and Starling, you can build fully-standalone native apps for iOS, Android, Windows, and Mac OS X, and you can even deploy to desktop web browsers with Adobe Flash Player.

## Installation & Getting Started

-   [Download Starling Framework](http://gamua.com/starling/download/)

-   [Download Feathers](http://feathersui.com/download/)

-   Set up Starling and Feathers in your preferred development environment:

    -   [Flash Builder](flash-builder.html)

    -   [IntelliJ IDEA](intellij-idea.html)

    -   [FlashDevelop](flashdevelop.html)

    -   [Flash Professional](flash-pro.html)

-   Follow the instructions in [Getting Started with Feathers](getting-started.html) to create your first "Hello World" app using Feathers.

## Help & Support

There are a number of places where you can get help with Feathers issues or to ask questions.

-   Bookmark the [Feathers API Reference](../api-reference/) for easy access to all of the classes, properties, methods, and events that Feathers components offer.

-   Study the [Frequently Asked Questions (FAQ)](faq/index.html). Feathers makes some default choices that aren't necessarily intuitive because they improve performance significantly. For beginners, the FAQ will answer a number of common questions.

-   Ask for help at [Feathers in the Starling Forum](http://forum.starling-framework.org/forum/feathers). Many of the community's experts (including Josh Tynjala, the main author behind Feathers) visit frequently to answer questions. Be sure to try a couple of searches to see if someone else has had the same issue -- maybe your questions have been answered already! If not, then feel free to start a new thread.

-   Submit [bug reports and feature requests](https://github.com/joshtynjala/feathers/issues) on Github. If you're not quite sure if you've found a bug or not, or if you simply have a question, then please post in the forums first. We can escalate to a bug report later, if needed.

-   Looking for quick recipes that show you how to do common tasks using Feathers? Check out the [Feathers Cookbook](cookbook/index.html).

## Core Concepts

-   [Introduction to Themes](themes.html)

-   [Introduction to Text Renderers](text-renderers.html)

-   [Introduction to Text Editors](text-editors.html)

## Feathers Components

A more detailed look at each of the components that Feathers provides.

-   [`Alert`](alert.html)

-   [`AutoComplete`](auto-complete.html)

-   [`Button`](button.html)

-   [`ButtonGroup`](button-group.html)

-   [`Callout`](callout.html)

-   [`Check`](check.html)

-   [`DefaultListItemRenderer` and `DefaultGroupedListItemRenderer`](default-item-renderers.html)

-   [`Drawers`](drawers.html)

-   [`GroupedList`](grouped-list.html)

-   [`Header`](header.html)

-   [`ImageLoader`](image-loader.html)

-   [`Label`](label.html)

-   [`LayoutGroup`](layout-group.html)

-   [`List`](list.html)

-   [`NumericStepper`](numeric-stepper.html)

-   [`PageIndicator`](page-indicator.html)

-   [`Panel`](panel.html)

-   [`PanelScreen`](panel-screen.html)

-   [`PickerList`](picker-list.html)

-   [`ProgressBar`](progress-bar.html)

-   [`Radio`](radio.html)

-   [`Screen`](screen.html)

-   [`ScreenNavigator`](screen-navigator.html)

-   [`ScrollBar`](scroll-bar.html)

-   [`ScrollContainer`](scroll-container.html)

-   [`ScrollScreen`](scroll-screen.html)

-   [`ScrollText`](scroll-text.html)

-   [`SimpleScrollBar`](simple-scroll-bar.html)

-   [`Slider`](slider.html)

-   [`SpinnerList`](spinner-list.html)

-   [`StackScreenNavigator`](stack-screen-navigator.html)

-   [`TabBar`](tab-bar.html)

-   [`TextArea`](text-area.html)

-   [`TextInput`](text-input.html)

-   [`ToggleButton`](toggle-button.html)

-   [`ToggleSwitch`](toggle-switch.html)

-   [`WebView`](web-view.html)

A bit further down, you can find number of articles that go into detail about the Feathers component architecture and how to create [custom components](#custom-components).

## Display Objects

Custom Starling display objects included with Feathers for skinning. These display objects are designed to scale up to any size without distortion.

-   [`Scale3Image`](scale3-image.html)

-   [`Scale9Image`](scale9-image.html)

-   [`TiledImage`](tiled-image.html)

## Layouts

A detailed look at each of the layout algorithms that Feathers provides out-of-the-box.

-   [`AnchorLayout`](anchor-layout.html)

-   [`HorizontalLayout`](horizontal-layout.html)

-   [`VerticalLayout`](vertical-layout.html)

-   [`VerticalSpinnerLayout`](vertical-spinner-layout.html)

-   [`TiledColumnsLayout`](tiled-columns-layout.html)

-   [`TiledRowsLayout`](tiled-rows-layout.html)

### Custom Layouts

If the built-in layouts don't provide what you need, Feathers containers support custom layouts too.

-   [Introduction to custom Feathers layouts](custom-layouts.html)

-   [`ILayoutDisplayObject` and `ILayoutData`](layout-data.html)

-   [Creating virtualized custom Feathers layouts](virtual-custom-layouts.html)

## Skinning and Themes

Some tutorials on how to skin components and how to use Feathers themes.

-   [Introduction to Themes](themes.html)

-   [Skinning Feathers Components](skinning.html)

-   [Extending Themes](extending-themes.html)

-   [Creating Custom Themes](custom-themes.html)

-   [Managing Assets in Feathers Themes](theme-assets.html)

-   [Migrating legacy Feathers 1.x themes to Feathers 2.x](migrating-themes.html)

More skinning resources.

-   [Original Example Theme Design Sources](theme-sources.html)

## Custom Components

Often, applications and games need components that don't come standard in a user interface library. The following articles will help you get started developing custom components on top of Feathers.

-   [Feathers Component Lifecycle](component-lifecycle.html)

-   [The Anatomy of a Feathers Component](component-properties-methods.html)

-   [Feathers Component Validation with draw()](component-validation.html)

### Custom Item Renderers

Item renderers are custom components used by lists to display items from the data provider. They have a few extra considerations to keep in mind.

-   [Introduction to Custom Item Renderers](item-renderers.html)

-   [Custom Item Renderers with `LayoutGroup`](layout-group-item-renderers.html)

-   [Custom Item Renderers with `FeathersControl` and `IListItemRenderer`](feathers-control-item-renderers.html)

## Managing UI interactions

-   [Displaying pop-ups above other content in Feathers](pop-ups.html)

-   [Keyboard focus management](focus.html)

-   [Drag and drop between Feathers components](drag-drop.html)

## Miscellaneous

-   [Building the Feathers SWC from source code](build.html)

-   [Feathers prerelease information](prerelease.html)

-   [API Deprecation Policy](deprecation-policy.html)

-   [API Beta Policy](beta-policy.html)

## Feathers Community

### Contributing to Feathers

Would you like to contribute a bug fix or new feature to Feathers? Please open a [Pull Request](https://help.github.com/articles/using-pull-requests) on the [Feathers Github project](https://github.com/joshtynjala/feathers).

-   [Feathers Coding Conventions for Contributors](coding-conventions.html)

-   [List of Feathers Contributors](contributors.html)

### Extensions and Components

The following community projects are built on Feathers. Feel free to share your components and extensions in the [Feathers forum](http://forum.starling-framework.org/forum/feathers).

-   [List of Feathers Extensions and Components](extensions.html)

## Platform UI Guidelines

Please take a look at the official documentation linked below for the platforms that Feathers supports. Become familiar with the guidelines for each platform, and try to tailor your application's experience to the specific platform that your code is running on at any given moment. Cross-platform user interface libraries like Feathers can be convenient and powerful, but do not forget that you are responsible for meeting the expectations of your users on each platform. One size rarely fits all.

-   [iOS Human Interface Guidelines](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/index.html)

-   [Android Design Guidelines](http://developer.android.com/design/index.html)

-   [Mac OS X Human Interface Guidelines](https://developer.apple.com/library/mac/#documentation/userexperience/Conceptual/AppleHIGuidelines/Intro/Intro.html)

-   [Windows User Experience Interaction Guidelines](http://msdn.microsoft.com/en-us/library/windows/desktop/aa511258.aspx)