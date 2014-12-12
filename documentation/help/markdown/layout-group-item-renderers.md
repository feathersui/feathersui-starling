---
title: Creating custom item renderers with the Layout Group container  
author: Josh Tynjala

---
# Creating custom item renderers with the Layout Group container

The `LayoutGroup` container is a simple Feathers component that holds children and provides the ability to specify a layout. This makes an ideal base for any [custom component](index.html#custom_components), but it's especially useful for custom item renderers in the `List` and `GroupedList` components.

Feathers includes three subclasses of `LayoutGroup` that are designed specifically to help you get started creating custom item renderers.

-   `LayoutGroupListItemRenderer` can be used as an item renderer in `List`.

-   `LayoutGroupGroupedListItemRenderer` can be used as an item renderer in `GroupedList`.

-   `LayoutGroupGroupedListHeaderOrFooterRenderer` can be used as either a header renderer or a footer renderer in `GroupedList`.

All of these classes implement the required functions from their respective interfaces, to save you time on bootstrapping code, and they provide a couple of useful functions that you can override the update the layout and the parse the data without worrying about the lowest level parts of the Feathers component architecture.

Below, we will look at how to create a simple custom item renderer by extending one of these classes. At the very end, the complete source code for a simple custom item renderer will be provided to offer a starting point for other custom item renderers.

These base classes for item renderers based on `LayoutGroup` provide the easiest way to build custom item renderers in Feathers. However, they have the risk of lower performance. For a more advanced approach at a lower level in the Feathers architecture, please see [Custom Item Renderers with FeathersControl and IListItemRenderer](feathers-control-item-renderers.html) instead.

## The Simplest Item Renderer

Let's implement a very simple item renderer. It will contain a `Label` component to display some text and it will be possible to customize some padding around the edges.

When it's finished, we'll want to use it like this:

``` code
var list:List = new List();
list.itemRendererFactory = function():IListItemRenderer
{
    var renderer:CustomLayoutGroupItemRenderer = new CustomLayoutGroupItemRenderer();
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

For this example, we're creating an item renderer for a `List` component, but it will be the exact same process to create an item renderer, header renderer, or footer renderer for a `GroupedList` component. You simply need to change the class that you extend.

## Implementation Details

Let's start out with the basic framework for our custom item renderer. We want to subclass `feathers.controls.renderers.LayoutGroupListItemRenderer`:

``` code
package
{
    import feathers.controls.renderers.LayoutGroupListItemRenderer;
 
    public class CustomLayoutGroupItemRenderer extends LayoutGroupListItemRenderer
    {
        public function CustomLayoutGroupItemRenderer()
        {
        }
    }
}
```

This base class implements `IListItemRenderer`, so the `data`, `index`, and `owner` properties that the `List` component sets on an item renderer are already there for us.

### Adding Children

We want to display a `Label` component, so let's add a member variable for it:

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

For more information about the `initialize()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](http://wiki.starling-framework.org/feathers/component-properties-methods).

### Parsing the data

Next, we want to access the `data` property and display something in our `Label` component. Override the convenient `commitData()` function to do this:

``` code
override protected function commitData():void
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

For this particular item renderer, we're requiring all items in the data provider to have a `label` property that holds the text to display in the `Label` component. If we were building a generic item renderer, ideally, we might like to make that field name customizable, like the `labelField` property in `DefaultListItemRenderer`. However, let's keep it simple.

Don't forget to handle the case where the data property is `null`. You don't want any runtime errors causing you trouble.

### Adjusting the layout

Let's handle how the `Label` sub-component will be positioned and sized within the item renderer. We generally want to use a fluid layout that can handle changes in the dimensions of the item renderer (which are ultimately controlled by the parent `List` component). `AnchorLayout` is ideal for this situation.

At the beginning of the `initialize()` function, let's create our `AnchorLayout` instance:

``` code
override protected function initialize():void
{
    this.layout = new AnchorLayout();
```

Now, in order to have the `AnchorLayout` control the `Label` component's positioning and dimensions, we need to pass an `AnchorLayoutData` instance to the `Label` component. Let's do that next:

``` code
override protected function initialize():void
{
    this.layout = new AnchorLayout();
 
    var labelLayoutData:AnchorLayoutData = new AnchorLayoutData();
    labelLayoutData.top = 0;
    labelLayoutData.right = 0;
    labelLayoutData.bottom = 0;
    labelLayoutData.left = 0;
 
    this._label = new Label();
    this._label.layoutData = this._labelLayoutData;
```

We've constrained the `Label` component to all four edges of the item renderer. If the item renderer's width grows or shrinks, the `Label` component will be resized appropriately.

With that finished, we now have a fully working item renderer. However, we probably don't want the `Label` component to fill the item renderer right up to the edges. We probably want a little space around the edge to allow the labels to breathe when they appear next to each other in the list. Let's add a `padding` property to customize this spacing around the edges:

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

When we change a property that requires the component to change something about its appearance, we need to call the `invalidate()` function. This will tell the component that it needs to update its appearance before the next time that Starling renders to the screen. We'll explain that constant, `INVALIDATION_FLAG_LAYOUT`, in a moment.

For more information about the `invalidate()` function and other parts of the Feathers architecture, see [Anatomy of a Feathers Component](http://wiki.starling-framework.org/feathers/component-properties-methods).

The base class offers a `preLayout()` function that you can override to update layout properties on children *before* the layout code is run. We're going to update the `Label` component's `AnchorLayoutData` in this function:

``` code
override protected function preLayout():void
{
    var labelLayoutData:AnchorLayoutData = AnchorLayoutData(this._label.layoutData);
    labelLayoutData.top = this._padding;
    labelLayoutData.right = this._padding;
    labelLayoutData.bottom = this._padding;
    labelLayoutData.left = this._padding;
}
```

If we had additional children in the item renderer, we'd adjust their `layoutData` properties in this function too. With `AnchorLayoutData`, we're not limited to constraining children to the edges of their parent container. We can also position those children relative to the center of the container, both horizontally and vertical. We can even position children relative to each other too! For complete details, see [Anchor Layout in Feathers](anchor-layout.html).

The base class also offers a `postLayout()` function that can be overridden to update anything *after* the layout code has run. We won't be using that one here, though.

## Source Code

The complete source code for the `CustomLayoutGroupItemRenderer` class is included below:

``` code
package
{
    import feathers.controls.Label;
    import feathers.controls.renderers.LayoutGroupListItemRenderer;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
 
    public class CustomLayoutGroupItemRenderer extends LayoutGroupListItemRenderer
    {
        public function CustomLayoutGroupItemRenderer()
        {
        }
 
        protected var _label:Label;
 
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
            this.layout = new AnchorLayout();
 
            var labelLayoutData:AnchorLayoutData = new AnchorLayoutData();
            labelLayoutData.top = 0;
            labelLayoutData.right = 0;
            labelLayoutData.bottom = 0;
            labelLayoutData.left = 0;
 
            this._label = new Label();
            this._label.layoutData = labelLayoutData;
            this.addChild(this._label);
        }
 
        override protected function commitData():void
        {
            if(this._data && this._owner)
            {
                this._label.text = this._data.label;
            }
            else
            {
                this._label.text = null;
            }
        }
 
        override protected function preLayout():void
        {
            var labelLayoutData:AnchorLayoutData = AnchorLayoutData(this._label.layoutData);
            labelLayoutData.top = this._padding;
            labelLayoutData.right = this._padding;
            labelLayoutData.bottom = this._padding;
            labelLayoutData.left = this._padding;
        }
    }
}
```

## Next Steps

Looking to do more with your custom item renderer? Check out the [Feathers Cookbook](cookbook/index.html) for "recipes" that show you how to implement typical features in custom item renderers and in other Feathers UI components.

## Related Links

-   [Introduction to Custom Item Renderers](item-renderers.html)

-   [Feathers Cookbook: Recipes for Custom Item Renderers](cookbook/index.html#custom_item_renderers)

-   [LayoutGroupListItemRenderer API Documentation](http://feathersui.com/documentation/feathers/controls/renderers/LayoutGroupListItemRenderer.html)

-   [LayoutGroupGroupedListItemRenderer API Documentation](http://feathersui.com/documentation/feathers/controls/renderers/LayoutGroupGroupedListItemRenderer.html)

-   [LayoutGroupGroupedListHeaderOrFooterRenderer API Documentation](http://feathersui.com/documentation/feathers/controls/renderers/LayoutGroupGroupedListHeaderOrFooterRenderer.html)

For more tutorials, return to the [Feathers Documentation](index.html).


