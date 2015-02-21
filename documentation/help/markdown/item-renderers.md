---
title: Creating custom item renderers for the Feathers List and GroupedList components  
author: Josh Tynjala

---
# Creating custom item renderers for the Feathers `List` and `GroupedList` components

The [default item renderers](default-item-renderers.html) provide an abundance of customization options to display up to three children with a variety of layouts. However, sometimes, you need more children or more advanced layout capabilities to translate a design to code for a customized list. In those situations, you may need to create a custom item renderer class.

Custom item renderers are basically [custom Feathers components](index.html#custom_components). When you create a custom item renderer, you will be working at a low level inside the Feathers architecture. Ideally, you should understand the internals of Feathers components before proceeding.

## Getting Started

-   [FAQ: What is layout virtualization?](faq/layout-virtualization.html)

-   [Custom Item Renderers with `LayoutGroup`](layout-group-item-renderers.html)

-   [Custom Item Renderers with `FeathersControl` and `IListItemRenderer`](feathers-control-item-renderers.html)

## Further Reading

-   [Cookbook: Adding a background skin to a custom item renderer based on `FeathersControl` and `IListItemRenderer`](cookbook/item-renderer-background-skin.html)

-   [Cookbook: Handling touch states in a custom item renderer](cookbook/item-renderer-touch-states.html)

-   [Cookbook: Selecting a custom item renderer on tap or click](cookbook/item-renderer-select-on-tap.html)

-   [Cookbook: Dispatching a triggered event from a custom item renderer](cookbook/item-renderer-triggered-on-tap.html)

-   [Cookbook: Dispatching a long press event from an item renderer](cookbook/item-renderer-long-press.html)

-   [Cookbook: Prevent a `List` from scrolling when a child of a custom item renderer is touched](cookbook/item-renderer-stop-scrolling.html)

## Related Links

-   [How to use the Feathers `List` component](list.html)

-   [How to use the Feathers `GroupedList` component](grouped-list.html)

-   [How to use the Feathers Default Item Renderers](default-item-renderers.html)