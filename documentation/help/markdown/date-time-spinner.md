---
title: How to use the Feathers DateTimeSpinner component  
author: Josh Tynjala

---
# How to use the Feathers `DateTimeSpinner` component

The [`DateTimeSpinner`](../api-reference/feathers/controls/DateTimeSpinner.html) component allows the selection of date and time values using a set of [`SpinnerList`](spinner-list.html) components. It support multiple editing modes to allow users to select only the date, only the time, or both.

<figure>
<img src="images/date-time-spinner.png" srcset="images/date-time-spinner@2x.png 2x" alt="Screenshot of Feathers a DateTimeSpinner component" />
<figcaption>A `DateTimeSpinner` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

## The Basics

First, let's create a `DateTimeSpinner` control, set up its editing mode and its range of values, and add it to the display list.

``` code
var spinner:DateTimeSpinner = new DateTimeSpinner();
spinner.editingMode = DateTimeMode.DATE;
spinner.minimum = new Date(1970, 0, 1);
spinner.maximum = new Date(2050, 11, 31);
spinner.value = new Date(2015, 10, 31);
this.addChild( spinner );
```

The [`value`](../api-reference/feathers/controls/DateTimeSpinner.html#value) property indicates the currently selected date and time, while the [`minimum`](../api-reference/feathers/controls/DateTimeSpinner.html#minimum) and [`maximum`](../api-reference/feathers/controls/DateTimeSpinner.html#maximum) properties establish a range of possible values. You may omit the `minimum` and `maximum` properties, and reasonable defaults will be chosen automatically.

The [`editingMode`](../api-reference/feathers/controls/DateTimeSpinner.html#editingMode) property determines how the date and time are displayed.

* [`DateTimeMode.DATE`](../api-reference/feathers/controls/DateTimeMode.html#DATE) displays only the date, without the time. The month and day are displayed in order based on the current locale.
* [`DateTimeMode.TIME`](../api-reference/feathers/controls/DateTimeMode.html#TIME) displays only the time, without the date. The time is displayed in either 12-hour or 24-hour format based on the current locale.
* [`DateTimeMode.DATE_AND_TIME`](../api-reference/feathers/controls/DateTimeMode.html#DATE_AND_TIME) displays both the date and the time. As with the previous mode, the current locale determines formatting.

Add a listener to the [`Event.CHANGE`](../api-reference/feathers/controls/DateTimeSpinner.html#event:change) event to know when the `value` property changes:

``` code
spinner.addEventListener( Event.CHANGE, spinner_changeHandler );
```

The listener might look something like this:

``` code
function spinner_changeHandler( event:Event ):void
{
    var spinner:DateTimeSpinner = DateTimeSpinner( event.currentTarget );
    trace( "spinner.value changed:", spinner.value );
}
```

## Skinning a `DateTimeSpinner`

The skins for a `DateTimeSpinner` control are divided into multiple [`SpinnerList`](spinner-list.html) components. For full details about what skin and style properties are available, see the [`DateTimeSpinner` API reference](../api-reference/feathers/controls/DateTimeSpinner.html). We'll look at a few of the most common properties below.

### Targeting a `DateTimeSpinner` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( DateTimeSpinner ).defaultStyleFunction = setDateTimeSpinnerStyles;
```

If you want to customize a specific `DateTimeSpinner` to look different than the default, you may use a custom style name to call a different function:

``` code
spinner.styleNameList.add( "custom-date-time-spinner" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( DateTimeSpinner )
    .setFunctionForStyleName( "custom-date-time-spinner", setCustomDateTimeSpinnerStyles );
```

Trying to change the spinner's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the spinner was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the spinner's properties directly.

### Skinning the `SpinnerList` sub-components

This section only explains how to access the `SpinnerList` sub-components. Please read [How to use the Feathers `SpinnerList` component](spinner-list.html) for full details about the skinning properties that are available on `SpinnerList` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`DateTimeSpinner.DEFAULT_CHILD_STYLE_NAME_LIST`](../api-reference/feathers/controls/DateTimeSpinner.html#DEFAULT_CHILD_STYLE_NAME_LIST) style name.

``` code
getStyleProviderForClass( SpinnerList )
    .setFunctionForStyleName( DateTimeSpinner.DEFAULT_CHILD_STYLE_NAME_List, setDateTimeSpinnerListStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
spinner.customListStyleName = "custom-list";
```

You can set the function for the [`customListStyleName`](../api-reference/feathers/controls/DateTimeSpinner.html#customListStyleName) like this:

``` code
getStyleProviderForClass( SpinnerList )
    .setFunctionForStyleName( "custom-list", setDateTimeSpinnerCustomListStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`listFactory`](../api-reference/feathers/controls/DateTimeSpinner.html#listFactory) to provide skins for the list sub-components:

``` code
spinner.listFactory = function():SpinnerList
{
    var list:SpinnerList = new SpinnerList();
    //skin the list here
    list.backgroundSkin = new Image( texture );
    return list;
}
```

## Related Links

-   [`feathers.controls.DateTimeSpinner` API Documentation](../api-reference/feathers/controls/DateTimeSpinner.html)