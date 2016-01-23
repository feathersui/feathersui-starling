---
title: Migrating legacy themes to Feathers 2.0  
author: Josh Tynjala

---
# Migrating legacy themes to Feathers 2.0

Feathers 2.0 includes a [new skinning architecture](skinning.html). The [`DisplayListWatcher`](../api-reference/feathers/core/DisplayListWatcher.html) class that legacy themes extended still exists, and you can continue using it for the foreseeable future. However, if you're ready to modernize your theme to take advantage of the new style provider system, you will need to make a number of fundamental changes to your themes.

## Extend a new class: `StyleNameFunctionTheme`

A legacy theme will extend the [`feathers.core.DisplayListWatcher`](../api-reference/feathers/core/DisplayListWatcher.html) class.

``` code
// legacy
public class CustomTheme extends DisplayListWatcher
```

To create a modern theme, extend [`feathers.themes.StyleNameFunctionTheme`](../api-reference/feathers/themes/StyleNameFunctionTheme.html) instead.

``` code
// modern
public class CustomTheme extends StyleNameFunctionTheme
```

After this change, if you try to compile, you will probably see a number of errors. We need to make a few more changes, but they're pretty straightforward.

## Replace calls to `setInitializerForClass()`

The modern [`StyleNameFunctionTheme`](../api-reference/feathers/themes/StyleNameFunctionTheme.html) still calls functions that set properties on components, similar to legacy themes. You can still use strings (called style names) to differentiate between components of the same type that need to have different appearances. The API has changed a bit for setting these functions, though.

When using a legacy theme, you might call [`setInitializerForClass()`](../api-reference/feathers/core/DisplayListWatcher.html#setInitializerForClass()) and pass in a class and a function. You could optionally pass in a style name as the optional third argument, to specify function for alternate styles:

``` code
// legacy
this.setInitializerForClass( Button, setButtonStyles );
this.setInitializerForClass( Button, setCustomButtonStyles, "my-custom-button" );
```

In a modern theme, you first ask for then global style provider for a specific class. Then, you can either set its default style function or set a function for a specific style name:

``` code
// modern
this.getStyleProviderForClass(Button).defaultStyleFunction = setButtonStyles;
this.getStyleProviderForClass(Button).setFunctionForStyleName( "my-custom-button", setCustomButtonStyles );
```

### The quick-and-dirty way

Replacing every call to `setInitializerForClass()` can be time consuming and tedious. If you need to migrate faster, and you want to worry about cleaning things up later, you can copy the following function into your theme class:

``` code
public function setInitializerForClass(type:Class, styleFunction:Function, styleName:String = null):void
{
    var styleProvider:StyleNameFunctionStyleProvider = this.getStyleProviderForClass(type);
    if(styleName)
    {
        styleProvider.setFunctionForStyleName(styleName, styleFunction);
    }
    else
    {
        styleProvider.defaultStyleFunction = styleFunction;
    }
}
```

As you can see, it implements `setInitializerForClass()` with the same function signature, but it uses style providers under the hood.

## Replace calls to `setInitializerForClassAndSubclasses()`

There is no direct replacement for this function. It mainly existed to work around limitations in the legacy architecture where a subclass wouldnt be automatically skinned like its superclass. A modern theme will treat subclasses the same as their superclasses (unless a component chooses to opt out), so this function is no longer necessary for its original purpose.

Here's an example of calling [`setInitializerForClassAndSubclasses()`](../api-reference/feathers/core/DisplayListWatcher.html#setInitializerForClassAndSubclasses()) in a legacy theme:

``` code
// legacy
this.setInitializerForClassAndSubclasses( Scroller, setScrollerStyles );
```

You should switch to calling that function directly when you style the subclasses. For instance, if you have a function that sets common styles on the `Scroller` class, you would call that function in a function that sets specific styles on the `List` class.

``` code
// modern
protected function setListStyles( list:List ):void
{
    this.setScrollerStyles( list );
 
    // set other styles here
}
```

When an instance of the `List` class (or any of its subclasses) needs to be styled, `setScrollerStyles()` will be called too.

## Replace calls to `exclude()`

In a legacy theme, you could exclude a component from being skinned by passing it to the [`exclude()`](../api-reference/feathers/core/DisplayListWatcher.html#exclude()) function defined by `DisplayListWatcher`.

``` code
// legacy
theme.exclude( button );
```

In a modern theme, you can remove a component's style provider:

``` code
// modern
button.styleProvider = null;
```

Make sure you do that before the component initializes. That's when the theme is asked to style the component. By default, a component will initialize when it is added to the stage.

## Replace "name" with "style name"

In order to fix some issues developers had using [`getChildByName()`](http://doc.starling-framework.org/core/starling/display/DisplayObjectContainer.html#getChildByName()), Feathers no longer uses the [`name`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#name) and `nameList` properties to indicate to the theme that it should give a component an alternate visual appearance.

In a legacy theme, you might add a string to the `nameList` property (or set the `name` property directly):

``` code
// legacy
button.nameList.add( "my-custom-button" );
// or
button.name = "my-custom-button";
```

In a modern theme, you should use the [`styleNameList`](../api-reference/feathers/core/FeathersControl.html#styleNameList) or [`styleName`](../api-reference/feathers/core/FeathersControl.html#styleName) properties instead:

``` code
// modern
button.styleNameList.add( "my-custom-button" );
// or
button.styleName = "my-custom-button";
```

The `nameList` property still exists in Feathers 2.0 and 2.1, but it is completely removed in Feathers 2.2 and newer. In the versions where it still exists, it simply maps to the `styleNameList` property so that legacy code will continue to work.

The [`name`](http://doc.starling-framework.org/core/starling/display/DisplayObject.html#name) property is no longer used for styling Feathers components at all. It does not map to the `styleName` property the way that `nameList` maps to the `styleNameList` property. This change makes a strict distinction between `name` and `styleName` in order to fix issues using `getChildByName()` with Feathers components.

Constants for alternate style names have also been renamed. For example, constants like `Button.ALTERNATE_NAME_DANGER` that contain `NAME` have been renamed with `STYLE_NAME` instead. To reference the alternate style name for a "danger" button, use the new constant `Button.ALTERNATE_STYLE_NAME_DANGER` instead.

Similarly, constants like `Slider.DEFAULT_CHILD_NAME_THUMB` switched from `NAME` to `STYLE_NAME`. To reference the default style name of the slider's thumb, use `Slider.DEFAULT_CHILD_STYLE_NAME_THUMB` instead.

Finally, properties like `customThumbName` on the slider component switch from `Name` to `StyleName`. To set a custom style name for a slider's thumb, use the `customThumbStyleName` property instead.

## Related Links

-   [Skinning Feathers components](skinning.html)

-   [Introduction to Feathers themes](themes.html)

-   [Extending Feathers example themes](extending-themes.html)

-   [Custom Feathers themes](extending-themes.html)