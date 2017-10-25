---
title: How to use the Feathers DataGrid component  
author: Josh Tynjala

---
# How to use the Feathers `DataGrid` component

The [`DataGrid`](../api-reference/feathers/controls/DataGrid.html) class displays a table of data. Each item in the data provider is displayed as a row, divided into columns for the item's fields. It includes support for selection, scrolling, layout virtualization to optimize rendering of large collections, and custom cell renderers.

<figure>
<img src="images/data-grid.png" srcset="images/data-grid@2x.png 2x" alt="Screenshot of a Feathers DataGrid component" />
<figcaption>`DataGrid` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Selection](#selection)

-   [Skinning a `DataGrid`](#skinning-a-data-grid)

-   [Custom cell renderers](#custom-cell-renderers)

-   [Customize scrolling behavior](#customize-scrolling-behavior)

## The Basics

First, let's create a `DataGrid` control and add it to the display list:

``` code
var grid:DataGrid = new DataGrid();
grid.width = 300;
grid.height = 250;
this.addChild( grid );
```

Next, we want the data grid to display some items, so let's create an [`ArrayCollection`](../api-reference/feathers/data/ArrayCollection.html) as its data provider.

``` code
var items:ArrayCollection = new ArrayCollection(
[
	{ item: "Chicken breast", dept: "Meat", price: "5.90" },
	{ item: "Bacon", dept: "Meat", price: "4.49" },
	{ item: "2% Milk", dept: "Dairy", price: "2.49" },
	{ item: "Butter", dept: "Dairy", price: "4.69" },
	{ item: "Lettuce", dept: "Produce", price: "1.29" },
	{ item: "Broccoli", dept: "Produce", price: "2.99" },
	{ item: "Whole Wheat Bread", dept: "Bakery", price: "2.49" },
	{ item: "English Muffins", dept: "Bakery", price: "2.99" },
]);
grid.dataProvider = items;
```

`ArrayCollection` wraps a regular ActionScript `Array`, and it adds special events and things that the `DataGrid` uses to add, update, and remove rows in real time.

<aside class="info">`ArrayCollection` is one of multiple classes that implement the [`IListCollection`](../api-reference/feathers/data/IListCollection.html) interface. `IListCollection` may wrap any type of data to provide a common API that the `DataGrid` component can understand. Out of the box, we may use these collection implementations: 

* [`ArrayCollection`](../api-reference/feathers/data/ArrayCollection.html) for data based on an [`Array`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Array.html)
* [`VectorCollection`](../api-reference/feathers/data/VectorCollection.html) for data based on a [`Vector`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Vector.html)
* [`XMLListCollection`](../api-reference/feathers/data/XMLListCollection.html) for data based on an [`XMLList`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/XMLList.html)

It's even possible for anyone to create new `IListCollection` implementations to display custom data types, if needed.</aside>

### Columns

Now, we should define the columns in the data grid, so that it knows which fields from the data provider's items to display. Let's start by taking a moment to review one of the items from the data provider:

``` code
{ item: "Broccoli", dept: "Produce", price: "2.99" },
```

The item has three fields, `item`, `dept`, and `price`. We can define a [`DataGridColumn`](../api-reference/feathers/controls/DataGridColumn.html) for each of them, and pass them to the `columns` property in a collection.

``` code
grid.columns = new ArrayCollection(
[
	new DataGridColumn("item", "Item"),
	new DataGridColumn("dept", "Department"),
	new DataGridColumn("price", "Unit Price"),
]);
```

As you can see in the code above, we can also customize the text to display in each column header. Setting the header text is optional, and the field name will be displayed when it is omitted.

<aside class="info">If you don't set the `columns` property, the data grid will attempt to populate it automatically. There's no guarantee that the columns will be displayed in any particular order, so it's usually a good idea to define the columns manually instead of relying on the automatic behavior.</aside>

## Selection

The `DataGrid` component may have one selected item, which selects an entire row. You can access information about selection through the [`selectedIndex`](../api-reference/feathers/controls/DataGrid.html#selectedIndex) and [`selectedItem`](../api-reference/feathers/controls/DataGrid.html#selectedItem) properties. If there is no selection, the value of `selectedIndex` will be `-1` and the value of `selectedItem` will be `null`.

To listen for when the selection changes, listen to [`Event.CHANGE`](../api-reference/feathers/controls/DataGrid.html#event:change):

``` code
grid.addEventListener( Event.CHANGE, grid_changeHandler );
```

The listener might look something like this:

``` code
private function grid_changeHandler( event:Event ):void
{
    var grid:DataGrid = DataGrid( event.currentTarget );
    trace( "selectedIndex:", grid.selectedIndex );
}
```

You can manually change the selection, if needed:

``` code
grid.selectedIndex = 4;
```

Selection indices start at `0`, so the above code would select the fifth row in the data grid.

If you prefer, you can change selection by passing in an item from the data provider:

``` code
grid.selectedItem = item;
```

If needed, you can clear selection manually:

``` code
grid.selectedIndex = -1;
```

To disable selection completely, use the [`isSelectable`](../api-reference/feathers/controls/DataGrid.html#isSelectable) property:

``` code
grid.isSelectable = false;
```

To support the selection of more than one item, set the [`allowMultipleSelection`](../api-reference/feathers/controls/DataGrid.html#allowMultipleSelection) property to `true`:

``` code
grid.allowMultipleSelection = true;
```

## Skinning a `DataGrid`

## Custom cell renderers

## Customize scrolling behavior

A number of properties are available to customize scrolling behavior and the scroll bars.

### Interaction Modes

Scrolling containers provide two main interaction modes, which can be changed using the [`interactionMode`](../api-reference/feathers/controls/Scroller.html#interactionMode) property.

By default, you can scroll using touch, just like you would on many mobile devices including smartphones and tablets. This mode allows you to grab the container anywhere within its bounds and drag it around to scroll. This mode is defined by the constant, [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH).

Alternatively, you can set `interactionMode` to [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE). This mode allows you to scroll using the horizontal or vertical scroll bar sub-components. You can also use the mouse wheel to scroll vertically.

Finally, you can set `interactionMode` to [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS). This mode allows you to scroll both by dragging the container's content and by using the scroll bars.

### Scroll Bar Display Mode

The [`scrollBarDisplayMode`](../api-reference/feathers/controls/Scroller.html#scrollBarDisplayMode) property controls how and when scroll bars are displayed. This value may be overridden by the scroll policy, as explained below.

The default value is [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT), which displays the scroll bars as an overlay above the view port's content, rather than affecting the size of the view port. When the scroll bars are floating, they fade out when the container is not actively scrolling. This is a familiar behavior for scroll bars in the touch interaction mode. In the mouse interaction mode, the scroll bars will appear when the mouse hovers over them and then disappear when the hover ends.

To completely hide the scroll bars, but still allow scrolling, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE).

If you want the scroll bars to always be visible outside of the content in a fixed position, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED). This is best for traditional desktop scrollable content.

Finally, you can set `scrollBarDisplayMode` to [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED_FLOAT) to display the scroll bar as an overlay above the view port's content, but it does not fade away.

### Scroll Policies

The two previous properties control how scrolling works. The [`horizontalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#horizontalScrollPolicy) and [`verticalScrollPolicy`](../api-reference/feathers/controls/Scroller.html#verticalScrollPolicy) properties control whether scrolling is enabled or not.

The default scroll policy for both directions is [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO). If the content's width is greater than the view port's width, the container may scroll horizontally (same for height and vertical scrolling). If not, then the container will not scroll in that direction. In addition to the `scrollBarDisplayMode`, this can affect whether the scroll bar is visible or not.

You can completely disable scrolling in either direction, set the scroll policy to [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF). The scroll bar will not be visible, and the container won't scroll, even if the content is larger than the view port.

Finally, you can ensure that scrolling is always enabled by setting the scroll policy to [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON). If combined with `hasElasticEdges` in the touch interaction mode, it will create a playful edge that always bounces back, even when the content is smaller than the view port. If using the mouse interaction mode, the scroll bar may always be visible under the same circumstances, though it may be disabled if the content is smaller than the view port.

## Related Links

-   [`feathers.controls.DataGrid` API Documentation](../api-reference/feathers/controls/DataGrid.html)