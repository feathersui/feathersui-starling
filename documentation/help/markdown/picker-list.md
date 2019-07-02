---
title: How to use the Feathers PickerList component  
author: Josh Tynjala

---
# How to use the Feathers `PickerList` component

The [`PickerList`](../api-reference/feathers/controls/PickerList.html) class displays a [`Button`](button.html) that may be triggered to show a [pop-up](pop-ups.html) [`List`](list.html). The way that the list is displayed may be customized for different platforms by changing the picker list's *pop-up content manager*. Several different options are available, including drop downs, callouts, and simply filling the stage vertically.

<figure>
<img src="images/picker-list.png" srcset="images/picker-list@2x.png 2x" alt="Screenshot of a Feathers PickerList component" />
<figcaption>A `PickerList` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Skinning a `PickerList`](#skinning-a-pickerlist)

## The Basics

First, let's create a `PickerList` control and add it to the display list:

``` actionscript
var list:PickerList = new PickerList();
this.addChild( list );
```

Next, we want to actually allow it to select some items, so like a `List` components, we pass in an [`IListCollection`](../api-reference/feathers/data/IListCollection.html) implementation, such as [`ArrayCollection`](../api-reference/feathers/data/ArrayCollection.html) or [`VectorCollection`](../api-reference/feathers/data/VectorCollection.html), to the [`dataProvider`](../api-reference/feathers/controls/PickerList.html#dataProvider) property.

``` actionscript
var groceryList:ArrayCollection = new ArrayCollection(
[
    { text: "Milk" },
    { text: "Eggs" },
    { text: "Bread" },
    { text: "Chicken" },
]);
list.dataProvider = groceryList;
```

We need to tell the picker list's item renderers about the text to display, so we'll define the [`labelField`](../api-reference/feathers/controls/renderers/BaseDefaultItemRenderer.html#labelField).

``` actionscript
list.itemRendererFactory = function():IListItemRenderer
{
    var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
    itemRenderer.labelField = "text";
    return itemRenderer;
}
```

Since the selected item's label is also displayed by the picker list's button, we also need to pass a value to the [`labelField`](../api-reference/feathers/controls/PickerList.html#labelField) of the picker list.

``` actionscript
list.labelField = "text";
```

<aside class="info">Custom item renderers are not required to define a property named `labelField`, so the `PickerList` cannot automatically detect this property from its pop-up `List`. That's why we need to define it in two places.</aside>

We can provide some text to display with the button's label when no item is selected. This is often called a hint, a description, or a [`prompt`](../api-reference/feathers/controls/PickerList.html#prompt):

``` actionscript
list.prompt = "Select an Item";
list.selectedIndex = -1;
```

We need to set the [`selectedIndex`](../api-reference/feathers/controls/PickerList.html#selectedIndex) to `-1` if you want to display the prompt because the picker list will automatically select the first item.

## Skinning a `PickerList`

The skins for a `PickerList` control are divided into several parts, including the button and pop-up list sub-components. For full details about what skin and style properties are available, see the [`PickerList` API reference](../api-reference/feathers/controls/PickerList.html).

### Skinning the button

Please read [How to use the Feathers `Button` component](button.html) for full details about how to skin this component.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON`](../api-reference/feathers/controls/PickerList.html#DEFAULT_CHILD_STYLE_NAME_BUTTON) style name:

``` actionscript
getStyleProviderForClass( Button )
    .setFunctionForStyleName( PickerList.DEFAULT_CHILD_STYLE_NAME_BUTTON, setPickerListButtonStyles );
```

The styling function might look like this:

``` actionscript
private function setPickerListButtonStyles( button:Button ):void
{
    button.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );
}
```

You can override the default style name to use a different one in your theme, if you prefer:

``` actionscript
list.customButtonStyleName = "custom-button-name";
```

You can set the function for the [`customButtonStyleName`](../api-reference/feathers/controls/PickerList.html#customButtonStyleName) like this:

``` actionscript
getStyleProviderForClass( Button )
    .setFunctionForStyleName( "custom-button-name", setPickerListCustomButtonStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`buttonFactory`](../api-reference/feathers/controls/PickerList.html#buttonFactory) to provide skins for the picker list's button:

``` actionscript
list.buttonFactory = function():Button
{
    var button:Button = new Button();

    //skin the button here, if not using a theme
    button.fontStyles = new TextFormat( "Helvetica", 20, 0xcc0000 );

    return button;
};
```

### Skinning the List

Please read [How to use the Feathers `List` component](list.html) for full details about how to skin this component.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`PickerList.DEFAULT_CHILD_STYLE_NAME_LIST`](../api-reference/feathers/controls/PickerList.html#DEFAULT_CHILD_STYLE_NAME_LIST) style name:

``` actionscript
getStyleProviderForClass( List )
    .setFunctionForStyleName( PickerList.DEFAULT_CHILD_STYLE_NAME_LIST, setPickerListPopUpListStyles );
```

The styling function might look like this:

``` actionscript
private function setPickerListPopUpListStyles( list:List ):void
{
    var skin:Image = new Image( texture );
    skin.scale9Grid = new Rectangle( 2, 3, 1, 6 );
    list.backgroundSkin = skin;
}
```

You can override the default style name to use a different one in your theme, if you prefer:

``` actionscript
list.customListStyleName = "custom-list";
```

You can set the function for the [`customListStyleName`](../api-reference/feathers/controls/PickerList.html#customListStyleName) like this:

``` actionscript
getStyleProviderForClass( List )
    .setFunctionForStyleName( "custom-list", setPickerListCustomListStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`listFactory`](../api-reference/feathers/controls/PickerList.html#listFactory) to provide skins for the picker list's pop-up list:

``` actionscript
list.listFactory = function():List
{
    var list:List = new List();

    //skin the pop-up list here, if not using a theme
    var skin:Image = new Image( texture );
    skin.scale9Grid = new Rectangle( 2, 3, 1, 6 );
    list.backgroundSkin = skin;

    return list;
};
```

### Customizing the Pop Up Behavior

Next, we'll take a look at how to use the [`popUpContentManager`](../api-reference/feathers/controls/PickerList.html#popUpContentManager) property to customize how the pop-up list appears when you trigger the picker list's button.

Feathers comes with three pop-up content managers:

-   [`VerticalCenteredPopUpContentManager`](../api-reference/feathers/controls/popups/VerticalCenteredPopUpContentManager.html) provides a pop-up UI similar to Android. The list fills the entire vertical space of the screen. The list fills enough space horizontally to fit within the shorter edge of the screen, even when the device is in the landscape orientation. Along all edges, padding around the edges of the list may be customized.

-   [`CalloutPopUpContentManager`](../api-reference/feathers/controls/popups/CalloutPopUpContentManager.html) places the list into a [`Callout`](callout.html) component. The callout points to the picker list's button.

-   [`DropDownPopUpContentManager`](../api-reference/feathers/controls/popups/DropDownPopUpContentManager.html) displays the list as a drop down along the edge of the picker list's button. This is similar to a drop down list in a desktop UI.

Selecting the pop up content manager, is as simple as instantiating it and passing it to the picker list:

``` actionscript
list.popUpContentManager = new DropDownPopUpContentManager();
```

You may customize properties of the pop up content manager first, if needed:

``` actionscript
var popUpContentManager:VerticalCenteredPopUpContentManager = new VerticalCenteredPopUpContentManager();
popUpContentManager.marginTop = 20;
popUpContentManager.marginRight = 25;
popUpContentManager.marginBottom = 20;
popUpContentManager.marginLeft = 25;
list.popUpContentManager = popUpContentManager;
```

You can completely customize the pop-up behavior of the picker list by implementing the [`IPopUpContentManager`](../api-reference/feathers/controls/popups/IPopUpContentManager.html) interface.

## Related Links

-   [`feathers.controls.PickerList` API Documentation](../api-reference/feathers/controls/PickerList.html)