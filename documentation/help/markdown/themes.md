---
title: Introduction to Feathers themes  
author: Josh Tynjala

---
# Introduction to Feathers themes

A Feathers *theme* is class that packages up the styling code for multiple UI components in one location. Style providers are registered globally, and when any Feathers component is initialized, it will be styled automatically. It's easy to drop a theme into your new Feathers app, and have it skin every component in the same style. If you need a custom skin for any individual component (even one that looks wildly different than the default), you can easily exclude the component from the theme completely. If you like the default styles, but you want to make some tweaks, Feathers can do that too!

<picture><img src="images/themes.jpg" srcset="images/themes@2x.png 2x" alt="Screenshot of multiple Feathers themes side-by-side" /></picture>

Themes are not required, of course. You can skin any Feathers component manually by setting its style properties directly, if you prefer. However, the main advantage of a theme is to keep your styling code from getting mixed up with things like the business logic of your productivity app or the gameplay mechanics of a your hot new shoot-em-up. Themes help you to reduce clutter by organizing your code. Plus, pre-made themes are a great way to get started if you want to focus on your app's functionality before you start worrying about the appearance of components. You may even be able to swap themes with little impact on the rest of your project, if you decide to stick with pre-made themes for an app that doesn't need its own custom design.

A number of sample themes are available in the `themes` directory included with Feathers. Just grab the compiled SWC file for the theme you'd like to use, and drop it into your project. Instantiate the theme when your app first starts up by adding only a single line of code. Any component that you add to the app will be skinned automatically. We'll see a simple example in a moment.

## Initialize a Theme

In the following example, we'll use the example `MetalWorksMobileTheme` included in the *themes* directory that comes with the Feathers UI library.

In our project's root Starling display object, let's instantiate the theme right away in the constructor.

``` actionscript
import starling.display.Sprite;
import feathers.themes.MetalWorksMobileTheme;

public class Main extends Sprite
{
	public function Main()
	{
		new MetalWorksMobileTheme();
		super();
	}
}
```

<aside class="info">By creating the theme before the `super()` call, the theme can skin the root component too, if needed.</aside>

To test it out, let's create a button. First, listen for `Event.ADDED_TO_STAGE`:

``` actionscript
public function Main()
{
	new MetalWorksMobileTheme();
	super();
	this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
}

private function addedToStageHandler(event:Event):void
{

}
```

Inside the listener function, create the button:

``` actionscript
var button:Button = new Button();
button.label = "Click Me";
button.x = 200;
button.y = 150;
this.addChild( button );
```

That's it! When we pass the button to `addChild()`, the theme will detect the button and give it some skins. Any other components that we add to the display list after this will be skinned too.

Most of the example projects included with the Feathers library use themes. Take a look in the *examples* directory to see the source code for these projects, and learn how they initialize their themes in the context of a larger app. Check out the *themes* directory for several different example themes, for both mobile and desktop.

## Customize a specific component instance

If you've chosen to use a theme, it's considered best practice to keep all of your styling code inside the theme, just to keep things organized. However, it's certainly possible to customize styles on any component in your app so that they're different than the theme's defaults. Let's customize a button's font styles:

``` actionscript
var button:Button = new Button();
button.label = "Click Me";
button.fontStyles = new TextFormat( "_sans", 20, 0x4c4c4c );
this.addChild(button);
```

The button's background skin, padding, and other styles will still be set by the theme, but the text will display with our custom [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html).

<aside class="info">In previous versions of Feathers, customizing styles outside of the theme was a bit cumbersome, in comparison. Simply setting a style property could result in the theme replacing it at a later time. Starting with Feathers 3.1, style properties may be set without conflict.</aside>

### Replace a component's styles completely

There are a couple of different ways to tell a component not to use the default styles from the theme.

#### Opt-out of the theme by clearing the style provider

The most drastic thing we can do is tell a component not to use the theme at all, by setting its `styleProvider` property to `null`:

``` actionscript
var button:Button = new Button();
button.styleProvider = null; //no theme!
button.label = "Click Me";
button.fontStyles = new TextFormat( "_sans", 20, 0x4c4c4c );
button.defaultSkin = new Quad( 100, 30, 0xcccccc );
button.padding = 10;
this.addChild(button);
```

When we remove the style provider, we can be sure that the theme won't make any changes. However, without a style provider, things like padding, layouts, and fonts will need to be set manually as well. This option is all or nothing.

#### Extend the theme with a custom style name

Finally, the best practice is to [extend the theme](extending-themes.html). This usually involves subclassing the existing theme so that you can add a new *style name* for the component that you want to customize. Putting all of your skinning code in the theme keeps things more organized, and you'll avoid cluttering up every corner of your app with random styling code.

## Built-in alternate style names

Some components provide a set of alternate skin "style names" that may be added to a component instance's `styleNameList` to tell the theme that a particular instance should be skinned slightly differently than the default. These alternate skins provide a way to differentiate components visually without changing their functionality. For instance, you might want certain buttons to be a little more prominent than others, so you might give them a special "call-to-action" style name that a theme might use to provide a more colorful skin.

Let's look at another example. The `GroupedList` component has a regular skin that looks a lot like the `List`, but with headers and footers. It tends to be best for groups that are strongly related, such as an alphabetized list of items. The `GroupedList` control also has an alternate "inset" style where the groups have rounded edges on the first and last item, and there is some padding between the edges of the component and the item renderers. This style is better for groups that are more weakly related. iOS uses a similar style very effectively in settings screens where it makes sense to differentiate each group a bit more.

<aside class="info">To see the difference between these two styles, you can view the `GroupedList` in the [Component Explorer](http://feathersui.com/examples/components-explorer/). In the settings screen for the `GroupedList`, change the "Group Style" to "inset".</aside>

Alternate style names get exposed as public static constants on any class that provides them. For instance, `GroupedList` defines `ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST`. The inset style can be used by adding the constant to a grouped list's `styleNameList`, like this:

``` actionscript
var list:GroupedList = new GroupedList();
list.styleNameList.add( GroupedList.ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST );
this.addChild( list );
```

If you are trying out a theme that doesn't provide a specific alternate skin for a component, your component won't be left unskinned. Instead, the theme will automatically fall back to using the default skin for that component. This requires no special code from the theme author. It's a core part of the theming system. It's not ideal when you prefer a specific style, but if you're switching between multiple themes, it will always leave your app fully functional. If you're designing your own themes, obviously you can ensure that all required alternate style names are supported.

## File Size Warning

The example themes generally skin every available component in Feathers. This means that all Feathers components will be compiled into your application... including some that you may not actually use. To save on file size, you should consider modifying the theme's source code to remove references to all components that you are not using.

Obviously, if you create a [custom theme](custom-themes.html) for your application or game, you will probably skin only the components that you plan to use in your UI. In this case, the file size will not be affected by extra, unused components.

## Related Links

-   [Managing assets in Feathers themes](theme-assets.html)

-   [Extending Feathers example themes](extending-themes.html)

-   [Creating custom Feathers themes](custom-themes.html)

-   [An in-depth look at Feathers style providers](style-providers.html)

-   [Migrating legacy themes to Feathers 2.0](migrating-themes.html)