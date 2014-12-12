---
title: Skinning Feathers components  
author: Josh Tynjala

---
# Skinning Feathers components

All core Feathers components are designed with custom skinning in mind. Many components include properties to set background skins for different states, different layout options, and a variety of font styling capabilities.

For practical reasons, Feathers components [don't have default skins](faq/default-skins.html). Developers should generally create their own skins. However, a number of example [themes](themes.html) are included with Feathers that provide pre-created skins in a number of different styles. These themes may be [extended to provide custom skins](extending-themes.html), if needed.

## Basic skinning

All skins and styles available on Feathers components are exposed as public properties. Styling a component is as simple as passing values to the appropriate setters.

If you're using an example theme, you will also want to read [Extending Feathers Themes](extending-themes.html) to see how skins should be customized when using themes.

Let's look at a simple example of skinning a `Button` component:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.defaultSkin = new Quad( 200, 60, 0xcccccc );
button.downSkin = new Quad( 200, 60, 0x999999 );
this.addChild( button );
```

In the code above, we set the `defaultSkin` and `downSkin` properties to provide the button with background skins. In the button's up state, we see the `defaultSkin`, and when we press the button, we see the `downSkin`. The `Button` class has many more properties for styling things like the label's font, but let's keep things simple right now. For more details about styling buttons, take a look at [How to use the Feathers Button component](button.html).

## Skinning multiple components of the same type

If you want more than one button to use the same skins, you might be looking for a way to avoid copy and pasting the same code over and over again. Feathers components support something called a *style provider* that is designed to set a component's skins after it initializes.

Let's create one of the simplest style providers, called `FunctionStyleProvider`:

``` code
function skinButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xcccccc );
    button.downSkin = new Quad( 200, 60, 0x999999 );
}
 
var customButtonStyles:FunctionStyleProvider = new FunctionStyleProvider( skinButton );
```

As you can see, we've created a function that we can call when we want to skin the component. The function takes one argument, a reference to the component that we want to skin. You can see that we set the same `defaultSkin` and `downSkin` properties as in the previous example. Simply pass the function to the `FunctionStyleProvider` constructor.

Telling a component to use a style provider is as simple as passing it to the `styleProvider` property:

``` code
var button1:Button = new Button();
button1.label = "Cancel";
button1.styleProvider = customButtonStyles;
this.addChild( button1 );
 
var button2:Button = new Button();
button2.label = "Delete";
button2.styleProvider = customButtonStyles;
button2.y = 100;
this.addChild( button2 );
```

Now, we have two buttons, and they'll both use the same skins.

## Automatically skinning all components of the same type

In the previous example, we created the `FunctionStyleProvider` as a local variable and simply set the `styleProvider` property on our two buttons. That will work well if you only create buttons in that one single function. However, apps usually consist of many functions across multiple classes, and buttons may be created in many different places. We want to be able to easily reuse a style provider anywhere in our app. To do this, we need to set a *global style provider*.

Each component class (such as `Button`, `Slider`, or `List`) provides a static `globalStyleProvider` property. In the following example, we'll set the global style provider for all buttons:

``` code
function skinButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xcccccc );
    button.downSkin = new Quad( 200, 60, 0x999999 );
}
 
Button.globalStyleProvider = new FunctionStyleProvider( skinButton );
```

As you can see, we created the `FunctionStyleProvider` the same way we did it in the previous example. The main difference is that we passed it to the static `Button.globalStyleProvider` property.

Now, when we create our buttons, we don't need to set the `styleProvider` property at all:

``` code
var button1:Button = new Button();
button1.label = "Cancel";
this.addChild( button1 );
 
var button2:Button = new Button();
button2.label = "Delete";
button2.y = 100;
this.addChild( button2 );
```

When a `Button` is created, Feathers automatically sets its `styleProvider` property to the value of `Button.globalStyleProvider` in the constructor:

``` code
trace( button1.styleProvider == Button.globalStyleProvider ); //true
```

### Ignoring the global styles for an individual component

Let's say that we're creating a `Button`, but we don't want it to use one the global style provider. The easiest way to replace the default skins with our own skins is to start from scratch by clearing the button's `styleProvider` property:

``` code
var button1:Button = new Button();
button1.label = "Click Me";
 
//don't use the default style provider
button1.styleProvider = null;
 
//now, we can set our own custom skins
button1.defaultSkin = new Quad( 200, 60, 0xff0000 );
button1.downSkin = new Quad( 200, 60, 0x000000 );
button.labelFactory = function():ITextRenderer
{
    return new TextFieldTextRenderer();
};
button1.defaultLabelProperties.textFormat = new TextFormat( "_sans", 36, 0xffffff );
 
this.addChild( button1 );
```

Now that the button doesn't have a style provider, our custom skins cannot be replaced when the button initializes.

Alternatively, instead of setting the `styleProvider` property to `null`, you could pass in a different style provider, like a `FunctionStyleProvider`.

### Minor changes to the global styles for an individual component

If we're generally happy with the styles provided by the global style provider, but we want to make some minor tweaks for one instance of a component, we can wrap the existing style provider with an `AddOnFunctionStyleProvider`. This style provider allows to us call an extra function after the original style provider has applied its styles.

Let's use an `AddOnFunctionStyleProvider` to add an icon to a `Button` component:

``` code
function setExtraStyles( button ):void
{
    button.iconPosition = Button.ICON_POSITION_TOP;
    button.defaultIcon = new Image( texture );
}
 
var button1:Button = new Button();
button1.label = "Click Me";
button1.styleProvider = new AddOnFunctionStyleProvider( button1.styleProvider, setExtraStyles );
this.addChild( button1 );
```

In the example above, the button will be styled first by the *global style provider*, which we passed to the `AddOnFunctionStyleProvider`. Afterwards, the `AddOnFunctionStyleProvider` will call the `setExtraStyles()` function to pass in the icon and set the icon's position.

## Multiple global styles for the same type of component

What if we want several buttons to look different from the default? Obviously, we could pass different style providers to each component:

``` code
function skinNormalButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xcccccc );
    button.downSkin = new Quad( 200, 60, 0x999999 );
}
function skinWarningButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xff0000 );
    button.downSkin = new Quad( 200, 60, 0xcc0000 );
}
 
var button1:Button = new Button();
button1.label = "Cancel";
button1.styleProvider = new FunctionStyleProvider( skinNormalButton );
this.addChild( button1 );
 
var button2:Button = new Button();
button2.label = "Delete";
button2.styleProvider = new FunctionStyleProvider( skinWarningButton );
button2.y = 100;
this.addChild( button2 );
```

However, just like before, it would be better if we could use `Button.globalStyleProvider` so that we don't need to set the `styleProvider` property on every `Button` instance. Thankfully, `FunctionStyleProvider` isn't the only style provider available. There's another one called `StyleNameFunctionStyleProvider` that allows us to define multiple functions.

``` code
function skinNormalButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xcccccc );
    button.downSkin = new Quad( 200, 60, 0x999999 );
}
function skinWarningButton( button:Button ):void
{
    button.defaultSkin = new Quad( 200, 60, 0xff0000 );
    button.downSkin = new Quad( 200, 60, 0xcc0000 );
}
 
var buttonStyleProvider:StyleNameFunctionStyleProvider = new StyleNameFunctionStyleProvider();
buttonStyleProvider.defaultStyleFunction = skinNormalButton;
buttonStyleProvider.setFunctionForStyleName( "warning-button", skinWarningButton );
Button.globalStyleProvider = buttonStyleProvider;
```

As you can see, the default function to skin a `Button` will still be the same `skinNormalButton()` function. However, we've called `setFunctionForStyleName()` to pass in our `skinWarningButton()` function, and we associated this function with the "warning-button" *style name*.

A style name is a string that allows us to differentiate different types of the same component. We can add a style name to any component with the `styleNameList` property:

``` code
var button1:Button = new Button();
button1.label = "Cancel";
this.addChild( button1 );
 
var button2:Button = new Button();
button2.label = "Delete";
button2.styleNameList.add( "warning-button" );
button2.y = 100;
this.addChild( button2 );
```

In the example above, we added the "warning-button" style name to the `styleNameList` of the second button. The `StyleNameFunctionStyleProvider` will use this value to determine that it needs to call `setWarningButtonStyles()` instead of `setNormalButtonStyles()` when it skins the second button.

Tip: To avoid making simple mistakes that the compiler can easily catch for you, it's usually a good idea to define custom style names as constants.

## Themes and style providers

Style providers are the basic building blocks of *[themes](themes.html)*, which allow you combine all of your global styling code into one class. Typically, a theme is instantiated when your app first starts up.

The example themes included with Feathers define functions for skinning components, exactly like those that we worked with in the code examples above. The example themes create a `StyleNameFunctionStyleProvider` for each component class, and these are used as global style providers. Some functions are passed into the `defaultStyleFunction` property of the `StyleNameFunctionStyleProvider` to provide default styles when a component doesn't have any style names. Other functions get passed to the `setFunctionForStyleName()` method to be associated with style names.

For more information about how themes use style providers, see [Extending Feathers 2.0 themes](extending-themes.html).

## Glossary

-   A *style provider* provides skins to a component after the component initializes.

-   Using a *global style provider*, we can define a default style provider for all components of the same type. Before a component initializes, we can easily replace the default global style provider with a different one, if needed.

-   By setting a *style name* on a component, we can inform style providers to provide alternate skinning behavior for individual components.

-   A *theme* allows us to put all of our global styling code in one location — often, in just a single class that may be instantiated on app startup.

## Related Links

-   [Introduction to Feathers Themes](themes.html)

-   [Extending Feathers 2.0 Themes](extending-themes.html)

For more tutorials, return to the [Feathers Documentation](index.html).


