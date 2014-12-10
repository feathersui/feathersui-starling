# Feathers Cookbook: Adding a background skin to a custom item renderer based on FeathersControl and IListItemRenderer

The example [custom item renderer with FeathersControl and IListItemRenderer](../feathers-control-item-renderers.html) offers an easy-to-understand foundation to build upon. It's pretty limited in features, though. For instance, you may want some kind of background skin.

## A backgroundSkin getter and setter

Let's start by adding a `backgroundSkin` property to our custom item renderer class:

``` code
private var _backgroundSkin:DisplayObject;
 
public function get backgroundSkin():DisplayObject
{
    return this._backgroundSkin;
}
 
public function set backgroundSkin(value:DisplayObject):void
{
    if(this._backgroundSkin == value)
    {
        return;
    }
    if(this._backgroundSkin)
    {
        this.removeChild(this._backgroundSkin, true);
    }
    this._backgroundSkin = value;
    if(this._backgroundSkin)
    {
        this.addChildAt(this._backgroundSkin, 0);
    }
    this.invalidate(INVALIDATION_FLAG_SKIN);
}
```

Notice that if an old background skin already exists, we remove it. Then, if the new background skin isn't `null`, we add it as a child at index `0`. This will ensure that the background skin is always at the bottom.

### Resizing the background skin

As you may recall, the example custom item renderer based on `FeathersControl` and `IListItemRenderer` had a `layoutChildren()` function. Let's simply set the width and height of the background skin in there.

``` code
protected function layoutChildren():void
{
    if(this._backgroundSkin)
    {
        this._backgroundSkin.width = this.actualWidth;
        this._backgroundSkin.height = this.actualHeight;
    }
 
    // position and resize other children here
}
```

You probably also want to include the background skin with the measurement calculations inside the `autoSizeIfNeeded()` function:

``` code
var newWidth:Number = this.explicitWidth;
if(needsWidth)
{
    newWidth = this._label.width + 2 * this._padding;
    var backgroundWidth:Number = this._backgroundSkin.width;
    if(backgroundWidth > newWidth)
    {
        newWidth = backgroundWidth;
    }
}
var newHeight:Number = this.explicitHeight;
if(needsHeight)
{
    newHeight = this._label.height + 2 * this._padding;
    var backgroundHeight:Number = this._backgroundSkin.height;
    if(backgroundHeight > newWidth)
    {
        newWidth = backgroundHeight;
    }
}
```

Instead of always using the current dimensions of the background skin for measurement, we could save the dimensions of the background skin in member variables when the `backgroundSkin` setter is called. Let's say that we call the variables `originalBackgroundSkinWidth` and `originalBackgroundSkinHeight`. This will allow us to always measure using the original dimensions of the background skin instead of basing the measurement on the `this._backgroundSkin.width` and `this._backgroundSkin.height` values that may get changed in `layoutChildren()`.

## Multiple background skins

The example code above adds only a single background skin. What if you want to display a different background skin for each touch phase?

-   [Cookbook: Handling touch states in a custom item renderer](item-renderer-touch-states.html)

## Related Links

-   [Introduction to Custom Item Renderers](../item-renderers.html)

This is a recipe in the [Feathers Cookbook](index.html). For more information about Feathers, return to the [Feathers Documentation](../index.html).


