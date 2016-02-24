---
title: Feathers 3.0 Migration Guide  
author: Josh Tynjala

---
# Feathers 3.0 Migration Guide

This guide explains how to migrate an application created with a previous version of Feathers to Feathers 3.0. Some APIs have been removed and others have been deprecated. New classes like `ImageSkin` make it easier to skin components while optimizing memory and performance.

-   [Skinning Changes](#skinning-changes)

	-   [Removal of `Scale9Image`, `Scale3Image`, and `TiledImage`](#removal-of-scale9image-scale3image-and-tiled-image)

	-   [The new `ImageSkin` class](#the-new-imageskin-class)

	-   [Setting font styles on text renderers](#setting-font-styles-on-text-renderers)
	
	-   [Removal of `StandardIcons.listDrillDownAccessoryTexture`](#removal-of-standardicons.listdrilldownaccessorytexture)

-   [Multi-Resolution Development with Feathers](#multi-resolution-development-with-feathers)

-   [Duplicate constants moved to shared classes](#duplicate-constants-moved-to-shared-classes)

-   [Appendix: List of Removed APIs](#appendix-list-of-removed-apis)

-   [Appendix: List of Deprecated APIs](#appendix-list-of-deprecated-apis)

-   [Appendix: Find and Replace Regular Expressions](#appendix-find-and-replace-regular-expressions)

## Skinning Changes

### Removal of `Scale9Image`, `Scale3Image`, and `TiledImage`

Starling 2.0 now offers these features natively!

To replace `Scale9Image`, create an `Image` and set its `scale9Grid` property:

``` code
var image:Image = new Image( texture );
image.scale9Grid = new Rectangle( 2, 2, 3, 6 );
this.addChild( image );
```

To replace `Scale3Image`, create an `Image` and set its `scale9Grid` property. For horizontal scaling, set the grid's height to the full height of the texture. For vertical scaling, set the grid's width to the full width of the texture. In the following example, the `Image` can be scaled horizontally like the old `Scale3Image`:

``` code
var image:Image = new Image( texture );
image.scale9Grid = new Rectangle( 2, 0, 3, texture.frameHeight );
this.addChild( image );
```

To replace `TiledImage`, create an `Image` and set the `tileGrid` property to an empty `Rectangle`:

``` code
var image:Image = new Image( texture );
image.tileGrid = new Rectangle();
this.addChild( image );
```

### The new `ImageSkin` class

[`feathers.skin.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) provides a more optimized way to skin Feathers components that have multiple states, such as `Button` and `TextInput`.

Previously, the easiest way to skin these components involved creating separate display objects for each state. For instance, a `Button` might have a default skin, a down skin, a hover skin, and a disabled skin. You would create four separate `Image` objects with four textures.

From an optimization perspective, it would be better to use a single `Image` and simply reuse it with all four textures. Previously, we could do that by using the `stateToSkinFunction` property, but it's wasn't very intuitive, so many developers preferred to use separate display objects for each state. The `ImageSkin` class takes advantage of new capabilities in Starling 2.0 to make using multiple textures easy.

Let's take a look at how a button can use `ImageSkin`:

``` code
var skin:ImageSkin = new ImageSkin( defaultTexture );
skin.setTextureForState( ButtonState.DOWN, downTexture );
skin.setTextureForState( ButtonState.DISABLED, disabledTexture );
skin.scale9Grid = SCALE_9_GRID;
button.defaultSkin = skin;
```

Each state can display a different texture, and the `ImageSkin` automatically detects when the button's state changes. If a texture isn't specified for the current state, the default texture will be used.

`ImageSkin` is a subclass of `starling.display.Image`, so all properties like `scale9Grid` and `tileGrid` are available too!

In addition to being used for background skins, `ImageSkin` can also be used for the icon on buttons, text inputs, and item renderers.

### Setting font styles on text renderers

[Text renderers](text-renderers.html) in Feathers components can now change their own font styles when their parent component changes state. Previously, the `Button` class managed multiple sets of properties for different states (like `defaultLabelProperties` and `downLabelProperties`) using objects that were not strictly type-checked at compile-time. The new approach is stricter, and easier to customize outside of the theme: 

``` code
button.labelFactory = function():ITextRenderer
{
	var textRenderer:BitmapFontTextRenderer = new TextBlockTextRenderer();
	textRenderer.styleProvider = null; // avoid conflicts with the theme
	textRenderer.textFormat = new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0xffffff );
	return textRenderer;
};
```

In the code above, we create a [`BitmapFontTextRenderer`](bitmap-font-text-renderer.html) and we use the `textFormat` property to set its font styles in the `labelFactory` of a `Button`.

On the `BitmapFontTextRenderer`, we can call the `setTextFormatForState()` function to pass in different font styles of each of the button's states. Let's do that in the same `labelFactory`:

``` code
textRenderer.setElementFormatForState( ButtonState.DOWN,
	new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0xffcc00 ) );

textRenderer.setElementFormatForState( ButtonState.DISABLED,
	new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0x999999 ) );
```

<aside class="info">To display text with a different text renderer, the approach is mostly the same, but each text renderer has its own way to set font styles. To use a `TextBlockTextRenderer`, pass the default font styles to the `elementFormat` property. Call the `setElementFormatForState()` function to pass in font styles for different states.</aside>

If you prefer to keep all of your styling code in your theme, you can [create a new style name](extending-themes.html) for the text renderer class. On a `Button`, you'd pass this custom style name to the `customLabelStyleName` property:

``` code
button.customLabelStyleName = "my-custom-text-renderer";
```

In your theme, you'd add a new styling function for `BitmapFontTextRenderer`.

``` code
getStyleProviderForClass( BitmapFontTextRenderer )
	.setFunctionForStyleName( "my-custom-text-renderer", setCustomTextRendererStyles );
```

Just like above, we can set the default font styles, and styles for different states:

``` code
function setCustomTextRendererStyles( textRenderer: BitmapFontTextRenderer ):void
{
	textRenderer.textFormat = new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0xffffff );
	textRenderer.setElementFormatForState( ButtonState.DOWN,
		new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0xffcc00 ) );
	textRenderer.setElementFormatForState( ButtonState.DISABLED,
		new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0x999999 ) );
}
```

### Removal of `StandardIcons.listDrillDownAccessoryTexture`

This static property was previously used to return a special icon for item renderers inside `accessorySourceFunction`. In Feathers 3.0, you should add the [`DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html#ALTERNATE_STYLE_NAME_DRILL_DOWN) constant to the item renderer's `styleNameList` instead. The theme will detect this style name, and it will pass a drill down icon to the item renderer.

<aside class="info">`DefaultGroupedListItemRenderer` also defines a [`ALTERNATE_STYLE_NAME_DRILL_DOWN` constant](../api-reference/feathers/controls/renderers/DefaultGroupedListItemRenderer.html#ALTERNATE_STYLE_NAME_DRILL_DOWN).</aside>

If some of the items in the list should not display a drill down icon, use the [`setItemRendererFactoryWithID()`](../api-reference/feathers/controls/List.html#setItemRendererFactoryWithID()) and [`factoryIDFunction`](../api-reference/feathers/controls/List.html#factoryIDFunction) to pass multiple item renderer factories to the `List` or `GroupedList`.

``` code
list.itemRendererFactory = function():IListItemRenderer
{
	var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
	itemRenderer.styleNameList.add( DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN );
	return itemRenderer;
};
```

If all items in the list should have a drill down icon, you may use `customItemRendererStyleName` instead:

``` code
list.customItemRendererStyleName = DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN;
```

## Multi-Resolution Development with Feathers

Feathers 3.0 fully embraces Starling's `contentScaleFactor` system described in [Starling Multi-Resolution Development](http://wiki.starling-framework.org/manual/multi-resolution_development). Feathers even has some tricks up its sleeve to make it easy to scale to any mobile device's screen, while using its native aspect ratio.

### `ScreenDensityScaleFactorManager`

The [`ScreenDensityScaleFactorManager`](../api-reference/feathers/utils/ScreenDensityScaleFactorManager.html) class provides a convienent way to automatically calculate an appropriate `contentScaleFactor` value while maintaining the aspect ratio of any mobile device's screen. It uses a system inspired by Android that takes into account the screen density and the screen's resolution.

The following example shows how to use `ScreenDensityScaleFactorManager` by modifying the sample [Startup Code](http://wiki.starling-framework.org/manual/startup_code) from the Starling wiki.

``` code
public class Startup extends Sprite
{
	private var mStarling:Starling;
	private var mScaler:ScreenDensityScaleFactorManager;
 
	public function Startup()
	{
		mStarling = new Starling( Game, stage );
		mScaler = new ScreenDensityScaleFactorManager( mStarling );
		mStarling.start();
	}
}
```

You don't need to set the dimensions of Starling's view port, or the `stageWidth` and `stageHeight` properties of the Starling stage. `ScreenDensityScaleFactorManager` handles it all for you — even when the device's orientation changes.

`ScreenDensityScaleFactorManager` is considered optional, and if you'd prefer to manage the Starling view port and stage size manually using the techniques in [Multi-Resolution Development](http://wiki.starling-framework.org/manual/multi-resolution_development), Feathers fully supports that approach too.

### Changes to example themes

The example themes have been modified to allow Starling to automatically scale assets using `contentScaleFactor`. The textures in these themes now use a scale factor value of 2.

The themes no longer have `scale` variable that is calculated using the screen density. Pixel dimensions and font sizes are now the same for all scale factors.

If subclasses of example themes define `scale9Grid` rectangles, the values may need to be scaled down to continue working in Feathers 3.0. Previously, these themes defined textures with scale factor 1, and then scaled them up or down manually using the `scale` variable. Since the textures now use scale factor 2, the old `scale9Grid` values should be divided by 2. Note: If the original values in the `scale9Grid` are odd numbers, rounding up may work, but the skin may need to be widened by an extra pixel to get an even number width or height.

## Duplicate constants moved to shared classes

In previous versions of Feathers, a number of constants were duplicated across many classes. For instance, you could find `HORIZONTAL_ALIGN_LEFT` on such classes as `Button`, `DefaultListItemRenderer`, `HorizontalLayout`, and `TiledRowsLayout` (and elsewhere too!). In Feathers 3.0, you can now use a shared `HorizontalAlign.LEFT` constant. Put another way, once you've used `HorizontalAlign.LEFT` constant with one class, you'll know exactly where to find when you need it in the future for any other class.

Other duplicate constants have been consolidated in the same way. The following classes with shared constants have been added to Feathers:

-   [`feathers.controls.AutoSizeMode`](../api-reference/feathers/layout/AutoSizeMode.html)

-   [`feathers.controls.ButtonState`](../api-reference/feathers/layout/ButtonState.html)

-   [`feathers.controls.DecelerationRate`](../api-reference/feathers/layout/DecelerationRate.html)

-   [`feathers.controls.ScrollBarDisplayMode`](../api-reference/feathers/controls/ScrollBarDisplayMode.html)

-   [`feathers.controls.ScrollInteractionMode`](../api-reference/feathers/controls/ScrollInteractionMode.html)

-   [`feathers.controls.ScrollPolicy`](../api-reference/feathers/controls/ScrollPolicy.html)

-   [`feathers.controls.TextInputState`](../api-reference/feathers/layout/TextInputState.html)

-   [`feathers.layout.Direction`](../api-reference/feathers/layout/Direction.html)

-   [`feathers.layout.HorizontalAlign`](../api-reference/feathers/layout/HorizontalAlign.html)

-   [`feathers.layout.RelativePosition`](../api-reference/feathers/layout/RelativePosition.html)

-   [`feathers.layout.VerticalAlign`](../api-reference/feathers/layout/VerticalAlign.html)

<aside class="info">See [Appendix: List of Deprecated APIs](#appendix-list-of-deprecated-apis) for details about which deprecated constants map to the new shared constants.</aside>

The original duplicate constants are considered deprecated. They will remain available in order to maintain backward compatibility for a short time. However, they will be removed at some point in the future.

In general, a deprecated API in Feathers will not be removed until six months have passed or two minor updates have been released (whichever takes longer). However, due to the impact of this change, the deprecated constants will not be removed until 18 months have passed or one major update has been released (again, whichever takes longer). This should give developers more time to migrate.

Additionally, take a look at [Appendix: Find and Replace Regular Expressions](#appendix-find-and-replace-regular-expressions) to find a set of regular expressions to help automate the process of migrating to these new shared constants.

## Appendix: List of Removed APIs

The following table lists all removed APIs, organized alphabetically. The replacement API or migration instructions appear next to each listed API.

Removed API										| How to Migrate
----------------------------------------------- | -----------------------------
`ImageLoader.snapToPixels`						| Use the [`pixelSnapping`](../api-reference/feathers/controls/ImageLoader.html#pixelSnapping) property instead, which is also the name of the new property on `starling.display.Image`.
`ImageLoader.smoothing`						| Use the [`textureSmoothing`](../api-reference/feathers/controls/ImageLoader.html#textureSmoothing) property instead, which is also the new name of the property on `starling.display.Image`.
`Scale3Image`									| Create a `starling.display.Image` and set its `scale9Grid` property.
`Scale3Textures`								| See instructions for `Scale3Image`.
`Scale9Image`									| Create a `starling.display.Image` and set its `scale9Grid` property.
`Scale9Textures`								| See instructions for `Scale9Image`.
`Scale9ImageStateValueSelector`					| Create a [`feathers.skins.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) and call `setTextureForState()` to use multiple textures.
`SmartDisplayObjectStateValueSelector`			| Create a [`feathers.skins.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) and call `setTextureForState()` to use multiple textures.
`StandardIcons.listDrillDownAccessoryTexture`	| Add [`DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html#ALTERNATE_STYLE_NAME_DRILL_DOWN) to the item renderer's `styleNameList`.
`TiledImage`									| Create a `starling.display.Image` and set the `tileGrid` property.


## Appendix: List of Deprecated APIs

The following tables list all deprecated APIs, organized by class. The replacement API or migration instructions appear next to each listed property or method.

<aside class="warn">APIs that are deprecated have not been removed yet, but they will be removed at some point in the future. You are encouraged to migrate as soon as possible.</aside>

### `Alert`

No APIs are deprecated.

### `AutoComplete`

No APIs are deprecated.

### `BaseDefaultItemRenderer`

Deprecated API											| How to Migrate
------------------------------------------------------- | --------------------------------
`BaseDefaultItemRenderer.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`BaseDefaultItemRenderer.STATE_DOWN`					| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`BaseDefaultItemRenderer.STATE_HOVER`					| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`BaseDefaultItemRenderer.STATE_DISABLED`				| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`BaseDefaultItemRenderer.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`BaseDefaultItemRenderer.STATE_DOWN_AND_SELECTED`		| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`BaseDefaultItemRenderer.STATE_HOVER_AND_SELECTED`		| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`BaseDefaultItemRenderer.STATE_DISABLED_AND_SELECTED`	| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`BaseDefaultItemRenderer.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`BaseDefaultItemRenderer.ICON_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`BaseDefaultItemRenderer.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`BaseDefaultItemRenderer.ICON_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`BaseDefaultItemRenderer.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`BaseDefaultItemRenderer.ICON_POSITION_LEFT_BASELINE`	| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`BaseDefaultItemRenderer.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`BaseDefaultItemRenderer.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`BaseDefaultItemRenderer.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`BaseDefaultItemRenderer.HORIZONTAL_ALIGN_RIGHT`		| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`BaseDefaultItemRenderer.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`BaseDefaultItemRenderer.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`BaseDefaultItemRenderer.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`BaseDefaultItemRenderer.ACCESSORY_POSITION_TOP`		| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`BaseDefaultItemRenderer.ACCESSORY_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`BaseDefaultItemRenderer.ACCESSORY_POSITION_BOTTOM`		| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`BaseDefaultItemRenderer.ACCESSORY_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`BaseDefaultItemRenderer.ACCESSORY_POSITION_MANUAL`		| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)

### `Button`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`stateToSkinFunction`					| Pass an [`ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) to the `defaultSkin` property.
`stateToIconFunction`					| Pass an [`ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) to the `defaultIcon` property.
`stateToLabelPropertiesFunction`		| Set the font styles directly on the text renderer and use the `ButtonState` constants to set font styles for each state.
`upLabelProperties`						| Set font styles on text renderer using `ButtonState.UP`
`downLabelProperties`					| Set font styles on text renderer using `ButtonState.DOWN`
`hoverLabelProperties`					| Set font styles on text renderer using `ButtonState.HOVER`
`disabledLabelProperties`				| Set font styles on text renderer using `ButtonState.DISABLED`
`Button.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`Button.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`Button.STATE_HOVER`					| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`Button.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`Button.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`Button.ICON_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Button.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`Button.ICON_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`Button.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`Button.ICON_POSITION_LEFT_BASELINE`	| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`Button.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`Button.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`Button.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`Button.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`Button.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`Button.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`Button.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `ButtonGroup`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`ButtonGroup.DIRECTION_HORIZONTAL`		| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ButtonGroup.DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`ButtonGroup.HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`ButtonGroup.HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`ButtonGroup.HORIZONTAL_ALIGN_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`ButtonGroup.HORIZONTAL_ALIGN_JUSTIFY`	| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)
`ButtonGroup.VERTICAL_ALIGN_TOP`		| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`ButtonGroup.VERTICAL_ALIGN_MIDDLE`		| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`ButtonGroup.VERTICAL_ALIGN_BOTTOM`		| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`ButtonGroup.VERTICAL_ALIGN_JUSTIFY`	| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.html#JUSTIFY)

### `Callout`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`Callout.ARROW_POSITION_TOP`			| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`Callout.ARROW_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Callout.ARROW_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`Callout.ARROW_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)

### `Check`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`Check.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`Check.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`Check.STATE_HOVER`						| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`Check.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`Check.STATE_UP_AND_SELECTED`						| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`Check.STATE_DOWN_AND_SELECTED`						| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`Check.STATE_HOVER_AND_SELECTED`						| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`Check.STATE_DISABLED_AND_SELECTED`					| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`Check.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`Check.ICON_POSITION_RIGHT`				| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Check.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`Check.ICON_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`Check.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`Check.ICON_POSITION_LEFT_BASELINE`		| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`Check.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`Check.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`Check.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`Check.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`Check.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`Check.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`Check.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `DateTimeSpinner`

No APIs are deprecated.

## `DefaultGroupedListItemRenderer`

Deprecated API													| How to Migrate
--------------------------------------------------------------- | --------------------------------
`DefaultGroupedListItemRenderer.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`DefaultGroupedListItemRenderer.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`DefaultGroupedListItemRenderer.STATE_HOVER`					| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`DefaultGroupedListItemRenderer.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`DefaultGroupedListItemRenderer.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_DOWN_AND_SELECTED`		| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_HOVER_AND_SELECTED`		| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_DISABLED_AND_SELECTED`	| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`DefaultGroupedListItemRenderer.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultGroupedListItemRenderer.ICON_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultGroupedListItemRenderer.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultGroupedListItemRenderer.ICON_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultGroupedListItemRenderer.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultGroupedListItemRenderer.ICON_POSITION_LEFT_BASELINE`	| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`DefaultGroupedListItemRenderer.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_TOP`		| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_BOTTOM`		| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_MANUAL`		| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)

### `DefaultListItemRenderer`

Deprecated API											| How to Migrate
------------------------------------------------------- | --------------------------------
`DefaultListItemRenderer.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`DefaultListItemRenderer.STATE_DOWN`					| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`DefaultListItemRenderer.STATE_HOVER`					| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`DefaultListItemRenderer.STATE_DISABLED`				| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`DefaultListItemRenderer.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`DefaultListItemRenderer.STATE_DOWN_AND_SELECTED`		| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`DefaultListItemRenderer.STATE_HOVER_AND_SELECTED`		| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`DefaultListItemRenderer.STATE_DISABLED_AND_SELECTED`	| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`DefaultListItemRenderer.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultListItemRenderer.ICON_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultListItemRenderer.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultListItemRenderer.ICON_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultListItemRenderer.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultListItemRenderer.ICON_POSITION_LEFT_BASELINE`	| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`DefaultListItemRenderer.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_RIGHT`		| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`DefaultListItemRenderer.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`DefaultListItemRenderer.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`DefaultListItemRenderer.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`DefaultListItemRenderer.ACCESSORY_POSITION_TOP`		| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultListItemRenderer.ACCESSORY_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultListItemRenderer.ACCESSORY_POSITION_BOTTOM`		| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultListItemRenderer.ACCESSORY_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultListItemRenderer.ACCESSORY_POSITION_MANUAL`		| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)

### `Drawers`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`Drawers.AUTO_SIZE_MODE_STAGE`			| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`Drawers.AUTO_SIZE_MODE_CONTENT`		| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `GroupedList`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`GroupedList.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`GroupedList.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`GroupedList.SCROLL_POLICY_OFF`							| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`GroupedList.SCROLL_BAR_DISPLAY_MODE_FIXED`				| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`GroupedList.SCROLL_BAR_DISPLAY_MODE_FLOAT`				| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`GroupedList.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`GroupedList.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`GroupedList.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`GroupedList.VERTICAL_SCROLL_BAR_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`GroupedList.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`GroupedList.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`GroupedList.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`GroupedList.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`GroupedList.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`GroupedList.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`GroupedList.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)

## Appendix: Find and Replace Regular Expressions

Many IDEs and text editors offer the ability to use regular expressions to **Find and Replace** text in a file. You may use the following regular expressions to accelerate the Feathers 3.0 migration process.

<aside class="info">These regular expressions are provided for convenience only, and they may not work perfectly in all cases. After making replacements, be sure to double-check the modified code to verify that no unexpected errors were introduced.</aside>

Find 												| Replace
--------------------------------------------------- | -------------------------
`\w+\.HORIZONTAL_ALIGN_(\w+)`						| `HorizontalAlign.$1`
`\w+\.VERTICAL_ALIGN_(\w+)`							| `VerticalAlign.$1`
`\w+\.ICON_POSITION_(\w+)`							| `RelativePosition.$1`
`\w+\.ACCESSORY_POSITION_(\w+)`						| `RelativePosition.$1`
`\w+\.AUTO_SIZE_MODE_(\w+)`							| `AutoSizeMode.$1`
`\w+\.SCROLL_POLICY_(\w+)`							| `ScrollPolicy.$1`
`\w+\.SCROLL_BAR_DISPLAY_MODE_(\w+)`				| `ScrollBarDisplayMode.$1`
`(?<=[\s\,\(])(?!Callout)(?:\w+)\.DIRECTION_(\w+)`	| `Direction.$1`
`\w+\.MOUSE_WHEEL_SCROLL_DIRECTION_(\w+)`			| `Direction.$1`
`\w+\.VERTICAL_SCROLL_BAR_POSITION_(\w+)`			| `RelativePosition.$1`
`\w+\.DECELERATION_RATE_(\w+)`						| `DecelerationRate.$1`
`(?:(?<=[\s\,\(])(?!PageIndicator)(?:\w+))\.INTERACTION_MODE_(\w+)` | `ScrollInteractionMode.$1`
`(?:TextInput|TextArea).STATE_(\w+)`				| `TextInputState.$1`
`(?:Button|ToggleButton|Check|Radio).STATE_(\w+)`	| `ButtonState.$1`
`\w+ItemRenderer.STATE_(\w+)`						| `ButtonState.$1`
