# Extending Legacy Feathers 1.x Themes

Sometimes, you want to use an existing Feathers [theme](themes.html), but you want certain components to look different than the default style. Sometimes, you can just modify the component's properties directly, but often, you will need to extend the theme and apply different skins and styles through the theme architecture.

The tutorial explains the theme architecture in Feathers 1.3.1 and below. For newer versions of Feathers, see [Extending Feathers 2.0 Themes](extending-themes.html). For information about upgrading themes to use the new architecture, see [Migrating legacy themes to Feathers 2.0](migrating-themes.html).

## Names

In [Introduction to Feathers themes](themes.html), you learned about *alternate style names*. When you extend a theme to style certain components differently than the default, you will be creating your own custom alternate skin names.

To add a name to a component, you use the [nameList](http://feathersui.com/documentation/feathers/core/FeathersControl.html#nameList) property.

``` code
var button:Button = new Button();
button.nameList.add( "my-custom-button" );
this.addChild( button );
```

In the code above, we've added the `“my-custom-button”` name to the button. We can now use this name when we create our extended theme. As you can see, it is just a string. The only restriction is that names cannot contain spaces.

Names only work when added to a component *before* it is added to the stage for the first time. You **cannot** change names later to give a component a different skin.

## Quick and Dirty

If you're providing your own textures and other assets, and you don't need any of the existing textures from the theme, you can simply instantiate the theme normally, and call the `setInitializerForClass()` function to pass in a function that will apply your component's skin. Let's use the button name we created above to do exactly that:

``` code
var theme:MetalWorksMobileTheme = new MetalWorksMobileTheme();
theme.setInitializerForClass( Button, myCustomButtonInitializer, "my-custom-button" );
```

Then, the initializer might look something like this:

``` code
private function myCustomButtonInitializer( button:Button ):void
{
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    button.hoverSkin = new Image( hoverTexture );
 
    button.defaultLabelProperties.elementFormat = new ElementFormat(
        new FontDescription( "fontName" ), 18, 0xffffff );
}
```

That's the most basic way to extend a theme. It's best for simple changes that don't rely on the textures and other assets that the theme already uses. Let's look at a more formal example next.

## Using a Subclass

In general, to extend a theme, it's best to create a subclass of it. This way, you can access its textures, fonts, and other `protected` variables and functions. Often, you may want to change one or the other of a component's background skins or fonts, but leave the other the same as the rest of the theme.

Let's start by creating the subclass:

``` code
package com.example.themes
{
    import feathers.themes.MetalWorksMobileTheme;
    import starling.display.DisplayObjectContainer;
 
 
    public class ExtendedMetalWorksTheme extends MetalWorksMobileTheme
    {
        public function ExtendedMetalWorksTheme( root:DisplayObjectContainer, scaleToDPI:Boolean = true )
        {
            super( root, scaleToDPI );
        }
 
        override protected function initialize():void
        {
            super.initialize();
 
            // set new initializers here
        }
    }
}
```

Next, let's make our custom name into a static constant so that we can get proper compile time checking:

``` code
public static const ALTERNATE_NAME_MY_CUSTOM_BUTTON:String = "my-custom-button";
```

Then, we can add it to our button's `nameList` like this instead:

``` code
button.nameList.add( ExtendedMetalWorksTheme.ALTERNATE_NAME_MY_CUSTOM_BUTTON );
```

Any other button in your app can use the same name too. That's the beauty of using the theming architecture.

Inside the `initialize()` function of the theme, we can add our initializer function:

``` code
override protected function initialize():void
{
    super.initialize();
 
    this.setInitializerForClass( Button, myCustomButtonInitializer, ALTERNATE_NAME_MY_CUSTOM_BUTTON );
}
```

Then, we add the initializer to our theme class too:

``` code
private function myCustomButtonInitializer( button:Button ):void
{
    button.defaultSkin = new Image( upTexture );
    button.downSkin = new Image( downTexture );
    button.hoverSkin = new Image( hoverTexture );
 
    button.defaultLabelProperties.elementFormat = this.darkUIElementFormat;
    button.disabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
    button.selectedDisabledLabelProperties.elementFormat = this.darkUIDisabledElementFormat;
}
```

Notice that custom skin textures are still used like above, but I used some text formats defined in the super class to match the rest of the theme.

## Related Links

-   [Extending Feathers 2.0 themes](extending-themes.html)

-   [Migrating legacy themes to Feathers 2.0](migrating-themes.html)

For more tutorials, return to the [Feathers Documentation](start.html).


