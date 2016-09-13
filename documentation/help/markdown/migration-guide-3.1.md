---
title: Feathers 3.1 Migration Guide  
author: Josh Tynjala

---
# Feathers 3.1 Migration Guide

This guide explains how to migrate an application created with [Feathers 3.0](migration-guide-3.0.html) to Feathers 3.1. While the following changes are not required or "breaking" changes, migration will result in simplified skinning code and more flexibility to customize skins outside of a theme.

-   [Font styles with `starling.text.TextFormat`](#font-styles-with-starling.text.textformat)

-   [Style properties and themes](#style-properties-and-themes)

## Font styles with `starling.text.TextFormat`

Starling 2 introduces a new `starling.text.TextFormat` class.

## Style properties and themes

In previous versions of Feathers, it was easy to run into conflicts with the theme when attempting to skin components. to avoid this issue, you could use the `AddOnFunctionStyleProvider` class, set the `styleProvider` property to `null`, or extend the theme. However, each of these options could be somewhat cumbersome for minor tweaks to a component's appearance.

Starting with Feathers 3.1, certain properties are now considered "styles". If you set a "style property" outside of the theme, you don't need to worry about the theme replacing it later. Any other styles from the theme won't be affected. As an example, if you wanted to customize a button's font styles, but keep the background skin, it's easy.

``` code
var button:Button = new Button();
button.label = "Click Me";
//this won't be replaced by the theme
button.fontStyles = new TextFormat( "_sans", 20, 0xff0000 );
this.addChild( button );
```

### Minimum dimensions in the theme

You should not set the `minWidth` and `minHeight` properties directly on a component. These properties are **not** considered styles, and you may run into conflicts if you also try to set them outside of the theme.

``` code
//inside the theme
private function setButtonStyles( button:Button ):void
{
	button.defaultSkin = new ImageSkin( texture );
	button.minWidth = 40; //don't do this!
}
```

Instead, set `minWidth` and `minHeight` on the component's skin:

``` code
//inside the theme
private function setButtonStyles( button:Button ):void
{
	var skin:ImageSkin = new ImageSkin( texture );
	skin.minWidth = 40;
	skin.minHeight = 20;
	button.defaultSkin = backgroundSkin;
}
```

If a component doesn't have explicit dimensions, it will always use the skin's dimensions for measurement. With that mind, setting dimensions on the skin is virtually the same as setting dimensions directly on the button.

What if a component doesn't need to display a background skin? Consider the possibility that you might actually consider the background skin to be transparent, in that case. You can simply use a `starling.display.Quad` with its `alpha` property set to `0`:

``` code
var backgroundSkin:Quad = new Quad( 40, 20 );
backgroundSkin.alpha = 0;
component.backgroundSkin = backgroundSkin;
```

Starling will not render a fully transparent background, so it will not affect draw calls or performance. However, the dimensions of the `Quad` will be treated as minimum dimensions for the component.

<aside class="info">When a display object doesn't have `minWidth` and `minHeight` properties, it's regular `width` and `height` properties also serve as minimum values. If you need `minWidth` and `minHeight` to have smaller values than `width` and `height`, respectively, consider using `feathers.skins.ImageSkin`.</aside>

## Related Links

-   [Feathers 3.0 Migration Guide](migration-guide-3.0.html)