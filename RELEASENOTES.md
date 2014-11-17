# Feathers Release Notes

Noteworthy changes in official, stable releases of [Feathers](http://feathersui.com/).

## 2.0.1

## 2.0.0

* New style provider architecture for skinning and themes.
* Components may always be validated, even if they are not on the display list yet.
* New Text Editor: TextBlockTextEditor is a desktop-only text editor built on FTE, similar to TextBlockTextRenderer.
* New Text Editor: BitmapFontTextEditor is a desktop-only text editor built on bitmap fonts, similar to BitmapFontTextRenderer.
* All Components: subComponentProperties pattern is now stricter. If properties that don't exist are set, a runtime error will be thrown.
* BitmapFontTextRenderer: properly redraws when isEnabled is changed.
* BitmapFontTextRenderer: if textFormat is null, generates a default value so that something will be displayed (using Starling's embedded BitmapFont.MINI).
* Button: added minGap property that is used when gap is set to Number.POSITIVE_INFINITY.
* Button: pulled out toggle functionality into a subclass: ToggleButton.
* Button: removed now-useless autoFlatten property.
* Button: added new hasLabelTextRenderer that may be set to false to avoid creating the text renderer (for things like scroll bar or slider button sub-components).
* Button: fixed issue where button didn't return to up state when focus is changed with keyboard while in another state.
* Callout: added stagePadding property to set stagePaddingTop, stagePaddingRight, stagePaddingBottom, and stagePaddingLeft properties all at once.
* Callout: fixed issue where touch listener was removed when callout was removed, but it wasn't re-added when the same callout instance was shown again.
* DefaultGroupedListHeaderOrFooterRenderer: fixed issue where content wasn't disabled when isEnabled changed.
* Drawers: added optional overlaySkin property to fade in a display object over the content when a drawer is opened.
* Drawers: checks if event types are null before adding listeners.
* Drawers: open and close events now pass the display object in the event data.
* Drawers: fix for issue where wrong toggle duration may used sometimes.
* DropDownPopUpContentManager: added new gap property.
* FeathersControl: enforced as an abstract class. If you need a generic Feathers component wrapper for layoutData and things, use LayoutGroup.
* FeathersControl: added styleName and styleNameList property to replace nameList. The name property is no longer used for styling, and it will work for getChildByName() in the rare situations where it was broken. The nameList property is deprecated.
* FeathersControl: fixed issue where changing minTouchWidth or minTouchHeight did not update the hit area if the width or height wasn't changed at the same time.
* FeathersControl: fixed issue where component would validate when disposed.
* FeathersControl: fixed issue in setSize() where scaled dimensions weren't updated.
* FocusManager: support for custom IFocusManager instances and support for multiple Starling stages.
* FocusManager: fixed issue where disabled components could receive focus.
* Header: added useExtraPaddingForOSStatusBar property to support iOS 7 status bar behavior.
* Header: getters for leftItems, rightItems, and centerItems no longer duplicate the array.
* Header: now disposed leftItems, rightItems, and centerItems by default. Can be controlled with new disposeItems property.
* Header: fixed issue where title text renderer's isEnabled property wasn't properly updated.
* Header: fixed issue where the touchable property was incorrectly set to false on some children.
* IFocusDisplayObject: added new focusOwner property to allow pop-ups to be owned by another component. Allows the focus manager to manage focus order better with components like PickerList.
* ImageLoader: checks for lost context before creating a texture from a loaded URL.
* ImageLoader: fixed issue where isLoaded getter didn't always return true if the source is a texture.
* ImageLoader: fixed issue where loaded textures could be uploaded to wrong Starling instance if multiple Starling instances were active.
* Item Renderers: added skinField, skinFunction, and itemHasSkin for background skins from the data provider.
* Item Renderers: added isSelectableOnAccessoryTouch property to control whether the selection will change or not when the accessory is touched.
* Item Renderers: added minGap and minAccessoryGap properties that are used when gap or accessoryGap are set to Number.POSITIVE_INFINITY.
* ITextEditor, ITextRenderer: extend a new IBaselineTextControl interface that defines a common baseline property.
* Layouts: fixed issue where they didn't account for pivotX and pivotY.
* Layouts: when centering items, rounds the x and y positions to the nearest integer.
* LayoutGroup: added new backgroundSkin and backgroundDisabledSkin properties.
* List, GroupedList: if dataProvider property is changed, or the collection dispatches CollectionEventType.RESET, automatically behaves as if updateItemAt() were called on all item renderers.
* ListCollection, HierarchicalCollection: added dispose() function to support a way to dispose things like display objects or textures in items.
* NumericStepper: claims exclusive touch so that it won't repeat while scrolling with touch.
* NumericStepper: fixes for obscure situations where text input changes are not reflected in the value.
* NumericStepper: improved auto-measurement for values that are not integers.
* NumericStepper: added textInputGap and buttonGap properties.
* PageIndicator: added new interactionMode property to allow alternate precise selection of symbols on tap, instead of previous back/next behavior.
* Panel: added new outerPadding properties to support padding that is around the everything, including the header and footer. The existing (inner) padding properties only apply to the content between the header and footer.
* PanelScreen: turns on clipping by default.
* PickerList: added toggleButtonOnOpenAndClose property.
* PickerList: implements IFocusDisplayObject and manages focus of children better.
* PickerList: closes on enter key to match native behavior.
* PopUpManager: when centering a pop-up, rounds the x and y positions to the nearest integer.
* ProgressBar: fixed vertical fill so that it starts from the bottom and fills up.
* PropertyProxy: added toString() function to allow a PropertyProxy to be output to console.
* Scale3Image, Scale9Image, fixed issue where scaling smaller than the minimum size would cause overlapping instead of distortion when end regions weren't the same size.
* Scale3Textures, Scale9Textures: fixed rendering of textures with a scale property that isn't equal to 1.
* Screens: removed dpiScale, pixelScale, originalWidth, and originalHeight properties. The kinds of calculations these values were used for should be handled in the theme (or somewhere else outside of the screen if not using a theme).
* ScrollBar: increment and decrement buttons are hidden, like the thumb, if the minimum is equal to the maximum. The track fills the full dimensions.
* ScrollBar: fix for wrongly positioned track when direction is horizontal.
* ScrollContainer: fixed wrong measurement when using no layout with children at negative coordinates.
* Scroller: fixed issue where a floating scroll bar wouldn't disappear.
* Scroller: refactored scrolling behavior to more closely match iOS native scrolling.
* Scroller: touch overlay and background skins are added and removed instead of changing visible property. Works better with Monster Debugger.
* Scroller: fixes issue where events were dispatched for a completed scroll when the scroll position didn't actually change from calling throwTo().
* Scroller: added support for a view port that doesn't necessarily auto-size to show its full content. In other words, a view port can choose to measure so that it needs to scroll.
* Scroller: fixed issue where background wasn't sized property when isEnabled was changed.
* Scroller: skips some unnecessary code when dimensions are explicit to improve performance.
* Scroller: added new measureViewPort property that can be set to false to exclude the view port from auto-measurement and only use the background skin.
* Scroller: automatically sets direction property on scroll bars, so that you don't need to, thanks to the new IDirectionalScrollBar interface.
* ScrollText: added disabledTextFormat property.
* ScrollText: may receive focus and use keyboard arrow keys to scroll.
* Slider: added new trackInteractionMode property to control whether touching the track updates the value by page or jumps directly to the nearest value.
* SmartDisplayObjectValueSelector: fixed issue where getValueTypeHandler() function had an extra parameter.
* SmartDisplayObjectValueSelector: added support for null value other than the default.
* SmartDisplayObjectValueSelector: stricter reuse of display objects. Type must match exactly. Fixes issue where Image is incorrectly reused because it is a subclass of Quad.
* StageTextTextEditor: fixed issue where measurement was wrong when text was an empty string.
* StageTextTextEditor: fixed issue on iOS where characters were masked immediately instead of showing in the clear for a moment.
* StageTextTextEditor: fixed issue where the clipboard menu appeared unexpectedly when multiline is true.
* StageTextTextEditor: draws StageText to BitmapData with double dimensions on Mac HiDPI, thanks to Adobe's bug fix.
* TabBarSlideTransitionManager: fixes bug where switching between tabs quickly would break the transition.
* Text: will use non-power-of-two textures for snapshots, if the Stage 3D profile supports it.
* Text: if a renderer or editor supports native filters, does some extra cleanup in dispose() that is actually unnecessary, but will ease some pressure if there's a memory leak.
* Text: fixed issue where snapshot wasn't updated when isEnabled changed.
* TextBlockTextRenderer: if elementFormat is null, generates a default value so that something will be displayed.
* TextBlockTextRenderer: fixed issue where width was calculated wrong when text ended in whitespace.
* TextFieldTextEditor, TextFieldTextRenderer: added useGutter property to allow removal of the 2-pixel "gutter" that Flash adds to a TextField.
* TextInput, TextArea: added hasFocus getter to allow checking focus, even if there is no focus manager.
* TextInput, Text Editors: added new selectionBeginIndex and selectionEndIndex properties.
* TextInput: fixes issue where prompt text renderer's isEnabled property wasn't updated.
* TextInput: added new verticalAlign property to support top, middle, bottom, or justify.
* TextInput: won't throw an error if there's no background skin, but auto-measurement will result in a width and height of 0, unless typicalText is set.
* TextInput: improved support for text editors that are completely on the Starling display list without a native overlay.
* TextInput: doesn't create prompt text renderer if prompt is null.
* TextArea: added stateToSkinFunction, similar to Button background skin.
* TextArea: fixed issue where background skin was sometimes missing.
* TextArea: added clearFocus() function match API of TextInput.
* TextArea: further improvements to positioning and scaling of texture snapshot.
* Text Editors: improved support for Mac HiDPI.
* Text Editors: added disabled font styles.
* Text Renderers: uses generateFilterRect() when using nativeFilters for improved texture dimensions.
* Text Renderers: ITextRenderer now has a first-class wordWrap property that is required by all renderers.
* TiledColumnsLayout, TiledRowsLayouts: fixed result of getScrollPositionForIndex() when paging is disable to allow the item to be properly centered.
* TiledColumnsLayout, TiledRowsLayouts: fixed calculation of tile count when padding is used.
* TiledColumnsLayout, TiledRowsLayout: added requestedRowCount and requestedColumnCount properties.
* ToggleSwitch: fixed issue where the isEnabled property of text renderers wasn't properly updated.
* ToggleSwitch: added toggleThumbSelection property to update the isSelected property of the thumb (if it's a ToggleButton) to match the isSelected property of the switch.
* ToggleSwitch: fixed issue where selection change wasn't animated when triggered with the keyboard instead of a touch.
* ToggleSwitch: added new setSelectionWithAnimation() method so that programmatic selection changes can be optionally animated.
* Examples: override initialize() instead of listening for FeathersEventType.INITIALIZE.
* Example Themes: rewritten using the new style provider system.
* Example Themes: tweaked padding, gap, dimensions, and other values to be based on a simple grid system for more consistency.

### 2.0.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `nameList` property has been deprecated, and it is replaced by the `styleNameList` property. The `name` property is no longer connected to style names, and situations where it failed to work with `getChildByName()` have been resolved. The `styleName` property has been added to replace the former usage of the `name` property as a concatenated version of `nameList` (now, `styleNameList`).

The `manageVisibility` property on layouts has been deprecated. In previous versions, this property could be used to improve performance of non-virtual layouts by hiding items that were outside the view port. However, other performance improvements have made it so that setting `manageVisibility` can now sometimes hurt performance instead of improving it.

### 2.0.0 Default Behavior and API Changes

This is a major update to Feathers, so it includes more breaking changes than usual. Be sure to read this section thoroughly to see if any of these changes will affect your apps.

`TextFieldTextRenderer` and `TextFieldTextEditor` now have a `useGutter` property that controls whether the 2-pixel gutter around the edges of the `flash.text.TextField` will be used in measurement and layout. In previous versions of Feathers, the gutter was always enabled. The gutter is now disabled by default to allow text controls based on `TextField` to more easily align with other text controls.

The `ITextRenderer` and `ITextEditor` interfaces now extend the `ITextBaselineControl` interface. In the case of `ITextEditor`, a new `baseline` getter is required.

The `ITextRenderer` interface now requires a `wordWrap` property.

The `IFocusDisplayObject` interface now requires a `focusOwner` property.

Properties including `dpiScale`, `pixelScale`, `originalWidth`, `originalHeight`, and `originalDPI` have been removed from `Screen`, `ScrollScreen` and `PanelScreen`. The calculations previously offered by these properties should be handled in skinning code, such as the theme.

The `Button` class no longer supports selection. This functionality has been moved into a subclass, `ToggleButton`.

The `autoFlatten` property has been removed from the `Button` class.

Setting the properties of a sub-component, such as using `thumbProperties` on a `Slider` to set properties on the slider's thumb sub-component, is now stricter. Previously, when a property did not exist, it was silently ignored. Now, an error will be thrown.

If no text format is defined, `BitmapFontTextRenderer` defaults to using `BitmapFont.MINI` so that the text will always be rendered. Previously, it would render nothing.

If no element format is defined, `TextBlockTextRenderer` defaults to using a new `ElementFormat` with default arguments so that the text will always be rendered. Previously, an error was thrown.

A `trackInteractionMode` property has been added to `Slider`. In previous versions, `Slider` behaved as if `trackInteractionMode` were set to `Slider.TRACK_INTERACTION_MODE_BY_PAGE`. Now, the default value is `Slider.TRACK_INTERACTION_MODE_TO_VALUE`.

A `verticalAlign` property has been added to `TextInput`. In previous versions, `TextInput` behaved as if `verticalAlign` were set to `TextInput.VERTICAL_ALIGN_JUSTIFY`. Now, the default value is `TextInput.VERTICAL_ALIGN_MIDDLE`.

The `FeathersControl` class is now considered abstract. It will throw a runtime error if instantiated directly instead of being subclassed. If you need a generic Feathers component as a wrapper for another display object, use `LayoutGroup` instead.

The `leftItems`, `rightItems`, and `centerItems` getters on the `Header` class no longer make a copy of their storage variables. Take care when modifying these values directly.

Focus management now supports multiple Starling stages (for AIR desktop apps). The static `isEnabled` property has been removed. Instead, you should use the static `setEnabledForStage()` function:

```as3
FocusManager.setEnabledForStage( Starling.current.stage, true );
```

All layouts now account for the `pivotX` and `pivotY` properties when positioning display objects. In previous versions, these properties were ignored.

When the `direction` property of a `ProgressBar` is equal to `ProgressBar.DIRECTION_VERTICAL`, the fill now starts at the bottom and fills up.

The increment button and decrement button sub-components of a `ScrollBar` are now hidden when the scroll bar's maximum scroll position is equal to its minimum scroll position, just like how the thumb is hidden. The track will be resized to fill the extra space where the buttons were previously rendered.

When replacing the `dataProvider` of a `List` or `GroupedList` (or replacing the `data` property of a `ListCollection` or `HierarchicalCollection`), it is no longer necessary to call `updateItemAt()` on the new collection if it contains some of the same items as the previous collection. This behavior will happen automatically.

## 1.3.1

* NumericStepper: fixed issue where using step to calculate a new value didn't account for the minimum value.
* NumericStepper: fixed issue where only some text was selected after changing value.
* TextInput: fixed issue where FOCUS_OUT event wasn't dispatched when used with a NumericStepper and FocusManager.isEnabled is true, causing NumericStepper to fail to update its value properly.
* Slider: fixed issue where using step to calculate a new value didn't account for the minimum value.
* Button: validates skin if the skin implements IValidating so that the skin resizes properly if button dimensions are tweened.
* Callout: fixed issue where callout incorrectly stopped content from resizing.
* Callout: fixed issue where content resizing wouldn't reposition callout to point to origin.
* TextInput: fixed issue where sometimes focus was not cleared on removal.
* TextBlockTextRenderer: fixed issue where sometimes an infinite loop was triggering when attempting to truncate.
* TextFieldTextEditor: fixed issue where existing text did not render with new text format.
* StageTextTextEditor, TextFieldTextEditor: fixed issue where multiple FOCUS_OUT events could be dispatched.
* TextArea: fixed positioning of texture snapshot when scrolling.
* TiledRowsLayout, TiledColumnsLayout: fixed issue where some tiles would be incorrectly invisible with top or left padding and manageVisibility.
* LayoutGroup: respects includeInLayout when no layout is specified.
* TextInput: fixed selection position on touch when displaying an icon.
* Gallery Example: updated to use HTTPS URLs since Flickr will soon require it.
* YouTubeFeeds Example: switched to category feeds since the older feeds were deprecated and displayed the wrong data.

## 1.3.0

* New Component: ScrollScreen is new base class for ScreenNavigator screens that supports scrolling similar to ScrollContainer.
* New Component: TextBlockTextRenderer is a new text renderer that renders text with flash.text.engine.TextBlock, with a texture snapshot similar to TextFieldTextRenderer.
* More performance improvements with the help of Adobe Scout.
* Improved support for multiple windows in desktop AIR apps.
* Improved support for using scaleX and scaleY with Feathers components.
* Added support for Mac HiDPI resolutions.
* HorizontalLayout: added support for percentWidth and percentHeight with HorizontalLayoutData.
* VerticalLayout: added support for percentWidth and percentHeight with VerticalLayoutData.
* AnchorLayout: added support for percentWidth and percentHeight with AnchorLayoutData.
* HorizontalLayout: added optional firstGap and lastGap properties.
* VerticalLayout: added optional firstGap and lastGap properties.
* HorizontalLayout: added distributeWidths property to available divide available width equally to all items.
* HorizontalLayout: added distributeHeights property to available divide available height equally to all items.
* AnchorLayout: performance improvements.
* PickerList: added openList() and closeList() functions to open and close pop-up list programmatically.
* Screen: now extends LayoutGroup to support layouts.
* Scroller: final removal of scrollerProperties, which was deprecated in version 1.1.0.
* Scroller: support for placing the vertical scroll bar on the right for right-to-left locales.
* Scroller: added mouseWheelScrollStep property to support different steps on scroll bar and mouse wheel.
* ScrollText: now chooses exclusively between styleSheet or textFormat to avoid runtime error.
* ScrollText: added support for hyperlinks, including a new Event.TRIGGERED event when a link is clicked/tapped.
* TextFieldTextRenderer: now chooses exclusively between styleSheet or textFormat to avoid runtime error.
* TextFieldTextRenderer: added nativeFilters property to support rendering text with filters.
* BitmapFontTextRenderer: fixed issue where truncation happened when it wasn't necessary.
* BitmapFontTextRenderer: fixed kerning when font size is scaled.
* ImageLoader: added textureFormat property to specify a Context3DTextureFormat value.
* List: reuses its typical item renderer instead of creating a new one when measurement is required.
* ScrollContainer: added IScrollContainer interface including functions for "raw" children.
* Themes: "quiet" buttons now have a transparent up skin to blend into toolbars.
* Themes: broke apart initialize() function into multiple functions for better organization.
* Themes: support for optionally loading assets at runtime instead of embedding.
* Themes: now available as SWCs for easier project setup.
* MetalWorksMobileTheme: uses the new TextBlockTextRenderer.
* LayoutGroup: fix for empty spaces when an item is added more than once.
* ILayout: added new requiresLayoutOnScroll property to improve performance for static layouts.
* IValidating: new interface for objects that support validation.
* Scale9Image: implements IValidating to support forced validation and to put it in the ValidationQueue.
* Scale3Image: implements IValidating to support forced validation and to put it in the ValidationQueue.
* TiledImage: implements IValidating to support forced validation and to put it in the ValidationQueue.
* TabBar: support for more layout properties similar to ButtonGroup.
* Header: added optional centerItems property to support items in the center to replace the title.
* Item Renderers: added selectableField and selectableFunction to allow some item renderers to be selectable and some that are not selectable.
* Item Renderers: added enabledField and enabledFunction to allow some item renderers to be enabled and some that are not enabled.
* Item Renderers: added iconLabelField and iconLabelFunction similar to accessoryLabelField and accessoryLabelFunction.
* Item Renderers: support truncation of accessory label.
* DisplayListWatcher: extends EventDispatcher so that subclasses (themes) can dispatch events.
* DisplayListWatcher: now processes all matching named initializers instead of only the first match.
* PopUpManager: added IPopUpManager to support custom pop-up managers.
* PopUpManager: better support for multiple Starling instances.
* Alert: fixed issue where button group was disposed on close and caused runtime error.
* AnchorLayout: fixes for broken layouts with certain ordering of children.
* AnchorLayout: fixes to avoid runtime error when using children that don't implement ILayoutDisplayObject.
* Button: fix to long press duration being treated as an integer instead of floating point.
* Button: small fixes to layout edge cases.
* ButtonGroup: fix to allow buttons to be disabled and re-enabled.
* ButtonGroup: fix to properly remove event listners from data provider when data provider changes.
* BitmapFontTextRenderer: fix for centered text being blurred because its position wasn't rounded to an integer.
* Item Renderers: minor fixes to layout edge cases.
* StageTextTextEditor: fix for StageText not being properly hidden when text is empty.
* TextInput: fix for icon positioning using wrong padding value.
* ImageLoader: added optional textureQueueDuration property to upload textures after a short delay while delayTextureCreation is true. Previously, textures would not upload at all until delayTextureCreation was set to false again.
* ProgressBar: no longer sets touchable to false on skins.
* Panel: fix for failing to detect header and footer resizing.
* Drawers: fix for failing to detect drawer resizing.
* Scroller: fix for issue where an animated scroller with the scroll policy set to SCROLL_POLICY_OFF would incorrectly stop scrolling when touched. 
* Scroller: fix for incorrect calculation of maximum scroll positions when pageWidth or pageHeight is set.
* TextFieldTextRenderer: fix for wrapping bug.
* HorizontalLayout: fix for getScrollPositionForIndex() to properly calculate scroll position for indices less than beforeVirtualizedItemCount.
* VerticalLayout: fix for getScrollPositionForIndex() to properly calculate scroll position for indices less than beforeVirtualizedItemCount.
* ScreenNavigator: fix for edge case where the screen was not resized properly with AUTO_SIZE_MODE_CONTENT.

### 1.3.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `scrollerProperties` property on scrolling components, including List, GroupedList, ScrollText and ScrollContainer was originally deprecated in Feathers 1.1.0, and it has now been removed. Because these components now extend `Scroller` instead of adding a `Scroller` as a child, all of the properties that could be set through `scrollerProperties` can now be set directly on the components.

### 1.3.0 API Changes

Some changes have been made to Feathers that have the potential to break code in existing projects. Changes of this type may be considered [exceptions to the Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy#exceptions), and careful consideration is made to limit the impact of these changes on existing projects. Most developers using Feathers will not be affected by these changes, except perhaps, to observe improved stability and consistency.

#### ILayout

One change has been made to the `ILayout` interface. Custom implementations of `ILayout` created before Feathers 1.3.0 will have compiler errors until the required changes are made.

The property `requiresLayoutOnScroll` has been added to `ILayout` to provide improved performance for static layouts that don't change when a container scrolls.

 This property can easily simulate the old behavior from Feathers 1.2.0, if required. The following implementation of `requiresLayoutOnScroll` can easily be copied into a custom implementations of `ILayout` to quickly migrate existing Feathers 1.2.0 implementations to behave exactly the same in Feathers 1.3.0:

	public function get requiresLayoutOnScroll():Boolean
	{
		return true;
	}

## 1.2.0

* New Component: Alert
* New Component: Drawers
* New Component: LayoutGroup
* New Component(s): LayoutGroupListItemRenderer, LayoutGroupGroupedListItemRenderer, LayoutGroupedListHeaderOrFooterRenderer
* FeathersControl: better support for scaleX and scaleY. Width and height are scaled.
* FeathersControl: dispatches FeathersEventType.CREATION_COMPLETE after the first validation.
* FeathersControl: added isCreated flag to indicate if FeathersEventType.CREATION_COMPLETE has been dispatched.
* FeathersControl: ensures that keyboard focus is ignored if disabled.
* FeathersControl: new protected functions setInvalidationFlag() and getInvalidationFlag() for better re-invalidation during draw().
* FeathersControl: getChildByName() uses nameList.contains(). Doesn't work when an IFeathersControl is in a non-Feathers display object.
* Button: added FeathersEventType.LONG_PRESS event.
* Button: updates isEnabled on label text renderer and icon, if applicable.
* Button: label is always on top of the icon.
* List, GroupedList: Setting a new data provider will clear selection. Now, selection cannot be set before data provider is passed in. If the same selection is desired after a data provider change, it should be done manually.
* List, GroupedList: improved invalidation when various properties are changed.
* List, GroupedList: better handling of typical item to improve performance an accuracy of layout calculations.
* List, GroupedList: support for item renderers that can be deselected if multiple selection isn't enabled.
* ListCollection: removeAll() checks if length is 0 to avoid dispatching an event.
* GroupedList: improved handling of updateItemAt() to properly update whole groups.
* ImageLoader: added loadingTexture and errorTexture properties.
* ImageLoader: support for loading ATF files from URL.
* ToggleSwitch: on and off labels can be created with separate factories.
* Panel: header and footer contents can receive keyboard focus.
* ButtonGroup: properly resizes when data provider changes.
* ButtonGroup: support for padding around buttons.
* ButtonGroup: dispatches its own Event.TRIGGERED when any button is triggered.
* ButtonGroup: support for horizontal and vertical alignment.
* ButtonGroup, TabBar: better handling of custom names for first and last items.
* Callout: backgroundSkin is no longer required.
* Callout: show() function adds an argument for a custom overlay factory.
* Scale9Image, Scale3Image: support for scaling edge regions down to zero. Causes distortion, but removes overlapping.
* Scale9Image, Scale3Image, TiledImage, BitmapFontTextRenderer: uses batchable property from QuadBatch for improved performance.
* BitmapFontTextRenderer: fix for center and right alignment when using maxWidth.
* BitmapFontTextRenderer: fix for center and right alignment when no width or maxWidth is set.
* Scroller: support for minimum scroll positions less than zero.
* Scroller: improved draw() function to avoid extra invalidation.
* Scroller: new interactionMode value INTERACTION_MODE_TOUCH_AND_SCROLL_BARS.
* Scroller: added minimumDragDistance and minimumPageThrowVelocity.
* Scroller: fixed vertical page snapping.
* Scroller: supports custom page dimensions for snapping.
* Scroller: won't scroll with mouse wheel when scroll policy is off.
* Text editors: visibility fixes when text is empty.
* TextFieldTextEditor: support for rotation.
* StageTextTextEditor: doesn't clear text when displayAsPassword is changed.
* StageTextTextEditor: better scaling and support for rotation.
* TextFieldTextRenderer: supports using multiple textures if text width or height is greater than 2048 pixels.
* TextFieldTextRenderer: added disabledTextFormat property.
* TextInput, text renderers: dispatches soft keyboard events.
* TextInput: supports icon.
* TextInput: alternate name for search input.
* Screen, PanelScreen: better handling of back button that accounts for depth.
* ScreenNavigator: properly resizes if content is resized.
* ScreenNavigator: clears screen if removeScreen() is called for the active screen.
* ToggleGroup: added getItemIndex() and setItemIndex().
* VerticalCenteredPopUpContentManager: touch must begin and end outside of content to close the content.
* DisplayListWatcher: added initializeObject() function to initialize display objects that are already added when a theme is created.
* PropertyProxy: support for QName values.
* SmartDisplayObjectValueSelector: fix to support uint values for Quads.
* SmartDisplayObjectValueSelector: support for ConcreteTexture.
* State value selectors: strict equality checks for null to support 0 values.
* VerticalLayout, HorizontalLayout: improved item validation to account for justify alignment.
* AnchorLayout: better measurement when using horizontalCenter or verticalCenter values.
* ValidationQueue: items are added to the queue faster with better sorting.
* ExclusiveTouch: allows a component to claim a touch so that nested scrolling components won't be in conflict.
* Label: added ALTERNATE_NAME_HEADING for larger text and ALTERNATE_NAME_DETAIL for smaller text.
* Default item renderers: better handling of data and fields.
* Default item renderers: support for delaying texture creation on scroll in ImageLoaders.
* Default item renderers: updates isEnabled on accessory, if applicable.
* Default item renderers: accessory is cleared if itemHasAccessory is set to false.
* Default item renderers: fix for measurement when label is missing and gap isn't needed.
* DefaultGroupedListHeaderOrFooterRenderer: contentLabel maxWidth is used for proper wrapping, if needed.
* DefaultGroupedListHeaderOrFooterRenderer: added support for justify alignments.
* Many performance improvements with the help of Adobe Scout.
* All built-in components ensure that sub-components are validated.
* Examples: use drawers component where applicable.
* Examples: new DrawersExplorer example.
* Examples: new DragAndDrop example for DragDropManager.
* Themes: updated to support new properties and alternate names.
* Documentation: many properties now list default values.
* Documentation: createSubComponent() and autoSizeIfNeeded() patterns are now documented parts of the architecture.
* Fixes to better support iOS 7.
* New minimum runtime versions. Target SWF version rolled back to 18 (Flash Player 11.5 and AIR 3.5) to offer easier BlackBerry 10 support.

### 1.2.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `scrollerProperties` property on scrolling components, including List, GroupedList, ScrollText and ScrollContainer is deprecated. Because these components now extend `Scroller` instead of adding a `Scroller` as a child, all of the properties that could be set through `scrollerProperties` can now be set directly on the components. The `scrollerProperties` property was deprecated in Feathers 1.1.0, and it remains deprecated in Feathers 1.2.0. 

### 1.2.0 API Changes

Some changes have been made to Feathers that have the potential to break code in existing projects. Changes of this type are considered [exceptions to the Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy#exceptions), and careful consideration is made to limit the impact of these changes on existing projects. Most developers using Feathers will not be affected by these changes, except perhaps, to observe improved stability and consistency.

#### PopUpManager

Two changes have been made to the `PopUpManager`.

The function `isTopLevelPopUp()` has been modified to indicate if a pop-up is above the top-most modal overlay. Previously, this function indicated if a pop-up is the single top-most pop-up.

When a pop-up is centered when calling `PopUpManager.addPopUp()`, the `PopUpManager` will automatically realign the pop-up if the stage or the pop-up is resized. If you prefer that the pop-up isn't realigned, change the argument to `false` and call `PopUpManager.centerPopUp()` instead. It will align the pop-up only once. If you previously manually repositioned the pop-up to keep it centered when it or the stage resized, you may remove that code. However, if the code remains, it should not cause conflicts with the new behavior.

#### IVirtualLayout

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

#### GroupedList

The `typicalHeader` and `typicalFooter` properties have been removed from `GroupedList` to support the better handling of typical items in virtual layouts, as discussed above. From now on, the `typicalItem` on a `GroupedList` is the only way to provide hints to the layout used by a `GroupedList`.

## 1.1.1

This release includes minor updates to support Starling Framework 1.4 and a number of minor bug fixes.

* Switches to Starling's implementation of the clipRect property.
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
* TextInput: fix to allow TextFieldTextEditor to be selected on focus in.
* TextInput: added clearFocus() to allow programmatic removal of focus in NumericStepper.
* TextFieldTextEditor: snapshot is properly hidden when text is cleared.
* ButtonGroup: properly resizes when data provider changes.
* GroupedList: requests proper typical item from data provider.
* ScrollText: better padding getter.
* PickerList: closes pop-up list on Event.TRIGGERED.
* PickerList: properly disposes pop-up list and IPopUpContentManager.
* NumericStepper: if TextInput sub-component is editable, it will be selected on focus in.
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

### 1.1.0 API Changes

Some changes have been made to Feathers that have the potential to break code in existing projects. Changes of this type are considered [exceptions to the Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy#exceptions), and careful consideration is made to limit the impact of these changes on existing projects. Most developers using Feathers will not be affected by these changes, except perhaps, to observe improved stability and consistency.

#### IVariableVirtualLayout

Two changes have been made to the `IVariableVirtualLayout` interface. Custom implementations of `IVariableVirtualLayout` created before Feathers 1.1.0 will have compiler errors until the required changes are made. It is expected that a very small number of Feathers developers have created custom implementations of `IVariableVirtualLayout`, so this change will have no impact on the vast majority of projects that are upgraded from older versions of Feathers.

The functions `addToVariableVirtualCacheAtIndex()` and `removeFromVariableVirtualCacheAtIndex()` have been added to `IVariableVirtualLayout` to provide lower-level control over the cache of item dimensions. Instead of clearing the entire cache, a component may insert or remove a specific index from the cache. For instance, the `List` component uses these functions when its data provider is manipulated. These functions allow the layout to provide more accuracy to its virtualization and to improve performance.

 These two functions can easily simulate the old behavior from Feathers 1.0.x, if required. The following implementations of `addToVariableVirtualCacheAtIndex()` and `removeFromVariableVirtualCacheAtIndex()` can easily be copied into a custom implementations of `IVariableVirtualLayout` to quickly migrate existing Feathers 1.0.x implementations to behave exactly the same in Feathers 1.1.0:

	public function addToVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
	{
		this.resetVariableVirtualCache();
	}

	public function removeFromVariableVirtualCacheAtIndex(index:int, item:DisplayObject = null):void
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
