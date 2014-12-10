# List of Feathers Features

Feathers is a user interface component library built on the Starling Framework, a GPU-accelerated 2D library for the Adobe Flash Runtimes. Here are just a few of the features that Feathers offers.

## Overview

-   Designed with mobile devices in mind.

    -   Optimized for performance on phones and tablets.

    -   Supports multi-touch input.

    -   Scrolling with optional pages, “throw” physics and elastic, springy edges (and you can select traditional desktop scrollbar and mouse wheel input, if needed).

    -   Easy to scale for different screen dimensions and DPIs.

-   Simple, but powerful, component architecture.

    -   Invalidation. Queues property changes until Starling render phase.

    -   No vague getStyle()/setStyle() look-ups with string keys. Strictly-typed properties for all skins and visual properties.

    -   Factories and interfaces allow you to customize sub-components. For instance, select the type best suited for phone, tablet, or desktop.

    -   Easy to understand for anyone familiar with Adobe Flex or the Flash Pro AS3 components.

-   All components are fully skinnable using Starling display objects.

    -   If no width or height is provided, components will resize themselves automatically based on the provided skin and dimensions of sub-components.

    -   Sub-components may be easily skinned through their parent, nesting infinitely.

    -   Supports “themes” that separate all skinning code from the rest of the application. Example themes are easily extended.

    -   Add one of the example themes with one line of code.

    -   Scale 9, scale 3, and tiled image types provide fluid resizing for skins.

    -   Smart image management that can improve performance by swapping textures without creating new image objects.

-   Plus a lot more.

    -   Choice of text rendering between bitmap fonts or vector fonts drawn to textures.

    -   Create your own custom text renderers (Flash Text Engine or TLF, perhaps?) using a simple interface.

    -   A powerful screen/menu navigation system with transitions.

    -   Drag and drop.

    -   Pop-up management (with or without modality).

## Components

Feathers includes [many different components](start.html#feathers_components), including buttons, sliders, toggle switches, check boxes, radio buttons, lists and grouped lists, progress bars, text inputs, tab bars, navigators, scrolling and layout containers, callouts/popovers, and others. Take a look at a few noteworthy features available for some of these components.

-   Button

    -   Appearance may be customized for each touch/mouse state, including up, hover, down, and disabled.

    -   Optional toggle/selection behavior. Doubles the number of states.

    -   Customizable skins, icons, and label properties for each state, including the ability to specify defaults when some states will not be uniquely skinned.

-   TextInput

    -   Uses the operating system's native input controls for seamless selection and copy/paste behavior.

-   ScrollContainer

    -   Provides scrolling for any kind of content.

    -   Supports a variety of built-in layouts, plus your own custom layouts.

-   List

    -   A scrolling list of items with optional selection.

    -   Swappable, customizable, layout algorithms.

    -   Layout virtualization for improved performance (creates and reuses renderers only for visible data).

    -   Variable item renderer dimensions.

    -   Custom item renderers.

    -   A robust default item renderer with label, icon, and “accessory” views with all the states that buttons provide.

    -   A ListCollection class with data descriptors to support any type of data. Supports Array, Vector, and XMLList out of the box.

-   GroupedList

    -   Everything that List provides, plus more.

    -   Groups or sections with optional headers and footers.

    -   Separate renderer types/factories for headers, footers, and items.

    -   Multi-dimensional HierarchicalCollection with data descriptors.

-   ScreenNavigator

    -   Use events or, optionally, [as3-signals](https://github.com/robertpenner/as3-signals) to trigger navigation between screens (such as game menus).

    -   Pass properties into screens, such as a shared settings object or other assets.

    -   Specify animated transitions for switching screens.

To learn more about Feathers, return to the [Feathers Documentation](start.html).


