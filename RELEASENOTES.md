# Feathers Release Notes

Noteworthy changes in official releases of [Feathers](http://feathersui.com/).

## 1.2.0

Version 1.2.0 of Feathers is still in active development. This list of changes is a work in progress, and one may find missing or outdated information below. The complete list of changes will be made available when beta and final builds Feathers 1.2.0 are officially released.

* New Component: Drawers
* New Component: LayoutGroup
* New Component: LayoutGroupListItemRenderer
* Many performance improvements with the help of Adobe Scout.
* New minimum runtime versions. Target SWF version rolled back to 18 (Flash Player 11.5 and AIR 3.5) to offer easier BlackBerry 10 support.

### 1.2.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `scrollerProperties` property on scrolling components, including List, GroupedList, ScrollText and ScrollContainer is deprecated. Because these components now extend `Scroller` instead of adding a `Scroller` as a child, all of the properties that could be set through `scrollerProperties` can now be set directly on the components. The `scrollerProperties` property was deprecated in Feathers 1.1.0, and it remains deprecated in Feathers 1.2.0. 

### 1.2.0 Interface Changes

Three changes have been made to the `IVirtualLayout` interface. Custom implementations of `IVirtualLayout` created before Feathers 1.2.0 will have compiler errors until the required changes are made. It is expected that a small number of Feathers developers have created custom implementations of `IVirtualLayout`, so this change will have no impact on the majority of projects that are upgraded from older versions of Feathers.

The `typicalItemWidth` and `typicalItemHeight` properties may be removed completely from custom `IVirtualLayout` implementations. In their place, the `typicalItem` property must be added. Components like `List` previously passed pre-calculated width and height values for a typical item display object. However, a layout may need to manipulate the typical item before calculating its dimensions. By giving more control to the layouts, their estimation of virtualized items will be more accurate.

The new `typicalItem` property might be declared as follows:

	/**
	 * @private
	 */
	protected var _typicalItem:DisplayObject;

	/**
	 * @inheritDoc
	 */
	public function get typicalItem():DisplayObject
	{
		return this._typicalItem;
	}

	/**
	 * @private
	 */
	public function set typicalItem(value:DisplayObject):void
	{
		if(this._typicalItem == value)
		{
			return;
		}
		this._typicalItem = value;
		this.dispatchEventWith(Event.CHANGE);
	}

Usage of the new `typicalItem` property may depend on factors that are specific to each implementation. In general, an implementation will measure the typical item at the beginning of most of its public functions, including `layout()`, `getScrollPositionForIndex()`, `getVisibleIndicesAtScrollPosition()`, and `measureViewPort()`. If the typical item is a Feathers control, it should be validated. The following snippet shows the most basic case for how to request the typical item's dimensions:

	var measuredTypicalItemWidth:Number = 0;
	var measuredTypicalItemHeight:Number = 0;
	if( this._useVirtualLayout && this._typicalItem )
	{
		if( this._typicalItem is IFeathersControl )
		{
			//validate the typical item so that it reports the correct width and height
			this._typicalItem.validate();
		}

		measuredTypicalItemWidth = this._typicalItem.width;
		measuredTypicalItemHeight = this._typicalItem.height;
	}

If the typical item is a Feathers control, validate() should be called before requesting its dimensions. Optionally, the dimensions of a Feathers control may be reset to `NaN` in order to ask the control for its ideal dimensions. This will match the behavior introduced Feathers 1.1.x. However, in Feathers 1.2.0, the built-in layouts have chosen to reset the typical item's dimensions only when a flag is enabled. For many layouts, resetting the dimensions of the typical item is rarely required, and it may be undesireable. This change reverts the behavior to match Feathers 1.0.x, while still allowing advanced developers to re-enable the behavior introduced in Feathers 1.1.x.

For more advanced code, take a look at one of the built-in layout classes, such as `VerticalLayout`.

Note: The built-in layout classes repurpose the `typicalItemWidth` and `typicalItemHeight` properties that were removed from `IVirtualLayout` to work with a new `resetTypicalItemDimensionsOnMeasure` property. By default, setting these properties outside of a component like `List` will have no effect, which exactly matches the behavior from all older versions of Feathers. Custom layouts may elect to provide this same capability, but it is not required by the `IVirtualLayout` interface.

## 1.1.1

This release includes minor updates to support Starling Framework 1.4 and a number of minor bug fixes.

* Switches to Starling's implementation of the `clipRect` property.
* Uses Texture onRestore for internally managed textures, like in text controls.
* StageTextTextEditor: fix for displayAsPassword clearing the text.
* Panel: won't scroll if mouse wheel or touch occurs in header or footer.
* Panel: header and footer can be touched when content is scrolling.
* AeonDesktopTheme: uses a better disabled text color.
* SmartDisplayObjectStateValueSelector: properly supports uint color value of 0.
* Item Renderers: smarter handling of accessory resizing.
* Item Renderers: better measurement to account for NaN.
* Item Renderers: properly checks for _data, in addition to _owner, in commitData().
* Label: sets proper text renderer dimensions if height is explicitly set.
* Radio: better handling of setting toggleGroup to avoid accidentally adding to defaultRadioGroup.
* Scroller: properly updates isEnabled on scroll bars when they are first created.
* Scroller: child touches are blocked until throw animation finishes to match native behavior.
* Scroll bars: better isEnabled handling.
* TextInput: better handling of focus when not visible.
* TextInput: better prompt handling.
* TextFieldTextEditor: snapshot is properly hidden when text is cleared.
* ButtonGroup: properly resizes when data provider changes.
* GroupedList: requests proper typical item from data provider.
* ScrollText: better padding getter.
* PickerList: closes pop-up list on Event.TRIGGERED.
* PickerList: properly disposes pop-up list and IPopUpContentManager.
* TiledRowsLayout, TiledColumnsLayout: fixed manageVisibility implementation.
* TiledRowsLayout, TiledColumnsLayout: fixed bad positioning when useSquareTiles is true.

## 1.1.0

* New Beta Component: NumericStepper. Add and subtract from a numeric value with buttons. Optional text editing.
* New Beta Component: TextArea. A multiline text input. Recommended for desktop only. Not recommended for mobile.
* New Beta Component: Panel. A new container subclassing ScrollContainer that adds a header and an optional footer.
* New Beta Component: PanelScreen. An IScreen implementation (similar to Screen) based on Panel.
* New Beta Layout: AnchorLayout. Added to support fluid layouts and relative positioning. Can position relative to parent container and also to other children of the parent container.
* Added FocusManager for keyboard navigation and interaction. Not intended for mobile. Use a desktop theme or set `FocusManager.isEnabled = true`. TextInput *cannot* use StageTextTextEditor when focus management is enabled. TextFieldTextEditor is recommended.
* All Components: sub-components are created from factories and can receive custom names for theming.
* Added ILayoutObject interface to support extra data for layouts to use, like includeInLayout property.
* List: support for optional multiple selection.
* TextInput: supports prompt/hint
* TextInput/StageTextTextEditor: supports multiline on mobile.
* PickerList: supports prompt when no item is selected.
* Slider: measurement now includes thumb dimensions and a new property called trackScaleMode has been added.
* Callout: disposal is more consistent. Set combination of disposeOnSelfClose and disposeContent.
* Callout: doesn't close when origin is touched. origin should now separately determine correct behavior.
* Callout: added origin and supportedDirections properties to make Callout capable of switching origins after creation.
* Item Renderers: properly handle accessory resizing if accessory is a FeathersControl.
* Item Renderers: fixes for a number of layout order, gap, and alignment combinations.
* PickerList: doesn't close when touching scroll bar. only item renderer touch will trigger a close.
* PopUpManager: Supports custom root to place pop-ups somewhere other than the stage.
* PopUpManager: modal pop-ups receive a different focus manager.
* ScreenNavigator: added hasScreen(), getScreen(), and getScreenIDs().
* ScreenNavigator: added autoSizeMode property to select between sizing to fit stage or to fit content.
* ScreenNavigator: fix for broken transition if showScreen() is calleed before transition begins but after new screen is added to stage.
* Transitions: fix for quickStack constructor argument.
* ScrollContainer, List, GroupedList: better auto-sizing with a background skin.
* ScrollContainer: new alternate name for toolbar style.
* TextInput: exposed isEditable, maxChars, restrict, and displayAsPassword properties.
* BitmapFontTextRenderer, Scale3Image, Scale9Image: option to turn off the use of a separate QuadBatch.
* TextFieldTextEditor: better selection on mobile.
* TextFieldTextEditor: properly dispatches FeathersEventType.ENTER.
* Text Renderers and Editors: better snapshot disposal.
* TextFieldTextRenderer: better measurement to workaround runtime dimensions being wrong.
* TiledRowsLayout, TiledColumnsLayout: supports separate horizontal and vertical gaps.
* TiledRowsLayout, TiledColumnsLayout: more stable virtualized item renderer count to improve performance.
* TiledRowsLayout, TiledColumnsLayout: fixes for certain issues with paging.
* ButtonGroup: supports isEnabled as a property in the data provider.
* ImageLoader: added delayTextureCreation flag to avoid creating textures while scrolling (or during any action that requires best performance).
* Scroller: adds an invisible overlay during scrolling to block touch events on children.
* Scroller: exposes horizontal and vertical page count properties.
* Scroller: added FeathersEventType.SCROLL_START event.
* Scroller: scroll bars are hidden when stopScrolling() is called.
* Scroller: fix for velocity calculation.
* Button: better detection of click to avoid other display objects moving on top of button before TouchPhase.ENDED.
* Button: new styles for themes, including back, forward, call-to-action, quiet, and danger.
* List: if items are added or removed, selected indices are adjusted.
* List, GroupedList, ScrollContainer, and ScrollText all extend Scroller, instead of using it as a sub-component. The scrollerProperties property on each of these is now deprecated because all public properties of Scroller are now direct public properties of these components. Theme initializers that target Scroller will break because Scroller is no longer a sub-component, but a super class of classes like List. Move this stuff into initializers for List, GroupedList, ScrollContainer, and ScrollText.
* FeathersControl: setSizeInternal() is now stricter. It can never receive a NaN value for width or height. This is a common source of bugs, and throwing an error here will help make it easier to find those bugs.
* IVariableVirtualLayout: added function addToVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions.
* IVariableVirtualLayout: added function removeFromVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions.
* ScrollText: now properly handles visible and alpha properties.
* ListCollection: added removeAll(), addAll(), addAllAt() and contains().
* Scroller: scrolling animates for mouse wheel.
* List, VerticalLayout, HorizontalLayout: optimized case where useVirtualLayout is true and hasVariableItemDimensions is false.
* HorizontalLayout, VerticalLayout, TiledRowsLayout, TiledColumnsLayout: added manageVisibility property to set items to false when not in view. Set to true to improve performance.
* Item Renderers: added stopScrollingOnAccessoryTouch property to make accessory touch behavior configurable.
* Screen: default value of originalDPI is DeviceCapabilities.dpi. It used to be 168. Can still be changed.
* MetalWorksMobileTheme and MinimalMobileTheme: major overhaul with improved skins and new alternate skins.
* AeonDesktopTheme: added some missing skins, like TabBar.
* AeonDesktopTheme: uses FocusManager.
* AzureMobileTheme: removed this example theme. Please feel free to continue using the old version, if desired.
* ComponentsExplorer: better button screen to show off various styles of buttons.
* Todos: new example.
* All Examples: Use PanelScreen instead of Screen and Header where appropriate.
* All Examples: Use AnchorLayout where appropriate.
* All Examples: Uses NumericStepper instead of Slider where appropriate.
* Added 96x96 icons to examples for Android xhdpi. Requires AIR 3.7.
* Extended API documentation with inline examples and improved descriptions.
* Added many new articles to the Feathers Manual.
* Now built with ASC 2.0.

### 1.1.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `scrollerProperties` property on scrolling components, including List, GroupedList, ScrollText and ScrollContainer is deprecated. Because these components now extend `Scroller` instead of adding a `Scroller` as a child, all of the properties that could be set through `scrollerProperties` can now be set directly on the components.

### 1.1.0 Interface Changes

Two changes have been made to the `IVariableVirtualLayout` interface. Custom implementations of `IVariableVirtualLayout` created before Feathers 1.1.0 will have compiler errors until the required changes are made. It is expected that a very small number of Feathers developers have created custom implementations of `IVariableVirtualLayout`, so this change will have no impact on the vast majority of projects that are upgraded from older versions of Feathers.

The functions `addToVariableVirtualCacheAtIndex()` and `removeFromVariableVirtualCacheAtIndex()` have been added to `IVariableVirtualLayout` to provide lower-level control over the cache of item dimensions. Instead of clearing the entire cache, a component may insert or remove a specific index from the cache. For instance, the `List` component uses these functions when its data provider is manipulated. These functions allow the layout to provide more accuracy to its virtualization and to improve performance.

 These two functions can easily simulate the old behavior from Feathers 1.0.x, if needed. The following implementations of `addToVariableVirtualCacheAtIndex()` and `removeFromVariableVirtualCacheAtIndex()` can easily be copied into a custom implementations of `IVariableVirtualLayout` to quickly migrate existing Feathers 1.0.x implementations to behave exactly the same in Feathers 1.1.0:

	public addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
	{
		this.resetVariableVirtualCache();
	}

	public removeFromVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
	{
		this.resetVariableVirtualCache();
	}

## 1.0.1

This release includes a number of bug fixes.

* Scroller: FeathersEventType.SCROLL_COMPLETE always dispatched after last Event.SCROLL.
* ScrollBar, SimpleScrollBar: thumb position properly accounts for padding.
* Scroller: mouse wheel detection properly accounts for contentScaleFactor.
* ScreenNavigator: calling clearScreen() during a transition no longer causes a stack overflow.
* ScrollBar, SimpleScrollBar: can drag to minimum and maximum if they aren't a multiple of the step.
* Header: Fix for runtime error when rightItems aren't IFeathersDisplayObjects
* TextInput: better selection/cursor recovery when changing text programmatically.
* TextInput: Moved fontSize contentScaleFactor multiplication into StageTextTextEditor.
* FeathersControl: requires isInitialized to be true before it can validate.
* FeathersControl: clipRect properly accounts for scale.
* GroupedList: added missing documentation for setSelectedLocation().
* ImageLoader: does a better job keeping aspect ratio when only one dimension is explicit.
* ImageLoader: properly scales content when dimensions are explicit.
* ImageLoader: no runtime errors if content loads after dispose.
* ScrollContainer, List, GroupedList, ScrollText: fix for detecting changes in scrollToPageIndex().

## 1.0.0

No major API changes since 1.0.0 BETA. Mostly bug fixes and minor improvements.

* Fix for memory leaks in List, GroupedList, and ImageLoader
* PageIndicator properly handles ImageLoader or other IFeathersControl as symbol
* IGroupedListHeaderOrFooterRenderer extends IFeathersControl
* Header: fix for "middle" vertical alignment
* Updated for Starling Framework 1.3

## 1.0.0 BETA

Initial release. The following major changes happened in the last month or two leading to the beta.

* GTween library removed as a dependency. All animations switched to the Starling `Tween` class.
* as3-signals library removed as a dependency. Switched to Starling events.
* `TextInput`: supports swappable text editors, similar to the text renderers used for uneditable text. The default `StageTextTextEditor` uses `StageText` to allow text input, which is ideal for mobile. The `TextFieldTextEditor` uses a `TextField` of `TextFieldType.INPUT` instead, and it may be a better choice for desktop. A static function, `defaultTextEditorFactory`, has been added to `FeathersControl`.
* `TextInput`: now has events for focus in and out.
* Item renderers: Switched to `ImageLoader` for icon and accessory textures, which has a `source` property that supports `Texture` instances or `String` URLs to load textures from the web. Properties like `iconTextureField` and `accessoryTextureFunction` now have new names like `iconSourceField` and `accessorySourceFunction` because values other than textures are now allowed. Similarly, `iconImageFactory` and `accessoryImageFactory` have been renamed to `iconLoaderFactory` and `accessoryLoaderFactory`.
* Item renderers: accessory may be positioned. See `layoutOrder` and `accessoryPosition` properties.
* Added `dispose()` method to `AddedWatcher` so that theme resources like textures be disposed.
* Added `ScrollText` component to display text in an overlay on the native display list. Useful for long passages of text that may be too large to convert to a texture.
* `ScreenNavigator`: added events for transition start and complete.
* `ToggleSwitch`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_ON_OFF`.
* `Slider`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_MIN_MAX`.
* `ScrollBar`: `TRACK_LAYOUT_MODE_STRETCH` is now `TRACK_LAYOUT_MODE_MIN_MAX`.
