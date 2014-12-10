# Creating Virtualized Custom Feathers Layouts

This is an advanced tutorial about creating custom layouts. Before continuing, please be sure that you read the [Introduction to Custom Layouts](custom-layouts.html) first.
Please note that this tutorial is a work in progress and should be considered incomplete.

## The measureViewPort() function

The first function defined by `IVirtualLayout` is `measureViewPort()`. Please take a moment to review its signature below:

``` code
measureViewPort(itemCount:int, viewPortBounds:ViewPortBounds = null, result:Point = null):Point
```

Using a `ViewPortBounds` object and the number of items displayed, this function estimates the final width and height of the view port.

## The getVisibleIndicesAtScrollPosition() function

The second function defined by `IVirtualLayout` is `getVisibleIndicesAtScrollPosition()`. Please take a moment to review its signature below:

``` code
getVisibleIndicesAtScrollPosition(scrollX:Number, scrollY:Number, width:Number, height:Number, itemCount:int, result:Vector.<int> = null):Vector.<int>
```

This function determines which items won't be virtual in the layout. In other words, it determines which items are visible within the view port.

## Variable Virtualized Layouts

`IVirtualLayout` normally expects all of its items to have the same dimensions. If item A has a width and height of 100 pixels by 50 pixels, then item B must also have a width and height of 100 pixels by 50 pixels. The `IVariableVirtualLayout` interface extends `IVirtualLayout` to provide additional functions that allow the layout to keep a cache of item dimensions that can be used in the virtualization process so that items can each have different dimensions. This cache allows the layout to remain as stable as possible when real items are replaced by virtual items as they scroll out of view. If a cache were not kept, the virtual items would have different dimensions, and the items in the view port could jump around unexpectedly and ruin the user experience.

The `hasVariableItemDimensions` property indicates whether the layout allows items with variable widths and heights or not. The layout is expected to have an optimized version of its functions for equal-sized items when `hasVariableItemDimensions` is `false`.

When the `layout()` function is called, an `ILayout` will usually ask each item for its width and height. When this happens, the item's dimensions should be cached and the `ILayout` should dispatch `Event.CHANGE`. This may cause the container using the layout to invalidate so that it can ask the `ILayout` to determine if the same items are still visible, of if new indices have come into view. This isn't a more inefficient process than a layout where the item dimensions are all the same, as you can probably image, so it's recommended to enable variable item dimensions only when needed. Eventually, after one or more attempts, the layout will stabilize (at least until it needs to scroll).

The container using the layout listens for when its items are resized. When this happens, the container will tell the layout that its cache is out of date, and the layout will adjust accordingly. Several functions are defined by `IVariableVirtualLayout` to make changes to the cache:

The `resetVariableVirtualCache()` function clears the entire cache. The layout needs to build its cache from scratch, as if it were brand new. Other functions offer fine-grained control, so this function is often a last resort for major changes to the items in the layout.

The `addToVariableVirtualCacheAtIndex()` function inserts a new item into the cache. The existing item at that index, and any items appearing after it, will remain in the cache, but the index will increase by one.

The `removeFromVariableVirtualCacheAtIndex()` function will completely remove an item from the cache. The items that appear after the removed item will remain in the cache, but their indices will decrease by one to fill in the empty space.

The `resetVariableVirtualCacheAtIndex()` tells the layout that the cached dimensions for an item at a specific index are no longer valid, and it needs to be remeasured. The item is not removed and no other item's index will be changed.

## Trimmed Virtualized Layouts

For layouts with tens of thousands of items (or more, depending on the system), performance may begin to degrade. In these cases, the vast majority of those items are virtual, and most of them are clustered together at the beginning and end of the layout. With this in mind, we can optimize some types of virtual layouts to quickly skip many of these virtual items instead of looping through each one using the `ITrimmedVirtualLayout` interface.

## Related Links

-   [Introduction to Custom Feathers Layouts](custom-layouts.html)

For more tutorials, return to the [Feathers Documentation](start.html).


