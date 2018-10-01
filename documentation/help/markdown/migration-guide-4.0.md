---
title: Feathers 4.0 Migration Guide  
author: Josh Tynjala

---
# Feathers 4.0 Migration Guide

This guide explains how to migrate an application created with Feathers 3 to Feathers 4.0.

-   [Removed APIs that were deprecated in Feathers 3](#removed-apis-that-were-deprecated-in-feathers-3)
-   [Themes and `AssetManager`](#themes-and-assetmanager)
-   [New `dragProxy` property on `IListItemRenderer`]

## Removed APIs that were deprecated in Feathers 3

A number of APIs were deprecated in Feathers 3. See the [Feathers 3.0 Migration Guide](migration-guide-3.0.html) and the [Feathers 3.3 Migration Guide](migration-guide-3.3.html) for complete details.

## Themes and `AssetManager`

Feathers example themes that use [Starling's Asset Manager](http://manual.starling-framework.org/en/#_asset_management) have been upgraded to the new [`starling.assets.AssetManager`](http://doc.starling-framework.org/current/starling/assets/AssetManager.html) class that was added in Starling v2.4.

The new `AssetManager` handles errors differently, so the example themes now dispatch a different set of events. In previous versions, the themes dispatched separate `Event.PARSE_ERROR`, `Event.SECURITY_ERROR` and `Event.IO_ERROR` events. Starting in Feathers 4.0, the example themes dispatch a generic `FeathersEventType.ERROR` event for all event types. This change is required because the new `AssetManager` no longer differentiates between different types of errors.

An example event listener for `FeathersEventType.ERROR` appears below:

``` code
theme.addEventListener(FeathersEventType.ERROR, function(event:Event, error:String):void
{
	trace("AssetManager error:", error);
});
```

The `Event.COMPLETE` event dispatched by the example themes has not changed.

## New `dragProxy` property on `IListItemRenderer`

A new [`dragProxy`](../api-reference/feathers/controls/renderers/IListItemRenderer.html#dragProxy) property has been added to the [`IListItemRenderer`](../api-reference/feathers/controls/renderers/IListItemRenderer.html) interface to allow customization of drag and drop behavior. If you have created a custom item renderer that directly implements the `IListItemRenderer` interface, you will need to add a new getter function for `dragProxy`.

In most cases, you can add the following implementation that simply returns `null`:

``` code
public function get dragProxy():DisplayObject
{
	return null;
}
```

You may return any child of the item renderer instead, if needed.

If your custom item renderer extends [`LayoutGroupListItemRenderer`](../api-reference/feathers/controls/renderers/LayoutGroupListItemRenderer.html), this method is already implemented and you don't need to do anything. However, you may override it if you need to return a custom value.

The [`DefaultListItemRenderer`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html) class implements this the `dragProxy` getter too, and it returns the value of the new [`dragIcon`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html#dragIcon) property.

## Related Links

-   [Feathers 3.0 Migration Guide](migration-guide-3.0.html)
-   [Feathers 3.3 Migration Guide](migration-guide-3.3.html)