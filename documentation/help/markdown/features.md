---
title: Features  
author: Josh Tynjala

---
# Feathers Features

Feathers is an open source library of user interface components for [Starling Framework](http://gamua.com/starling/). Let's take a look at some of what Feathers has to offer.

## Overview

-   Dozens of user interface components for apps and games.

-   Hardware-accelerated graphics.

-   Target iOS, Android, Windows and Mac OS X.

-   Built on top of Starling Framework and Adobe AIR.

-   Backed by Adobe and the community.

## Cross Platform

-   Create user interfaces for both desktop and mobile apps.

-   Easy to scale for different screen dimensions and DPIs.

-   Support for fluid layouts that fit to a wide variety of screen sizes.

-   Choose between scrolling with touch physics including elastic, springy edges or traditional desktop scroll bars and the mouse scroll wheel.

-   Support for keyboard focus navigation using the tab key, with the ability to disable focus on individual components or children of specific container. Includes full control over focus order.

## Skinning

-   All components may be skinned using any Starling display object.

-   Strictly-typed properties for all skins and properties that affect visual styling. No vague `getStyle()` or `setStyle()` look-ups with string keys.

-   Scale 9, scale 3, and tiled image types provide fluid resizing for skins.

-   Supports [themes](themes.html) that separate all skinning code from the application logic.

## Robust Architecture

-   Invalidation. Queues property changes until Starling render phase to maximize performance.

-   Easy to understand for anyone familiar with Adobe Flex or the Flash Pro AS3 components.

-   If no width or height is provided, components will resize themselves automatically based on the provided skin and dimensions of sub-components.

-   Factories and interfaces allow you to customize sub-components. For instance, select the type best suited for phone, tablet, or desktop.

-   Choice of [text rendering](text-renderers.html) between bitmap fonts or vector fonts drawn to textures. Vector fonts may be rendered with either `flash.text.TextField` or Flash Text Engine.

## Containers

-   Several built-in layouts, and support for [custom layouts](custom-layouts.html).

-   [`LayoutGroup`](layout-group.html) is a lightweight Feathers container with support for layouts.

-   [`ScrollContainer`](scroll-container.html) supports scrolling and layouts.

-   [`Panel`](panel.html) supports a header and an optional footer, in addition to scrolling and layouts.

-   [`Drawers`](drawers.html) provides slide-out drawers to display menus and other actions.

## Lists

-   The [`List`](list.html) component supports displaying a data provider using item renderers inside a scrollable container.

-   Support for hierarchical data using [`GroupedList`](grouped-list.html).

-   [`PickerList`](picker-list.html) supports displaying a list as a drop-down triggered by a [`Button`](button.html).

-   Several built-in layouts, including [`VerticalLayout`](vertical-layout.html), [`HorizontalLayout`](horizontal-layout.html), and [`TiledRowsLayout`](tiled-rows-layout.html).

-   Support for [custom layouts](custom-layouts.html).

-   Layout virtualization for improved performance (creates and reuses renderers only for visible data).

-   Support for selecting an item, including optional multiple selection.

-   A robust [default item renderer](default-item-renderers.html) with up to three sub-views with full control over how they are positioned relative to each other.

-   Support for [custom item renderers](item-renderers.html).

-   Variable item renderer dimensions.

-   A `ListCollection` class with data descriptors to support any type of data. Includes built-in support for `Array`, `Vector`, and `XMLList`.

-   Optionally split items into multiple pages, and snap to each page when scrolling.

## Menus and Navigation

-   Create menus and navigate between screens using [`StackScreenNavigator`](stack-screen-navigator.html) or [`ScreenNavigator`](screen-navigator.html).

-   Push and pop screens using a history stack that easily supports a back button.

-   [Animate the transition](transitions.html) between screens. Push and pop actions may use separate transitions, and individual screens may optionally be given their own unique transitions.

-   Support for custom transitions.

-   Dispatch events to trigger navigation between screens.
    
-   Inject properties into screens to quickly configure them.

## More!

-   Buttons, sliders, radio buttons, check boxes, toggle switches, steppers, text inputs, tabs, and tons of other common UI controls.

-   A manager for drag and drop.

-   Add pop-ups above all other content in the app. Includes support for modal pop-ups that display an overlay between the pop-up and everything under it.

## Sound useful?

[Download Feathers](http://feathersui.com/download/), and [get started](getting-started.html) building cross-platform, hardware-accelerated user interfaces for apps and games with Starling Framework and Feathers.