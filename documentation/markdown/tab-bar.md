# How to use the Feathers TabBar Component

The `TabBar` class displays a set of togglable buttons with a vertical or horizontal layout, where only one button at a time may be selected. A tab bar's tabs may be added or removed at runtime through its data provider, and the first and last tabs may be optionally styled differently. For instance, one could create a more “pill” shaped control that looks more like a segmented button bar than a set of tabs.

The [DisplayObjectExplorer example](http://feathersui.com/examples/display-object-explorer) demonstrates how to connect a `TabBar` to a `ScreenNavigator`.

## The Basics

Let's start by creating a tab bar, setting it's data provider to display a few tabs, and adding it to the display list:

``` code
var tabs:TabBar = new TabBar();
tabs.dataProvider = new ListCollection(
[
    { label: "One" },
    { label: "Two" },
    { label: "Three" },
]);
this.addChild( tabs );
```

The `label` field in each item from the data provider will set the `label` property on the corresponding tab. In addition to the label, you can also set the various icons available on the `Button` class, such as `defaultIcon`, `upIcon`, or `downIcon`.

To know when the selected tab changes, we need to listen to `Event.CHANGE`:

``` code
tabs.addEventListener( Event.CHANGE, tabs_changeHandler );
```

A listener might look something like this:

``` code
function tabs_changeHandler( event:Event ):void
{
    var tabs:TabBar = TabBar( event.currentTarget );
    trace( "selectedIndex:", tabs.selectedIndex );
}
```

The `selectedIndex` property indicates the zero-based index of the currently selected tab.

## Skinning a Tab Bar

Except for a couple of layout properties, most of the skinning happens on the tabs. For full details about what skin and style properties are available, see the [TabBar API reference](http://feathersui.com/documentation/feathers/controls/TabBar.html). We'll look at a few of the most common properties below.

### Layout

For layout, you can set the `direction` property to `DIRECTION_HORIZONTAL` or `DIRECTION_VERTICAL`. The `gap` property sets the extra space, measured in pixels, between tabs.

### Targeting a TabBar in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( TabBar ).defaultStyleFunction = setTabBarStyles;
```

If you want to customize a specific tab bar to look different than the default, you may use a custom style name to call a different function:

``` code
tabs.styleNameList.add( "custom-tab-bar" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( TabBar )
    .setFunctionForStyleName( "custom-tab-bar", setCustomTabBarStyles );
```

Trying to change the tab bar's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the tab bar was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the tab bar's properties directly.

### Skinning the Tabs

This section only explains how to access the tab sub-components, which are simply buttons. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `TabBar.DEFAULT_CHILD_NAME_TAB` style name.

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( setTabStyles, TabBar.DEFAULT_CHILD_NAME_TAB );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
tabBar.customTabName = "custom-tab";
```

You can set the function for the `customTabName` like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( setCustomTabStyles, "custom-tab" );
```

#### Without a Theme

If you are not using a theme, you can use `tabFactory` to provide skins for the tabs:

``` code
tabBar.tabFactory = function():Button
{
    var tab:Button = new Button();
    tab.defaultSkin = new Image( texture );
    tab.downSkin = new Image( texture );
    tab.defaultLabelProperties.textFormat = new TextFormat("Arial", 24, 0x323232, true );
    return tab;
};
```

In addition to the `tabFactory`, you may use the `tabProperties` to pass properties to the tabs. The values of these properties are shared by *all* tabs, so display objects should never be passed in using `tabProperties`. A display object may only have one parent, so passing in a display object as a skin to every tab is impossible. Other types of styles, like gap and padding, can be passed in through `tabProperties`:

``` code
tabBar.tabProperties.gap = 20;
```

In general, you should only pass properties to the tab bar's tabs through `tabProperties` if you need to change these values after the tabs are created. Using `tabFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the First and Last Tabs

This section only explains how to access the first and last tab sub-components. Please read [How to use the Feathers Button component](button.html) for full details about the skinning properties that are available on `Button` components.

The tab bar's first and last tabs will have the same skins as the other tabs by default. However, their skins may be customized separately, if desired.

For the first tab, you can customize the name with `customFirstTabName`. If you aren't using a theme, then you can use `firstTabFactory` and `firstTabProperties`.

For the last tab, you can customize the name with `customLastTabName`. If you aren't using a theme, then you can use `lastTabFactory` and `lastTabProperties`.

Separate skins for the first and last tabs are completely optional.

## Related Links

-   [TabBar API Documentation](http://feathersui.com/documentation/feathers/controls/TabBar.html)

For more tutorials, return to the [Feathers Documentation](index.html).


