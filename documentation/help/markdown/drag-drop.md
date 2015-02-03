---
title: Drag and drop between Feathers components  
author: Josh Tynjala

---
# Drag and drop between Feathers components

<aside class="warn">The following description of how to use the Feathers [`DragDropManager`](../api-reference/feathers/dragDrop/DragDropManager.html) is taken from [this forum thread](http://forum.starling-framework.org/topic/would-you-please-give-us-an-examples-on-how-to-use-dragdropmanager). This text combines multiple posts into a single source, without much editing, so refer to the linked thread if some context is missing. More thorough documentation will be added in the future.</aside>

<aside class="info">In the `examples/DragDrop` directory that comes with Feathers, you can find a simple, working example of the `DragDropManager`.</aside>

1) You need to implement the [`IDragSource`](../api-reference/feathers/dragDrop/IDragSource.html) and [`IDropTarget`](../api-reference/feathers/dragDrop/IDropTarget.html) interfaces on the appropriate objects.

2) Call [`DragDropManager.startDrag()`](../api-reference/feathers/dragDrop/DragDropManager.html#startDrag()), passing in the `IDragSource`, the [`Touch`](http://doc.starling-framework.org/core/starling/events/Touch.html) object that initiated the drag, and a [`DragData`](../api-reference/feathers/dragDrop/DragData.html) object which stores the data that is being dragged. You can specify data by "format" so that different targets can accept different types of data.

3) When the `IDropTarget` dispatches [`DragDropEvent.DRAG_ENTER`](../api-reference/feathers/events/DragDropEvent.html#DRAG_ENTER) (the `DragDropManager` handles the event dispatching, you just need to listen), and the `DragData` object includes data of the correct format, it should call [`DragDropManager.acceptDrag()`](../api-reference/feathers/dragDrop/DragDropManager.html#acceptDrag()).

4) The `IDropTarget` will dispatch [`DragDropEvent.DRAG_DROP`](../api-reference/feathers/events/DragDropEvent.html#DRAG_DROP) if you drop the object (stop touching or release the mouse button) over the `IDropTarget`. If it does, you need to handle the drop in the event listener.

5) The `IDragSource` will dispatch [`DragDropEvent.DRAG_COMPLETE`](../api-reference/feathers/events/DragDropEvent.html#DRAG_COMPLETE) whether the drop was accepted or not. The [`isDropped`](../api-reference/feathers/events/DragDropEvent.html#isDropped) property of the event is a `Boolean` that indicates if the drag was successfully dropped on a target that accepted it, of if it was cancelled. If the data that was dragged needs to be removed from the source after being dropped on the target, this event listener is the place to do it. Just check the `isDropped` property to see if it was dropped or cancelled.

You can pass the "ghosted drag image" as the "avatar" when you call `DragDropManager.startDrag()`. The avatar is what follows the mouse while you're dragging.

The format is what actually gets passed between the drag source and the drop target. This may be the same as the avatar, or it may be something more data-centric, like the data for a list item.

Usually, if you're simply dragging a display object around (that has no data associated with it like a list item would), you could add the display object itself as the drag data. Something like this is probably fine:

``` code
var dragData:DragData = new DragData();
dragData.setDataForFormat("display-object-drag-format", theDisplayObject);
```

In this case, I randomly called the format `"display-object-drag-format"`, but call it whatever you want. It just needs to be a string that both sides (the drag source and the drop target) agree on.

Then in your `DragDropEvent.DRAG_ENTER` listener, you can check for that format:

``` code
function(event:DragDropEvent, dragData:DragData):void
{
    if(dragData.hasDataForFormat("display-object-drag-format"))
    {
        DragDropManager.acceptDrag(this);
    }
}
```

In the `DragDropEvent.DRAG_DROP` listener, you use `dragData.getDataForFormat()` with the same string to retrieve the display object or other data.

## Related Links

-   [`feathers.dragDrop.DragDropManager` API Documentation](../api-reference/feathers/dragDrop/DragDropManager.html)