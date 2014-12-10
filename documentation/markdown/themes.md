# Introduction to Feathers Themes

A Feathers theme is class that packages up the skinning code for multiple UI components in one location. Skins are registered globally, and when any Feathers component is instantiated, it will be automatically skinned. It's easy to drop a theme into your new Feathers app, and have it skin every component in the same style. If you need a custom skin for any individual component (even one that looks wildly different than the default), it's easy to exclude the component from the theme. If you like the default styles, but you want to make some tweaks, Feathers provides mechanisms for extending a theme.

Themes are not required, of course. You can skin any Feathers component manually, if you prefer. However, the main advantage of a theme is to keep styling code from being mixed up with things like the play mechanics of a game or the business logic of an productivity app. Themes help you to reduce clutter by organizing your code. Plus, pre-made themes are a great way to get started if you want to focus on your app's functionality before you start worrying about skinning. You may even be able to swap themes with little impact on the rest of your project, if you decide to stick with pre-made themes for an app that doesn't need its own custom design.

A number of sample themes are available in the `themes` directory included with Feathers. Just grab the compiled SWC file for the theme you'd like to use, and drop it into your project. Instantiate the theme when your app first starts up by adding only a single line of code. Any component that you instantiate will be skinned automatically. We'll see an example in a moment.

Curious about themes as an architectural decision and why Feathers doesn't provide default skins? See [Why don't the Feathers components have default skins?](http://wiki.starling-framework.org/feathers/faq?&#why_don_t_the_feathers_components_have_default_skins) in the [Feathers FAQ](http://wiki.starling-framework.org/feathers/faq).

## Initializing a Theme

In the following example, we'll use the example `MetalWorksMobileTheme` included in the *themes* directory that comes with the Feathers library.

In your project's root Starling display object, add an `Event.ADDED_TO_STAGE` listener in the constructor.

``` code
public function Main()
{
    this.addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
}
 
private function addedToStageHandler( event:Event ):void
{
    // more here later
}
```

Next, inside `addedToStageHandler()`, the first thing we should do is instantiate the theme. This needs to be done before we add any Feathers UI components to our app:

``` code
new MetalWorksMobileTheme();
```

To test it out, let's create a button on the next line, after we've created the theme:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.x = 200;
button.y = 150;
this.addChild( button );
```

That's it! When we pass the button to `addChild()`, the theme will detect the button and give it some skins. Anything else that we add to the display list after this will be skinned too.

Most of the samples and apps included with the Feathers library use themes. Take a look in the *examples* directory to see the source code for these projects to see how they initialize their themes in the context of a larger app. Check out the *themes* directory for several example themes.

## When does a theme apply skins to a component?

A theme applies skins after a component initializes. This happens automatically when a component is added to the display list and it gains access to the stage. In other words, a component won't be skinned immediately when its constructor is called. The skinning happens when you pass a component to the `addChild()` function and the component gains access to the stage.

Any skin-related properties that you set before adding a component to the display list may be replaced by the theme. You should [extend the theme](extending-themes.html) to customize individual component skins.

## Customizing a specific component instance

If you've chosen to use a theme, it's best to stay within the theme architecture when you want to customize a specific component instance's skins. See the [Extending a Feathers Theme](extending-themes.html) documentation for way to customize an individual component instance to look different than the default. It's very easy, and it helps you keep all of your skinning code in one place.

It's not recommended when using themes, but you can also change skin and style properties directly on a particular component when you create it. You simply need to do this *after* it has been added to the stage. As noted above, any style properties that you set before adding the component to the stage may be replaced by the theme. For best results, you should always stay within the theming architecture when you choose to use a theme. This means extending the theme when you want to make changes. Otherwise, you may find yourself fighting the theme code and getting frustrated.

Theming is a powerful, but (ultimately) optional, part of Feathers. You can always skin your components without themes. Many Feathers developers do, and you're encouraged to use Feathers in whatever way best fits your preferred workflow.

## Alternate Style Names

Some components provide a set of alternate skin “style names” that may be added to a component instance's `styleNameList` to tell the theme that a particular instance should be skinned slightly differently than the default. These alternate skins provide a way to differentiate components visually without changing their functionality. For instance, you might want certain buttons to be a little more prominent than others, so you might give them a special “call-to-action” style name that a theme might use to provide a more colorful skin.

Let's look at another example. The `GroupedList` component has a regular skin that looks a lot like the `List`, but with headers and footers. It tends to be best for groups that are strongly related, such as an alphabetized list of items. The `GroupedList` control also has an alternate “inset” style where the groups have rounded edges on the first and last item, and there is some padding between the edges of the component and the item renderers. This style is better for groups that are more weakly related. iOS uses a similar style very effectively in settings screens where it makes sense to differentiate each group a bit more.

To see the difference between these two styles, you can view the `GroupedList` in the [Component Explorer](http://feathersui.com/examples/components-explorer/). In the settings screen for the `GroupedList`, change the “Group Style” to “inset”.

Alternate style names get exposed as public static constants on any class that provides them. For instance, `GroupedList` defines `ALTERNATE_NAME_INSET_GROUPED_LIST`. The inset style can be used by adding the constant to a grouped list's `styleNameList`, like this:

``` code
var list:GroupedList = new GroupedList();
list.styleNameList.add( GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST );
this.addChild( list );
```

If you are trying out a theme that doesn't provide a specific alternate skin for a component, your component won't be left unskinned. Instead, the theme will automatically fall back to using the default skin for that component. This requires no special code from the theme author. It's a core part of the theming system. It's not ideal when you prefer a specific style, but if you're switching between multiple themes, it will always leave your app fully functional. If you're designing your own themes, obviously you can ensure that all required alternate style names are supported.

Style names only work when added to a component *before* it the component initializes. You **cannot** change style names later to give a component a different skin.

## Standard Icons

Feathers provides a class `StandardIcons` that themes can use to provide textures for commonly-used icons. For example, `StandardIcons.listDrillDownAccessoryTexture` typically provides an arrow pointing to the right to indicate that you can select a list item to drill down into more detailed data. This icon can be used with a list item's `accessoryTextureField` or `accessoryTextureFunction`.

Not all themes will provide these icons, but theme authors are encouraged to include them.

## File Size Warning

The example themes generally skin every available component in Feathers. This means that all Feathers components will be compiled into your application, including the ones that you don't actually use. To save on file size, you should consider removing references to all components that you are not using from your app's local copy of the theme.

Obviously, if you create a [custom theme](custom-themes.html) for your application or game, you will probably skin only the components that you plan to use in your UI. In this case, the file size will not be affected by extra, unused components.

## Related Links

-   [Managing Assets in Feathers Themes](theme-assets.html)

-   [Extending Feathers Themes](extending-themes.html)

-   [Creating Custom Feathers Themes](custom-themes.html)

-   [Migrating legacy themes to Feathers 2.0](migrating-themes.html)

For more tutorials, return to the [Feathers Documentation](start.html).


