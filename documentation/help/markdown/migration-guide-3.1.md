---
title: Feathers 3.1 Migration Guide  
author: Josh Tynjala

---
# Feathers 3.1 Migration Guide

This guide explains how to migrate an application created with [Feathers 3.0](migration-guide-3.0.html) to Feathers 3.1. Be aware that, as a minor update, the new features in this version are not considered "breaking" changes. You are not required to make any modifications to your projects to update to this version. However, you will see benefits from switching to some of the newer, simplified APIs. The focus of this release is to improve the developer experience, especially when dealing with font styles and skinning.

-   [Font styles with `starling.text.TextFormat`](#font-styles-with-starling.text.textformat)

-   [Style properties and themes](#style-properties-and-themes)

## Font styles with `starling.text.TextFormat`

Starling 2 introduced a new [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) class that defines common font styles used by all types of text, including bitmap fonts and TTF/OTF fonts. Previously, to customize font styles on Feathers [text renderers](text-renderers.html), you needed to use different classes and set different properties, depending on which text renderer you were using. For instance, [`TextBlockTextRenderer`](text-block-text-renderer.html) has an `elementFormat` property of type `flash.text.engine.ElementFormat` while [`TextFieldTextRenderer`](text-field-text-renderer.html) has a `textFormat` property of type `flash.text.TextFormat`. Now, all text renderers have a unified way to support the `starling.text.TextFormat` class.

In fact, the font styles don't need to be set directly on the text renderer anymore. Instead, you can set them on the component that uses the text renderer, such as a `Label` or `Button`. They parent component will automatically pass them down to the text renderer.

Let's customize the font styles on a [`Label`](label.html) component to see how it works:

``` code
var label:Label = new Label();
label.text = "Hello World";
label.fontStyles = new TextFormat( "_sans", 20, 0xff0000 );
this.addChild( label );
```

That's it! In the vast majority of cases, you won't need to deal with the text renderer factories at all.

If we wanted the `Label` to use different font styles when disabled, we can do that easily too:

``` code
label.disabledFontStyles = new TextFormat( "_sans", 20, 0x999999 );
```

Most components that contain a text renderer will now have `fontStyles` and `disabledFontStyles` properties. If a component can be toggled or selected, it may also have a `selectedFontStyles` property.

Finally, if a component supports a more complex set of mutiple states, such as the touch states in a `Button`, it will have a `setFontStylesForState()` method. This method accepts the name of the state along with a `TextFormat` object to use when the component is in that state. In the following example, we set separate font styles for the "down" and "hover" states of a [`Button`](button.html):

``` code
var button:Button = new Button();
button.setFontStylesForState( ButtonState.DOWN, new TextFormat( "_sans", 20, 0xffffff ) );
button.setFontStylesForState( ButtonState.HOVER, new TextFormat( "_sans", 20, 0xff9999 ) );
```

## Style properties and themes

In previous versions of Feathers, it was easy to run into conflicts with the theme when attempting to skin components. To avoid this issue, you could use the [`AddOnFunctionStyleProvider`](http://feathersui.com/api-reference/feathers/skins/AddOnFunctionStyleProvider.html) class, set the [`styleProvider`](../api-reference/feathers/core/FeathersControl.html#styleProvider) property to `null`, wait until a component initialized, or [extend the theme](extending-themes.html). However, each of these options could be somewhat cumbersome for minor tweaks to a single component's appearance.

Starting with Feathers 3.1, certain properties are now considered "styles". If you set a "style property" outside of the theme, you don't need to worry about the theme replacing it later. However, any other styles from the theme won't be affected. As an example, if you wanted to customize a button's font styles outside the theme, but keep the background skin from the theme, it's easy.

``` code
var button:Button = new Button();
button.label = "Click Me";
//this can't be replaced by the theme
button.fontStyles = new TextFormat( "_sans", 20, 0xff0000 );
this.addChild( button );
```

To see how style are now separated from other properties in the API reference, see the [`Button` component styles](../api-reference/feathers/controls/Button.html#styleSummary) as an example.

### Minimum dimensions in the theme

Be aware that if you set a regular property in a theme, it may still conflict with code outside of the them. For example, you should not set the `minWidth` and `minHeight` properties directly on a component in a theme. These properties are **not** considered styles, and you may run into conflicts if you also try to set them outside of the theme.

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

If a component doesn't have explicit dimensions, it will always use the skin's dimensions for measurement. With that mind, setting dimensions on the button's skin in the code above is virtually the same as setting dimensions directly on the button.

What if a component doesn't need to display a background skin? Consider using a transparent background skin, in that case. You might simply pass in a `starling.display.Quad` with its `alpha` property set to `0`:

``` code
var backgroundSkin:Quad = new Quad( 40, 20 );
backgroundSkin.alpha = 0;
component.backgroundSkin = backgroundSkin;
```

Starling will not ask the GPU to render a fully transparent display object, so this background cannot affect draw calls or performance. However, the dimensions of the `Quad` will be treated as minimum dimensions for the component.

<aside class="info">When a display object doesn't have `minWidth` and `minHeight` properties, like a `Quad`, its regular `width` and `height` properties also serve as minimum values. If you need `minWidth` and `minHeight` to have smaller values than `width` and `height`, respectively, consider using `feathers.skins.ImageSkin`.</aside>

## Related Links

-   [Feathers 3.0 Migration Guide](migration-guide-3.0.html)