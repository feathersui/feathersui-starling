---
title: Feathers 3.3 Migration Guide  
author: Josh Tynjala

---
# Feathers 3.3 Migration Guide

This guide explains how to migrate an application created with Feathers 3.2 to Feathers 3.3.

-   [Shared font styles](#shared-font-styles)

-   [Changes to implicit MXML imports](#changes-to-implicit-mxml-imports)

-   [Appendix: List of Deprecated APIs](#appendix-list-of-deprecated-apis)

## Shared font styles

In Feathers versions 3.1.2 and 3.2.0, whenever a `starling.text.TextFormat` was passed into a text renderer, it was always cloned. This was a workaround to avoid a memory leak caused by event listeners that were not being removed. It also had an unfortunate side effect where you could not modify properties of the original reference to the `TextFormat` object and see those changes reflected in the component. It also didn't let you simultaneously change the font styles of multiple components that share the same `TextFormat`. That had been possible in previous versions of Feathers, before 3.1.2.

This bug has now been fixed in Feathers 3.3.0, including a fix for the original memory leak. However, if you were not aware that modifying a shared `TextFormat` object could affect other components, you may discover unexpected changes to font styles when upgrading.

In Feathers 3.1.2 and 3.2.0, the following code would modify the color of only `label2`:

``` actionscript
var myFontStyles:TextFormat = new TextFormat("_sans", 12, 0x000000);
label1.fontStyles = myFontStyles;
label2.fontStyles = myFontStyles;
label2.fontStyles.color = 0xff0000; //should actually change both!
```

However, it was actually supposed to modify the color of both labels, and that's what you will now see in Feathers 3.3. If you don't want both labels to use the modified color, you should use `clone()` to ensure that each label uses a different `TextFormat` object:

``` actionscript
var myFontStyles:TextFormat = new TextFormat("_sans", 12, 0x000000);
label1.fontStyles = myFontStyles.clone();
label2.fontStyles = myFontStyles.clone();
label2.fontStyles.color = 0xff0000; //changes only label2
```

## Changes to implicit MXML imports

In Feathers SDK 3.3, two changes have been made to the "implicit" imports when using MXML. As you may be aware, certain packages are automatically imported in an MXML file, and if you use any classes from one of those packages, they do not need to be imported manually.

Because Feathers has embraced the use of [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) for font styles, the `starling.text.*` package is now imported implicitly in MXML.

To avoid conflicts between classes in the `starling.text.*` package and the `flash.text.*` package, `flash.text.*` is no longer implicitly imported in MXML.

If you are using a class from the `flash.text.*` package in MXML, and you see new compiler errors after upgrading to Feathers SDK 3.3, simply import those classes at the beginning of the `<fx:Script>` block.

## Appendix: List of Deprecated APIs

The following tables list all deprecated APIs, organized by class. The replacement API or migration instructions appear next to each listed property or method.

<aside class="warn">APIs that are deprecated have not been removed yet, but they will be removed at some point in the future. You are encouraged to migrate as soon as possible.</aside>


### `TiledColumnsLayout`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`TiledColumnsLayout.PAGING_HORIZONTAL`					| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`TiledColumnsLayout.PAGING_VERTICAL`					| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`TiledColumnsLayout.PAGING_NONE`						| [`Direction.NONE`](../api-reference/feathers/layout/Direction.html#NONE)

### `TiledRowsLayout`

Deprecated API										| How to Migrate
--------------------------------------------------- | ---------------------
`TiledRowsLayout.PAGING_HORIZONTAL`					| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`TiledRowsLayout.PAGING_VERTICAL`					| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`TiledRowsLayout.PAGING_NONE`						| [`Direction.NONE`](../api-reference/feathers/layout/Direction.html#NONE)

## Related Links

-   [Feathers 3.1 Migration Guide](migration-guide-3.1.html)
-   [Feathers 3.0 Migration Guide](migration-guide-3.0.html)