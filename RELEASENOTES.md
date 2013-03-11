# Feathers Release Notes

Noteworthy changes in official releases of [Feathers](http://feathersui.com/).

## 1.1.0 PRERELEASE

* List: support for optional multiple selection.
* MetalWorksMobileTheme: tweaked colors and appearances. embeds open source Source Sans Pro font.
* List, GroupedList, ScrollContainer, and ScrollText all extend Scroller, instead of using it as a sub-component. The scrollerProperties property on each of these is now deprecated because all public properties of Scroller are now direct public properties of these components.
* Focus management and keyboard control can be enabled with FocusManager.isEnabled = true. TextInput must use TextFieldTextEditor when focus management is enabled.
* Slider: measurement now includes thumb dimensions and a new property called trackScaleMode has been added.
* Callout: content disposal is more consistent. Set disposeContent to false to reuse content in another callout later.
* Added ILayoutObject to support extra data for layouts to use.
* AnchorLayout: added to support fluid layouts and relative positioning.
* MultiColumnGridLayout: added to support fluid layouts on standard columns with device responsiveness.
* All sub-components are created from factories and can receive custom names for theming.
* PopUpManager: Supports custom root to place pop-ups somewhere other than the stage.
* PopUpManager: modal pop-ups receive a different focus manager.
* PickerList: supports prompt when no item is selected.
* Panel: A new container similar to ScrollContainer, but with a header component too (defaults to feathers.controls.Header).
* PanelScreen: An IScreen implementation based on Panel.
* ScreenNavigator: added hasScreen(), getScreen(), and getScreenIDs().
* ScrollContainer, List, GroupedList: better auto-sizing with a background skin.
* BitmapFontTextRenderer, Scale3Image, Scale9Image: option to turn off the use of a separate QuadBatch.
* Scroller/Button: better blocking of touches on children when scrolling with touch.
* TiledRowsLayout, TiledColumnsLayout: supports separate horizontal and vertical gaps.
* IVariableVirtualLayout: added function addToVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions. The following implementation can be added to existing classes to simulate the old behavior:

		public addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			this.resetVariableVirtualCache();
		}

* IVariableVirtualLayout: added function removeFromVariableVirtualCacheAtIndex() for more specific control over the cache of item dimensions. The following implementation can be added to existing classes to simulate the old behavior:

		public removeFromVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
		{
			this.resetVariableVirtualCache();
		}
* ScrollText: now properly handles visible and alpha properties.
* ListCollection: added removeAll(), addAll(), addAllAt() and contains().
* Scroller: adds an invisible overlay during scrolling to block touch events on children.
* Scroller: scrolling animates forf mouse wheel.
* List, VerticalLayout, HorizontalLayout: optimized case where useVirtualLayout is true and hasVariableItemDimensions is false.
* Screen: default value of originalDPI is DeviceCapabilities.dpi. It used to be 168. Can still be changed.

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