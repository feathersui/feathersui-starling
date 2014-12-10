# Anatomy of a Feathers Component

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

## setSizeInternal()

The `setSizeInternal()` method is called to specify ideal dimensions. It chooses between explicit and ideal dimensions to calculate the final “actual” dimensions used for layout.

The final argument determines if the component should invalidate after adjusting the dimensions. If you call it during validation (during `draw()`, basically), then you should probably pass `false`. Otherwise, the component will end up redrawing itself every render cycle, which you probably don't want.

See below for more detailed information on component dimensions.

## isQuickHitAreaEnabled

The `isQuickHitAreaEnabled` property is similar to `mouseChildren` from the classic display list. However, it takes things a step further and limits the component's hit area to a simple rectangle, which can greatly improve performance of touch hit tests. The rectangular hit area is automatically calculated based on the component's “actual” width and height dimensions (see below). This is most useful in buttons, but any component where the children don't need to receive touch events can benefit from it.

## styleName and styleNameList

A component's `styleNameList` is used by [Feathers themes](themes.html) to provide separate skins to different types of the same component. It is most often used by components that have child components that need to be skinned, such as a `Slider` has track and a thumb sub-components that are buttons.

For more information about component style names, please read [Introduction to Feathers Themes](themes.html).

## width and height

`FeathersControl` provides a number of useful width and height values. Understanding the differences among them is important for maximizing performance and getting the most out Feathers' capabilities.

The `width` and `height` getters and setters expose the component's dimensions externally. The values returned by the getters are determined based on a number of factors. They may be explicit dimensions passed to the setters or they may be ideal dimensions calculated automatically because no explicit dimensions were specified.

The `explicitWidth` and `explicitHeight` variables are changed if the `width` and `height` setters are called with numeric values. In the following example, a `Button` control is created, and its `width` property is set to `150` pixels. Internally, the button will store this value in the `explicitWidth` variable.

``` code
var button:Button = new Button();
button.width = 150;
```

The `actualWidth` and `actualHeight` variables are the values returned by the `width` and `height` getters. These values should also be used when drawing the component. The “actual” dimensions typically default to the values of `explicitWidth` and `explicitHeight`, but if explicit dimensions are not specified, the component may try to calculate ideal dimensions. These could be hard-coded pixel values or they could be determined based on the dimensions of skins or other children (such as sub-components). How the ideal dimensions are calculated is often different from component to component.

A custom component should pass its ideal calculated dimensions to the `setSizeInternal()` method before the layout phase. This method will determine if the dimensions were already set explicitly. If so, the ideal values will be ignored, and the `actualWidth` and `actualHeight` variables will be set to the explicit dimensions. If not, they will be set to the ideal dimensions instead.

If explicit dimensions have been set, and you want to use the component's ideal dimensions instead, pass `NaN` to the `width` and `height` setters.

The `minWidth` and `minHeight` properties are used by `setSizeInternal()` to adjust the ideal dimensions to a minimum value. `minWidth` and `minHeight` do \_not\_ affect explicit dimensions in any way.

## Related Links

-   [Feathers Component Lifecycle](component-lifecycle.html)

-   [Feathers Component Validation with draw()](component-validation.html)

For more tutorials, return to the [Feathers Documentation](index.html).


