---
title: Anatomy of a Feathers user interface component  
author: Josh Tynjala

---
# Anatomy of a Feathers user interface component

The following properties and methods are core parts of `FeathersControl` and all component developers should be intimately familiar with them. Please be sure to read [Feathers Component Lifecycle](component-lifecycle.html) for additional, related information.

## The Constructor

Any code appearing within the **constructor** should be kept to a minimum. In general, most initialization code should appear within `initialize()` instead.

## initialize()

The `initialize()` method is called the first time that the component is added to the display list. It will only be called once in the component's lifetime. You may override this method to create children and handle other tasks that should be run when the component is first initialized.

## invalidate()

The `invalidate()` method should be called to tell the component that a property has changed and that it needs to redraw itself. Typically, this method is called within a setter function. It takes one or more flags as arguments to inform the component what has changed. The component may use these flags to focus on redrawing only a subset of itself if some parts are able to remain the same.

## draw()

The `draw()` method is called immediately before the component is rendered by Starling. You should override it to commit property changes, calculate an ideal size, and layout children.

Please read [Component Validation with draw()](component-validation.html) for more detailed information about the `draw()` method.

## isInvalid()

The `isInvalid()` method is used to determine if a specific flag has been set with `invalidate()`. Call this in `draw()` to determine which parts of the component need to be redrawn. If you call it with no arguments, the result will be `true` if `invalidate()` has been called regardless of which flags have been passed in.

## saveMeasurements()

The `saveMeasurements()` method is called to set a component's dimensions during validation, if the `width` and `height` properties have not been set manually. In this case, the component needs to automatically measure its own ideal dimensions, possibly based on the dimensions of skins or sub-components and properties like padding and gap.

See below for more detailed information on the various properties for a component's dimensions.

## isQuickHitAreaEnabled

The `isQuickHitAreaEnabled` property is similar to `mouseChildren` from the classic display list. However, it takes things a step further and limits the component's hit area to a simple rectangle, which can greatly improve performance of touch hit tests. The rectangular hit area is automatically calculated based on the component's `actualWidth` and `actualHeight` member variables (see below). This is most useful in buttons, but any component where the children don't need to receive touch events can benefit from this optimization.

## styleName and styleNameList

A component's `styleNameList` is used by [Feathers themes](themes.html) to provide separate skins to different types of the same component. It is most often used by components that have child components that need to be skinned, such as a `Slider` has track and a thumb sub-components that are buttons.

For more information about component style names, please read [Introduction to Feathers Themes](themes.html).

## Variables and properties for width and height

The `FeathersControl` class provides a number of useful variables and properties for its dimensions. Fully understanding what each one is used for and when they should be changed or accessed is important for maximizing the performance of custom Feathers components and getting the most out of the framework's architecture.

The `width` and `height` getters and setters expose the component's dimensions externally. The values returned by the getters are determined based on a number of factors. They may be explicit dimensions passed to the setters or they may be ideal dimensions calculated automatically during validation (because no explicit dimensions were specified).

The `explicitWidth` and `explicitHeight` variables are changed if the `width` and `height` setters are called with numeric values. In the following example, a `Button` control is created, and its `width` property is set to `150` pixels. Internally, the button will store this value in the `explicitWidth` variable.

``` code
var button:Button = new Button();
button.width = 150;
```

The `actualWidth` and `actualHeight` variables are the values used for layout. The "actual" dimensions typically default to the values of `explicitWidth` and `explicitHeight`, but if explicit dimensions are not specified, the component must calculate ideal dimensions. The ideal dimensions could be hard-coded values or they could be determined based on the dimensions of skins or sub-components, and other values like padding and gap. Most components calculate their ideal dimensions differently, but the result should always be passed to the `saveMeasurements()` method.

Minimum dimensions work similarly, with `minWidth` and `minHeight` properties exposed publicly, and `explicitMinWidth`, `explicitMinHeight`, `actualMinWidth`, and `actualMinHeight` variables used internally.

## Related Links

-   [Feathers Component Lifecycle](component-lifecycle.html)

-   [Feathers Component Validation with `draw()`](component-validation.html)