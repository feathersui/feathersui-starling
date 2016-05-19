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
	
-   [`saveMeasurements()` replaces `setSizeInternal()`](#savemeasurements-replaces-setsizeinternal)
	
-   [Return type API changes](#return-type-api-changes)

-   [Multi-Resolution Development with Feathers](#multi-resolution-development-with-feathers)

-   [Duplicate constants moved to shared classes](#duplicate-constants-moved-to-shared-classes)

-   [Backwards compatibility with `feathers-compat`](#backwards-compatibility-with-feathers-compat)

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

<aside class="info">`ImageSkin` is a subclass of `starling.display.Image`, so all properties like `scale9Grid` and `tileGrid` are available too!</aside>

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
textRenderer.setTextFormatForState( ButtonState.DOWN,
	new BitmapFontTextFormat( "My Font", BitmapFont.NATIVE_SIZE, 0xffcc00 ) );

textRenderer.setTextFormatForState( ButtonState.DISABLED,
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

## `saveMeasurements()` replaces `setSizeInternal()`

Custom component developers should migrate to the new `saveMeasurements()` as a replacement for `setSizeInternal()`, which is now considered deprecated.

In addition to the more intuitive name, `saveMeasurements()` now allows components to dynamically calculate minimum width and height:

``` code
this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
```

To maintain the previous behavior, you may pass a value of `0` for the minimum dimensions:

``` code
this.saveMeasurements(newWidth, newHeight, 0, 0);
```

You might also consider setting the minimum dimensions to the same as the regular dimensions:

``` code
this.saveMeasurements(newWidth, newHeight, newWidth, newHeight);
```

All of the core Feathers components now calculate minimum dimensions, if they are not set explicitly.

## Return type API changes

The [`Drawers`](drawers.html) component now requires its content and drawers to be Feathers components. Previously, `starling.display.Sprite` was allowed. To replace `Sprite` as a generic container, consider using [`LayoutGroup`](layout-group.html) instead.

The [`INativeFocusOwner`](../api-reference/feathers/core/INativeFocusOwner.html) interface now returns type `Object` for its `nativeFocus` property to allow objects like `flash.text.StageText` to receive focus. Previously, the return type was `flash.display.InteractiveObject`.

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

## Backwards compatibility with `feathers-compat`

The [`feathers-compat`](https://github.com/BowlerHatLLC/feathers-compat) project is a backwards compatibility library that is designed to make migration to Feathers 3.0 easier. It includes a number classes that were removed from Feathers 3.0. If you relied on these classes with earlier versions of Feathers, use `feathers-compat` to get your project up and running more quickly when upgrading to Starling 2.0 and Feathers 3.0. Then, you can take a little extra time to migrate your existing code.

For example, if you used `SmartDisplayObjectValueSelector` for skinning, you are strongly encouraged to switch to the new, more intuitive `ImageSkin`. However, you can add `feathers-compat` to your project, and you'll be able to continue using `SmartDisplayObjectValueSelector` and save the migration to `ImageSkin` for a later time.

[Download `feathers-compat` from Github](https://github.com/BowlerHatLLC/feathers-compat)

## Appendix: List of Removed APIs

The following table lists all removed APIs, organized alphabetically. The replacement API or migration instructions appear next to each listed API.

Removed API										| How to Migrate
----------------------------------------------- | -----------------------------
`BitmapFontTextRenderer.snapToPixels`			| Use the [`pixelSnapping`](../api-reference/feathers/controls/BitmapFontTextRenderer.html#pixelSnapping) property instead, which is also the name of the new property on `starling.display.Mesh`.
`ImageLoader.snapToPixels`						| Use the [`pixelSnapping`](../api-reference/feathers/controls/ImageLoader.html#pixelSnapping) property instead, which is also the name of the new property on `starling.display.Mesh`.
`ImageLoader.smoothing`						| Use the [`textureSmoothing`](../api-reference/feathers/controls/ImageLoader.html#textureSmoothing) property instead, which is also the new name of the property on `starling.display.Image`.
`OldFadeNewSlideTransitionManager`				| Switch to `StackScreenNavigator` to get full support for navigation history. Create a custom `pushTransition` and `popTransition`.
`Scale3Image`									| Create a `starling.display.Image` and set its `scale9Grid` property.
`Scale3Textures`								| See instructions for `Scale3Image`.
`Scale9Image`									| Create a `starling.display.Image` and set its `scale9Grid` property.
`Scale9Textures`								| See instructions for `Scale9Image`.
`Scale9ImageStateValueSelector`					| Create a [`feathers.skins.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) and call `setTextureForState()` to use multiple textures.
`ScreenFadeTransitionManager`					| Use `Fade` transition.
`ScreenSlidingStackTransitionManager`			| Switch to `StackScreenNavigator` to get full support for navigation history. Use `Slide` for `pushTransition` and `popTransition`.
`SmartDisplayObjectStateValueSelector`			| Create a [`feathers.skins.ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) and call `setTextureForState()` to use multiple textures.
`StandardIcons.listDrillDownAccessoryTexture`	| Add [`DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN`](../api-reference/feathers/controls/renderers/DefaultListItemRenderer.html#ALTERNATE_STYLE_NAME_DRILL_DOWN) to the item renderer's `styleNameList`.
`TextBlockTextRenderer.snapToPixels`			| Use the [`pixelSnapping`](../api-reference/feathers/controls/TextBlockTextRenderer.html#pixelSnapping) property instead, which is also the name of the new property on `starling.display.Mesh`.
`TextFieldTextRenderer.snapToPixels`			| Use the [`pixelSnapping`](../api-reference/feathers/controls/TextFieldTextRenderer.html#pixelSnapping) property instead, which is also the name of the new property on `starling.display.Mesh`.
`TiledImage`									| Create a `starling.display.Image` and set the `tileGrid` property.


## Appendix: List of Deprecated APIs

The following tables list all deprecated APIs, organized by class. The replacement API or migration instructions appear next to each listed property or method.

<aside class="warn">APIs that are deprecated have not been removed yet, but they will be removed at some point in the future. You are encouraged to migrate as soon as possible.</aside>

### `FeathersControl`

Deprecated API					| How to Migrate
------------------------------- | -----------------------------------------
`setSizeInternal()`				| [`saveMeasurements()`](../api-reference/feathers/core/FeathersControl.html#saveMeasurements())

### `Alert`

No APIs are deprecated.

### `AutoComplete`

No APIs are deprecated.

### `BaseDefaultItemRenderer`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
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
`supportedDirections`					| `supportedPositions`
`Callout.ARROW_POSITION_TOP`			| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`Callout.ARROW_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Callout.ARROW_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`Callout.ARROW_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`Callout.DIRECTION_ANY`					| `null`
`Callout.DIRECTION_HORIZONTAL`			| `new <String>[RelativePosition.RIGHT, RelativePosition.LEFT]`
`Callout.DIRECTION_VERTICAL`			| `new <String>[RelativePosition.BOTTOM, RelativePosition.TOP]`
`Callout.DIRECTION_TOP`					| `new <String>[RelativePosition.TOP]`
`Callout.DIRECTION_RIGHT`				| `new <String>[RelativePosition.RIGHT]`
`Callout.DIRECTION_BOTTOM`				| `new <String>[RelativePosition.BOTTOM]`
`Callout.DIRECTION_LEFT`				| `new <String>[RelativePosition.LEFT]`

### `Check`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`Check.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`Check.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`Check.STATE_HOVER`						| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`Check.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`Check.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`Check.STATE_DOWN_AND_SELECTED`			| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`Check.STATE_HOVER_AND_SELECTED`		| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`Check.STATE_DISABLED_AND_SELECTED`		| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
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

Deprecated API									| How to Migrate
----------------------------------------------- | -----------------------------
`DateTimeSpinner.EDITING_MODE_DATE`				| [`DateTimeMode.DATE`](../api-reference/feathers/controls/DateTimeMode.html#DATE)
`DateTimeSpinner.EDITING_MODE_TIME`				| [`DateTimeMode.TIME`](../api-reference/feathers/controls/DateTimeMode.html#TIME)
`DateTimeSpinner.EDITING_MODE_DATE_AND_TIME`	| [`DateTimeMode.DATE_AND_TIME`](../api-reference/feathers/controls/DateTimeMode.html#DATE_AND_TIME)

## `DefaultGroupedListItemRenderer`

Deprecated API														| How to Migrate
------------------------------------------------------------------- | ---------
`DefaultGroupedListItemRenderer.STATE_UP`							| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`DefaultGroupedListItemRenderer.STATE_DOWN`							| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`DefaultGroupedListItemRenderer.STATE_HOVER`						| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`DefaultGroupedListItemRenderer.STATE_DISABLED`						| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`DefaultGroupedListItemRenderer.STATE_UP_AND_SELECTED`				| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_DOWN_AND_SELECTED`			| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_HOVER_AND_SELECTED`			| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`DefaultGroupedListItemRenderer.STATE_DISABLED_AND_SELECTED`		| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`DefaultGroupedListItemRenderer.ICON_POSITION_TOP`					| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultGroupedListItemRenderer.ICON_POSITION_RIGHT`				| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultGroupedListItemRenderer.ICON_POSITION_BOTTOM`				| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultGroupedListItemRenderer.ICON_POSITION_LEFT`					| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultGroupedListItemRenderer.ICON_POSITION_MANUAL`				| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultGroupedListItemRenderer.ICON_POSITION_LEFT_BASELINE`		| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`DefaultGroupedListItemRenderer.ICON_POSITION_RIGHT_BASELINE`		| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_LEFT`				| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`DefaultGroupedListItemRenderer.HORIZONTAL_ALIGN_RIGHT`				| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_TOP`					| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_MIDDLE`				| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`DefaultGroupedListItemRenderer.VERTICAL_ALIGN_BOTTOM`				| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultGroupedListItemRenderer.ACCESSORY_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultGroupedListItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY`	| [`ItemRendererLayoutOrder.MANUAL`](../api-reference/feathers/controls/ItemRendererLayoutOrder.html#LABEL_ICON_ACCESSORY)
`DefaultGroupedListItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON`	| [`ItemRendererLayoutOrder.MANUAL`](../api-reference/feathers/controls/ItemRendererLayoutOrder.html#LABEL_ACCESSORY_ICON)

### `DefaultListItemRenderer`

Deprecated API													| How to Migrate
--------------------------------------------------------------- | -------------
`DefaultListItemRenderer.STATE_UP`								| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`DefaultListItemRenderer.STATE_DOWN`							| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`DefaultListItemRenderer.STATE_HOVER`							| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`DefaultListItemRenderer.STATE_DISABLED`						| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`DefaultListItemRenderer.STATE_UP_AND_SELECTED`					| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`DefaultListItemRenderer.STATE_DOWN_AND_SELECTED`				| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`DefaultListItemRenderer.STATE_HOVER_AND_SELECTED`				| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`DefaultListItemRenderer.STATE_DISABLED_AND_SELECTED`			| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`DefaultListItemRenderer.ICON_POSITION_TOP`						| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultListItemRenderer.ICON_POSITION_RIGHT`					| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultListItemRenderer.ICON_POSITION_BOTTOM`					| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultListItemRenderer.ICON_POSITION_LEFT`					| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultListItemRenderer.ICON_POSITION_MANUAL`					| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultListItemRenderer.ICON_POSITION_LEFT_BASELINE`			| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`DefaultListItemRenderer.ICON_POSITION_RIGHT_BASELINE`			| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_LEFT`					| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_CENTER`				| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`DefaultListItemRenderer.HORIZONTAL_ALIGN_RIGHT`				| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`DefaultListItemRenderer.VERTICAL_ALIGN_TOP`					| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`DefaultListItemRenderer.VERTICAL_ALIGN_MIDDLE`					| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`DefaultListItemRenderer.VERTICAL_ALIGN_BOTTOM`					| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`DefaultListItemRenderer.ACCESSORY_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`DefaultListItemRenderer.ACCESSORY_POSITION_RIGHT`				| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`DefaultListItemRenderer.ACCESSORY_POSITION_BOTTOM`				| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`DefaultListItemRenderer.ACCESSORY_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`DefaultListItemRenderer.ACCESSORY_POSITION_MANUAL`		 		| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`DefaultListItemRenderer.LAYOUT_ORDER_LABEL_ICON_ACCESSORY`		| [`ItemRendererLayoutOrder.MANUAL`](../api-reference/feathers/controls/ItemRendererLayoutOrder.html#LABEL_ICON_ACCESSORY)
`DefaultListItemRenderer.LAYOUT_ORDER_LABEL_ACCESSORY_ICON`		| [`ItemRendererLayoutOrder.MANUAL`](../api-reference/feathers/controls/ItemRendererLayoutOrder.html#LABEL_ACCESSORY_ICON)

### `Drawers`

Deprecated API								| How to Migrate
------------------------------------------- | --------------------------------
`Drawers.AUTO_SIZE_MODE_STAGE`				| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`Drawers.AUTO_SIZE_MODE_CONTENT`			| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)
`Drawers.DOCK_MODE_LANDSCAPE`				| [`Orientation.LANDSCAPE`](../api-reference/feathers/layout/Orientation.html#LANDSCAPE)
`Drawers.DOCK_MODE_PORTRAIT`				| [`Orientation.PORTRAIT`](../api-reference/feathers/layout/Orientation.html#PORTRAIT)
`Drawers.DOCK_MODE_BOTH`					| [`Orientation.BOTH`](../api-reference/feathers/layout/Orientation.html#BOTH)
`Drawers.DOCK_MODE_NONE`					| [`Orientation.NONE`](../api-reference/feathers/layout/Orientation.html#NONE)
`Drawers.OPEN_GESTURE_DRAG_CONTENT`			| [`DragGesture.CONTENT`](../api-reference/feathers/controls/DragGesture.html#CONTENT)
`Drawers.OPEN_GESTURE_DRAG_CONTENT_EDGE`	| [`DragGesture.EDGE`](../api-reference/feathers/controls/DragGesture.html#EDGE)
`Drawers.OPEN_GESTURE_NONE`					| [`DragGesture.NONE`](../api-reference/feathers/controls/DragGesture.html#NONE)

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

### `Header`

Deprecated API						| How to Migrate
----------------------------------- | -----------------------------------------
`Header.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`Header.VERTICAL_ALIGN_MIDDLE`		| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`Header.VERTICAL_ALIGN_BOTTOM`		| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`Header.TITLE_ALIGN_PREFER_LEFT`	| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`Header.TITLE_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`Header.TITLE_ALIGN_PREFER_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)

### `ImageLoader`

Deprecated API							| How to Migrate
--------------------------------------- | -------------------------------------
`ImageLoader.HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`ImageLoader.HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`ImageLoader.HORIZONTAL_ALIGN_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`ImageLoader.VERTICAL_ALIGN_TOP`		| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`ImageLoader.VERTICAL_ALIGN_MIDDLE`		| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`ImageLoader.VERTICAL_ALIGN_BOTTOM`		| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `Label`

No APIs are deprecated.

### `LayoutGroup`

Deprecated API							| How to Migrate
--------------------------------------- | -------------------------------------
`LayoutGroup.AUTO_SIZE_MODE_STAGE`		| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`LayoutGroup.AUTO_SIZE_MODE_CONTENT`	| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `List`

Deprecated API									| How to Migrate
----------------------------------------------- | ---------------------
`List.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`List.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`List.SCROLL_POLICY_OFF`						| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`List.SCROLL_BAR_DISPLAY_MODE_FIXED`			| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`List.SCROLL_BAR_DISPLAY_MODE_FLOAT`			| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`List.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`List.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`List.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`List.VERTICAL_SCROLL_BAR_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`List.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`List.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`List.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`List.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`	| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`List.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`List.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`List.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)

### `NumericStepper`

Deprecated API												| How to Migrate
----------------------------------------------------------- | -----------------
`NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_HORIZONTAL`		| [`StepperButtonLayoutMode.SPLIT_HORIZONTAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#SPLIT_HORIZONTAL)
`NumericStepper.BUTTON_LAYOUT_MODE_SPLIT_VERTICAL`			| [`StepperButtonLayoutMode.SPLIT_VERTICAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#SPLIT_VERTICAL)
`NumericStepper.BUTTON_LAYOUT_MODE_RIGHT_SIDE_VERTICAL`		| [`StepperButtonLayoutMode.RIGHT_SIDE_VERTICAL`](../api-reference/feathers/controls/StepperButtonLayoutMode.html#RIGHT_SIDE_VERTICAL)

### `PageIndicator`

Deprecated API									| How to Migrate
----------------------------------------------- | -----------------------------
`PageIndicator.INTERACTION_MODE_PREVIOUS_NEXT`	| [`PageIndicatorInteractionMode.PREVIOUS_NEXT`](../api-reference/feathers/controls/PageIndicatorInteractionMode.html#PREVIOUS_NEXT)
`PageIndicator.DIRECTION_HORIZONTAL`			| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`PageIndicator.DIRECTION_VERTICAL`				| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`PageIndicator.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`PageIndicator.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`PageIndicator.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`PageIndicator.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`PageIndicator.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`PageIndicator.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `Panel`

Deprecated API									| How to Migrate
----------------------------------------------- | ---------------------
`Panel.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`Panel.SCROLL_POLICY_ON`						| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`Panel.SCROLL_POLICY_OFF`						| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`Panel.SCROLL_BAR_DISPLAY_MODE_FIXED`			| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`Panel.SCROLL_BAR_DISPLAY_MODE_FLOAT`			| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`Panel.SCROLL_BAR_DISPLAY_MODE_NONE`			| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`Panel.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`Panel.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Panel.VERTICAL_SCROLL_BAR_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`Panel.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`Panel.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`Panel.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`Panel.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`	| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`Panel.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`Panel.DECELERATION_RATE_NORMAL`				| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`Panel.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)
`Panel.AUTO_SIZE_MODE_STAGE`					| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`Panel.AUTO_SIZE_MODE_CONTENT`					| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `PanelScreen`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`PanelScreen.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`PanelScreen.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`PanelScreen.SCROLL_POLICY_OFF`							| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`PanelScreen.SCROLL_BAR_DISPLAY_MODE_FIXED`				| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`PanelScreen.SCROLL_BAR_DISPLAY_MODE_FLOAT`				| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`PanelScreen.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`PanelScreen.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`PanelScreen.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`PanelScreen.VERTICAL_SCROLL_BAR_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`PanelScreen.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`PanelScreen.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`PanelScreen.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`PanelScreen.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`PanelScreen.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`PanelScreen.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`PanelScreen.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)
`PanelScreen.AUTO_SIZE_MODE_STAGE`						| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`PanelScreen.AUTO_SIZE_MODE_CONTENT`					| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `PickerList`

No APIs are deprecated.

### `ProgressBar`

Deprecated API						| How to Migrate
----------------------------------- | -------------------------------------
`ProgressBar.DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ProgressBar.DIRECTION_VERTICAL`	| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)

### `Radio`

Deprecated API							| How to Migrate
--------------------------------------- | --------------------------------
`Radio.STATE_UP`						| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`Radio.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`Radio.STATE_HOVER`						| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`Radio.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`Radio.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`Radio.STATE_DOWN_AND_SELECTED`			| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`Radio.STATE_HOVER_AND_SELECTED`		| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`Radio.STATE_DISABLED_AND_SELECTED`		| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`Radio.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`Radio.ICON_POSITION_RIGHT`				| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`Radio.ICON_POSITION_BOTTOM`			| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`Radio.ICON_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`Radio.ICON_POSITION_MANUAL`			| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`Radio.ICON_POSITION_LEFT_BASELINE`		| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`Radio.ICON_POSITION_RIGHT_BASELINE`	| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`Radio.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`Radio.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`Radio.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`Radio.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`Radio.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`Radio.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `Screen`

Deprecated API						| How to Migrate
----------------------------------- | -------------------------------------
`Screen.AUTO_SIZE_MODE_STAGE`		| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`Screen.AUTO_SIZE_MODE_CONTENT`		| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `ScreenNavigator`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`ScreenNavigator.AUTO_SIZE_MODE_STAGE`		| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`ScreenNavigator.AUTO_SIZE_MODE_CONTENT`	| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `ScrollBar`

Deprecated API							| How to Migrate
--------------------------------------- | -------------------------------------
`ScrollBar.DIRECTION_HORIZONTAL`		| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ScrollBar.DIRECTION_VERTICAL`			| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`ScrollBar.TRACK_LAYOUT_MODE_SINGLE`	| [`TrackLayoutMode.SINGLE`](../api-reference/feathers/controls/TrackLayoutMode.html#SINGLE)
`ScrollBar.TRACK_LAYOUT_MODE_MIN_MAX`	| [`TrackLayoutMode.SPLIT`](../api-reference/feathers/controls/TrackLayoutMode.html#SPLIT)

### `ScrollContainer`

Deprecated API												| How to Migrate
----------------------------------------------------------- | -----------------
`ScrollContainer.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`ScrollContainer.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`ScrollContainer.SCROLL_POLICY_OFF`							| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED`				| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FLOAT`				| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollContainer.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollContainer.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`ScrollContainer.VERTICAL_SCROLL_BAR_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`ScrollContainer.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`ScrollContainer.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`ScrollContainer.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`ScrollContainer.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`ScrollContainer.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ScrollContainer.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`ScrollContainer.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)
`ScrollContainer.AUTO_SIZE_MODE_STAGE`						| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`ScrollContainer.AUTO_SIZE_MODE_CONTENT`					| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `ScrollScreen`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`ScrollScreen.SCROLL_POLICY_AUTO`						| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`ScrollScreen.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`ScrollScreen.SCROLL_POLICY_OFF`						| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`ScrollScreen.SCROLL_BAR_DISPLAY_MODE_FIXED`			| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`ScrollScreen.SCROLL_BAR_DISPLAY_MODE_FLOAT`			| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollScreen.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`ScrollScreen.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollScreen.VERTICAL_SCROLL_BAR_POSITION_RIGHT`		| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`ScrollScreen.VERTICAL_SCROLL_BAR_POSITION_LEFT`		| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`ScrollScreen.INTERACTION_MODE_TOUCH`					| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`ScrollScreen.INTERACTION_MODE_MOUSE`					| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`ScrollScreen.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`	| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`ScrollScreen.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`	| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`ScrollScreen.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ScrollScreen.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`ScrollScreen.DECELERATION_RATE_FAST`					| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)
`ScrollScreen.AUTO_SIZE_MODE_STAGE`						| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`ScrollScreen.AUTO_SIZE_MODE_CONTENT`					| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `ScrollText`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`ScrollText.SCROLL_POLICY_AUTO`							| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`ScrollText.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`ScrollText.SCROLL_POLICY_OFF`							| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`ScrollText.SCROLL_BAR_DISPLAY_MODE_FIXED`				| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`ScrollText.SCROLL_BAR_DISPLAY_MODE_FLOAT`				| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollText.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`ScrollText.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`ScrollText.VERTICAL_SCROLL_BAR_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`ScrollText.VERTICAL_SCROLL_BAR_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`ScrollText.INTERACTION_MODE_TOUCH`						| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`ScrollText.INTERACTION_MODE_MOUSE`						| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`ScrollText.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`		| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`ScrollText.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`ScrollText.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`ScrollText.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`ScrollText.DECELERATION_RATE_FAST`						| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)

### `SimpleScrollBar`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`SimpleScrollBar.DIRECTION_HORIZONTAL`		| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`SimpleScrollBar.DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)

### `Slider`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`Slider.DIRECTION_HORIZONTAL`				| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`Slider.DIRECTION_VERTICAL`					| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`Slider.TRACK_LAYOUT_MODE_SINGLE`			| [`TrackLayoutMode.SINGLE`](../api-reference/feathers/controls/TrackLayoutMode.html#SINGLE)
`Slider.TRACK_LAYOUT_MODE_MIN_MAX`			| [`TrackLayoutMode.SPLIT`](../api-reference/feathers/controls/TrackLayoutMode.html#SPLIT)
`Slider.TRACK_SCALE_MODE_DIRECTIONAL`		| [`TrackScaleMode.DIRECTIONAL`](../api-reference/feathers/controls/TrackScaleMode.html#DIRECTIONAL)
`Slider.TRACK_SCALE_MODE_EXACT_FIT`			| [`TrackScaleMode.EXACT_FIT`](../api-reference/feathers/controls/TrackScaleMode.html#EXACT_FIT)
`Slider.TRACK_INTERACTION_MODE_TO_VALUE`	| [`TrackInteractionMode.TO_VALUE`](../api-reference/feathers/controls/TrackInteractionMode.html#TO_VALUE)
`Slider.TRACK_INTERACTION_MODE_BY_PAGE`		| [`TrackInteractionMode.BY_PAGE`](../api-reference/feathers/controls/TrackInteractionMode.html#BY_PAGE)

### `SoundPlayer`

No APIs are deprecated.

### `SpinnerList`

No APIs are deprecated.

### `StackScreenNavigator`

Deprecated API									| How to Migrate
----------------------------------------------- | -----------------------------
`StackScreenNavigator.AUTO_SIZE_MODE_STAGE`		| [`AutoSizeMode.STAGE`](../api-reference/feathers/controls/AutoSizeMode.html#STAGE)
`StackScreenNavigator.AUTO_SIZE_MODE_CONTENT`	| [`AutoSizeMode.CONTENT`](../api-reference/feathers/controls/AutoSizeMode.html#CONTENT)

### `TabBar`

Deprecated API						| How to Migrate
----------------------------------- | -----------------------------------------
`TabBar.DIRECTION_HORIZONTAL`		| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`TabBar.DIRECTION_VERTICAL`			| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`TabBar.HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`TabBar.HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`TabBar.HORIZONTAL_ALIGN_RIGHT`		| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`TabBar.HORIZONTAL_ALIGN_JUSTIFY`	| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)
`TabBar.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TabBar.VERTICAL_ALIGN_MIDDLE`		| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TabBar.VERTICAL_ALIGN_BOTTOM`		| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TabBar.VERTICAL_ALIGN_JUSTIFY`		| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.html#JUSTIFY)

### `TextArea`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`stateToSkinFunction`									| Pass an [`ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) to the `backgroundSkin` property.
`TextArea.STATE_ENABLED`								| [`TextInputState.ENABLED`](../api-reference/feathers/controls/TextInputState.html#ENABLED)
`TextArea.STATE_DISABLED`								| [`TextInputState.DISABLED`](../api-reference/feathers/controls/TextInputState.html#DISABLED)
`TextArea.STATE_FOCUSED`								| [`TextInputState.FOCUSED`](../api-reference/feathers/controls/TextInputState.html#FOCUSED)
`TextArea.SCROLL_POLICY_AUTO`							| [`ScrollPolicy.AUTO`](../api-reference/feathers/controls/ScrollPolicy.html#AUTO)
`TextArea.SCROLL_POLICY_ON`							| [`ScrollPolicy.ON`](../api-reference/feathers/controls/ScrollPolicy.html#ON)
`TextArea.SCROLL_POLICY_OFF`							| [`ScrollPolicy.OFF`](../api-reference/feathers/controls/ScrollPolicy.html#OFF)
`TextArea.SCROLL_BAR_DISPLAY_MODE_FIXED`				| [`ScrollBarDisplayMode.FIXED`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FIXED)
`TextArea.SCROLL_BAR_DISPLAY_MODE_FLOAT`				| [`ScrollBarDisplayMode.FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`TextArea.SCROLL_BAR_DISPLAY_MODE_NONE`				| [`ScrollBarDisplayMode.NONE`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#NONE)
`TextArea.SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT`		| [`ScrollBarDisplayMode.FIXED_FLOAT`](../api-reference/feathers/controls/ScrollBarDisplayMode.html#FLOAT)
`TextArea.VERTICAL_SCROLL_BAR_POSITION_RIGHT`			| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`TextArea.VERTICAL_SCROLL_BAR_POSITION_LEFT`			| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`TextArea.INTERACTION_MODE_TOUCH`						| [`ScrollInteractionMode.TOUCH`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH)
`TextArea.INTERACTION_MODE_MOUSE`						| [`ScrollInteractionMode.MOUSE`](../api-reference/feathers/controls/ScrollInteractionMode.html#MOUSE)
`TextArea.INTERACTION_MODE_TOUCH_AND_SCROLL_BARS`		| [`ScrollInteractionMode.TOUCH_AND_SCROLL_BARS`](../api-reference/feathers/controls/ScrollInteractionMode.html#TOUCH_AND_SCROLL_BARS)
`TextArea.MOUSE_WHEEL_SCROLL_DIRECTION_VERTICAL`		| [`Direction.VERTICAL`](../api-reference/feathers/layout/Direction.html#VERTICAL)
`TextArea.MOUSE_WHEEL_SCROLL_DIRECTION_HORIZONTAL`	| [`Direction.HORIZONTAL`](../api-reference/feathers/layout/Direction.html#HORIZONTAL)
`TextArea.DECELERATION_RATE_NORMAL`					| [`DecelerationRate.NORMAL`](../api-reference/feathers/controls/DecelerationRate.html#NORMAL)
`TextArea.DECELERATION_RATE_FAST`						| [`DecelerationRate.FAST`](../api-reference/feathers/controls/DecelerationRate.html#FAST)

### `TextInput`

Deprecated API						| How to Migrate
----------------------------------- | -----------------------------------------
`stateToSkinFunction`				| Pass an [`ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) to the `backgroundSkin` property.
`stateToIconFunction`				| Pass an [`ImageSkin`](../api-reference/feathers/skins/ImageSkin.html) to the `defaultIcon` property.
`TextInput.STATE_ENABLED`			| [`TextInputState.ENABLED`](../api-reference/feathers/controls/TextInputState.html#ENABLED)
`TextInput.STATE_DISABLED`			| [`TextInputState.DISABLED`](../api-reference/feathers/controls/TextInputState.html#DISABLED)
`TextInput.STATE_FOCUSED`			| [`TextInputState.FOCUSED`](../api-reference/feathers/controls/TextInputState.html#FOCUSED)
`TextInput.VERTICAL_ALIGN_TOP`		| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TextInput.VERTICAL_ALIGN_MIDDLE`	| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TextInput.VERTICAL_ALIGN_BOTTOM`	| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TextInput.VERTICAL_ALIGN_JUSTIFY`	| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.html#JUSTIFY)

### `ToggleButton`

Deprecated API									| How to Migrate
----------------------------------------------- | -----------------------------
`ToggleButton.STATE_UP`							| [`ButtonState.UP`](../api-reference/feathers/controls/ButtonState.html#UP)
`ToggleButton.STATE_DOWN`						| [`ButtonState.DOWN`](../api-reference/feathers/controls/ButtonState.html#DOWN)
`ToggleButton.STATE_HOVER`						| [`ButtonState.HOVER`](../api-reference/feathers/controls/ButtonState.html#HOVER)
`ToggleButton.STATE_DISABLED`					| [`ButtonState.DISABLED`](../api-reference/feathers/controls/ButtonState.html#DISABLED)
`ToggleButton.STATE_UP_AND_SELECTED`			| [`ButtonState.UP_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#UP_AND_SELECTED)
`ToggleButton.STATE_DOWN_AND_SELECTED`			| [`ButtonState.DOWN_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DOWN_AND_SELECTED)
`ToggleButton.STATE_HOVER_AND_SELECTED`			| [`ButtonState.HOVER_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#HOVER_AND_SELECTED)
`ToggleButton.STATE_DISABLED_AND_SELECTED`		| [`ButtonState.DISABLED_AND_SELECTED`](../api-reference/feathers/controls/ButtonState.html#DISABLED_AND_SELECTED)
`ToggleButton.ICON_POSITION_TOP`				| [`RelativePosition.TOP`](../api-reference/feathers/layout/RelativePosition.html#TOP)
`ToggleButton.ICON_POSITION_RIGHT`				| [`RelativePosition.RIGHT`](../api-reference/feathers/layout/RelativePosition.html#RIGHT)
`ToggleButton.ICON_POSITION_BOTTOM`				| [`RelativePosition.BOTTOM`](../api-reference/feathers/layout/RelativePosition.html#BOTTOM)
`ToggleButton.ICON_POSITION_LEFT`				| [`RelativePosition.LEFT`](../api-reference/feathers/layout/RelativePosition.html#LEFT)
`ToggleButton.ICON_POSITION_MANUAL`				| [`RelativePosition.MANUAL`](../api-reference/feathers/layout/RelativePosition.html#MANUAL)
`ToggleButton.ICON_POSITION_LEFT_BASELINE`		| [`RelativePosition.LEFT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#LEFT_BASELINE)
`ToggleButton.ICON_POSITION_RIGHT_BASELINE`		| [`RelativePosition.RIGHT_BASELINE`](../api-reference/feathers/layout/RelativePosition.html#RIGHT_BASELINE)
`ToggleButton.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`ToggleButton.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`ToggleButton.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`ToggleButton.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`ToggleButton.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`ToggleButton.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `ToggleSwitch`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE`		| [`TrackLayoutMode.SINGLE`](../api-reference/feathers/controls/TrackLayoutMode.html#SINGLE)
`ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF`		| [`TrackLayoutMode.SPLIT`](../api-reference/feathers/controls/TrackLayoutMode.html#SPLIT)
`ToggleSwitch.LABEL_ALIGN_MIDDLE`			| No replacement. It was a workaround for incorrect height returned by `TextBlockTextRenderer`, and that has been fixed.
`ToggleSwitch.LABEL_ALIGN_BASELINE`			| No replacement. It was a workaround for incorrect height returned by `TextBlockTextRenderer`, and that has been fixed.
`labelAlign`								| No replacement. It was a workaround for incorrect height returned by `TextBlockTextRenderer`, and that has been fixed.

### `WebView`

No APIs are deprecated.

### `VideoPlayer`

No APIs are deprecated.

### `FlowLayout`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`FlowLayout.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`FlowLayout.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`FlowLayout.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`FlowLayout.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`FlowLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`FlowLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `HorizontalLayout`

Deprecated API										| How to Migrate
--------------------------------------------------- | -------------------------
`HorizontalLayout.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`HorizontalLayout.HORIZONTAL_ALIGN_CENTER`			| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`HorizontalLayout.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`HorizontalLayout.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`HorizontalLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`HorizontalLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`HorizontalLayout.VERTICAL_ALIGN_JUSTIFY`			| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.JUSTIFY#BOTTOM)

### `HorizontalSpinnerLayout`

Deprecated API											| How to Migrate
------------------------------------------------------- | ---------------------
`HorizontalSpinnerLayout.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`HorizontalSpinnerLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`HorizontalSpinnerLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`HorizontalSpinnerLayout.VERTICAL_ALIGN_JUSTIFY`		| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.JUSTIFY#BOTTOM)

### `TiledColumnsLayout`

Deprecated API										| How to Migrate
--------------------------------------------------- | -------------------------
`TiledColumnsLayout.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`TiledColumnsLayout.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`TiledColumnsLayout.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`TiledColumnsLayout.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TiledColumnsLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TiledColumnsLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`TiledColumnsLayout.TILE_HORIZONTAL_ALIGN_JUSTIFY`	| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)
`TiledColumnsLayout.TILE_VERTICAL_ALIGN_TOP`		| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TiledColumnsLayout.TILE_VERTICAL_ALIGN_MIDDLE`		| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TiledColumnsLayout.TILE_VERTICAL_ALIGN_BOTTOM`		| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TiledColumnsLayout.TILE_VERTICAL_ALIGN_JUSTIFY`	| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.html#JUSTIFY)

### `TiledRowsLayout`

Deprecated API									| How to Migrate
----------------------------------------------- | -----------------------------
`TiledRowsLayout.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`TiledRowsLayout.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`TiledRowsLayout.HORIZONTAL_ALIGN_RIGHT`		| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`TiledRowsLayout.VERTICAL_ALIGN_TOP`			| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TiledRowsLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TiledRowsLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT`	| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`TiledRowsLayout.TILE_HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`TiledRowsLayout.TILE_HORIZONTAL_ALIGN_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`TiledRowsLayout.TILE_HORIZONTAL_ALIGN_JUSTIFY`	| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)
`TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP`		| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`TiledRowsLayout.TILE_VERTICAL_ALIGN_MIDDLE`	| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`TiledRowsLayout.TILE_VERTICAL_ALIGN_BOTTOM`	| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)
`TiledRowsLayout.TILE_VERTICAL_ALIGN_JUSTIFY`	| [`VerticalAlign.JUSTIFY`](../api-reference/feathers/layout/VerticalAlign.html#JUSTIFY)

### `TimeLabel`

Deprecated API										| How to Migrate
--------------------------------------------------- | -------------------------
`TimeLabel.DISPLAY_MODE_CURRENT_TIME`				| [`MediaTimeMode.CURRENT_TIME`](../api-reference/feathers/media/MediaTimeMode.html#CURRENT_TIME)
`TimeLabel.DISPLAY_MODE_TOTAL_TIME`					| [`MediaTimeMode.TOTAL_TIME`](../api-reference/feathers/media/MediaTimeMode.html#CURRENT_TIME)
`TimeLabel.DISPLAY_MODE_REMAINING_TIME`				| [`MediaTimeMode.REMAINING_TIME`](../api-reference/feathers/media/MediaTimeMode.html#CURRENT_TIME)
`TimeLabel.DISPLAY_MODE_CURRENT_AND_TOTAL_TIMES`	| [`MediaTimeMode.CURRENT_AND_TOTAL_TIMES`](../api-reference/feathers/media/MediaTimeMode.html#CURRENT_TIME)

### `VerticalLayout`

Deprecated API										| How to Migrate
--------------------------------------------------- | -------------------------
`VerticalLayout.HORIZONTAL_ALIGN_LEFT`			| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`VerticalLayout.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`VerticalLayout.HORIZONTAL_ALIGN_RIGHT`			| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY`		| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)
`VerticalLayout.VERTICAL_ALIGN_TOP`				| [`VerticalAlign.TOP`](../api-reference/feathers/layout/VerticalAlign.html#TOP)
`VerticalLayout.VERTICAL_ALIGN_MIDDLE`			| [`VerticalAlign.MIDDLE`](../api-reference/feathers/layout/VerticalAlign.html#MIDDLE)
`VerticalLayout.VERTICAL_ALIGN_BOTTOM`			| [`VerticalAlign.BOTTOM`](../api-reference/feathers/layout/VerticalAlign.html#BOTTOM)

### `VerticalSpinnerLayout`

Deprecated API										| How to Migrate
--------------------------------------------------- | -------------------------
`VerticalSpinnerLayout.HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`VerticalSpinnerLayout.HORIZONTAL_ALIGN_CENTER`		| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`VerticalSpinnerLayout.HORIZONTAL_ALIGN_RIGHT`		| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)
`VerticalSpinnerLayout.HORIZONTAL_ALIGN_JUSTIFY`	| [`HorizontalAlign.JUSTIFY`](../api-reference/feathers/layout/HorizontalAlign.html#JUSTIFY)

### `WaterfallLayout`

Deprecated API								| How to Migrate
------------------------------------------- | ---------------------------------
`WaterfallLayout.HORIZONTAL_ALIGN_LEFT`		| [`HorizontalAlign.LEFT`](../api-reference/feathers/layout/HorizontalAlign.html#LEFT)
`WaterfallLayout.HORIZONTAL_ALIGN_CENTER`	| [`HorizontalAlign.CENTER`](../api-reference/feathers/layout/HorizontalAlign.html#CENTER)
`WaterfallLayout.HORIZONTAL_ALIGN_RIGHT`	| [`HorizontalAlign.RIGHT`](../api-reference/feathers/layout/HorizontalAlign.html#RIGHT)

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
`\w+\.TRACK_LAYOUT_MODE_SINGLE`						| `TrackLayoutMode.SINGLE`
`\w+\.TRACK_LAYOUT_MODE_(MIN_MAX|ON_OFF)`			| `TrackLayoutMode.SPLIT`
`\w+\.TRACK_SCALE_MODE_(\w+)`						| `TrackScaleMode.$1`
`\w+\.TRACK_INTERACTION_MODE_(\w+)`					| `TrackInteractionMode.$1`
`\w+\.EDITING_MODE_(\w+)`							| `DateTimeMode.$1`
`\w+\.DOCK_MODE_(\w+)`								| `Orientation.$1`
`TimeLabel\.DISPLAY_MODE_(\w+)`						| `MediaTimeMode.$1`
`Header\.TITLE_ALIGN(_PREFER){0,1}_(\w+)`			| `HorizontalAlign.$2`
`Drawers\.OPEN_MODE_(\w+)`							| `RelativeDepth.$1`
`Drawers\.OPEN_GESTURE_(DRAG_)?(CONTENT_)?(\w+)`	| `DragGesture.$3`
`\w+\.LAYOUT_ORDER_(\w+)`							| `ItemRendererLayoutOrder.$1`
`\w+\.BUTTON_LAYOUT_MODE_(\w+)`						| `StepperButtonLayoutMode.$1`
`PageIndicator.INTERACTION_MODE_(\w+)`				| `PageIndicatorInteractionMode.$1`