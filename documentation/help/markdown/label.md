---
title: How to use the Feathers Label component  
author: Josh Tynjala

---
# How to use the Feathers `Label` component

The [`Label`](../api-reference/feathers/controls/Label.html) component is for displaying text. It uses a [text renderer](text-renderers.html).

<figure>
<img src="images/label.png" srcset="images/label@2x.png 2x" alt="Screenshot of a Feathers Label component" />
<figcaption>`Label` components skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

### The Basics

First, let's create a `Label` control, give it some text to display, and add it to the display list:

``` code
var label:Label = new Label();
label.text = "Hello World";
this.addChild( label );
```

## Styling the `Label`

For full details about what skin and style properties are available, see the [`Label` API reference](../api-reference/feathers/controls/Label.html). We'll look at a few of the most common properties below.

### Styling the Text Renderer

This section explains how to customize the [text renderer](text-renderers.html) sub-component. Feathers provides multiple text renderers to choose from, and each one will have different properties that may be set to customize font styles and other capabilities. For more information about text renderers, including which ones are available, please read [Introduction to Feathers Text Renderers](text-renderers.html).

If you are not using a theme, you can use [`textRendererFactory`](../api-reference/feathers/controls/Label.html#textRendererFactory) to provide styles for the label's text renderer:

``` code
label.textRendererFactory = function():ITextRenderer
{
    var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
    textRenderer.textFormat = new BitmapFontTextFormat( myPixelFont );
    textRenderer.smoothing = TextureSmoothing.NONE;
    return textRenderer;
}
```

In the example above, we provide styles for a [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html). The styles for another text renderer, like [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html), will be different:

``` code
label.textRendererFactory = function():ITextRenderer
{
    var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
    textRenderer.textFormat = new TextFormat( "Arial", 24, 0x323232 );
    textRenderer.embedFonts = true;
    textRenderer.isHTML = true;
    return textRenderer;
}
```

It is best to look at the API documentation for the specific text renderer that you are using to see what capabilities it exposes. Each has its own advantages and disadvantages.

## Commentary

Why not just instantiate a [text renderer](text-renderers.html), such as `BitmapFontTextRenderer`, directly instead of using `Label`? The `Label` component exists to help you abstract the choice of a text renderer away from your core application. For instance, this allows you to easily switch between [themes](themes.html) that have different text renderers. You can also refactor a theme more easily if you decide that you're prefer to use a different text renderer than the one that you originally selected. If you simply instantiated a text renderer directly whenever you needed to display some text, you'd need to make changes to many classes throughout your project.

Generally, all of the Feathers example apps use `Label` for generic text, and you can easily modify their `Main` class to switch to any of the example themes that are included with Feathers. The theme will automatically select an appropriate text renderer and set matching font styles for any `Label` component that it encounters.

## Related Links

-   [`feathers.controls.Label` API Documentation](../api-reference/feathers/controls/Label.html)

-   [Introduction to Feathers Text Renderers](text-renderers.html)