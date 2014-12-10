# How to use the Feathers PickerList Component

The `PickerList` class displays a `Button` that may be triggered to show a pop-up [List](list.html). The way that the list is displayed may be customized for different platforms by changing the picker list's *pop-up content manager*. Several different options are available, including drop downs, callouts, and simply filling the stage vertically.

## The Basics

Let's start by creating our picker list control:

``` code
var list:PickerList = new PickerList();
this.addChild( list );
```

Next, we want to actually allow it to select some items, so like a `List` components, we pass in a `ListCollection` to the `dataProvider` property.

``` code
var groceryList:ListCollection = new ListCollection(
[
    { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
    { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
    { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
    { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
]);
list.dataProvider = groceryList;
```

Again, similar to a [list](list.html), we need to tell the picker list's item renderers about how to use those properties, so we'll define the `labelField` and `iconSourceField`.

``` code
list.listProperties.@itemRendererProperties.labelField = "text";
list.listProperties.@itemRendererProperties.iconSourceField = "thumbnail";
```

Since the selected item's label is displayed by the picker list's button, we also need to pass a value to the `labelField` of the picker list.

``` code
list.labelField = "text";
```

You can display text on the button when no item is selected. This is often called a hint, a description, or a `prompt`:

``` code
list.prompt = "Select an Item";
list.selectedIndex = -1;
```

Don't forget that you need to set the `selectedIndex` to `-1` if you want to display the prompt because the picker list will automatically select the first item.

## Skinning a Picker List

The skins for a `PickerList` control are divided into several parts, including the button and pop-up list sub-components. For full details about what skin and style properties are available, see the [PickerList API reference](http://feathersui.com/documentation/feathers/controls/PickerList.html).

### Targeting a PickerList in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( PickerList ).defaultStyleFunction = setPickerListStyles;
```

If you want to customize a specific picker list to look different than the default, you may use a custom style name to call a different function:

``` code
list.styleNameList.add( "custom-picker-list" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( PickerList )
    .setFunctionForStyleName( "custom-picker-list", setCustomPickerListStyles );
```

Trying to change the picker list's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the picker list was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the picker list's properties directly.

### Skinning the Button

Please read [How to use the Feathers Button component](button.html) for full details about how to skin this component.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `PickerList.DEFAULT_CHILD_NAME_BUTTON` style name:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( PickerList.DEFAULT_CHILD_NAME_BUTTON, setPickerListButtonStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
list.customButtonName = "custom-button-name";
```

You can set the function for the `customButtonName` like this:

``` code
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-button-name", setPickerListCustomButtonStyles );
```

#### Without a Theme

If you are not using a theme, you can use `buttonFactory` to provide skins for the picker list's button:

``` code
list.buttonFactory = function():Button
{
    var button:Button = new Button();
    button.defaultSkin = new Scale9Image( up9Textures );
    button.downSkin = new Scale9Image( down9Textures );
    button.hoverSkin = new Scale9Image( hover9Textures );
    return button;
};
```

Alternatively, or in addition to the `buttonFactory`, you may use the `buttonProperties` to pass skins to the button:

``` code
list.buttonProperties.defaultSkin = new Scale9Image( up9Textures );
list.buttonProperties.downSkin = new Scale9Image( down9Textures );
list.buttonProperties.hoverSkin = new Scale9Image( hover9Textures );
```

In general, you should only skins to the picker list's button through `buttonProperties` if you need to change skins after the button is created. Using `buttonFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Skinning the List

Please read [How to use the Feathers List component](list.html) for full details about how to skin this component.

#### With a Theme

If you're creating a [theme](themes.html), you can target the `PickerList.DEFAULT_CHILD_NAME_LIST` style name:

``` code
getStyleProviderForClass( List )
    .setFunctionForStyleName( PickerList.DEFAULT_CHILD_NAME_LIST, setPickerListListStyles );
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
list.customListName = "custom-list";
```

You can set the function for the `customListName` like this:

``` code
getStyleProviderForClass( List )
    .setFunctionForStyleName( "custom-list", setPickerListCustomListStyles );
```

#### Without a Theme

If you are not using a theme, you can use `listFactory` to provide skins for the picker list's list:

``` code
list.listFactory = function():List
{
    var list:List = new List();
    list.backgroundSkin = new Scale9Image( backgroundSkinTextures );
    return list;
};
```

Alternatively, or in addition to the `listFactory`, you may use the `listProperties` to pass skins to the list.

``` code
list.listProperties.backgroundSkin = new Scale9Image( backgroundSkinTextures );
```

In general, you should only skins to the picker list's list through `listProperties` if you need to change skins after the list is created. Using `listFactory` will provide slightly better performance, and your development environment will be able to provide code hinting thanks to stronger typing.

### Customizing the Pop Up Behavior

Next, we'll take a look at how to use the `popUpContentManager` property to customize how the pop-up list appears when you trigger the picker list's button.

Feathers comes with three pop-up content managers:

-   `VerticalCenteredPopUpContentManager` provides a pop-up UI similar to Android. The list fills the entire vertical space of the screen. The list fills enough space horizontally to fit within the shorter edge of the screen, even when the device is in the landscape orientation. Along all edges, padding around the edges of the list may be customized.

-   `CalloutPopUpContentManager` places the list into a `Callout` component. The callout points to the picker list's button.

-   `DropDownPopUpContentManager` displays the list as a drop down along the edge of the picker list's button. This is similar to a drop down list in a desktop UI.

Selecting the pop up content manager, is as simple as instantiating it and passing it to the picker list:

``` code
list.popUpContentManager = new DropDownPopUpContentManager();
```

You may customize properties of the pop up content manager first, if needed:

``` code
var popUpContentManager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
popUpContentManager.marginTop = 20;
popUpContentManager.marginRight = 25;
popUpContentManager.marginBottom = 20;
popUpContentManager.marginLeft = 25;
list.popUpContentManager = popUpContentManager;
```

You can completely customize the pop-up behavior of the picker list by implementing the `IPopUpContentManager` interface.

## Related Links

-   [PickerList API Documentation](http://feathersui.com/documentation/feathers/controls/PickerList.html)

For more tutorials, return to the [Feathers Documentation](index.html).


