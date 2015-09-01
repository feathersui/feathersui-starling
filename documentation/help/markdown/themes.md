---
title: Introduction to Feathers themes  
author: Josh Tynjala

---
# Introduction to Feathers themes

A Feathers *theme* is class that packages up the skinning code for multiple UI components in one location. Skins are registered globally, and when any Feathers component is instantiated, it will be automatically skinned. It's easy to drop a theme into your new Feathers app, and have it skin every component in the same style. If you need a custom skin for any individual component (even one that looks wildly different than the default), it's easy to exclude the component from the theme. If you like the default styles, but you want to make some tweaks, Feathers provides mechanisms for extending a theme.

<picture><img src="images/themes.jpg" srcset="images/themes@2x.png 2x" alt="Screenshot of multiple Feathers themes side-by-side" /></picture>

Themes are not required, of course. You can skin any Feathers component manually, if you prefer (we'll learn how to exclude a component from the theme later). However, the main advantage of a theme is to keep styling code from being mixed up with things like the play mechanics of a game or the business logic of a productivity app. Themes help you to reduce clutter by organizing your code. Plus, pre-made themes are a great way to get started if you want to focus on your app's functionality before you start worrying about skinning. You may even be able to swap themes with little impact on the rest of your project, if you decide to stick with pre-made themes for an app that doesn't need its own custom design.

A number of sample themes are available in the `themes` directory included with Feathers. Just grab the compiled SWC file for the theme you'd like to use, and drop it into your project. Instantiate the theme when your app first starts up by adding only a single line of code. Any component that you instantiate will be skinned automatically. We'll see an example in a moment.

## Initializing a Theme

In the following example, we'll use the example `MetalWorksMobileTheme` included in the *themes* directory that comes with the Feathers UI library.

In our project's root Starling display object, let's instantiate the theme in the constructor.

``` code
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

<aside class="info">By creating the theme before the `super()` call, the theme can skin the root component, if needed.</aside>

To test it out, let's create a button. First, listen for `Event.ADDED_TO_STAGE`:

``` code
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

``` code
var button:Button = new Button();
button.label = "Click Me";
button.x = 200;
button.y = 150;
this.addChild( button );
```

That's it! When we pass the button to `addChild()`, the theme will detect the button and give it some skins. Anything else that we add to the display list after this will be skinned too.

Most of the example projects included with the Feathers library use themes. Take a look in the *examples* directory to see the source code for these projects to see how they initialize their themes in the context of a larger app. Check out the *themes* directory for several different example themes, for both mobile and desktop.

## Customizing a specific component instance

If you've chosen to use a theme, it's best to stay within the theme architecture when you want to customize a specific component instance's skins. If you try to set skin/style properties in the same place that you create a component, you may discover that the theme replaces your choices. Something like this might not work:

``` code
var button:Button = new Button();
button.iconPosition = Button.ICON_POSITION_TOP;
button.defaultIcon = new Image(texture);
this.addChild(button);
```

The theme doesn't set skins right away after the constructor is called. It waits until the component initializes. Usually, that happens when the component is added to the stage. In the code above, our `iconPosition` and `defaultIcon` properties may be changed by the theme because we're setting them too early!

There are a few ways to work within the theme architecture.

### Set the style provider to `null` to skin manually

The most drastic thing we can do is tell a component not to use the theme at all, by setting its `styleProvider` property to `null`:

``` code
var button:Button = new Button();
button.styleProvider = null;
button.iconPosition = Button.ICON_POSITION_TOP;
button.defaultIcon = new Image(texture);
this.addChild(button);
```

When we remove the style provider, we can be sure that the theme won't make any changes. However, without a style provider, things like padding, layouts, and fonts will need to be set manually as well. This option is all or nothing.

### Use `AddOnFunctionStyleProvider` to make changes after the theme is applied

Completely removing the theme from a component may undesireable. Maybe we want to keep some of the theme's styles, but tweak others. We can do that using the [`AddOnFunctionStyleProvider`](../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) class:

``` code
function setExtraStyles( button ):void
{
    button.iconPosition = Button.ICON_POSITION_TOP;
    button.defaultIcon = new Image( texture );
}
 
var button:Button = new Button();
button.styleProvider = new AddOnFunctionStyleProvider( button.styleProvider, setExtraStyles );
this.addChild( button );
```

An `AddOnFunctionStyleProvider` will apply the theme's style first, and then it will call an extra function that allows us to safely make changes to a component's styles without worrying that the theme will replace anything.

We pass two things to the `AddOnFunctionStyleProvider`. First, the button's original style provider that sets the theme's styles. Then, our extra function to call after the theme's styles are applied.

### Extend the theme with a custom style name

Finally, the best practice is to [extend the theme](extending-themes.html). This usually involves subclassing the existing theme so that you can add a new *style name* for the component that you want to customize. Putting all of your skinning code in the theme keeps things more organized, and you'll avoid cluttering up every corner of your app with random styling code.

## Built-in alternate style names

Some components provide a set of alternate skin "style names" that may be added to a component instance's `styleNameList` to tell the theme that a particular instance should be skinned slightly differently than the default. These alternate skins provide a way to differentiate components visually without changing their functionality. For instance, you might want certain buttons to be a little more prominent than others, so you might give them a special "call-to-action" style name that a theme might use to provide a more colorful skin.

Let's look at another example. The `GroupedList` component has a regular skin that looks a lot like the `List`, but with headers and footers. It tends to be best for groups that are strongly related, such as an alphabetized list of items. The `GroupedList` control also has an alternate "inset" style where the groups have rounded edges on the first and last item, and there is some padding between the edges of the component and the item renderers. This style is better for groups that are more weakly related. iOS uses a similar style very effectively in settings screens where it makes sense to differentiate each group a bit more.

<aside class="info">To see the difference between these two styles, you can view the `GroupedList` in the [Component Explorer](http://feathersui.com/examples/components-explorer/). In the settings screen for the `GroupedList`, change the "Group Style" to "inset".</aside>

Alternate style names get exposed as public static constants on any class that provides them. For instance, `GroupedList` defines `ALTERNATE_STYLE_NAME_INSET_GROUPED_LIST`. The inset style can be used by adding the constant to a grouped list's `styleNameList`, like this:

``` code
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

-   [Migrating legacy themes to Feathers 2.0](migrating-themes.html)