---
title: Why does my Feathers app throw "Error #1056: Cannot create property elementFormat"?  
author: Josh Tynjala

---
# Why does my Feathers app throw "Error #1056: Cannot create property `elementFormat`"?

<aside class="info">Before Feathers 3.1, different [text renderers](../text-renderers.html) each had unique ways to set font styles. For instance, [`TextBlockTextRenderer`](../text-block-text-renderer.html) used `flash.text.engine.ElementFormat`, but [`TextFieldTextRenderer`](../text-field-text-renderer.html) used `flash.text.TextFormat` instead. Today, the architecture has been redesigned to allow developers to set font styles on any text renderer using [`starling.text.TextFormat`](http://doc.starling-framework.org/current/starling/text/TextFormat.html).

If you are using Feathers 3.1 or newer, **this document is considered obsolete**. It remains available to assist developers who need to support legacy apps that are still using older versions of Feathers.</aside>

This error usually pops up when we try to ask a component in our application to use a different [text renderer](../text-renderers.html) (or a different [text editor](../text-editors.html)) than the [theme](../themes.html) expects. A theme will usually standardize on one type of text renderer for all components, so when we try to use a different one, it doesn't know that it should set font styles in a different way.

Sometimes, though, we need to use a different text renderer than the theme uses as its default. Feathers certainly allows mixing and matching text renderers, but we need to tell the theme about what we're doing. We have a couple of options.

<aside class="info">In the following examples, let's assume that we want to give a `Button` component a different text renderer for its label. Maybe we want to use `TextFieldTextRenderer` instead, so that we can set its `isHTML` property to `true`.</aside>

## Option 1: Remove the style provider

We can simply tell the `Button` not to use the theme by removing its style provider:

``` code
button.styleProvider = null;
```

By setting the `styleProvider` property to `null`, our component won't be skinned by the theme at all.

However, this will also remove things like background skin, padding, and other properties that we may want to keep. In many cases, this may not be an acceptable option unless we want to change everything about the appearance of a component, and not just the font styles.

## Option 2: Create a new style name

The better option is to create a new *style name* for the component. The theme offers textures and things for the default styles that we want to keep, and we'll use those while customizing the font styles for our different text renderer.

Similar to how we might add `Button.ALTERNATE_STYLE_NAME_BACK_BUTTON` to the `styleNameList` of a `Button`, we can use our own custom strings too:

``` code
button.styleNameList.add( "my-custom-button" );
```

Now, we need to tell the theme about our custom style name. Let's start by creating the function that should be called to style the button when this style name has been added. Inside the theme, let's create a function named `setMyCustomButtonStyles()`:

``` code
protected function setMyCustomButtonStyles( button:Button ):void
{

}
```

We'll add some code to the function's body in a moment. Let's make sure the theme knows how to call this function before we do that.

Inside the theme's `initializeStyleProviders()` function, we'll add our `"my-custom-button"` style name to the theme's style provider for the `Button` class:

``` code
override protected function initializeStyleProviders():void
{
	super.initializeStyleProviders();
	this.getStyleProviderForClass( Button ).setFunctionForStyleName(
		"my-custom-button", this.setMyCustomButtonStyles );
}
```

Now that everything is hooked up in the theme, let's style the button in the body of the `setMyCustomButtonStyles()` function. We'll start by copying some code from the existing function for styling buttons:

``` code
// this is the default function for buttons
protected function setButtonStyles( button:Button ):void
{
	button.defaultSkin = new Image( this.buttonUpSkinTexture );
	button.downSkin = new Image( this.buttonDownSkinTexture );
	button.padding = 20;
	button.defaultLabelProperties.elementFormat = this.buttonElementFormat;
}
```

We're interested in the background skins and the padding, but we don't want to set the `elementFormat` property, since we're using a different `TextBlockTextRenderer`.

``` code
protected function setMyCustomButtonStyles( button:Button ):void
{
	button.defaultSkin = new Image( this.buttonUpSkinTexture );
	button.downSkin = new Image( this.buttonDownSkinTexture );
	button.padding = 20;

	// we'll set different font styles here
}
```

Let's finish up by telling the `Button` to use a different text renderer, and then we'll set the appropriate font styles:

``` code
protected function customTextRendererFactory():ITextRenderer
{
	return new TextFieldTextRenderer();
}

protected function setMyCustomButtonStyles( button:Button ):void
{
	button.defaultSkin = new Image( this.buttonUpSkinTexture );
	button.downSkin = new Image( this.buttonDownSkinTexture );
	button.padding = 20;

	button.textRendererFactory = this.customTextRendererFactory;
	button.defaultLabelProperties.textFormat = new TextFormat( "_sans", 20, 0x000000 );
}
```

For more details about extending a theme and creating a custom style name, see [Extending Feathers Themes](../extending-themes.html).