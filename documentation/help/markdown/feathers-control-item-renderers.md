---
title: Creating custom item renderers with FeathersControl and IListItemRenderer  
author: Josh Tynjala

---
# Creating custom item renderers with `FeathersControl` and `IListItemRenderer`

The [`FeathersControl`](../api-reference/feathers/core/FeathersControl.html) class it the most basic foundation of all Feathers user interface components, including item renderers. With that in mind, if you need a custom item renderer for a [`List`](list.html) or [`GroupedList`](grouped-list.html), you're actually going to create a [custom Feathers component](index.html#custom-components). An item renderer will have a few extra properties that are needed to communicate with its owner, but ultimately, it will be very similar to any regular Feathers component.

Feathers includes three interfaces that define the API used by the `List` or `GroupedList` components to communicate with their item renderers.

-   [`IListItemRenderer`](../api-reference/feathers/controls/renderers/IListItemRenderer.html) can be used to implement an item renderer in [`List`](list.html).

-   [`IGroupedListItemRenderer`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html) can be used to implement an item renderer in [`GroupedList`](grouped-list.html).

-   [`IGroupedListHeaderOrFooterItemRenderer`](../api-reference/feathers/controls/renderers/IGroupedListHeaderOrFooterRenderer.html) can be used to implement either a header renderer or a footer renderer in [`GroupedList`](grouped-list.html).

Below, we will look at how to create a simple custom item renderer using one of these interfaces. We'll also be taking peek at many aspects of the core architecture used by the Feathers components. At the very end, the complete source code for a simple custom item renderer will be provided to offer a starting point for other custom item renderers.

<aside class="info">The [`FeathersControl`](../api-reference/feathers/core/FeathersControl.html) class comes from the low-level foundation of the Feathers architecture, and it requires an intimate knowledge of Feathers internals to use effectively. You may be able to get better performance with it over the alternative, but it's a bit trickier to manage for developers that are less experienced with Feathers. If you're looking for the easiest way to built custom item renderers, please see [Creating custom item renderers with `LayoutGroup`](layout-group-item-renderers.html) instead.</aside>

## The Simplest Item Renderer

Let's implement a very simple item renderer. It will contain a [`Label`](label.html) component to display some text and it will be possible to customize some padding around the edges.

When it's finished, we'll want to use it like this:

``` code
var list:List = new List();
list.itemRendererFactory = function():IListItemRenderer
{
    var renderer:CustomFeathersControlItemRenderer = new renderer:CustomFeathersControlItemRenderer();
    renderer.padding = 10;
    return renderer;
};
list.dataProvider = new ListCollection(
[
    { label: "One" },
    { label: "Two" },
    { label: "Three" },
    { label: "Four" },
    { label: "Five" },
]);
this.addChild(list);
```

Notice that we set a `padding` property to adjust the layout. The item renderer will get the text for its `Label` sub-component from the `label` property of an item in the data provider.

We could go crazy and add background skins, icons, the ability to customize the which field from the item that the label text comes from, and many more things. We're going to keep it simple for now to avoid making thing confusing with extra complexity.

For this example, we're creating an item renderer for a [`List`](list.html) component, but it will be virtually the exact same process to create an item renderer, header renderer, or footer renderer for a [`GroupedList`](grouped-list.html) component. You simply need to change the interface that you implement. For example, instead of the [`IListItemRenderer`](../api-reference/feathers/controls/renderers/IListItemRenderer.html) interface, you might implement the [`IGroupedListItemRenderer`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html) interface.

## Implementation Details

Let's start out with the basic framework for our custom item renderer. We want to subclass [`feathers.core.FeathersControl`](../api-reference/feathers/core/FeathersControl.html) and we want to implement the [`feathers.controls.renderers.IListItemRenderer`](../api-reference/feathers/controls/renderers/IListItemRenderer.html) interface:

``` code
package
{
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;
 
    public class CustomLayoutGroupItemRenderer extends Feathers implements IListItemRenderer
    {
        public function CustomLayoutGroupItemRenderer()
        {
        }
    }
}
```

Next, we'll implement the properties required by the `IListItemRenderer` interface.

### Implementing IListItemRenderer

The [`IListItemRenderer`](../api-reference/feathers/controls/renderers/IListItemRenderer.html) interface defines several properties, including [`owner`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#owner), [`index`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#index), [`data`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#data), and [`isSelected`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#isSelected). Each of these properties can be implemented the same way in most cases, and the relevant code is included below.

``` code
protected var _index:int = -1;
 
public function get index():int
{
    return this._index;
}
 
public function set index(value:int):void
{
    if(this._index == value)
    {
        return;
    }
    this._index = value;
    this.invalidate(INVALIDATION_FLAG_DATA);
}
```

The `index` refers to the item's location in the data provider. One use for this property might be to display it at the beginning of a label.

``` code
protected var _owner:List;
 
public function get owner():List
{
    return this._owner;
}
 
public function set owner(value:List):void
{
    if(this._owner == value)
    {
        return;
    }
    this._owner = value;
    this.invalidate(INVALIDATION_FLAG_DATA);
}
```

Use the `owner` property to access the `List` component that uses this item renderer. You might use this to listen for events from the `List`, such as to know when it begins scrolling.

``` code
protected var _data:Object;
 
public function get data():Object
{
    return this._data;
}
 
public function set data(value:Object):void
{
    if(this._data == value)
    {
        return;
    }
    this._data = value;
    this.invalidate(INVALIDATION_FLAG_DATA);
}
```

The `data` property contains the item displayed by the item renderer. The properties of this item can be used to display something in the item renderer. There are no rules for how to interpret the item's properties, but we'll show a basic example later.

``` code
protected var _isSelected:Boolean;
 
public function get isSelected():Boolean
{
    return this._isSelected;
}
 
public function set isSelected(value:Boolean):void
{
    if(this._isSelected == value)
    {
        return;
    }
    this._isSelected = value;
    this.invalidate(INVALIDATION_FLAG_SELECTED);
    this.dispatchEventWith(Event.CHANGE);
}
```

The `isSelected` property indicates if the item has been selected. It's common for an item to be selected when it is touched, but that's not required.

<aside class="info">The [`IGroupedListItemRenderer`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html) interface is very similar. Instead of an `index` property, this type of item renderer has [`groupIndex`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html#groupIndex) and [`itemIndex`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html#itemIndex) properties to specify where in the data provider the item is located. An additional [`layoutIndex`](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html#layoutIndex) property specifies the item's order in the layout, including headers and footers. The `owner` property should be typed as `GroupedList` instead of `List`, obviously.</aside>

<aside class="info">Header and footer renderers in a `GroupedList` are similar to item renderers in a `GroupedList`. See the [`IGroupedListHeaderOrFooterRenderer`](../api-reference/feathers/controls/renderers/IGroupedListHeaderOrFooterRenderer.html) interface. These renderers have a `groupIndex` and a `layoutIndex`, but no `itemIndex`.</aside>

### Adding Children

We want to display a [`Label`](label.html) component, so let's add a member variable for it:

``` code
protected var _label:Label;
```

Next, we want to create a new instance and add it as a child. We need to override `initialize()` function:

``` code
override protected function initialize():void
{
    this._label = new Label();
    this.addChild(this._label);
}
```

The `initialize()` function is called once the very first time that the component is added to the stage. It's a good place to create sub-components and other children and possibly to do things like add event listeners that you don't intend to remove until the component is disposed. In general, it is better to use `initialize()` for this sort of thing instead of the constructor.

<aside class="info">For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](component-properties-methods.html).</aside>

### Parsing the data

Next, we want to access the [`data`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#data) property and display something in our `Label` component. Let's start by overriding the `draw()` function and checking if the appropriate invalidation flag is set to indicate that the data has changed.

``` code
override protected function draw():void
{
    var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
 
    if(dataInvalid)
    {
        this.commitData();
    }
}
```

You may remember that we called the [`invalidate()`](../api-reference/feathers/core/FeathersControl.html#invalidate()) function in the setter functions above. In the `data` setter, we passed in [`INVALIDATION_FLAG_DATA`](../api-reference/feathers/core/FeathersControl.html#INVALIDATION_FLAG_DATA). Inside the `draw()` function, we call [`isInvalid()`](../api-reference/feathers/core/FeathersControl.html#isInvalid()) to see if that flag has been set.

<aside class="info">For more information about the `draw()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](component-properties-methods.html).</aside>

Let's add a `commitData()` function to call when the data changes:

``` code
protected function commitData():void
{
    if(this._data)
    {
        this._label.text = this._data.label;
    }
    else
    {
        this._label.text = null;
    }
}
```

For this particular item renderer, we're requiring all items in the data provider to have a `label` property that holds the text to display in the `Label` component. If we were building a generic item renderer, ideally, we might like to make that field name customizable, like the [`labelField`](../api-reference/feathers/controls/renderers/BaseDefaultItemRenderer.html#labelField) property in [`DefaultListItemRenderer`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html). However, let's keep it simple.

Don't forget to handle the case where the data property is `null`. You don't want any runtime errors causing you trouble.

### Measuring the Item Renderer

Next, we want the item renderer to be able to measure itself if its width and height property haven't been set another way. Before we get to that, let's add that `padding` property that we used in the example code above to add some extra space around the edges of the `Label` component:

``` code
protected var _padding:Number = 0;
 
public function get padding():Number
{
    return this._padding;
}
 
public function set padding(value:Number):void
{
    if(this._padding == value)
    {
        return;
    }
    this._padding = value;
    this.invalidate(INVALIDATION_FLAG_LAYOUT);
}
```

With that in place, let's add an `autoSizeIfNeeded()` function. This isn't something that's built into Feathers, but most of the core Feathers components have a function like this because it's a nice consistent place for a component to measure itself. To keep things easy to digest, we'll break it up into a few parts:

``` code
protected function autoSizeIfNeeded():Boolean
{
    var needsWidth:Boolean = isNaN(this.explicitWidth);
    var needsHeight:Boolean = isNaN(this.explicitHeight);
    if(!needsWidth && !needsHeight)
    {
        return false;
    }
```

Let's start by checking whether the width and height properties have been set. We have internal variables named [`explicitWidth`](../api-reference/feathers/core/FeathersControl.html#explicitWidth) and [`explicitHeight`](../api-reference/feathers/core/FeathersControl.html#explicitHeight) that will either be a valid number of pixels or they will be `NaN` if they aren't set. If both the width and the height have been set already, we can simply return without any measuring.

<aside class="info">For more information about the `explicitWidth` and `explicitHeight` variables, and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](component-properties-methods.html).</aside>

Next, we update the width and height of the `Label` sub-component. If the item renderer's explicit dimensions are `NaN`, then the explicit dimensions of the `Label` will be set to `NaN` too, meaning that the `Label` should measure itself too, just like the item renderer is doing.

``` code
this._label.width = this.explicitWidth - 2 * this._padding;
this._label.height = this.explicitHeight - 2 * this._padding;
this._label.validate();
```

Next, we want to use the width and height values from the `Label` to calculate the item renderer's final width and height:

``` code
var newWidth:Number = this.explicitWidth;
if(needsWidth)
{
    newWidth = this._label.width + 2 * this._padding;
}
var newHeight:Number = this.explicitHeight;
if(needsHeight)
{
    newHeight = this._label.height + 2 * this._padding;
}
```

In more complex item renderers, we might add together the dimensions of multiple sub-components. For this simple item renderer, we'll simply ask the `Label` sub-component for its width and height, and then we add the padding to those values.

Finally, we tell Feathers what the final dimensions will be using the [`setSizeInternal()`](../api-reference/feathers/core/FeathersControl.html#setSizeInternal()) function:

``` code
return this.setSizeInternal(newWidth, newHeight, false);
```

The return value is true if the dimensions are different than the last time that the component validated. We return this same value from `autoSizeIfNeeded()` for use in the `draw()` function.

<aside class="info">For more information about the `setSizeInternal()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](component-properties-methods.html).</aside>

Speaking of the `draw()` function, we want to add some code to call the `autoSizeIfNeeded()` from there:

``` code
override protected function draw():void
{
    var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
 
    if(dataInvalid)
    {
        this.commitData();
    }
 
    this.autoSizeIfNeeded();
}
```

Notice that we don't actually use the returned `Boolean` value. This particular component doesn't need it, but more complex components may use that value, along with [`INVALIDATION_FLAG_SIZE`](../api-reference/feathers/core/FeathersControl.html#INVALIDATION_FLAG_SIZE), to selectively call other functions.

### Adjusting the layout

We now have the final dimensions of the item renderer, so let's position and size the `Label` sub-component. Let's do that in a new `layoutChildren()` function:

``` code
protected function layoutChildren():void
{
    this._label.x = this._padding;
    this._label.y = this._padding;
    this._label.width = this.actualWidth - 2 * this._padding;
    this._label.height = this.actualHeight - 2 * this._padding;
}
```

The [`actualWidth`](../api-reference/feathers/core/FeathersControl.html#actualWidth) and [`actualHeight`](../api-reference/feathers/core/FeathersControl.html#actualHeight) variables hold the final width and height of the item renderer. These variables are derived using a combination of the explicit dimensions and the measured dimensions that we calculated before passing them to `setSizeInternal()`.

<aside class="info">For more information about the `actualWidth` and `actualHeight` variables, and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](component-properties-methods.html).</aside>

We call the `layoutChildren()` function at the end of the `draw()` function:

``` code
override protected function draw():void
{
    var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
 
    if(dataInvalid)
    {
        this.commitData();
    }
 
    this.autoSizeIfNeeded();
    this.layoutChildren();
}
```

## Source Code

The complete source code for the `CustomFeathersControlItemRenderer` class is included below:

``` code
package
{
    import feathers.controls.Label;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.FeathersControl;
 
    import starling.events.Event;
 
    public class CustomFeathersControlItemRenderer extends FeathersControl implements IListItemRenderer
    {
        public function CustomFeathersControlItemRenderer()
        {
        }
 
        protected var _label:Label;
 
        protected var _index:int = -1;
 
        public function get index():int
        {
            return this._index;
        }
 
        public function set index(value:int):void
        {
            if(this._index == value)
            {
                return;
            }
            this._index = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }
 
        protected var _owner:List;
 
        public function get owner():List
        {
            return this._owner;
        }
 
        public function set owner(value:List):void
        {
            if(this._owner == value)
            {
                return;
            }
            this._owner = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }
 
        protected var _data:Object;
 
        public function get data():Object
        {
            return this._data;
        }
 
        public function set data(value:Object):void
        {
            if(this._data == value)
            {
                return;
            }
            this._data = value;
            this.invalidate(INVALIDATION_FLAG_DATA);
        }
 
        protected var _isSelected:Boolean;
 
        public function get isSelected():Boolean
        {
            return this._isSelected;
        }
 
        public function set isSelected(value:Boolean):void
        {
            if(this._isSelected == value)
            {
                return;
            }
            this._isSelected = value;
            this.invalidate(INVALIDATION_FLAG_SELECTED);
            this.dispatchEventWith(Event.CHANGE);
        }
 
        protected var _padding:Number = 0;
 
        public function get padding():Number
        {
            return this._padding;
        }
 
        public function set padding(value:Number):void
        {
            if(this._padding == value)
            {
                return;
            }
            this._padding = value;
            this.invalidate(INVALIDATION_FLAG_LAYOUT);
        }
 
        override protected function initialize():void
        {
            if(!this._label)
            {
                this._label = new Label();
                this.addChild(this._label);
            }
        }
 
        override protected function draw():void
        {
            var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
 
            if(dataInvalid)
            {
                this.commitData();
            }
 
            this.autoSizeIfNeeded();
            this.layoutChildren();
        }
 
        protected function autoSizeIfNeeded():Boolean
        {
            var needsWidth:Boolean = isNaN(this.explicitWidth);
            var needsHeight:Boolean = isNaN(this.explicitHeight);
            if(!needsWidth && !needsHeight)
            {
                return false;
            }
 
            this._label.width = this.explicitWidth - 2 * this._padding;
            this._label.height = this.explicitHeight - 2 * this._padding;
            this._label.validate();
 
            var newWidth:Number = this.explicitWidth;
            if(needsWidth)
            {
                newWidth = this._label.width + 2 * this._padding;
            }
            var newHeight:Number = this.explicitHeight;
            if(needsHeight)
            {
                newHeight = this._label.height + 2 * this._padding;
            }
 
            return this.setSizeInternal(newWidth, newHeight, false);
        }
 
        protected function commitData():void
        {
            if(this._data)
            {
                this._label.text = this._data.label;
            }
            else
            {
                this._label.text = null;
            }
        }
 
        protected function layoutChildren():void
        {
            this._label.x = this._padding;
            this._label.y = this._padding;
            this._label.width = this.actualWidth - 2 * this._padding;
            this._label.height = this.actualHeight - 2 * this._padding;
        }
    }
}
```

## Next Steps

Looking to do more with your custom item renderer? Check out the [Feathers Cookbook](cookbook/index.html) for "recipes" that show you how to implement typical features in custom item renderers.

## Related Links

-   [Introduction to Custom Item Renderers](item-renderers.html)

-   [Feathers Cookbook: Recipes for Custom Item Renderers](cookbook/index.html#custom_item_renderers)

-   [`feathers.controls.renderers.IListItemRenderer` API Documentation](../api-reference/feathers/controls/renderers/IListItemRenderer.html)

-   [`feathers.controls.renderers.IGroupedListItemRenderer` API Documentation](../api-reference/feathers/controls/renderers/IGroupedListItemRenderer.html)

-   [`feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer` API Documentation](../api-reference/feathers/controls/renderers/IGroupedListHeaderOrFooterRenderer.html)

For more tutorials, return to the [Feathers Documentation](index.html).


