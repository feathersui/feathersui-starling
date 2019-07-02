---
title: Introduction to Feathers text renderers  
author: Josh Tynjala

---
# Introduction to Feathers text renderers

There are multiple different approaches to displaying text on the GPU, each with advantages and disadvantages. None of these approaches are ultimately better than the others. With that in mind, when Feathers needs to display text in a component, it provides APIs to allow you to choose the appropriate *text renderer* based on your project's requirements.

Different text renderers may be more appropriate for some situations than others. You should keep a number of factors in mind when choosing a text renderer, including (but not necessarily limited to) the following:

-   the length of the text

-   how often the text changes

-   the language of the text that needs to be displayed

These factors may impact things like performance and memory usage, depending on which text renderer that you choose. Since you can mix and match text renderers among different components within a single scene, you have the ability to fine-tune the entire scene for the best results. One component may perform best with one text renderer while another right next to it is better off with a different text renderer.

Feathers provides three different text renderers. We'll learn the capabilities of each, along with their advantages and disadvantages. These text renderers are listed below:

-   [`BitmapFontTextRenderer`](bitmap-font-text-renderer.html) uses [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts) to render text. One texture may be shared by many instances, and instances may be batched to reduce draw calls. Bitmap fonts may be used to pre-render effects like gradients and filters that would be expensive to apply at runtime. They're not ideal for languages that require many characters or advanced ligatures (such as those with non-Latin alphabets), or when a variety of font sizes are needed.

-   [`TextBlockTextRenderer`](text-block-text-renderer.html) uses [Flash Text Engine](http://help.adobe.com/en_US/as3/dev/WS9dd7ed846a005b294b857bfa122bd808ea6-8000.html) to render text in software, and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) to be uploaded as a texture to the GPU. It offers the most advanced layout options, including the best support for right-to-left languages. Each instance requires a separate texture, so it may increase draw calls if your project must display a significant amount of text on screen at once.

-   [`TextFieldTextRenderer`](text-field-text-renderer.html) uses the classic [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) class to render text in software, and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) to be uploaded as a texture to the GPU. A `TextField` can render a subset of HTML, but it offers fewer advanced layout options than Flash Text Engine. Each instance of this text renderer requires a separate texture, so it may increase draw calls if your project must display a significant amount of text on screen at once.

Each text renderer has different capabilities, so be sure to study each one in detail to choose the best one for your project.

## The default text renderer factory

In many cases, most of the components in your app will use the same type of text renderer. To keep from repeating yourself by passing the same factory (a function that creates the text renderer) to each component separately, you can specify a global *default text renderer factory* to tell all Feathers components in your app how to create a new text renderer. Then, if some of your components need a different text renderer, you can pass them a separate factory that will override the default one.

By default, the default text renderer factory returns a [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html) that renders bitmap fonts. For games, one of the primary targets for Starling and Feathers, bitmap fonts are often a good choice because games tend to display shorter strings that change frequently.

However, when using a [theme](themes.html), you should check which text renderer the theme sets as the default. Themes will often embed a custom font, and it is completely up to the theme which text renderer it wants to use to render that font. Many of the Feathers example apps use vector fonts to easily support many different languages and text styles.

When an individual component doesn't have a custom text renderer factory specified, it calls the function [`FeathersControl.defaultTextRendererFactory()`](../api-reference/feathers/core/FeathersControl.html#defaultTextRendererFactory()). The label of a [`Button`](button.html) text, the title of a [`Header`](header.html) title, and the on and off labels of a [`ToggleSwitch`](toggle-switch.html) are all examples of places where the default text renderer will be used if a custom text renderer is not specified.

[`FeathersControl.defaultTextRendererFactory`](../api-reference/feathers/core/FeathersControl.html#defaultTextRendererFactory) is a static variable that may be changed to a different function, as needed. The default implementation of this function looks like this:

``` actionscript
function():ITextRenderer
{
    return new BitmapFontTextRenderer();
}
```

If you would prefer to use a different text renderer as the default in your app, you can easily change the variable to point to a different function. For instance, you might want to add this code to your application to use the [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) instead:

``` actionscript
FeathersControl.defaultTextRendererFactory = function():ITextRenderer
{
    return new TextBlockTextRenderer();
};
```

## Using a different text renderer on an individual component

You can tell a specific UI control not to use the default text renderer. For instance, on a [`Button`](button.html), you can pass in a [`labelFactory`](../api-reference/feathers/controls/Button.html#labelFactory) that will be used to create the button's label text renderer:

``` actionscript
button.labelFactory = function():ITextRenderer
{
    return new TextFieldTextRenderer();
}
```

You can even customize advanced font properties in the factory before returning the text renderer:

``` actionscript
button.labelFactory = function():ITextRenderer
{
    var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
    textRenderer.antiAliasType = AntiAliasType.NORMAL;
    textRenderer.gridFitType = GridFitType.SUBPIXEL;
    return textRenderer;
}
```

<aside class="warn">Be careful, if you're using a theme. When changing any styles in `labelFactory`, you may want to set the `styleProvider` property of the text renderer to `null`. The theme applies styles after the factory returns, and there is a chance that the theme could replace these styles.</aside>

Other components with the ability to display text may have a different name for their text renderer factories. For example, the factory for the title text renderer of a [`Header`](header.html) component is called [`titleFactory`](../api-reference/feathers/controls/Header.html#titleFactory). Check the [API reference](../api-reference/) for a specific component to learn the names of any properties that allow you to change the factories for its text renderers.

## The `Label` Component

The [`Label`](label.html) component is a component designed to simply display text. It's not a text renderer. Instead, it contains a text renderer. In general, if you're looking for a Feathers component to display arbitrary text, you want a `Label`. Maybe you want to display a score in a game, or to [lace a label next to a `TextInput` in a form, or perhaps, you'd like to display a small paragraph of text to provide some instructions. That's what `Label` is for.

Why not just instantiate a text renderer, such as [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html), directly? The `Label` component exists to help you abstract the choice of a text renderer away from your core application. For instance, it allows you to easily switch to a different [themes](themes.html), which may use different text renderers. The `Label` component has a `fontStyles` property that accepts a `starling.text.TextFormat` object, but individual text renderers may be styled with different types of objects, like `flash.text.engine.ElementFormat` or `feathers.text.BitmapFontTextFormat`.

When using `Label` components in your app, you can also refactor more easily, should you decide that you're prefer to use a different text renderer than the one that you originally chose. If you simply instantiated a text renderer directly when you wanted to display arbitrary text, you need to make changes to many classes throughout your project instead of in one place separated from the rest of your application: the theme.

Put another way, you wouldn't want to do something like this when you want to add a label to a form item:

``` actionscript
var label:TextFieldTextRenderer = new TextFieldTextRenderer();
label.text = "Email Address:";
this.addChild( label );
```

Instead, you should create a `Label` component:

``` actionscript
var label:Label = new Label();
label.text = "Email Address:";
this.addChild( label );
```

The choice of a text renderer can be left to your theme instead of cluttering up the rest of the application, and text styles may be customized appropriately. For complete details about how to set properties on a `Label` component in your theme, see [How to use the Feathers `Label` component](label.html).

## Custom Text Renderers

If you'd like to use a different approach to rendering text, you may implement the [`ITextRenderer`](../api-reference/feathers/core/ITextRenderer.html) interface. This interface provides a simple API for passing a string to a text renderer to display and measuring the text. One example of a custom text renderer might be one that uses [Text Layout Framework (TLF)](http://www.adobe.com/devnet/tlf.html) to provide a number of advanced capabilities.

Unless your custom renderer is capable of drawing directly to the GPU, chances are that you will need to implement some form of texture snapshots, similar to the `TextFieldTextRenderer` or `TextBlockTextRenderer`. Since Feathers is open source, feel free to look through the source code for one of these text renderer classes for inspiration.

## Alternatives

We have some other options for displaying text. As with the core text renderers detailed above, these alternatives have their own advantages and disadvantages.

### Feathers `ScrollText` Component

Sometimes, very long passages of text may be too large for text renderers like `TextFieldTextRenderer` and `TextBlockTextRenderer` to display because the total width or height is so large that there isn't enough memory on the GPU to store the required textures. Sometimes, you can use `BitmapFontTextRenderer` instead, since bitmap fonts don't require a larger texture to display longer text. However, that won't work if you are required to display vector fonts.

In this case, you should consider using the [`ScrollText`](scroll-text.html) component. `ScrollText` displays a native `flash.text.TextField` overlay on the native stage above Starling and Stage 3D. Rather than being converted into a texture on the GPU, this text is rendered in software and displayed above Stage 3D on the classic display list. It may be constrained to a rectangle in Starling coordinates, clipped, and scrolled.

There are some disadvantages, though. Because it is drawn entirely by the software renderer, scrolling may not be perfectly smooth on some mobile devices because the CPU may not be able to keep up with rendering so much text in software. Additioanlly, you will not be able to display Starling content above the `ScrollText` component. `ScrollText` is not rendered by the GPU, so it is completely outside of Starling and Stage 3D. `ScrollText` is always above Starling, and nothing inside Starling can ever appear on top of it. If you want to display anything above `ScrollText`, that content will also need to be on the native display list. This content will not be GPU accelerated, and it may perform poorly.

## Related Links

-   [How to use the Feathers `BitmapFontTextRenderer` component](bitmap-font-text-renderer.html)

-   [How to use the Feathers `TextBlockTextRenderer` component](text-block-text-renderer.html)

-   [How to use the Feathers `TextFieldTextRenderer` component](text-field-text-renderer.html)

-   [How to use the Feathers `Label` component](label.html)

-   [How to use the Feathers `ScrollText` component](scroll-text.html)

-   [`feathers.core.ITextRenderer` API Documentation](../api-reference/feathers/core/text/ITextRenderer.html)

-   [Introduction to Feathers Text Editors](text-editors.html)