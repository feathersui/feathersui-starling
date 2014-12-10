# Extending Feathers 2.0 themes

Using one of the example [themes](themes.html) included with Feathers, we can quickly style every Feathers component in our apps with a set of pre-made skins. This is a great way to get started with a new game, or an app with heavy branding, when we plan to integrate the final, custom design later. The example themes can even be useful for skinning productivity apps and things that don't require custom-designed branding and skins.

Whatever our needs, eventually, we may want to make some styling tweaks or to provide some alternative skins for a subset of components in our app. The examples themes are designed with extensibility in mind. Let's learn to modify the themes to use our custom skins.

This tutorial covers the new theme architecture in Feathers 2.0. If you are using Feathers 1.3.1 or below, you should read [Extending legacy Feathers 1.x themes](http://wiki.starling-framework.org/feathers/extending-themes-v1) instead.

If you haven't read [Skinning Feathers components](skinning.html) yet, start there first to learn about how do basic skinning without themes. You'll get an introduction to style providers, which are the foundation of a theme's architecture.

## Adding an alternate style function

Let's say that we're using `MetalWorksMobileTheme` in our app. Most of the skins meet our design requirements, but we need to create a special button in our app with a slightly different style.

In this tutorial, we extend `MetalWorksMobileTheme`, one of the example themes included with Feathers. You will find a compiled SWC for this theme, and the full source code, inside the Feathers ZIP file in the *themes* directory.

To get started, we'll subclass the `MetalWorksMobileTheme` class:

``` code
package com.example
{
    import feathers.themes.MetalWorksMobileTheme;
 
    public class CustomTheme extends MetalWorksMobileTheme
    {
        public function CustomTheme()
        {
            super();
        }
    }
}
```

Where we instantiate `MetalWorksMobileTheme` when our app first starts up, we must change it to instantiate our new subclass instead:

``` code
new CustomTheme();
```

Next, let's add a function that will provide different skins for our special button. Inside the `CustomTheme` class, add the following `setCustomButtonStyles()` function:

``` code
protected function setCustomButtonStyles( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xff0000 );
    button.downSkin = new Quad( 200, 60, 0x000000 );
    button.labelFactory = function():ITextRenderer
    {
        return new TextFieldTextRenderer();
    };
    button.defaultLabelProperties.textFormat = new TextFormat( "_sans", 36, 0xffffff );
}
```

Now, we need to tell the theme how to use this function. The superclass defines a method named `initializeStyleProviders()` where all of the global style providers are registered with Feathers.

Every example theme included with Feathers uses this same architecture. Themes provided by third-parties may work a bit differently, so you should refer to the third-party documentation for complete details.

We want to override the `initializeStyleProviders()` function so that we can tell the `Button` global style provider about our `setCustomButtonStyles()` function:

``` code
override protected function initializeStyleProviders():void
{
    super.initializeStyleProviders(); // don't forget this!
 
    this.getStyleProviderForClass(Button)
        .setFunctionForStyleName( "custom-button", this.setCustomButtonStyles );
}
```

We call the `getStyleProviderForClass()` function to access the global style provider for the `Button` class. If a global style provider hasn't been registered yet, one will be created automatically.

Because `MetalWorksMobileTheme` is a subclass of `StyleNameFunctionTheme`, the style provider returned by `getStyleProviderForClass()` is a `StyleNameFunctionStyleProvider`. We learned about this type of style provider in [Skinning Feathers components](skinning.html). It allows us to specify combinations of style names and functions to provide multiple skins for the same type of component.

We call `setFunctionForStyleName()` and pass in a “custom-button” style name (you can use any string that you want, as long as it is unique to your app) and a reference to our `setCustomButtonStyles()` function that we defined earlier.

That's all we need to add to the theme. Next, let's make a little tweak to the code that creates our special button:

``` code
var specialButton:Button = new Button();
specialButton.label = "Special!";
specialButton.styleNameList.add( "custom-button" );
this.addChild( specialButton );
```

We add the “custom-button” string to the button's `styleNameList`, and now the button will be skinned using our `setCustomButtonStyles()` function instead of the default function defined by `MetalWorksMobileTheme`.

## Adding custom components to a theme

By default, a custom component will inherit the default style provider from its super class. If you create a `CustomButton` class that extends `Button`, the subclass will automatically default to using `Button.globalStyleProvider`. If you want your component to simply use the same skins as its superclass, you don't need to do anything. It will happen automatically.

However, if you want the subclass to use a different default style provider than its superclass, then you need to add a couple of properties to your component's class. First, it needs a static global style provider:

``` code
public class CustomComponent extends FeathersControl
{
    public static var globalStyleProvider:IStyleProvider;
}
```

Second, it needs to override the non-static `defaultStyleProvider` getter:

``` code
override protected function get defaultStyleProvider():IStyleProvider
{
    return CustomComponent.globalStyleProvider;
}
```

For the vast majority of components, the `defaultStyleProvider` getter should simply return the static global style provider.

However, the default style provider can certainly be customized. For instance, the `ToggleButton` component will return `Button.globalStyleProvider` if `ToggleButton.globalStyleProvider` is `null`:

``` code
override protected function get defaultStyleProvider():IStyleProvider
{
    if( ToggleButton.globalStyleProvider )
    {
        return ToggleButton.globalStyleProvider;
    }
    return Button.globalStyleProvider;
}
```

Similarly, your custom component could also provide a fallback default style provider from the superclass.

To add the custom component to the theme, override the `initializeStyleProviders()` function, just like in the previous example:

``` code
override protected function initializeStyleProviders():void
{
    super.initializeStyleProviders(); // don't forget this!
 
    this.getStyleProviderForClass(CustomComponent).defaultStyleFunction = 
        this.setCustomComponentStyles;
}
```

You can set the `defaultStyleFunction` on the `StyleNameFunctionStyleProvider`. If you have alternate styles for the custom component, you can also call `setFunctionForStyleName()`, just like you can with any other component.

## Related Links

-   [Skinning Feathers components](skinning.html)

-   [Introduction to Feathers Themes](themes.html)

For more tutorials, return to the [Feathers Documentation](index.html).


