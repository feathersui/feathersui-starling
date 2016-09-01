---
title: Skinning Feathers components  
author: Josh Tynjala

---
# Skinning Feathers components

All core Feathers components are designed with many styling properties to support a variety of custom designs. Many components include properties to set background skins for different states, different layout options like padding and alignment, and font styles. Additionally, some components have different options that allow them to behave differently depending on whether you're building a mobile or desktop app.

For practical reasons, [Feathers components don't have default skins](faq/default-skins.html). Developers are encouraged to design unique skins for their games and applications. However, a number of example [themes](themes.html) are included with Feathers that provide pre-created skins in several different styles. These themes may be [extended to provide custom skins](extending-themes.html), if needed.

## The Basics

All skins, layout options, and other styles available on Feathers components are exposed as public properties. Styling a component is as simple as setting these properties.

Let's look at a simple example of skinning a [`Button`](button.html) component:

``` code
var button:Button = new Button();
button.label = "Click Me";
button.defaultSkin = new Quad( 100, 30, 0xc4c4c4 );
button.fontStyles = new TextFormat( "Helvetica", 20, 0x3c3c3c );
this.addChild( button );
```

In the code above, we set the [`defaultSkin`](../api-reference/feathers/controls/BasicButton.html#defaultSkin) property provides the button with a background skin. In this case, we created an instance of [`starling.display.Quad`](http://doc.starling-framework.org/current/starling/display/Quad.html) class, which makes our background skin a simple colored rectangle. We could just as easily use [`starling.display.Image`](http://doc.starling-framework.org/current/starling/display/Image.html) class to display a texture instead, and Feathers offers more advanced skinning options that we'll look at in a moment.

We set the [`fontStyles`](../api-reference/feathers/controls/Button.html#fontStyles) property to tell the button which font family to use for its text, along with the size and color. The [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html) class can be used to customize the font styles of any Feathers component, whether you are using bitmap fonts, embedded fonts, or system fonts.

<aside class="info">The `Button` class has many more styling properties for things like layout, icons, and more, but that is outside the scope of this document. For more details about styling buttons specifically, take a look at [How to use the Feathers `Button` component](button.html).</aside>

## Skin components with multiple states

Some components, like [`Button`](button.html) and [`TextInput`](text-input.html) have multiple different states, and it's possible to change a component's appearance when its state changes. For instance, we might change the background skin or font styles of a button when it is pressed and changes to the "down" state.

### Display different textures for each state

Let's use the [`feathers.skins.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) class to change the appearance of the button's background skin when the state changes:

``` code
var skin:ImageSkin = new ImageSkin( upTexture );
skin.setTextureForState( ButtonState.DOWN, downTexture );
button.defaultSkin = skin;
```

Pass the default texture to the `ImageSkin` constructor. This texture will be used when the button isn't being pressed. Then, call [`setTextureForState()`](../api-reference/feathers/skins/ImageSkin.html#setTextureForState()), and pass in the name of the state to customize, along with another texture. In this case, we specify [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN) for the name of the state.

<aside class="info">If the `ImageSkin` does not have a texture for a specific state, the default texture passed into the constructor will be used as a fallback. Since we didn't specify a texture for `ButtonState.HOVER`, the default texture will be used if the mouse is over the button.</aside>

It's possible to specify different textures for many different states, like in the following example:

``` code
var skin:ImageSkin = new ImageSkin( upTexture );
skin.setTextureForState( ButtonState.DOWN, downTexture );
skin.setTextureForState( ButtonState.HOVER, hoverTexture );
skin.setTextureForState( ButtonState.DISABLED, disabledTexture );
button.defaultSkin = skin;
```

### Use different font styles for each state

Similar to how we can change the appearance of a button's background skin when the button's state changes, we can also change the font styles too:

``` code
var upFontStyles:TextFormat = new TextFormat( "Helvetica", 20, 0x3c3c3c );
var downFontStyles:TextFormat = new TextFormat( "Helvetica", 20, 0xff0000 );

button.fontStyles = upFontStyles;
button.setFontStylesForState( ButtonState.DOWN, downFontStyles );
```

In the code above, we set the [`fontStyles`](../api-reference/feathers/controls/Button.html#fontStyles) property to specify the default font styles for the text. Then, we call [`setFontStylesForState()`](../api-reference/feathers/controls/Button.html#setFontStylesForState()) with the name of the state and another `starling.text.TextFormat` instance.

<aside class="info">If you don't call `setFontStylesForState()` for a particular state, the button will fall back to using the default `fontStyles` property. For example, since we didn't specify any font styles for `ButtonState.HOVER`, the default `fontStyles` will be used when the mouse is over the button.</aside>

## Skin components with sub-components

Some complex Feathers components contain other components as children. For example a [`Panel`](panel.html) container has a header. Sub-components like the panel's header may be styled, but their properties are not exposed directly on their parent component.

The easiest way to style a sub-component is to customize the *factory* function that the parent component calls to create the sub-component. The panel's header is created in its [`headerFactory`](../api-reference/feathers/controls/Panel.html#headerFactory):

``` code
var panel:Panel = new Panel();
panel.headerFactory = function():IFeathersControl
{
    var header:Header = new Header();
    header.backgroundSkin = new Quad( 200, 50, 0x3c3c3c );
    header.fontStyles = new TextFormat( "Helvetica", 20, 0xd4d4d4 );
    return header;
};
this.addChild( panel );
```

If you're using a [theme](themes.html), you may prefer to keep all of your styling code inside the theme. In this case, you should not use the sub-component's factory. Instead, consider creating a new *style name* for the sub-component and move your code into the theme.

A complex component will have a property to allow you to customize the style name of a sub-component. In the case of a `Panel`, we'll set the [`customHeaderStyleName`](../api-reference/feathers/controls/Panel.html#customHeaderStyleName) property:

``` code
var panel:Panel = new Panel();
panel.customHeaderStyleName = "custom-panel-header";
this.addChild( panel );
```

Inside the theme, create a new function to style your sub-component:

``` code
private function setCustomPanelHeaderStyles( header:Header ):void
{
    header.backgroundSkin = new Quad( 200, 50, 0x3c3c3c );
    header.fontStyles = new TextFormat( "Helvetica", 20, 0xd4d4d4 );
}
```

Then, tell the theme that when the sub-component has your custom style, it should pass the component to your function:

``` code
getStyleProviderForClass( Header )
    .setFunctionForStyleName( "custom-panel-header", setCustomPanelHeaderStyles );
```

## Related Links

-   [Introduction to Feathers Themes](themes.html)

-   [Extending Feathers example themes](extending-themes.html)