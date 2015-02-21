---
title: Introduction to Feathers text renderers  
author: Josh Tynjala

---
# Introduction to Feathers text renderers

There are muliple different approaches to displaying text on the GPU, each with advantages and disadvantages. None of these approaches are ultimately better than the others. With that in mind, when Feathers needs to display text in a component, it provides APIs to allow you to choose the appropriate *text renderer* based on your project's requirements.

Different text renderers may be more appropriate for some situations than others. You should keep a number of factors in mind when choosing a text renderer, including (but not necessarily limited to) the following:

-   the length of the text

-   how often the text changes

-   the language of the text that needs to be displayed

These factors may impact things like performance and memory usage, depending on which text renderer that you choose. Since you can mix and match text renderers among different components within a single scene, you have the ability to fine-tune the entire scene for the best results. One component may perform best with one text renderer while another right next to it is better off with a different text renderer.

Feathers provides three different text renderers. We'll learn the capabilities of each, along with their advantages and disadvantages. These text renderers are listed below:

-   [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html) uses [bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts) to display characters as separate textured quads.

-   [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) uses [`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) to render text in software and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

-   [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) uses [`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) to render text in software and the result is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU.

We'll look at the capabilities of each text renderer in more detail a bit later, and we'll even consider options for creating custom text renderers.

## The default text renderer factory

In many cases, most of the components in your app will use the same type of text renderer. To keep from repeating yourself by passing the same factory (a function that creates the text renderer) to each component separately, you can specify a global *default text renderer factory* to tell all Feathers components in your app how to create a new text renderer. Then, if some of your components need a different text renderer, you can pass them a separate factory that will override the default one.

By default, the default text renderer factory returns a [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html) that renders bitmap fonts. For games, one of the primary targets for Starling and Feathers, bitmap fonts are often a good choice because they tend to display shorter strings that change a lot.

However, when using a [theme](themes.html), you should check which text renderer is selected as the default. Themes will often embed a custom font, and it is completely up to the theme which text renderer it wants to use to render that font. Many of the Feathers example apps use vector fonts to easily support many different languages and text styles.

When an individual component doesn't have a custom text renderer factory specified, it calls the function [`FeathersControl.defaultTextRendererFactory()`](../api-reference/feathers/core/FeathersControl.html#defaultTextRendererFactory()). The label of a [`Button`](button.html) text, the title of a [`Header`](header.html) title, and the on and off labels of a [`ToggleSwitch`](toggle-switch.html) are all examples of places where the default text renderer will be used if a custom text renderer is not specified.

[`FeathersControl.defaultTextRendererFactory`](../api-reference/feathers/core/FeathersControl.html#defaultTextRendererFactory) is a static variable that may be changed to a different function, as needed. The default implementation of this function looks like this:

``` code
function():ITextRenderer
{
    return new BitmapFontTextRenderer();
}
```

If you would prefer to use a different text renderer as the default in your app, you can easily change the variable to point to a different function. For instance, you might want to add this code to your application to use the [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) instead:

``` code
FeathersControl.defaultTextRendererFactory = function():ITextRenderer
{
    return new TextBlockTextRenderer();
};
```

## Using a different text renderer on an individual component

You can tell a specific UI control not to use the default text renderer. For instance, on a [`Button`](button.html), you can pass in a [`labelFactory`](../api-reference/feathers/controls/Button.html#labelFactory) that will be used to create the button's label text renderer:

``` code
button.labelFactory = function():ITextRenderer
{
    return new TextFieldTextRenderer();
}
```

You can even apply font styles and other properties in the factory before returning the text renderer:

``` code
button.labelFactory = function():ITextRenderer
{
    var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
    textRenderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0xffffff );
    textRenderer.embedFonts = true;
    return textRenderer;
}
```

Be careful, if you're using a theme. The theme applies its styles after this function returns. That means that the theme may end up replacing any properties that you set in the factory. See [Extending Feathers Themes](extending-themes.html) for details about how to customize an existing theme's styles.

Other components with the ability to display text may have a different name for their text renderer factories. For example, the factory for the title text renderer of a [`Header`](header.html) component is called [`titleFactory`](../api-reference/feathers/controls/Header.html#titleFactory). Check the [API reference](../api-reference/) for a specific component to learn the names of any properties that allow you to change the factories for its text renderers.

## The Label Component

The [`Label`](label.html) component is a component designed strictly to display text and only text. It's not a text renderer, but it has one child, and that child is a text renderer. In general, if you're looking for a Feathers component to display arbitrary text, you want a `Label`. Maybe you want to display a score in a game, or to label or form field, or perhaps to display a small paragraph of text to provide some instructions. That's what `Label` is for.

Why not just instantiate a text renderer, such as [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html), directly? The `Label` component exists to help you abstract the choice of a text renderer away from your core application. For instance, it allows you to easily switch to a different [themes](themes.html) that has different text renderers. You can also refactor a theme more easily if you decide that you're prefer to use a different text renderer than the one that you originally selected. If you simply instantiated a text renderer directly when you wanted to display arbitrary text, you need to make changes to many classes throughout your project instead of in one place separated from the rest of your application: the theme.

Put another way, you wouldn't want to do something like this when you want to add a label to a form item:

``` code
var label:TextFieldTextRenderer = new TextFieldTextRenderer();
label.text = "Email Address:";
this.addChild( label );
```

Instead, you should create a `Label` component:

``` code
var label:Label = new Label();
label.text = "Email Address:";
this.addChild( label );
```

The choice of a text renderer can be left to your theme instead of cluttering up the rest of the application, and text styles may be customized appropriately. For complete details about how to set properties on a `Label` component in your theme, see [How to use the Feathers `Label` component](label.html).

## `BitmapFontTextRenderer`

[Bitmap fonts](http://wiki.starling-framework.org/manual/displaying_text#bitmap_fonts) separate each character into sub-textures inside an atlas. These sub-textures are displayed as images placed next to each other to form words and paragraphs. If the text has a particularly stylized appearance, such as gradients and outlines, bitmap fonts provide the best performance because the styles can be calculated at design time rather than runtime.

Bitmap fonts are often great for games in situations when you need to display a limited amount of text around the edges of the screen. Values that change often, such as score, ammo, health, etc. can quickly swap out characters without uploading new textures to the GPU.

Bitmap fonts can sometimes be useful for longer passages of text (assuming that you need a uniform font style throughout the whole passage) because each character is a separate sub-texture and can be reused without requiring more memory on the GPU. However, since each new character is a new image to render on Starling's display list, the transformation calculations for all of those separate display objects may eventually overwhelm the CPU as the number of characters increases. It may require testing to determine how many characters a particular device's CPU can handle at once.

While the English language has only 26 letters in the alphabet (in addition to any punctuation and other supporting characters that you might need), some languages require many hundreds of characters. A texture that contains all of those characters may be impossible to use with bitmap fonts because it hits texture memory limits imposed by the Flash runtime or the GPU. In these situations, you may have no choice but to use device fonts.

Bitmap fonts may be scaled, but because they use bitmaps, only scaling down is recommended. Even then, you may lose out on text hinting that would make vector fonts more readable at smaller sizes. It's common to include separate font sizes as separate textures for bitmap fonts to achieve the best looking results, and that can require a lot of memory.

`BitmapFontTextRenderer` does not support multiple font styles. A `BitmapFontTextRenderer` must use a single bitmap font to render its entire text.

### Using `BitmapFontTextRenderer`

To display text with bitmap fonts, use the [`BitmapFontTextRenderer`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html) class.

``` code
var textRenderer:BitmapFontTextRenderer = new BitmapFontTextRenderer();
textRenderer.text = "I am the very model of a modern Major-General";
```

Font styles may be customized by passing a [`BitmapFontTextFormat`](../api-reference/feathers/text/BitmapFontTextFormat.html) instance to the [`textFormat`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html#textFormat) property. The first parameter of the constructor accepts either name of a font registered with [`TextField.registerBitmapFont()`](http://doc.starling-framework.org/core/starling/text/TextField.html#registerBitmapFont()) or any [`BitmapFont`](http://doc.starling-framework.org/starling/text/core/BitmapFont.html) instance, regardless of whether it has been registered or not. Additionally, you may specify the font size (or set it to `NaN` to use the original font size) and the color of the text. The text color is applied using Starling's tinting capabilities. Finally, you may specify the alignment of the text as the final argument to the constructor.

``` code
textRenderer.textFormat = new BitmapFontTextFormat( "FontName", 14, 0xcccccc, TextFormatAlign.CENTER );
```

To use [`wordWrap`](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html#wordWrap), set it to `true` and give the `BitmapFontTextRenderer` (or a `Label` that is using a `BitmapFontTextRenderer`) a `width` or `maxWidth` value. You can also add manual line breaks using the `\n` character.

``` code
textRenderer.width = 100;
textRenderer.wordWrap = true;
```

`BitmapFontTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`BitmapFontTextRenderer` API reference](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html).

## `TextFieldTextRenderer`

[`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) may be used to render device fonts or embedded fonts using a software-based vector renderer. Inside Feathers, this text is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU. This text renderer may use device fonts (the fonts installed on the user's operating system), and it supports embedded fonts in TTF or OTF formats.

Since embedded vector fonts require less memory than embedded bitmap fonts, you may still be able to use custom fonts with languages with too many characters for bitmap fonts. However, even when the vector glyphs require too much memory, you can always fall back to using *device fonts* (the fonts installed on the user's operating system) to draw your text. For some languages, device fonts may be the only option.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU and affect performance if you have many different instances of `TextFieldTextRenderer` on screen at the same time.

[`flash.text.TextField`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html) has some known issues and limitations:

-   `TextField` may render incorrectly when drawn to `BitmapData` immediately after its properties have been changed. As a workaround, `TextFieldTextRenderer` waits one frame before drawing to `BitmapData` and uploading as a texture when the text or font styles are changed. Often, this delay will not be an issue, but it can be seen if watching closely.

-   `TextField` offers limited support for some languages, including right-to-left and bidirectional languages, and Flash Text Engine is recommended for these languages.

`TextFieldTextRenderer` supports [a limited subset of HTML](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText) courtesy of `flash.text.TextField`. This may be used to render richer text with multiple font styles.

### Using `TextFieldTextRenderer`

To render text in software with `flash.text.TextField` and display a snapshot of it as a texture on the GPU, use the [`TextFieldTextRenderer`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html) class.

``` code
var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
textRenderer.text = "About binomial theorem I'm teeming with a lot o' news";
```

Font styles may be customized using the native [`flash.text.TextFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html) class. Many of the property names defined by `TextField` are duplicated on `TextFieldTextRenderer`, including (but not limited to) [`textFormat`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#textFormat) and [`embedFonts`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#embedFonts):

``` code
textRenderer.textFormat = new TextFormat( "Source Sans Pro", 16, 0xcccccc );
textRenderer.embedFonts = true;
```

To enable word-wrapping, pass in a `width` or `maxWidth` value and set [`wordWrap`](../api-reference/feathers/controls/text/TextFieldTextRenderer.html#wordWrap) to `true`.

``` code
textRenderer.width = 100;
textRenderer.wordWrap = true;
```

To render the `text` property of the `TextFieldTextRenderer` using [a limited subset of HTML](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText), set the `isHTML` property to `true`:

``` code
textRenderer.text = "<span class='heading'>hello</span> world!";
textRenderer.isHTML = true;
```

`TextFieldTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextFieldTextRenderer` API reference](../api-reference/feathers/controls/text/TextFieldTextRenderer.html).

## `TextBlockTextRenderer`

[`flash.text.engine.TextBlock`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextBlock.html) may be used to render device fonts or embedded fonts using a software-based vector renderer. Inside Feathers, this text is drawn to [`BitmapData`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/BitmapData.html) and uploaded as a texture to the GPU. This text renderer may use device fonts (the fonts installed on the user's operating system), and it supports embedded fonts in TTF or OTF formats.

Since embedded vector fonts require less memory than embedded bitmap fonts, you may still be able to use custom fonts with languages with too many characters for bitmap fonts. However, even when the vector glyphs require too much memory, you can always fall back to using *device fonts* (the fonts installed on the user's operating system) to draw your text. For some languages, device fonts may be the only option.

Changing vector-based text on the GPU is slower than with bitmap fonts because the text needs to be redrawn to `BitmapData` and then it needs to be uploaded to a texture on the GPU. However, once this texture is on the GPU, performance will be very smooth as long as the text doesn't change again. For text that changes often, the texture upload time may become a bottleneck.

Because each passage of vector text needs to be drawn to `BitmapData`, each separate renderer requires its own separate texture on the GPU. This results in more [state changes](http://wiki.starling-framework.org/manual/performance_optimization#minimize_state_changes) and [draw calls](faq/draw-calls.html), which can create more work for the GPU and affect performance if you have many different instances of `TextBlockTextRenderer` on screen at the same time.

Flash Text Engine may render a bit slower than `flash.text.TextField` sometimes. In general, this performance difference is negligible, and the more advanced capabilities of FTE are often more compelling than a minor risk of reduced performance.

`TextBlockTextRenderer` optionally supports rich text, but it needs to be constructed manually adding multiple [`TextElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/TextElement.html) objects, each with different [`ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) values, to a [`GroupElement`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/GroupElement.html) object. You may pass the `GroupElement` to the text renderer's [`content`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#content) property. `TextBlockTextRenderer` does not support the simple subset of HTML that `TextFieldTextRenderer` can display.

### Using `TextBlockTextRenderer`

To render text in software with `flash.text.engine.TextBlock` and display it as a texture on the GPU, use the [`TextBlockTextRenderer`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) class.

``` code
var textRenderer:TextBlockTextRenderer = new TextBlockTextRenderer();
textRenderer.text = "I understand equations, both the simple and quadratical";
```

Many font styles may be customized using the native [`flash.text.engine.ElementFormat`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/ElementFormat.html) class. Pass an instance of `ElementFormat` to the [`elementFormat`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html) property:

``` code
var fontDescription:FontDescription = new FontDescription( "Source Sans Pro", FontWeight.NORMAL, FontPosture.NORMAL, FontLookup.EMBEDDED_CFF, RenderingMode.CFF, CFFHinting.NONE );
textRenderer.elementFormat = new ElementFormat( fontDescription, 16, 0xcccccc );
```

The first parameter to the `ElementFormat` constructor is a [`FontDescription`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/engine/FontDescription.html) object. This class is provided by Flash Text Engine to handle font lookup, including name, weight, posture, whether the font is embedded or not, and how the font is rendered.

Text alignment is not included in the `FontDescription` or the `ElementFormat`. Instead, set the [`textAlign`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#textAlign) property:

``` code
textRenderer.textAlign = TextBlockTextRenderer.TEXT_ALIGN_CENTER;
```

The `TextBlockTextRenderer` defines [`TEXT_ALIGN_CENTER`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#TEXT_ALIGN_CENTER) and some other constants that the `textAlign` property accepts.

To enable word-wrapping, pass in a `width` or `maxWidth` value and set [`wordWrap`](../api-reference/feathers/controls/text/TextBlockTextRenderer.html#wordWrap) to `true`.

``` code
textRenderer.width = 100;
textRenderer.wordWrap = true;
```

`TextBlockTextRenderer` provides a number of other advanced properties that may be customized, but aren't included in this quick introduction. For complete details about available properties, please take a look at the [`TextBlockTextRenderer` API reference](../api-reference/feathers/controls/text/TextBlockTextRenderer.html).

## Custom Text Renderers

If you'd like to use a different approach to rendering text, you may implement the [`ITextRenderer`](../api-reference/feathers/core/ITextRenderer.html) interface. This interface provides a simple API for passing a string to a text renderer to display and measuring the text. One example of a custom text renderer might be one that uses [Text Layout Framework (TLF)](http://www.adobe.com/devnet/tlf.html) to provide a number of advanced capabilities.

Unless your custom renderer is capable of drawing directly to the GPU, chances are that you will need to implement some form of texture snapshots, similar to the `TextFieldTextRenderer` or `TextBlockTextRenderer`. Since Feathers is open source, feel free to look through the source code for one of these text renderer classes for inspiration.

## Alternatives

We have some other options for displaying text, including some options included in Feathers and some custom text renderers developed by the community. As with the core text renderers detailed above, these alternatives have their own advantages and disadvantages.

### Feathers `ScrollText` Component

Sometimes, very long text may be too large for text renderers like `TextFieldTextRenderer` and `TextBlockTextRenderer` to display because the total width or height is so large that there isn't enough memory on the GPU to store the required textures. However, you may still want to use vector-based fonts in a `flash.text.TextField`.

In this case, you might consider using the [`ScrollText`](scroll-text.html) component instead. `ScrollText` displays a native `flash.text.TextField` overlay on the native stage above Starling and Stage 3D. Rather than being converted into a texture on the GPU, this text is rendered in software and displayed above Stage 3D on the classic display list. It may be constrained to a rectangle in Starling coordinates, clipped, and scrolled.

There are some disadvantages, though. Because it is drawn entirely by the software renderer, it may scroll slowly on mobile devices with high screen resolutions because the CPU may not be able to keep up with rendering so much text in software. Moreover, you will not be able to display Starling content above the `ScrollText` component. `ScrollText` is not rendered by the GPU, so it is completely outside of Starling and Stage 3D. `ScrollText` is always above Starling, and nothing inside Starling can appear on top. If you want to display something above `ScrollText`, it will also need to be on the native display list. This content will not be GPU accelerated, and it may perform poorly.

### firetype

[firetype](http://www.max-did-it.com/index.php/projects/firetype/) is a third-party library that renders text on the GPU using polygons instead of textures. Text displayed with firetype is resolution independent and uses less CPU than software rendering. This library includes support for Starling.

### Distance Field Fonts

[DistanceFieldFont](http://wiki.starling-framework.org/extensions/distancefieldfont) is a third-party Starling extension that implements distance fields for bitmap fonts. Distance fields allow bitmap fonts to use less texture memory and scale up much more smoothly than standard bitmap fonts. This extension includes a Feathers text renderer.

## Draw Calls

Please see the [FAQ: Draw Calls and Feathers Text](faq/draw-calls.html) article for a detailed explanation about how text in Starling and Feathers (and text on the GPU, in general) affects draw calls.

## Related Links

-   [`feathers.core.ITextRenderer` API Documentation](../api-reference/feathers/core/text/ITextRenderer.html)

-   [`feathers.controls.text.BitmapFontTextRenderer` API Documentation](../api-reference/feathers/controls/text/BitmapFontTextRenderer.html)

-   [`feathers.controls.text.TextFieldTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextFieldTextRenderer.html)

-   [`feathers.controls.text.TextBlockTextRenderer` API Documentation](../api-reference/feathers/controls/text/TextBlockTextRenderer.html)

-   [How to use the Feathers `Label` component](label.html)

-   [Introduction to Feathers Text Editors](text-editors.html)