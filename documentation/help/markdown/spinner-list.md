---
title: How to use the Feathers SpinnerList component  
author: Josh Tynjala

---
# How to use the Feathers `SpinnerList` component

The [`SpinnerList`](../api-reference/feathers/controls/SpinnerList.html) class extends the [`List`](list.html) component to allow the user to change the selected item by scrolling. Typically, the selected item is positioned in the center of the list, and it may be visually highlighted in some way. A `SpinnerList` will often loop infinitely, repeating its items as the user scrolls.

<figure>
<img src="images/spinner-list.png" srcset="images/spinner-list@2x.png 2x" alt="Screenshot of a Feathers SpinnerList component" />
<figcaption>A `SpinnerList` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Skinning a `SpinnerList`](#skinning-a-spinnerlist)

## The Basics

First, let's create a `SpinnerList` control and add it to the display list:

``` code
var list:SpinnerList = new SpinnerList();
this.addChild( list );
```

Similar to a `List`, we can pass a [`ListCollection`](../api-reference/feathers/data/ListCollection.html) to the [`dataProvider`](../api-reference/feathers/controls/List.html#dataProvider) property:

``` code
list.dataProvider = new ListCollection(
[
    { text: "Milk", thumbnail: textureAtlas.getTexture( "milk" ) },
    { text: "Eggs", thumbnail: textureAtlas.getTexture( "eggs" ) },
    { text: "Bread", thumbnail: textureAtlas.getTexture( "bread" ) },
    { text: "Chicken", thumbnail: textureAtlas.getTexture( "chicken" ) },
]);
```

We'll set up the label and icon in the item renderer the same way too:

``` code
list.itemRendererProperties.labelField = "text";
list.itemRendererProperties.iconSourceField = "thumbnail";
```

We can listen for selection changes with [`Event.CHANGE`](../api-reference/feathers/controls/List.html#event:change):

``` code
list.addEventListener( Event.CHANGE, list_changeHandler );
```

Likewise, we can use the [`selectedIndex`](../api-reference/feathers/controls/List.html#selectedIndex) and [`selectedItem`](../api-reference/feathers/controls/List.html#selectedItem) properties:

``` code
list.selectedIndex = 3;
trace( list.selectedItem.text ); //Chicken
```

One way that `SpinnerList` behaves differently is that selection may not be disabled. A regular `List` may be used to display read-only content without selection, but the purpose of `SpinnerList` is to select an item. If you attempt to set the [`isSelectable`](../api-reference/feathers/controls/List.html#isSelectable) property to `false`, a runtime error will be thrown.

## Skinning an `SpinnerList`

A spinner list provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`SpinnerList` API reference](../api-reference/feathers/controls/SpinnerList.html). We'll look at a few of the most common properties below.

As mentioned above, `SpinnerList` is a subclass of `List`. For more detailed information about the skinning options available to `SpinnerList`, see [How to use the Feathers `List` component](list.html).

### Using a theme? Some tips for customizing an individual spinner list's styles

A [theme](themes.html) does not style a component until the component initializes. This is typically when the component is added to stage. If you try to pass skins or font styles to the component before the theme has been applied, they may be replaced by the theme! Let's learn how to avoid that.

As a best practice, when you want to customize an individual component, you should add a custom value to the component's [`styleNameList`](../api-reference/feathers/core/FeathersControl.html#styleNameList) and [extend the theme](extending-themes.html). However, it's also possible to use an [`AddOnFunctionStyleProvider`](../api-reference/feathers/skins/AddOnFunctionStyleProvider.html) outside of the theme, if you prefer. This class will call a function after the theme has applied its styles, so that you can make a few tweaks to the default styles.

In the following example, we customize the spinner list's `selectionOverlaySkin` property with an `AddOnFunctionStyleProvider`:

``` code
var list:SpinnerList = new SpinnerList();
function setExtraSpinnerListStyles( list:SpinnerList ):void
{
	var skin:Image = new Image( texture );
	skin.scale9Grid = new Rectangle( 2, 3, 1, 6 );
	list.selectionOverlaySkin = skin;
}
list.styleProvider = new AddOnFunctionStyleProvider(
	list.styleProvider, setExtraSpinnerListStyles );
```

Our changes only affect the selection overlay skin. The spinner list will continue to use the theme's background skin and other styles.

### Highlight the selected item

As we saw above, we can add a display object above the selected item to visually highlight it. In the following example, we pass in a `starling.display.Image` to the [`selectionOverlaySkin`](../api-reference/feathers/controls/SpinnerList.html#selectionOverlaySkin) property, but the skin may be any Starling display object:

``` code
list.selectionOverlaySkin = new Image( texture );
```

This skin will be displayed in the center of the list, positioned either horizontally or vertically, depending on which way the list may be scrolled.

## Related Links

-   [`feathers.controls.SpinnerList` API Documentation](../api-reference/feathers/controls/SpinnerList.html)

-   [How to Use the Feathers `List` Component](list.html)