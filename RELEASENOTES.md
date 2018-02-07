# Feathers UI Release Notes

Noteworthy changes in official, stable releases of [Feathers UI](http://feathersui.com/).

## 3.4.1 - February 2018

* AnchorLayout: Fixed issue where x and y properties might not be accounted for in measurement if item had AnchorLayoutData, but didn't set left and top.
* BitmapFontTextEditor: Fixed issue where the cursor and selection might be positioned incorrectly when alignment is center or right.
* BitmapFontTextRenderer: Fixed issue where a new MeshStyle could be created too frequently when getDefaultMeshStyle() returns null.
* DataGrid: Fixed issue where reordering the columns might not reorder the column headers if the columns were generated automatically.
* DateTimeSpinner: Fixed issue where the default maximum date near the end of a year when using DateTimeMode.DATE_AND_TIME was not far enough into the future.
* FDT: Fixed some valid, but unconventional, code that caused this IDE to display false-positive compiler errors.
* Hierarchical Collections: Fixed some issues related to using null or empty locations that should have been considered invalid.
* ImageLoader: Fixed issue where an IOError or SecurityError might be thrown for an old source that was replaced.
* PopUpManager: Fixed issue where an error could be thrown by calling removeAllPopUps() when removing one pop-up might remove others automatically.
* TextBlockTextEditor: Fixed issue where the cursor might be positioned incorrectly when alignment is center or right.
* TextFieldTextEditor: Fixed issue where text editor would measure itself incorrectly when using embedded fonts because the measurement was based on device fonts instead.
* ToggleGroup: Fixed issue where a flag to ignore changes might be disabled too early, causing the selection to change to the wrong value.
* Tree: Fixed issue where changing the selected item programatically might not immediately update the appearance of the rendered component.

## 3.4.0 - December 2017

* New Component: DataGrid displays a list of data as a table. Each item is rendered as a row, divided into columns for each of the item's fields. Supports sorting columns, resizing columns, and drag-and-drop reordering of columns.
* Support for Android TV. Refactored focus management API and keyboard interaction to support TV remotes. Support scaling to TV resolutions.
* Collections: support for sorting.
* Alert: fixed null reference error when buttonsDataProvider is null and the accept or cancel key is pressed.
* ArrayHierarchicalCollection, VectorHierarchicalCollection: fixed issue where a runtime error could be thrown when checking if an item is a branch if the item is null.
* AutoComplete: fixed issue where the list did not close if an item is triggered by a keyboard event.
* BitmapFontTextRenderer: added breakLongWords property which can optionally break in the middle of long words if they extend beyond the width of the text renderer's bounds.
* BitmapFontTextRenderer: fixed issue where distance field fonts would render blurry and fonts that shouldn't use smoothing would be blurry.
* Button: added getScaleForState() and setScaleForState() to support different rendering scales in all states, in addition to the existing scaleWhenDown and scaleWhenHovering.
* Button, ToggleButton, ToggleSwitch, List, GroupedList, Tree: Event.TRIGGERED and Event.CHANGE may also be dispatched for Keyboard.ENTER if the key location is KeyLocation.D_PAD.
* Callout: added originGap property to optionally add extra spacing between the callout and its origin.
* DateTimeSpinner: fixed issue where internal SpinnerLists were not disabled when isEnabled is set to false.
* DeviceCapabilities: added simulateDPad property that allows regular keyboard arrow keys to interact with components similarly to a TV remote or another device that dispatches keyboard events with KeyLocation.D_PAD.
* DeviceCapabilities: methods that accept a flash.display.Stage parameter now default to null and fall back to Starling.current.nativeStage.
* DragDropManager: fixed issue where a null reference error could be thrown if the drag source's stage property was null during cleanup.
* FocusManager: can change focus up, down, left, or right if the keyLocation property of the KeyboardEvent is KeyLocation.D_PAD.
* FocusManager: supports TransformGestureEvent.GESTURE_DIRECTIONAL_TAP for focus navigation on Apple tvOS.
* HorizontalSpinnerLayout: added horizontalAlign property to allow the selected item to be aligned to the left or right instead of the default center.
* HorizontalSpinnerLayout: added paddingLeft and paddingRight to affect the position of the selected item, in addition to the horizontalAlign property.
* IFocusDisplayObject, added nextUpFocus, nextDownFocus, nextLeftFocus, and nextRightFocus properties, similar to previousTabFocus and nextTabFocus.
* IFocusDisplayObject: added isShowingFocus property to check if the focused object is showing its focus indicator.
* IListCollection: added sortCompareFunction property to allow sorting of items in the collection.
* ImageLoader: fixed issue where a texture that is too large for the current profile would result in a runtime error instead of being caught and turned into Event.IO_ERROR.
* ImageSkin: the defaultColor property defaults to 0xffffff so that it behaves more like the defaultTexture.
* ImageSkin: throws a runtime error if the color property from the Image superclass is set. Use defaultColor instead.
* IScreenNavigatorItem: added transitionDelayEvent to optionally delay the start of the transition until the screen dispatches an event. This allows the screen extra time to initialize and do things like load assets from the web.
* ISpinnerLayout: added selectionBounds getter to allow the layout to customize where the selectionOverlaySkin should be positioned.
* KeyToEvent: new superclass for KeyToTrigger to allow other events to easily get dispatched on key press.
* KeyToSelect, KeyToState, KeyToTrigger: added keyLocation property to optionally require a specific key location (like KeyLocation.D_PAD).
* LayoutGroup: fixed issue where AutoSizeMode.STAGE could be ignored if children are positioned beyond stageWidth and stageHeight, which could have made the container larger than expected.
* List, GroupedList, Scroller, SpinnerList, TextArea: uses native flash.events.KeyboardEvent.KEY_DOWN for keyboard interaction so that they can cancel focus changes, if necessary.
* List, GroupedList, Tree: fixed issue where a layout could be broken if the typicalItem were null.
* Mobile Themes: Now enable the FocusManager by default, just like desktop.
* NumericStepper: added useLeftAndRightKeys property to optionally allow stepper to be changed with Keyboard.LEFT and Keyboard.RIGHT instead of Keyboard.UP and Keyboard.DOWN.
* PickerList: fixed issue where the pop-up list may be given focus in the wrong focus manager when it uses a different focus manager than the PickerList.
* ScreenDensityScaleFactorManager: added support for Android TV and Apple tvOS.
* ScrollBar, SimpleScrollBar, Slider: fixed issue where the scroll bar could not reach the maximum scroll position with certain page or step values.
* Scroller: fixed issue where a null reference error could be thrown if scrolling animation were manually removed just as it completed.
* SpinnerList: added hideSelectionOverlayUnlessFocused to allow the selectionOverlaySkin to be hidden when the list is not focused if showSelectionOverlay is true.
* SpinnerList: added showSelectionOverlay property to completely hide the selectionOverlaySkin skin when set to false.
* SpinnerList: The selectedIndex and selectedItem is changed immediately when an item renderer is triggered or keyboard events change selection, instead of waiting for the animation to complete.
* StageTextTextEditor: keyboard arrow keys and Keyboard.ENTER are re-dispatched if KeyLocation.D_PAD so that this text editor will support focus changes, similar to how Keyboard.TAB is already re-dispatched.
* TapToEvent: new superclass for TapToTrigger to allow other events to easily get dispatched when tapping a display object.
* TapToEvent, TapToTrigger: added new tapCount property to wait for a specific number of taps before dispatching the event.
* TextBlockTextEditor: improved support for bidiLevel 1 and right-to-left languages.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where updateSnapshotOnScaleChange would result in incorrect texture dimensions if the scale was set after the component validated the first time but before it rendered.
* TextInput: added iconPosition property and support for RelativePosition.RIGHT.
* Todos Example: added a TabBar to filter items based on if they are completed or not.
* ToggleButton: added scaleWhenSelected property.
* TouchToState: if TouchPhase.HOVER is dispatched before TouchPhase.BEGAN, returns to hover state on TouchPhase.ENDED if hitTest() is successful.
* Tree: fixed issue where hasVariableItemDimensions was incorrectly forced to true, if possible. Should now be set manually on the layout.
* VerticalSpinnerLayout: added verticalAlign property to allow the selected item to be aligned to the top or bottom instead of the default middle.
* VerticalSpinnerLayout: added paddingTop and paddingBottom to affect the position of the selected item, in addition to the verticalAlign property.
* VideoPlayer: added netStreamFactory to customize how the flash.net.NetStream is created.

## 3.3.1 - October 2017

* BitmapFontTextRenderer: fixed issue where multiple text renderers with multiple custom mesh styles would incorrectly share a single style.
* FeathersControl: fixed issue where focusIndicatorSkin was not always disposed.
* FontStylesSet: fixed issue where properties from a new starling.text.TextFormat were incorrectly copied to the old TextFormat, which could cause other components to change font styles too.
* ImageLoader: fixed issue where texture would not be reused when starling.textures.Texture.asyncBitmapUploadEnabled is false.
* ImageLoader: fixed issue where error was thrown if using texture cache and the texture could not be reused in its current state on restoration.
* ImageLoader: fixed issue where a runtime error could be thrown if the texture is disposed while the application is deactivated on mobile.
* Scroller: fixed issue where top and bottom offsets were used instead of left and right when determining if the horizontal scroll bar should be displayed.
* Scroller: fixed issue where pull views would not work sometimes if hasElasticEdges is false.
* ScrollText: fixed issue where Event.TRIGGERED would not work if FocusManager is enabled because it didn't implement INativeFocusOwner to return its TextField.
* StageTextTextEditor: fixed issue where setting the parent TextInput's visible property to false inside a FeathersEventType.FOCUS_OUT listener would hide the background, but not the StageText.
* StageTextTextEditor: fixed issue where calling clearFocus() after setting the parent TextInput's visible property to false would hide the background, but not the StageText.
* TabNavigator: fixed issue where the previous screen was incorrectly recreated if isSwipeEnabled is true and a swipe transition is cancelled.
* TextInputRestrict: fixed issue where -, ^, and \ characters could not be escaped. Used by BitmapFontTextEditor and TextBlockTextEditor.

## 3.3.0 - July 2017

* New Component: Tree is a List-like component designed for displaying nested hierarchical data, with branches that may be opened and closed.
* New Layout: SlideShowLayout is designed for displaying one image at a time in a gallery.
* BaseDefaultItemRenderer: fixed issue in skinSourceField where the wrong variable was checked to determine if the property has changed.
* BaseDefaultItemRenderer: fixed issue where icon or accessory dimensions were not accounted for in measurement if item renderer does not have a label.
* BaseLinearLayout: new abstract base class for HorizontalLayout and VerticalLayout that shares common code.
* BaseTiledLayout: new abstract base class for TiledRowsLayout and TiledColumnsLayout that shares common code.
* BottomDrawerPopUpContentManager: added customCloseButtonStyleName to customize the style name of the close button in the theme.
* BottomDrawerPopUpContentManager, CalloutPopUpContentManager, DropDownPopUpContentManager, VerticalCenteredPopUpContentManager: fixed issue where the content was not scaled the same as the origin.
* Callout: fixed issue where stage dimensions were not accounted for when calculating maximum dimensions of content.
* Callout: fixed issue where moving origin when content is smaller than background skin could cause content to be rendered at incorrect size.
* Cover, Reveal, Wipe: fixed issue where runtime error could be thrown if mask was unexpectedly removed from display objects.
* DateTimeSpinner: fixed issue where you could not set the itemRendererFactory directly on the inner SpinnerLists when the DateTimeSpinner itemRendererFactory was null.
* DefaultFocusManager: fixed issue where addEventListener() was called where removeEventListener() should have been called, potentially causing a memory leak.
* DefaultFocusManager: fixed issue where maintainTouchFocus was incorrectly ignored.
* Direction: added NONE constant that may be used in some situations.
* DropDownPopUpContentManager: fixed issue where the delegate used for animation was not scaled by the same amount as the content it mirrored.
* DropDownPopUpContentManager, VerticalCenteredPopUpContentManager: fixed issue where content was not positioned or resized correctly if PopUpManager.root is scaled.
* FeathersControl: throws an error if validate() is called during initialize() because it was not clear that this previously returned without doing anything.
* FeathersControl: fixed issue where setting minWidth or minHeight that is larger than the actualWidth and actualHeight might fail to invalidate the component.
* FeathersControl: fixed issue where setting the validation queue before initialization could cause a navigator to trigger validation when showing a screen during initialization and validate something too early.
* FocusManager: fixed issue where getFocusManagerForStage() threw a RangeError if stack size is 0 instead of returning null.
* FontStylesSet: added dispose() method to make sure event listeners are removed (to be called by the parent of the text renderer/editor).
* FontStylesSet: no longer calls clone() on starling.text.TextFormat because this prevents detection of changes to original TextFormat object. This reverts a change in Feathers 3.1.2 and goes back to previous behavior (while still fixing the memory leak that prompted the change).
* GroupedList: fixed issue where first/last/single item renderer factories were not used as fallbacks when factoryIDFunction returns null.
* GroupedList, List: fixed issue where mouse wheel did not work when useVirtualLayout is false in layout.
* GroupedList: fixed issue where keyboard navigation failed after multiple groups.
* HorizontalSpinnerLayout, VerticalSpinnerLayout: fixed issue where keyboard navigation did not loop when items are repeated.
* ILayout: added calculateNavigationDestination() to allow custom behavior for keyboard navigation.
* IListCollection: new interface to support custom collection implementations, and added ArrayCollection, VectorCollection, and XMLListCollection.
* IHierarchicalCollection: new interface to support custom hierarchical collection implementations, and added ArrayHierarchicalCollection, VectorHierarchicalCollection, and XMLListHierarchicalCollection.
* ImageLoader: fixed issue where originalSourceWidth and originalSourceHeight properties returned the wrong value in an Event.COMPLETE listener.
* ImageLoader: fixed issue where scaleFactor getter returned incorrect value.
* LayoutGroup, ScrollContainer: in a subclass that overrides draw(), if a child is resized or has changes to its layoutData before super.draw() is called, the container will not be invalidated to avoid the "returned to validation queue too many times during validation" error.
* SoundPlayer: added soundLoaderContext property to allow a flash.media.SoundLoaderContext to be passed in for the internal load() call.
* Scroller: added horizontalPageIndex and verticalPageIndex setters so that you can change pages without calling scrollToPageIndex() (which is meant for animation).
* Scroller: fixed issue where scroll bar would fade out immediately when beyond the minimum or maximum scroll position instead of waiting until after the scroller snaps back into range.
* Scroller: if hasElasticEdges is false, does not consider itself dragged if already at the minimum or maximum and can't be scrolled further.
* Scroller: fixed issue with snapScrollPositionToPixels where the animation would appear to complete because it had already snapped to the final pixel, but there could still be more time left on the animation.
* Scroller: fixed issue where measured view port dimensions (such as those from a layout) that are smaller than content dimensions would cause the full dimensions to exclude the scroll bars. This would sometimes cause both horizontal and vertical scroll bars to appear when only one should be required.
* Scroller: fixed incorrect maximum page index calculation caused by floating point math error and Math.ceil.
* Scroller: fixed issue where pull views with pivots were not masked correctly.
* ScrollContainer: fixed issue where children positioned at negative coordinates did not affect the minimum scroll position.
* ScrollContainer: fixed issue where pivotX and pivotY were not scaled when calculating item position.
* SpinnerList: fixed issue where an item renderer that is disabled could be incorrectly selected. Returns to the previously selected index if the scroll position lands on a disabled item renderer.
* SpinnerList: fixed issue where pageThrowDuration property was ignored when scrolling horizontally.
* TabNavigator: fixed issue where isSwipeEnabled getter returned incorrect value.
* TextArea: fixed issue where runtime error would be thrown in measureViewPort is true.
* TextFieldTextEditor: fixed issue where state changes in the parent component would not always update the font styles when using starling.text.TextFormat.
* Text Renderers/Editors: if they have a texture snapshot, optimized to avoid updating the snapshot until render() is called, in case it needs to validate() multiple times per frame (which is common in lists).
* TiledColumnsLayout, TiledRowsLayout: deprecated PAGING_NONE, PAGING_HORIZONTAL, and PAGING_VERTICAL in favor of Direction.NONE, Direction.HORIZONTAL, and Direction.VERTICAL.
* ToggleSwitch: now uses ExclusiveTouch so that parent containers cannot scroll while dragging thumb.
* Gallery Example: replaced full size image with a List that uses SlideShowLayout, and the full size image may be resized with a gesture.

## 3.2.0 - April 2017

* PullToRefresh: new example that demonstrates how to support the popular "pull to refresh" gesture with Feathers lists and other scrolling containers.
* TabNavigator: support for swiping between tabs.
* ListCollection: added filterFunction property to support filtering items in data providers.
* API Reference: All classes now specify the version of Feathers when they were first added.
* Added [Deprecated] metadata to deprecated APIs.
* Alert: added acceptButtonIndex and cancelButtonIndex to allow keyboard (or hardware back button) control over alert.
* AnchorLayout: fixed issue where maxWidth and maxHeight were ignored when using top/right/bottom/left on AnchorLayoutData.
* AutoComplete, PickerList: fixed issue where event listeners were not added to default popUpContentManager created in initialize().
* BitmapFontTextEditor, TextBlockTextEditor: added support for blinking cursor when focused.
* BitmapFontTextEditor, TextBlockTextEditor: fixed issue where FeathersEventType.FOCUS_OUT would not be dispatched afte calling setFocus() when the FocusManager is not enabled.
* BitmapFontTextRenderer: fixed an issue where extra whitespace would appear at the end of every line.
* BitmapFontTextRenderer: added support for kerning and letterSpacing properties of starling.text.TextFormat.
* Button, DefaultGroupedListHeaderOrFooterRenderer, Header: added wordWrap property. No longer needs to be set in text renderer factory, but existing code that sets it there will continue to work.
* Button, DefaultGroupedListHeaderOrFooterRenderer, Header: added numLines getter to get the number of lines displayed in the text renderer.
* Button: fixed issue where label text renderer measurement was incorrect if minWidth or minHeight is set explicitly.
* CalloutPopUpContentManager: similar to Callout, the direction property is now deprecated and added supportedPositions as its replacement.
* DateTimeSpinner: added backgroundSkin, backgroundDisabledSkin, and padding properties.
* DateTimeSpinner: fixed issue where pending value of scrollToDate() was not cleared.
* Drawers: content property may now be null when validating. However, it should not be null when opening a drawer.
* FeathersControl; layoutData is set to null when disposed to avoid potential memory leaks.
* FeathersControl: Removes event listeners on styleNameList when disposed so that they cannot be called for no reason.
* FeathersControl; added ignoreNextStyleRestriction() to allow components to set defaults during initialization while still allowing a theme to replace styles later.
* FeathersControl: fixed an issue where measured minimum dimensions were not affected by explicit maximum dimensions.
* GroupedList: similar to items, an error is thrown if duplicate header or footer data appears in the data provider.
* HorizontalLayout, VerticalLayout: fixed issue where includeInLayout was ignored when distributing item sizes.
* HorizontalLayout, VerticalLayout: fixed issue where includeInLayout was ignored when using percent dimensions.
* HorizontalLayout, VerticalLayout: fixed issue where the typicalItem could not resize after layout.
* ImageLoader: supports asynchronous texture uploads to improve performance when uploading textures to the GPU.
* ImageLoader: exposed sourceToTextureCacheKey() to allow subclasses to override the key used in the TextureCache for non-URL sources.
* ImageLoader: createTextureOnRestore accepts sources that are non-URLs to allow subclasses to override this behavior.
* IPopUpContentManager: now includes EventDispatcher APIs so that casting is not required.
* Item Renderers: callbacks like labelFunction and iconFunction now support a second, optional parameter for the item's index. For example, labelFunction may now use either of the following signatures: function(item:Object):String or function(item:Object, index:int):String.
* Item Renderers: will now display data when owner is null.
* KeyToState: new utility class to change a component's state based on keyboard events.
* KeyToTrigger, KeyToSelect: fixed issue where event listeners added to the stage would not be removed if the target was set to null before it was removed from stage.
* List, GroupedList; when updateAll() is called on the data provider, items that were added or removed from source are now rendered.
* List, GroupedList: fixed issue where event listeners were not added to default layout created in initialize().
* List, GroupedList: fixed issue where an item could not receive a new factoryID after its index changes.
* ListCollection, HierarchicalCollection: removeAll() no longer results in CollectionEventType.RESET. This should not have been considered a drastic reset. CollectionEventType.REMOVE_ALL is dispatched instead.
* PickerList: added itemRendererFactory and customItemRendererStyleName. They no longer need to be set in the listFactory. However, existing code that sets them in the listFactory will continue to work correctly.
* Navigators: validates active screen when navigator validates to avoid flickering on next frame with delayed automatic validation.
* ScrollContainer: renamed internal stage_resizeHandler to scrollContainer_stage_resizeHandler because ASC 1.0 might consider it a conflict.
* Scroller: fixed issue where a state change would not cause the scroller to measure its new background skin.
* Scroller: fixed issue where a layout change would not cause the scroller to measure its content again.
* Scroller: added horizontalScrollBarPosition to allow the horizontal scroll bar to appear on top.
* Scroller: added support for pull views on top, right, bottom, and left to support "pull to refresh" gesture.
* Scroller: fixed issue where scrollToPageIndex() would not result in dispatch of FeathersEventType.SCROLL_START and FeathersEventType.SCROLL_COMPLETE.
* SpinnerList: fixed issue where scroll position was not updated if layout snapInterval changed.
* StageTextTextEditor: position of StageText can no longer be larger than 8191 or smaller than -8192 to avoid a runtime error.
* StageTextTextEditor: added clearButtonMode property to support new StageText API.
* StageTextTextEditor: does not call assignFocus() on StageText if StageText already has focus because this can cause soft keyboard to close and re-open on iOS.
* TabBar: fixed issue where setSelectedIndexWithAnimation() and setSelectedItemWithAnimation() did not change the value of the selectedItem property.
* TabBarSlideTransitionManager: moved to feathers-compat project.
* TextBlockTextRenderer: fixed issue where a new line width would not be properly detected when using content property, and optimized for the standard text case.
* TextBlockTextRenderer: added support for leading, kerning, and letterSpacing properties of starling.text.TextFormat.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed incorrect position of snapshots when using updateSnapshotOnScaleChange.
* TextFieldTextRenderer: ensures that _text property is not null because flash.text.TextField does not support null values.
* TextInput: no longer shows IBEAM cursor on TouchPhase.HOVER if isEditable and isSelectable are both false.
* TouchToState: new utility class to change a component's state based on TouchPhase values.
* VerticalCenteredPopUpContentManager: fixed margin setter that passed 0 to marginTop/marginRight/marginBottom/marginLeft instead of new value.
* VerticalLayout: alignment of headers with getScrollPositionForIndex() defaults to VerticalAlign.TOP because that makes more sense for headers instead of VerticalAlign.MIDDLE.
* VideoPlayer: fixed issue where display state was not properly updated when exiting full screen with the Escape key.

## 3.1.2 - January 2017

* FontStylesSet: Clones or copies properties from starling.text.TextFormat to avoid memory leak.

## 3.1.1 - November 2016

* AnchorLayout: fixed issue where using percentWidth would result in an error about maxWidth being NaN.
* DefaultListItemRenderer: fixed issue where defaultSkin and defaultIcon properties were not treated correctly as styles.
* FlowLayout: fixed issue where alignment to the center or right was not correct when container has explicit width.
* Header: accounts for new Capabilities.os value on some recent iOS devices when calculating extra padding for status bar when not full screen.
* HorizontalLayout, VerticalLayout fixed issue where using requestedColumnCount/requestedRowCount would result in incorrect view port dimensions if layout contained zero items.
* TextBlockTextRenderer, TextBlockTextEditor: fixed issue where text would not be clipped sometimes if truncation is disabled.
* TextBlockTextRenderer: fixed issue where center or bottom alignment was offset incorrectly.
* ToggleButton: fixed issue where defaultLabelProperties, selectedUpLabelProperties, and other selected label properties were ignored.

## 3.1.0 - October 2016

See the [Feathers 3.1 Migration Guide](http://feathersui.com/help/migration-guide-3.1.html) for details about how to upgrade to Feathers 3.1.

* New Component: TabNavigator to display a TabBar that switches between screens, similar to a ScreenNavigator.
* Font Styles: all components support starling.text.TextFormat for font styling. For advanced needs, text renderers can still use low-level ElementFormat/TextFormat objects which take precedence.
* Style Properties: some properties are now considered styles, and a theme cannot replace their values if they are set outside of the theme first. No more AddOnFunctionStyleProvider, validation, or extending the theme required.
* Architecture: Attempts to use stage.starling instead of Starling.current, if possible. Brings better compatibility with multiple Starling instances.
* Architecture: switched many places to use starling.utils.Pool instead of static helper objects.
* AnchorLayout: fixed issue where maxWidth wasn't used when explicitWidth was not set.
* AnchorLayout, HorizontalLayout, VerticalLayout: with percentWidth and percentHeight, explicitMinWidth and explicitMinHeight will be used as the final minimum bounds instead of calculated minimums sent to saveMeasurements().
* BitmapFontTextRenderer: fixed infinite loop when wordWrap is true and maxWidth is 0.
* BitmapFontTextRenderer: added style property to support a custom MeshStyle.
* BitmapFontTextRenderer: fixed issue where resizing larger would not change position of aligned text.
* Button: fixed issue where header would invalidate too often if icon dimensions change.
* Button: fixed alignment when using scaleWhenDown or scaleWhenHovering.
* ButtonBar: implements ITextBaselineControl to expose button baseline.
* Callout: is positioned in parent's coordinate space, instead of stage coordinate space.
* ColorFade: fixed issue where Quad could be given a width or height of 0 in its constructor, which causes a runtime error.
* Cube: fixed issue with culling that caused screen to overlap incorrectly during transition.
* DateTimeSpinner: added customItemRendererStyleName.
* Default Item Renderers: added customIconLoaderStyleName and customAccessoryLoaderStyleName for icon and accessory ImageLoaders.
* Default Item Renderers: uses customHitTest on TapToTrigger, TapToSelect, and LongPress to exclude accessory from touches (instead of old custom implementation).
* DropDownPopUpContentManager: fixed issue where Quad could be given a width or height of 0 in its constructor, which causes a runtime error.
* FeathersControl: runtime error is thrown if a component is repeatedly added to validation queue in the same frame.
* FeathersControl: instead of adding listeners for FeathersEventType.FOCUS_IN and FeathersEventType.FOCUS_OUT when focusManager is set, adds listeners automatically if component implements IFocusDisplayObject.
* FlowLayout: fixed issue where horizontal alignment did not account for items larger than the width of the view port.
* GroupedList, List: fixed issue where calling scrollToDisplayIndex() would result in a runtime error if dataProvider is null.
* Header: uses ScreenDensityScaleCalculator to calculate extra padding on iOS when app is not full screen.
* Header: fixed issue where header would invalidate too often if item dimensions change.
* Header: fixed issue where extra status bar padding for iOS might not be calculated correctly if background skin height is large enough.
* HorizontalLayout, VerticalLayout: fixed issue where distributeWidths and distributeHeights did not work correctly when useVirtualLayout is true.
* HorizontalLayout, VerticalLayout: fixed issue where percentHeight or percentWidth might not be used during measurement.
* HorizontalLayout, VerticalLayout: fixed issue where maxWidth or maxHeight would be incorrectly limited.
* HorizontalLayout, VerticalLayout: fixed issue where requestedRowCount and requestedColumnCount did not work correctly when useVirtualLayout is false.
* HorizontalLayout, VerticalLayout: added maxColumnCount and maxRowCount properties.
* HorizontalSpinnerLayout, VerticalSpinnerLayout: fixed runtime error in snapInterval property when typicalItem is null.
* ImageLoader: fixed issue where scale9Grid incorrectly allowed maintainAspectRatio to remain in effect.
* ImageLoader: fixed issue where a layout with percentWidth and percentHeight might not work because minimum dimensions were not calculated correctly.
* ImageLoader: does not call close() on flash.display.Loader because this can cause a memory leak when using ImageDecodingPolicy.ON_LOAD. Instead, switches to different Event.COMPLETE listener to dispose BitmapData and unload image.
* ImageSkin: fixed issue where skin would not resize correctly after setting explicit dimensions and then clearing them.
* ITextRenderer: added numLines getter that returns the number of lines of text that are wrapped.
* ITextRenderer, ITextEditor: added fontStyles property that accepts a FontStylesSet. This is not meant to be used by application developers, but custom component authors. Application developers should set font styles on the parent component instead of text renderer/editor.
* LayoutGroup Item Renderers: added backgroundSelectedSkin to optionally customize background when selected.
* LayoutGroup, ScreenNavigator, ScrollContainer: StackScreenNavigator: fixed issue where AutoSizeMode.STAGE would be ignored if the navigator validated before being added to the stage.
* LayoutGroup, ScrollContainer: the default layout (when the layout property is null) now accounts for pivotX and pivotY during measurement.
* MultiStarlingStyleNameFunctionTheme: moved to feathers-compat.
* Panel: fixed issue where header would invalidate too often if header dimensions changes.
* PickerList: calls revealScrollBars() on pop-up list when opened to show whether scrolling is possible.
* PickerList: implements ITextBaselineControl to expose button baseline.
* PopUpManager: now accounts for pivotX and pivotY when centering a pop-up.
* PopUpManager: added popUpCount property to indicate how many pop-ups are currently open.
* PopUpManager: added removeAllPoUps() function to remove all open pop-ups.
* ScreenDensityScaleCalculator: pulled out calculation of scale factor using DPI from ScreenDensityScaleFactorManager into separate class that can be used elsewhere.
* ScreenNavigator, StackScreenNavigator: the default transition (which has no effect) now happens immediately instead of waiting for next frame the way that animated transitions are treated.
* Scroller: fixed issue where final touch movement would not be included in drag on TouchPhase.ENDED.
* Scroller: runtime error is thrown if measurement of view port gets into an infinite loop. Previously, it broke out of the loop, but performance would suffer.
* Scroller: checks for drag start on TouchPhase.MOVED so that the Quad touch blocker appears faster and the view port does not receive invalid touches. Continues to update velocity on Event.ENTER_FRAME.
* Scroller: fixed issue where a runtime error was thrown when a bubbling TouchEvent continued after removing the listener.
* SpinnerList: fixed issue where pageThrowDuration property was ignored when scrolling horizontally.
* SpinnerList: fixed issue where scroll position was not updated after removing or adding item before the selected item.
* StackScreenNavigator: fixed issue where navigator could transition infinitely because state was not cleared correctly.
* StageTextTextEditor, TextFieldTextEditor: fixed issue where the texture would be updated too frequently because the wrong texture dimensions were used for comparison.
* StageTextTextEditor, TextFieldTextEditor: added maintainTouchFocus property that will keep the text editor in focus if something else is touched. On mobile, this will keep the soft keyboard open. Requires AIR 22.
* StageTextTextEditor: fixed issue where StageText could not always be hidden when isEditable is false.
* StyleNameFunctionTheme: has a property for the Starling instance it is associated with.
* StyleNameFunctionTheme: automatically supports multiple Starling instances. Create a new instance of the theme when a new instance of Starling is current.
* TabBar: dispatches Event.TRIGGERED when a tab is triggered. The event's data property references the item from the data provider.
* TabBar: added selectedSkin property to display an animated overlay over the tabs to indicate selection.
* TabBar: added setSelectedIndexWithAnimation() to animate the selectedSkin on programatic selection changes (always animated on user changes).
* TabBar: added labelField, labelFunction, iconField, iconFunction, enabledField and enabledFunction. These are no longer controlled by tabInitializer property.
* TabBar: icon from ListCollection is not disposed, and dispose() function on ListCollection should be used.
* TabBar: implements ITextBaselineControl to expose tab baseline.
* TapToTrigger, TapToSelect, LongPress: added customHitTest property to allow items to be excluded or other custom behavior.
* TextArea: no longer changes selection range when given focus because Flex and HTML textarea element don't do that.
* TextArea: exposed selectionBeginIndex and selectionEndIndex properties, similar to TextInput.
* TextArea: fixed issue where calling selectRange() immediately after setFocus() would incorrectly change selection.
* TextArea, TextInput: fixed issue where changing errorString while input has focus would not change visibility of TextCallout (such as when setting to null).
* TextBlockTextRenderer, TextBlockTextEditor, TextFieldTextRenderer, TextFieldTextEditor: uses SystemUtil.isEmbeddedFont() to determine if font styles are embedded when using starling.text.TextFormat.
* TextBlockTextRenderer, TextFieldTextRenderer: optimize render() function to avoid calling getTransformationMatrix() unless required.
* TextBlockTextRenderer, TextFieldTextRenderer: uses smallest texture possible, even when dimensions are explicit to save memory and optimize performance (so that resizing larger doesn't cause a new texture to be required).
* TextInput: calling setFocus() programatically will select all text, for consistency with Flex.
* TextInput: fixed issue where incorrect selection range would be reported in FeathersEventType.FOCUS_IN listener.
* TextInput: fixed issue where selection range would not be set if text editor did not exist yet.
* Text Renderers, Text Editors: when using starling.text.TextFormat, supports vertical alignment.
* TiledColumnsLayout, TiledRowsLayout: added distributeWidths and distributeHeights properties.
* ToggleGroup: added numItems property and getItemAt() method.
* ToggleSwitch: implemented IStateContext with states defined in feathers.controls.ToggleState class.
* ValidationQueue: no longer keeps a delayed queue that will be validated a frame later because FeathersControl throws an error in the cases where it was used.
* VerticalLayout: fixed issue where scroll position calculation did not account for sticky header on GroupedList.
* VideoPlayer: added events for MediaPlayerEventType.CUE_POINT and MediaPlayerEventType.XMP_DATA for NetStream's onCuePoint and onXMPData.
* VideoPlayer: invalidates layout after Event.READY so that it might resize, if needed.
* WebView: added FeathersEventType.LOCATION_CHANGING.
* New Example: Tabs, a demonstration of the new TabNavigator component.
* New Example: Magic8Chat, a mobile chat application.

## 3.0.4 - September 2016

* Header: fixed issue where extra padding for status bar did not work on iOS 10.

## 3.0.3 - July 2016

* ImageLoader: Fixed issue where reusing the existing texture did not cause the rendered view to update when skipUnchangedFrames is true.
* Text Renderers: Fixed issue where reusing the existing texture(s) did not cause the rendered view to update when skipUnchangedFrames is true.

## 3.0.2 - June 2016

* Scroller: Fixed issue where view port mask would not always be resized, such as when items are added to a List.

## 3.0.1 - June 2016

* List, GroupedList: fixed issue where ViewPortBounds minWidth and minHeight could be NaN (this broke percentWidth and percentHeight on some layouts).
*  HorizontalLayout, VerticalLayout: fixed issue where layout could invalidate every frame when using percentages.
*  FeathersControl: fixed issue where setting width or height, then scaleX or scaleY, then trying to set original width or height would fail.

## 3.0.0 - June 2016

See the [Feathers 3.0 Migration Guide](http://feathersui.com/help/migration-guide-3.0.html) for details about how to upgrade to Feathers 3.0.

* Support for Starling Framework 2.0
* Minimum runtime version is now Flash Player 19 and AIR 19.
* All Components: now automatically calculate minimum dimensions when they are not set explicitly. These values may be used by some layouts, such as when specifying percentWidth and percentHeight.
* New Example: StackScreenNavigatorExplorer demonstrates various options for StackScreenNavigator.
* Examples: updated to use ScreenDensityScaleFactorManager.
* Examples: updated to use Starling's new skipUnchangedFrames property.
* Example Themes: updated to scale based on contentScaleFactor instead of Capabilities.screenDPI.
* Example Themes: Redesigned using Animate CC, and exported as sprite sheet. Find links to original FLA files in Feathers Help.
* Migrated shared constants to a single class. Example: HORIZONTAL_ALIGN_LEFT, HORIZONTAL_ALIGN_CENTER, and HORIZONTAL_ALIGN_RIGHT are now available on the feathers.layout.HorizontalAlign class. See migration guide for details and regular expressions for Find/Replace.
* AnchorLayout: optimized measurement of children by restricting dimensions before validation.
* BasicButton: new superclass of Button that has only a background skin. Useful as for skinning components like a Slider's thumb or tracks that don't need an icon or label.
* BitmapFontTextEditor: fixed issue where selectionAnchorIndex was not updated in certain situations.
* BitmapFontTextRenderer: fixed issue where explicit dimensions were ignored in measurement.
* BitmapFontTextRenderer: replaced snapToPixels property with pixelSnapping property to match Starling 2.0 naming convention.
* BitmapFontTextRenderer: added support for offsetX and offsetY properties from starling.text.BitmapFont.
* BitmapFontTextRenderer: optimized measurement of width by skipping calculations if maximum is larger than last width.
* BottomDrawerPopUpContentManager: added overlayFactory property to customize the modal overlay.
* Button: deprecated stateToSkinFunction. Replaced by feathers.skins.ImageSkin.
* Button: deprecated upLabelProperties, hoverLabelProperties, downLabelProperties, disabledLabelProperties. Replaced by setting font styles on text renderer in labelFactory. Text renderers now support multiple font styles for different states.
* Button: states are defined in feathers.controls.ButtonState.
* Button: fixes issue where some icons or skins would not be disposed when button is disposed.
* ButtonGroup: fixed issue where changing isEnabled in data provider to false and then true would not re-enable a button.
* ButtonGroup: added buttonReleaser property that works similarly to buttonInitializer, but for cleaning up a tab.
* Callout: deprecated supportedDirections property, and replaced it with supportedPositions property that accepts a Vector.<String> of constants defined by the RelativePosition class. Allows more flexibility in the preferred order of callout positions.
* Callout: added horizontalAlign and verticalAlign properties to customize alignment of callout relative to its origin.
* CalloutPopUpContentManager: added overlayFactory property to customize the modal overlay.
* ConditionalStyleProvider: new style provider where the result of a function selects between two style providers.
* DateTimeSpinner: added itemRendererFactory property to allow the item renderer to be customized. Must return a DefaultListItemRenderer or a subclass.
* DateTimeSpinner: improved measurement with DateTimeMode.DATE by using longest month name as typical item.
* DateTimeSpinner: fixed issue where runtime error could be thrown if changing range or locale.
* DateTimeSpinner: fixed issue where changing locale would not update displayed month names.
* DateTimeSpinner: fixed issue where year range would be wrong after changing minimum.
* DateTimeSpinner: now uses a typicalItem for the DateTimeMode.DATE_AND_TIME dates list so that it won't resize during scrolling.
* DefaultListItemRenderer, DefaultGroupedListItemRenderer: itemToLabel() now strictly checks for null instead of a "truthy" value, and an empty string will have different behavior.
* DisplayListWatcher: removed class. Please migrate to new themes, or find this class in feathers-compat library.
* Drawers: fixed issue where drawer would jump open instead of opening smoothly when minimumDragDistance was too large.
* Drawers: optimized measurement of drawers by setting explicit/max dimensions before validation.
* Drawers: drawers must implement IFeathersControl, and Sprite is not allowed anymore.
* Drawers: now enforces the assumption that multiple drawers cannot be opened at the same time (multiple drawers can still be docked).
* FeathersControl: setSizeInternal() is deprecated and replaced by saveMeasurements(), which includes the ability to set the minimum width and minimum height.
* FeathersControl: added toolTip property to display a tool-tip if the ToolTipManager is enabled.
* FeathersControl: added explicitWidth, explicitHeight, explicitMinWidth, and explicitMinHeight. Will return a Number when set, or NaN if the component has auto-sized.
* FeathersControl: if component implements IStateContext and focusIndicatorSkin is IStateObserver, passes self to stateContext property.
* FeathersControl: added resetStyleProvider() function to allow a component's style provider to be set back to the default. Useful when changing to a different theme.
* FeathersControl: fixed issue where setting width after scaleX (or height after scaleY) would result in incorrect final dimensions. Same for minWidth and minHeight.
* FeathersControl: maxWidth and maxHeight can never be less than 0.
* FeathersControl: optimization where the component will not invalidate if changing minWidth, minHeight, maxWidth, or maxHeight obviously won't affect the actual dimensions of the component.
* FocusManager: fixed issue where focus would stop going forward when encountering an IFocusContainer.
* FlowLayout: fixed issue where alignment could be wrong if maximum row width were smaller than max width.
* GroupedList: added itemToItemRenderer(), headerDataToHeaderRenderer(), and footerDataToFooterRenderer() functions, to get a renderer for specific data (if one is available).
* GroupedList: fixed issue where a runtime error could be thrown when the dataProvider property is null.
* GroupedList: fixed issue where a runtime error could be thrown when adding or removing an item and using first, last, or single item renderer.
* Header: improved calculation of status bar height when using useExtraPaddingForOSStatusBar.
* Header: When horizontalAlign is HorizontalAlign.LEFT, and the header has leftItems, the title will appear to the right of the items instead of being hidden. Same for HorizontalAlign.RIGHT and rightItems. In these cases, the title will still be hidden if the header has centerItems.
* HorizontalLayout: fixed issue where percentWidth/percentHeight values greater than 100 were not clamped.
* HorizontalSpinnerLayout: added repeatItems property that may be set to false to disable repeating items with infinite scrolling.
* HorizontalSpinnerLayout: fixed issue where items could disappear when using gap property.
* ImageLoader: fixed issue where setting source to null when using a TextureCache would not release the texture from the cache.
* ImageLoader: replaced snapToPixels property with pixelSnapping property to match Starling 2.0 naming convention.
* ImageLoader: added scale9Grid and tileGrid properties.
* ImageLoader: fixed issue where ScaleMode.NONE was not respected during auto-sizing.
* ImageLoader: masks internal Image instead of itself when clipping a scaled texture so that the mask property can be used too.
* ImageSkin: new display object that supports multiple textures and colors for different states.
* IMeasureDisplayObject: new interface with explicit, minimum, and maximum dimensions for use when the full IFeathersControl is not necessary.
* INativeFocusOwner: nativeFocus property is now typed as Object instead of InteractiveObject so that objects like StageText may be used, and added IAdvancedNativeFocusOwner to provide custom API for setting focus.
* KeyToSelect: new utility class that allows selection with keyboard, similar to TapToSelect.
* KeyToTrigger: new utility class that allows trigger event with keyboard, similar to TapToTrigger.
* Label: added customTextRendererStyleName property.
* LayoutGroup: if component is root when initialized, defaults to AutoSizeMode.STAGE.
* List: added itemToItemRenderer() function, to get an item renderer for a specific item (if one is available).
* List: fixed issue where a runtime error could be thrown when the dataProvider property is null.
* NumericStepper: fixed issue where pressing increment or decrement button after editing TextInput would result in wrong value.
* OldFadeNewSlideTransitionManager: removed class. Use StackScreenNavigator with push and pop transitions instead, or find this class in feathers-compat.
* PickerList: itemToLabel() now strictly checks for null instead of a "truthy" value, and an empty string will have different behavior.
* PickerList: fixed issue where button label would not be updated when calling updateItemAt() on data provider with selected index.
* Scale3Image: removed class. Use starling.display.Image with scale9Grid.
* Scale3Textures: removed class. Use starling.display.Image with scale9Grid, or find this class in feathers-compat library.
* Scale9Image: removed class. Use starling.display.Image with scale9Grid.
* Scale9Textures: removed class. Use starling.display.Image with scale9Grid, or find this class in feathers-compat library.
* ScreenDensityScaleFactorManager: on desktop, screen density isn't used because native stage contentsScaleFactor has the proper behavior. However, it will DeviceCapabilities.dpi on desktop if the value has been customized.
* ScreenFadeTransitionManager: removed class. Use StackScreenNavigator with push and pop transitions instead, or find this class in feathers-compat.
* ScreenNavigator: fixed issue where an event with the same name as a member of the screen could result in a runtime error if as3-signals weren't available.
* ScreenSlidingStackTransitionManager: removed class. Use StackScreenNavigator with push and pop transitions instead, or find this class in feathers-compat.
* ScrollContainer: if component is root when initialized, defaults to AutoSizeMode.STAGE.
* ScrollContainer: fixed issue where includeInLayout could be ignored when not using a layout.
* Scroller: fixed issue where scrolling would still be active after removing from stage and adding again.
* Scroller: fixed issue where the page index calculation would fail if the width or height of the component were not an integer.
* Scroller: snapScrollPositionToPixels now accounts for contentScaleFactor so that pixel snapping is to view port dimensions instead of stage dimensions to make scrolling smoother.
* ScrollText: switched back default value for cacheAsBitmap to false because it seems to have started hurting performance again.
* Slider: TrackInteractionMode.TO_VALUE now allows dragging during TouchPhase.MOVED.
* SpinnerList: fixed issue where the selectionOverlaySkin could be resized incorrectly if the page size is larger than the list's dimensions.
* SpinnerList: can no longer be completely deselected if data provider is not empty.
* StackScreenNavigator: fixed issue where an event with the same name as a member of the screen could result in a runtime error if as3-signals weren't available.
* StackScreenNavigator: fixed runtime error in popAll() when root screen is visible.
* StackScreenNavigator: fixed issue where a new screen with the same ID as the active screen could not be shown.
* StackScreenNavigator: fixed issue where a new screen that has the same display object instance as the active screen would break navigation. The transition is now skipped.
* StageTextTextEditor: better measurement on desktop and when testing a mobile app in ADL to account for the internal TextField gutter. More consistent across all platforms.
* StageTextTextEditor: simplified font size calculation.
* StandardIcons: removed class that was deprecated. Use DefaultListItemRenderer.ALTERNATE_STYLE_NAME_DRILL_DOWN to display a drill down accessory in an item renderer.
* StateValueSelector: removed class. Use ImageSkin, or find this class in feathers-compat library.
* StateToggleValueSelector: removed class. Use ImageSkin, or find this class in feathers-compat library.
* StyleProviderRegistry: added hasStyleProvider() and getRegistredClasses().
* TabBar: fixed issue where changing isEnabled in data provider to false and then true would not re-enable a tab.
* TabBar: added tabReleaser property that works similarly to tabInitializer, but for cleaning up a tab.
* TapToSelect: fixed issue where runtime error could be thrown if removed from stage between TouchPhase.BEGAN and TouchPhase.ENDED.
* TapToTrigger: fixed issue where runtime error could be thrown if removed from stage between TouchPhase.BEGAN and TouchPhase.ENDED.
* TextArea: added errorString property to display an error in a TextCallout when the component is focused.
* TextArea: added TextInputState.ERROR to allow skins to change appearance when the errorString is set.
* TextArea: states are defined in feathers.controls.TextInputState.
* TextArea: fixed issue where set focus on touch did not account for vertical scroll position.
* TextBlockTextRenderer: better calculation of ascent and descent to avoid the issue where accents and other diacritical marks were being cut off at the top. Also, results in better vertical centering of the text.
* TextBlockTextRenderer: optimized measurement of width by skipping calculations if maximum is larger than last width.
* TextBlockTextRenderer: added support for input method editors (IMEs) to improve compatibility with more languages.
* TextBlockTextRenderer: replaced snapToPixels property with pixelSnapping property to match Starling 2.0 naming convention.
* TextBlockTextRenderer: fixed issue where runtime error could be thrown when attempting to create BitmapData with negative dimensions.
* TextBlockTextRenderer: optimized performance of measurement calculation by avoiding unecessary alignment.
* TextCallout: new component that conveniently displays a message in a callout.
* TextFieldTextRenderer: replaced snapToPixels property with pixelSnapping property to match Starling 2.0 naming convention.
* TextFieldTextRenderer: fixed issue where last line could sometimes be cut off due to floating point rounding errors.
* TextInput: fixed issue where the position of the text editor when using VerticalAlign.MIDDLE was not rounded to the nearest pixel.
* TextInput: added errorString property to display an error in a TextCallout when the component is focused.
* TextInput: added TextInputState.ERROR to allow skins to change appearance when the errorString is set.
* TextInput: states are defined in feathers.controls.TextInputState.
* TextInput: fixed issue where some icons or skins would not be disposed when input is disposed.
* TextInput: fixed issue where focus in and out events sometimes weren't dispatched.
* TextInput: fixed issue where IBEAM mouse cursor would not always be cleared.
* TextInput: will show focused state when focused, but text editor cannot have focus.
* TiledImage: removed class. Use starling.display.Image with tileGrid.
* TimeLabel: fixed issue where displayed text was incorrectly when time is greater than one hour.
* ToggleButton: deprecated defaultSelectedLabelProperties, selectedUpLabelProperties, selectedHoverLabelProperties, selectedDownLabelProperties, selectedDisabledLabelProperties. Replaced by setting font styles on text renderer in labelFactory. Text renderers now support multiple font styles for different states.
* ToggleSwitch: labelAlign is deprecated and behaves as LABEL_ALIGN_MIDDLE now that baseline issue in TextBlockTextRenderer is fixed.
* TokenList: optimized value getter to avoid repeated calls to Vector join().
* ToolTipManager: added support for displaying tool tips on mouse hover. Must use desktop theme or opt-in using setEnabledForStage().
* ValidationQueue: optimized to avoid sorting queue of length is 1 because sorting allocates and object and will result in more frequent garbage collection.
* VerticalCenteredPopUpContentManager: added overlayFactory property to customize the modal overlay.
* VerticalLayout: fixed issue where percentWidth/percentHeight values greater than 100 were not clamped.
* VerticalSpinnerLayout: added repeatItems property that may be set to false to disable repeating items with infinite scrolling.
* VerticalSpinnerLayout: fixed issue where items could disappear when using gap property.
* VideoPlayer: fixed issue where runtime error was thrown when setting netConnectionFactory.
* VideoPlayer: improved support for streaming video from server.
* VideoPlayer: dispatches FeathersEventType.ERROR when NetStream.Play.NoSupportedTrackFound is dispatched by NetStream.

### 3.0.0 API Changes

Please see the [Feathers 3.0 Migration Guide](http://feathersui.com/help/migration-guide-3.0.html) for details about what has been deprecated or removed in Feathers 3.0.

## 2.3.0 - December 2015

* New Component: DateTimeSpinner combines a set of SpinnerList components to select the date, the time, or both.
* New Theme: TopcoatLightMobileTheme. Thank you to Marcel Piestansky for your contributions.
* List, GroupedList: added support for displaying more than one type of item renderer (plus multiple header and footer renderers on GroupedList).
* TapToTrigger, TapToSelect, and LongPress: new utility classes that make it easy to implement Event.TRIGGERED, Event.CHANGE, and FeathersEventType.LONG_PRESS on custom item renderers.
* TextureCache: utility class used to store textures loaded from URL by ImageLoader for quick reloading from memory instead of requesting URL again.
* Text: Support changing between multiple font styles when parent component changes state. Makes it easier to set font styles for button and item renderer states with strict compile-time type checking (instead of using downLabelProperties, hoverLabelProperties, etc).
* Alert: fixed issue where icon would not be positioned correctly when message needed to scroll.
* Alert: fixed issue where layout would not be updated after icon resized.
* BitmapFontTextRenderer: fixed issue where a line break could happen too early due to floating point inaccuracy.
* BitmapFontTextRenderer: added support for leading property on BitmapFontTextFormat to add extra space between lines. Thanks, matyasatfp!
* BottomDrawerPopUpContentManager: New IPopUpContentManager for PickerList that opens a drawer at the bottom of the stage.
* Button: added setSkinForState() and setIconForState() methods. Recommended instead of separate properties like downSkin and hoverSkin.
* Button: fixed issue where skin was positioned incorrectly when using scaleWhenDown. Thanks, zongjingyao!
* Button: added customLabelStyleName property.
* ToggleButton: fixed issue where the button could get stuck in a disabled state if selected and re-enabled.
* Button, ToggleButton, LayoutGroup, Scroller, TextInput, TextArea: ensures that all skins are disposed when disposing the parent component (some may not be on the display list at the time, so they need to be disposed manually).
* Button, Item Renderers: when skin, icon, or accessory is IStateObserver, sets the stateContext property.
* ButtonGroup: when distributeButtonSizes is false, and the direction is horizontal, will display buttons in multiple rows if they will not fit into one row.
* ButtonGroup: added support for passing the item from the data provider as an optional third parameter to event listeners added in the data provider.
* ButtonGroup: added support for listening to FeathersEventType.LONG_PRESS on buttons.
* ButtonGroup: added support for calling updateItemAt() and updateAll() on data provider.
* Callout: adjusts minimum and maximum dimensions of content instead of setting width and height directly, if possible, to allow resizing.
* DefaultFocusManager: fixed issue where focus could be restored to an object that was no longer on stage, causing a runtime error.
* DefaultFocusManager: fixed issue where a component added under a modal pop-up doesn't have a focus manager.
* DefaultListItemRenderer, DefaultGroupedListItemRenderer: added defaultAccessory property and setAccessoryForState() method. As long as itemHasAccessory property is false, accessory does not need to be set with data provider.
* DefaultGroupedListHeaderOrFooterRenderer: added customContentLabelStyleName.
* Drawers: added openMode property to control whether drawers are opened above or below the content. For backwards compatibility, defaults to below.
* Drawers: fixed issue where setting drawer to null while open would leave overlay skin visible, making it impossible to interact with the content.
* Drawers: fixed issue where opening or closing a drawer without animation wouldn't always work.
* Drawers: added support for dividers between docked drawers and content.
* FlowLayout: added firstHorizontalGap and lastHorizontalGap properties to allow a different gap after the first item and before the last item.
* FlowLayout: fixed contentWidth result from layout() when content is larger than view port.
* FlowLayout: fixed result from measureViewPort() when using multiple rows.
* FlowLayout, TiledRowsLayout, TiledColumnsLayout: fixed issue where the calculated view port dimensions were too large when using maxWidth/maxHeight and the rows or columns were smaller than the maximum dimensions.
* GroupedList, List: dispatches FeathersEventType.RENDERER_REMOVE for all item renderers on dispose.
* GroupedList: default layout now uses stickyHeader property of VerticalLayout.
* Header: extra padding for iOS status bar now supports 3x devices.
* Header: added customTitleStyleName property.
* HierarchicalCollection, ListCollection: added updateAll() method, similar to updateItemItem(), that tells the List that all items have been updated.
* HorizontalLayout, VerticalLayout: fixed issue where percentWidth and percentHeight values were ignored when measuring the typical item in a virtual layout.
* HorizontalSpinnerLayout, VerticalSpinnerLayout: fixed issue where a "renderer map contains bad data" runtime error could be thrown after duplicate indices were requested by getVisibleIndicesAtScrollPosition().
* IAsyncTheme: new interface available to themes that need to load assets asynchronously. Used by Feathers SDK to delay app initialization until the theme is ready.
* IGroupedLayout: new interface for layouts that support special modifiers for GroupedList, like headers that stick to the top.
* IGroupedListHeaderOrFooterRenderer: interface is deprecated, and it replaced by two separate interfaces, IGroupedListHeaderRenderer and IGroupedListFooterRenderer.
* IListItemRenderer, IGroupedListItemRenderer: added factoryID property that allows List to determine which item renderer factory was used to create the renderer.
* IStateContext, IStateObserver: new relationship between components that have state and sub-components that want to know their parent's state.
* ImageLoader: immediately stops loading when changing source property, instead of waiting for validation.
* Layouts: fixed issue where the wrong dimensions would be calculated when the layout contained zero items.
* LayoutGroup: fixed issue where background skin dimensions did not affect min dimensions of layout.
* LayoutGroup: fixed issue where removing a child in an Event.REMOVED_FROM_STAGE listener could cause the internal state to get out of sync with the display list.
* List: fixed issue where FeathersEventType.RENDERER_REMOVE would be dispatched for item renderers that were kept in memory to improve performance, but they didn't have an item, so the event would make no sense.
* PickerList: defaults to using BottomDrawerPopUpContentManager and SpinnerList on devices detected as phones.
* PickerList: defaults to DropDownPopUpContentManager on devices detected as desktop computers.
* PickerList: fixed issue where pop-up List may incorrectly create an item renderer for every item in the data provider before the list is opened.
* Scale3Image: removed duplicate code that had no effect.
* SeekSlider: added progressSkin property to display loading progress from media player.
* SoundPlayer: fixed issue where passing Sound instance to soundSource property would not update totalTime property and the sound would not play.
* SoundPlayer: added MediaPlayerEventType.METADATA_RECEIVED event for Sound Event.ID3.
* SoundPlayer, VideoPlayer: implement new IProgressiveMediaPlayer interface with bytesLoaded and bytesTotal properties.
* SoundPlayer: fixed issue where sound might not stop playing or might not be cleaned up properly on dispose.
* SpinnerList: fixed issue where setting data provider to same object would reset selection.
* SpinnerList: default layouts requested four rows instead of five because it will be more visually obvious that it can scroll because some items will be only partially visible
* StandardIcons: this class is considered deprecated because List now supports multiple item renderer factories. Drill down icon should be passed to item renderer during skinning.
* StackScreenNavigator: added stackCount property.
* StackScreenNavigator: added replaceScreen(), popAll(), and popToRootAndReplace() functions.
* StackScreenNavigatorItem: added setScreenIDForReplaceEvent() and clearReplaceEvent() methods and replaceEvents property.
* StackScreenNavigator, ScreenNavigator: fixed issue where loading new screen in a FeathersEventType.TRANSITION_COMPLETE listener could cause old screen to remain on display list.
* StageTextTextEditor: added support for FocusManager.
* TabBar: implements IFocusDisplayObject, and the selected tab may be changed with keyboard.
* TextArea: added customTextEditorStyleName property.
* Text Editors: added global style providers.
* Text Editors: fixed issue where calling clearFocus() on Android would remove focus, but keep the soft keyboard open.
* TextBlockTextEditor: fixed issue where selection skin could incorrectly appear outside bounds of TextInput.
* Text Renderers: added text styles for selected state.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where textures were uploaded too frequently with certain Starling scale factors.
* TextFieldTextRenderer: fixed issue where snapshot was not updated when Starling scale factor changes at runtime.
* TextInput: added isSelectable property, to go with isEditable property, to allow selection and editing to be controlled separately.
* TextInput: added customTextEditorStyleName and customPromptStyleName properties.
* TiledRowsLayout, TiledColumnsLayout: fixed issue where wrong number of rows or columns were calculated when using maxWidth or maxHeight.
* TiledRowsLayout, TiledColumnsLayout: fixed issues with measurement and item positioning when using requested row or column counts.
* ToggleButton: added toggleGroup property, similar to Radio, and implemented IGroupedToggle interface.
* ToggleButton: added some missing constants inherited from Button.
* ToggleSwitch: added customOnLabelStyleName and customOffLabelStyleName.
* Todos: Example updated with modernized coding practices and changed design a bit.
* ValidationQueue: uses Vector insertAt() when available in runtime to improve performance by avoiding extra garbage collection.
* VideoPlayer: added netConnectionFactory to allow creation of NetConnection and the call to connect() to be customized.
* VideoPlayer: added MediaPlayerEventType.METADATA_RECEIVED event for NetStream onMetaData callback.
* VideoPlayer: fixed issue where Event.COMPLETE was not dispatched on iOS because NetStream.Play.Complete event was not dispatched on this platform only.
* VideoPlayer: fixed issue where restoring context would cause video to start playing if paused before context was lost.
* VideoPlayer: fixed issue where only audio would play on iOS if played a second time.
* VideoPlayer: fixed issue where video might not stop playing or might not be cleaned up properly on dispose.
* VideoPlayer: dispatches FeathersEventType.CLEAR when texture is disposed, similar to Event.READY when texture is ready to be rendered. ImageLoader should clear its source when this is dispatched.
* More than doubled the number of unit tests!

### 2.3.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `StandardIcons` class is deprecated. It was used to provide a drill-down icon for item renderers, but since lists now support multiple item renderer types, it is no longer needed. Additionally, the `StandardIcons` didn't work properly with multiple Starling instances, so it was ultimately a poor design choice.

The `IGroupedListHeaderOrFooterRenderer` interface is deprecated. The `GroupedList` component used this interface, but it now supports separate `IGroupedListHeaderRenderer` and `IGroupedListFooterRenderer` interfaces.

The `FeathersEventType.ERROR` constant was originally deprecated in Feathers 2.2.0 and remains deprecated in Feathers 2.3. The `ImageLoader` component used this constant, and it now dispatches separate `Event.IO_ERROR` and `Event.SECURITY_ERROR` events.

All properties and constants where "name" was replaced by "style name" were originally deprecated in Feathers 2.1.0, and they have now been removed. 

* `custom*Name` => `custom*StyleName`
* `DEFAULT_CHILD_NAME_*` => `DEFAULT_CHILD_STYLE_NAME_*`
* `ALTERNATE_NAME_*` => `ALTERNATE_STYLE_NAME_*`
* `itemRendererName` => `customItemRendererStyleName`
* `firstItemRendererName` => `customFirstItemRendererStyleName`
* `lastItemRendererName` => `customFirstItemRendererStyleName`
* `singleItemRendererName` => `customSingleItemRendererStyleName`
* `headerRendererName` => `customHeaderRendererStyleName`
* `footerRendererName` => `customFooterRendererStyleName`

## 2.2.0 - August 2015

* New Component: SoundPlayer. Plays audio using a Sound object.
* New Component: VideoPlayer. Plays video using a NetStream object.
* New Layout: Flow. Displays items of differing dimensions in multiple rows.
* New Layout: WaterfallLayout. Displays items optimally in columns of equal width.
* New Layout: HorizontalSpinnerLayout. Similar to VerticalSpinnerLayout, but displays items in a horizontal row.
* New Transition: Iris. Scales a circular mask to animate between two screens.
* New Transition: Wipe. Resizes a clipRect to animate between two screens.
* New Example: Video. A desktop AIR app that can play videos from the file system.
* AddOnFunctionStyleProvider: added callBeforeOriginalStyleProvider property to allow the add-on function to be called first.
* Alert: added customMessageStyleName property.
* BitmapFontTextEditor, TextBlockTextEditor: fixed an issue where they didn't accept non-Latin characters and ignored characters when Alt key was pressed.
* BitmapFontTextEditor, TextBlockTextEditor: uses needsSoftKeyboard and requestSoftKeyboard() to show soft keyboard on Android. Vote on [Adobe Bug #3962712](https://bugbase.adobe.com/index.cfm?event=bug&id=3962712) to add iOS support.
* BitmapFontTextEditor, TextBlockTextEditor: fixed issue where the selection anchor index wasn't properly updated, making the keyboard selection change on the wrong side.
* BitmapFontTextEditor, TextBlockTextEditor: fixed issue where setting TextInput's parent visible property to false wouldn't clear focus.
* BitmapFontTextEditor, TextBlockTextEditor: fixed an issue where pasting something other than text would cause a runtime error.
* BitmapFontTextEditor, TextBlockTextEditor: fixed an issue where changing the text property in an Event.CHANGE listener could cause the cursorSkin to be positioned incorrectly.
* Button: fixed issue where the label text renderer wasn't given an maxHeight that accounted for the button's height and padding.
* ColorFade: fixed name of createBlackFadeTransition().
* Default Item Renderers: fixed issue where children above or below label text renderer couldn't sometimes affect the label's width.
* DropDownPopUpContentManager: fixed issue where pop-up wasn't repositioned if the source moved to a new location.
* DropDownPopUpContentManager: added primaryDirection property to support trying to display the pop-up above the source first, instead of below.
* DropDownPopUpContentManager: added fitContentMinWidthToOrigin property to allow the content to be smaller than the origin.
* DropDownPopUpContentManager: fixed horizontal position of pop-up above origin.
* DropDownPopUpContentManager: fixed issues caused by multiple Starling instances.
* DropDownPopUpContentManager: added isModal and overlayFactory properties to affect how pop-up is displayed.
* FeathersControl: fixed issue where initialize() could be called during initialization.
* FocusManager: added support for new INativeFocusOwner interface, which allows components to be associated with a specific focusable native display object (like text editors!).
* GroupedList: the itemIndex parameter on scrollToDisplayIndex() is now optional so that you can scroll to a group header.
* Header: fixed issue where useExtraPaddingForOSStatusBar property didn't account for contentScaleFactor.
* HorizontalLayout, VerticalLayout: fixed issue where a scrollToDisplayIndex() on a List wouldn't work.
* HorizontalLayout, VerticalLayout: fixed issue where center/middle alignment wasn't properly ignored if total content size was larger than the container bounds (thanks kavolorn!)
* HorizontalLayout, VerticalLayout: fixed issue with alignment when scrolling is required in perpendicular direction.
* HorizontalLayout: fixed issue where items weren't measured correctly sometimes when using percentage dimensions.
* ImageLoader: now accounts for minimum and maximum dimensions when maintaining aspect ratio.
* ImageLoader: now dispatches separate Event.IO_ERROR and Event.SECURITY_ERROR constants instead of FeathersEventType.ERROR.
* ImageLoader: fixed issue where appending variable to ATF URL would break the check for the file extension.
* ImageLoader: added scaleContent, horizontalAlign, and verticalAlign properties.
* ImageLoader: added scaleMode property that uses values from starling.utils.ScaleMode.
* LayoutGroup: fixed issue where the background skin wasn't clipped by the clipRect.
* MultiStarlingStyleNameFunctionTheme: a variation of StyleNameFunctionTheme that supports multiple Starling instances.
* LayoutGroup, Scroller (and subclasses), ScreenNavigator, StackScreenNavigator: setting clipContent to false will clear the clipRect only once so that clipRect may be used externally.
* LayoutGroupListItemRenderer, LayoutGroupGroupedListItemRenderer: fixed issue where changing the data would hurt performance because the item renderer would need to validate more than once.
* List: sometimes keeps around an extra item renderer to avoid garbage collection and improve performance. When the typical item is from the data provider, the number of renderered items would fluctuate when scrolling.
* NumericStepper: fixed issue where selection might be changed in TextInput when using arrow keys to step.
* Panel: fixed issue where autoSizeMode property was ignored.
* PopUpManager: fixed issue where adding a pop-up that already had a parent would cause the Event.REMOVED_FROM_STAGE listener to be called early.
* ProgressBar, Slider: fixed issue where the layout would be broken if the minimum equals the maximum.
* RenderDelegate: a display object that passes rendering to another display object that has its own transformations. Useful for custom transitions.
* Scroller: fixed issue where scrollToPageIndex() would not accept negative page indicies.
* Scroller: fixed issue where the container didn't detect major changes to the maximum scroll position, causing it to scroll far beyond the end of the content.
* Scroller: added SCROLL_BAR_DISPLAY_MODE_FIXED_FLOAT to allow the scroll bar floats above the content, but it won't fade out.
* Scroller: fixed issue where INTERACTION_MODE_TOUCH_AND_SCROLL_BARS didn't work in nested scrollers because scroll bars could overlap and stop touches even when scrolling was not possible.
* Scroller: fixed issue where touching the scroll bar thumb wouldn't stop a throw.
* Scroller: fixed issue where a floating scroll bar would be hidden after hover out instead of waiting for the throw animation to finish.
* Scroller: fixed issue where clipping was no properly updated when using INTERACTION_MODE_MOUSE and the view port was resized small enough that scrolling was no longer needed.
* Scroller: fixed issue where Scroller couldn't properly calculate its dimensions when it has a background skin but no view port content, causing an infinite loop.
* Scroller: fixed issue where floating point errors sometimes caused it to snap to the wrong page.
* Scroller: fixed issue where maximum page indices might be one larger than they should be if a floating point error occurs.
* Scroller: snapScrollPositionToPixels now defaults to true.
* Scroller: switched to a different throwEase that is more natural.
* ScrollBar, SimpleScrollBar, Slider: on initialize, clamps value to minimum and maximum because value may not have been set, and it may be outside the range.
* ScrollContainer: fixed issue where getRawChildIndex() didn't reset the displayListBypassEnabled flag before returning the result.
* ScrollContainer: fixed issue where view port resizing wasn't ignored when using AUTO_SIZE_MODE_STAGE, potentially hurting performance.
* ScrollText: uses cacheAsBitmap to improve scrolling performance. A property has been exposed to disable this, if desired.
* ScreenDensityScaleFactorManager: manages the Starling view port and stage dimensions to automatically generate an appropriate contentScaleFactor value based on the screen DPI.
* ScrollContainer: fixed issue where addChild() stopped working with Starling 1.7.
* Slider: thumb position is now rounded to the nearest pixel.
* Slider: added thumbOffset property to allow the thumb to be repositioned in the direction perpendicular to the track.
* SpinnerList: by default, the scroll bar is hidden.
* StackScreenNavigator: fixed issue where setting rootScreenID before screens were added could throw a runtime error.
* StageTextTextEditor: fixed issue where text color wouldn't change when disabled while StageText didn't have focus.
* StageTextTextEditor: fixed an issue where where the text editor would try to change the font size property every frame, but it wasn't rounding to an integer, causing the check to fail.
* StageTextTextEditor, TextFieldTextEditor: improved positioning of StageText or TextField overlay when added to Sprite3D.
* StyleNameFunctionTheme: added a createRegistry() function that can be overridden in a subclass to customize the style provider registry.
* TabBar: now supports isEnabled in data provider, similar to ButtonGroup.
* TextArea, TextInput: fixed issue where the backgroundFocusedSkin wasn't displayed when the FocusManager was disabled (thanks tcfraser!)
* TextArea: fixed issue where setting the height of the TextArea larger than the text may result in the TextArea not receiving focus.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where the texture would sometimes restore with the wrong font size and clipping.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where snapshot dimensions were rounded down to the nearest pixel, which could cut off a small part of the text.
* TextBlockTextRenderer, TextFieldTextRenderer: uses Texture.empty() and uploads BitmapData manually instead of Texture.fromBitmapData() to avoid the creation of an onRestore function that will be immediately replaced.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where the texture snapshot could be blurry when scaled up from 0.
* Text Renderers: added updateSnapshotOnScaleChange property to allow the snapshot to always be crisp, even when scaled up or down. Use with caution as it needs to check the scale every frame.
* TextBlockTextRenderer: fixed issue where texture snapshot remained visible when the text renderer's width or height was supposed to be 0.
* TextBlockTextRenderer: fixed issue where the cursorSkin wasn't properly positioned and sized when calling setFocus() manually.
* TextBlockTextEditor: fixed an issue where scrolling wasn't working properly on HiDPI displays.
* TextFieldTextEditor: fixed issue where the font displayed at the wrong scale the first time that the text editor received focus on some mobile devices.
* TextFieldTextEditor: fixed issue where accessing the baseline property might throw a runtime error because textSnapshot was null.
* TextFieldTextEditor: exposed some more TextField property that control rendering.
* TextFieldTextRenderer: added useSnapshotDelayWorkaround property and disabled this workaround by default.
* Text Editors: detects changes in contentScaleFactor (such as when switching between HiDPI and normal screens) and recreates snapshots.
* TextInput: can now receive focus when isEditable is false.
* TiledRowsLayout, TiledColumnsCount: The requestedColumnCount property may now be used to calculate an ideal width for that number of columns, if the container doesn't have an explicitWidth. (TiledColumnsLayout uses the requestedRowCount property).
* ValidationQueue: skips components in queue that are no longer on the display list.
* ValidationQueue: will not proceed if Starling's context is invalid. This may happen if a TouchEvent.TOUCH listener causes a lost context.
* VerticalSpinnerLayout: fixed issue where item heights weren't forced to the same size, which could cause large gaps or overlapping items.
* WebView: added missing FeathersEventType.LOCATION_CHANGE constant for event.
* YouTubeFeeds: example updated to use newer YouTube API since the old one was shut down.
* Transitions: changed some to use RenderDelegate to avoid removing screens from display list.
* Examples: use Context3DProfile.BASELINE for mobile examples, since it is widely supported on mobile.
* Examples: enabled supportHighResolution flag for mobile apps so that they look better on HiDPI screens. This has no effect on a real mobile device. It just improves the development experience.
* Themes: when disposing, unregisters bitmap fonts, clears texture onRestore function, and clears StandardIcons class.
* Themes: desktop themes now use HiDPI textures.

### 2.2.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `FeathersEventType.ERROR` constant is deprecated. The `ImageLoader` component used this constant, and it now dispatches separate `Event.IO_ERROR` and `Event.SECURITY_ERROR` events. Error events should always be specific.

The `nameList` property on the `IFeathersControl` interface was originally deprecated in Feathers 2.0.0, and it has now been removed. It is replaced by the `styleNameList` property.

The `manageVisibility` property on layouts was originally deprecated in Feathers 2.0.0, and it has now been removed. This property no longer provided the performance improvements that it was originally intended for.

Properties such as `customThumbName` on the `Slider` component have have been renamed. In this case, `customThumbName` is deprecated and replaced by `customThumbStyleName`. Similarly, the static constant `Slider.DEFAULT_CHILD_NAME_THUMB` has been deprecated and renamed `Slider.DEFAULT_CHILD_STYLE_NAME_THUMB`. Similarly, the static constant `Button.ALTERNATE_NAME_BACK_BUTTON` has been deprecated and renamed `Button.ALTERNATE_STYLE_NAME_BACK_BUTTON`. On all components, APIs that refer to the *name* of sub-components have been deprecated and they have been replaced by a similar API that refers to the *style name* instead. For brevity, the list below shows the mapping between the old naming conventions and the new naming conventions instead of listing each renamed property individually.

* `custom*Name` => `custom*StyleName`
* `DEFAULT_CHILD_NAME_*` => `DEFAULT_CHILD_STYLE_NAME_*`
* `ALTERNATE_NAME_*` => `ALTERNATE_STYLE_NAME_*`

The `List` and `GroupedList` components had some properties that didn't follow the original `custom*Name` naming convention. In both classes, the `itemRendererName` property has been deprecated and replaced by `customItemRendererStyleName`. In `GroupedList`, `firstItemRendererName`, `lastItemRendererName` and `singleItemRendererName` have been deprecated and replaced by `customFirstItemRendererStyleName`, `customLastItemRendererStyleName`, and `customSingleItemRendererStyleName` respectively. Similarly, `headerRendererName` and `footerRendererName` have been deprecated and replaced by `customHeaderRendererStyleName` and `customFooterRendererStyleName` respectively. With this change, these properties no longer diverge from the naming convention used for similar properties on other components.

All of the above renamed APIs were deprecated in Feathers 2.1.0, and they remain deprecated in Feathers 2.2.0.

### 2.2.0 API Changes

The `scrollToPageIndex()` function in the `Scroller` class, and its subclasses, no longer accepts `-1` as a valid way of specifying that the horizontal or vertical page index should not change. You must pass in the current value of the `horizontalPageIndex` or `verticalPageIndex` property instead. With the ability to have negative page indices, `-1` must now be available as a valid page index.

In the following code, the vertical page index is not meant to be changed:

```
list.scrollToPageIndex( 2, -1 );
```

The code would need to be modified, like this:

```
list.scrollToPageIndex( 2, list.verticalPageIndex );
```

## 2.1.2 - July 2015

* ScrollContainer: overrides addChild() to fix "RangeError: Invalid child index" issue when using Starling 1.7.

## 2.1.1 - March 2015

* BitmapFontTextRenderer, ScrollContainer: added workarounds for compiler bugs in Adobe Flex SDK 4.6.
* ButtonGroup, TabBar: fixed issue where buttons or tabs would flicker and resize for a frame when the container resizes.
* HorizontalLayout, VerticalLayout: fixed an issue that resulted in no scrolling when the scrollToDisplayIndex() function is called on a List.
* ScrollContainer: fixed issue where setting autoSizeMode to AUTO_SIZE_MODE_STAGE resulted in being unable to scroll.
* SpinnerList: fixed issue where setting the selected index programmatically didn't always update the scroll position.
* TextBlockTextRenderer, TextFieldTextRenderer: fixed issue where text would appear blurry because snapToPixels incorrectly snapped on the y-axis.

## 2.1.0 - February 2015

* New Component: AutoComplete, a TextInput that provides a pop-up list of suggestions.
* New Component: SpinnerList, a list that changes selection when scrolling to an item.
* New Component: StackScreenNavigator, a variation of ScreenNavigator with a history stack that you can push and pop.
* New Component: WebView, displays a native web browser using StageWebView, but may be positioned in local coordinates. Available in AIR only.
* New Layout: VerticalSpinnerLayout, the default layout for the new SpinnerList component.
* New Transitions: ColorFade, Cover, Cube, Fade, Flip, Reveal, Slide.
* New Example: TransitionsExplorer demonstrates each transition.
* Unit tests: created unit tests for a number of Feathers components.
* Help: help files are now distributed with Feathers for offline use.
* AnchorLayout: fixed issue where items positioned relative to horizontalCenterAnchorDisplayObject or verticalCenterAnchorDisplayObject were not positioned correctly whent he anchor was at a higher depth.
* Button: added scaleWhenDown and scaleWhenHovering properties to scale the button in these states.
* BaseDefaultItemRenderer: fixed issue where data that is == null would be ignored in some cases by changing to stricter === null check.
* BitmapFontTextRenderer: fixed issue where a runtime error could be thrown if a character in the bitmap font had a width or height of 0.
* BitmapFontTextEditor, TextBlockTextEditor: fixed issue where clearing the text on focus would cause the selection range to be invalid.
* BitmapFontTextEditor, TextBlockTextEditor: listens for flash.events.Event.SELECT_ALL instead of Ctrl/Command+A with a keyboard event because it didn't work properly on Mac.
* BitmapFontTextRenderer: fixed issue where the last word of a line would sometimes appear on the next line.
* CalloutPopUpContentManager, DropDownPopUpContentManager, VerticalCenteredPopUpContentManager: detects if pop-up is removed from stage externally so that Event.CLOSE is properly dispatched.
* DropDownPopUpContentManager: fixed issue where the source would close the pop-up while validating, but the pop-up was being positioned, causing a runtime error, so now checks if open after source is validated.
* FeathersControl: added move() convenience function to set x and y properties, similar to how setSize() sets width and height.
* FeathersControl: the styleProvider property may be changed after initialization.
* FeathersControl: changes to styleNameList after initialization now causes the styleProvider to be re-applied.
* FeathersControl: may now flatten even when not initialized or on stage.
* FEATHERS_VERSION: new constant that can be used to see the version of Feathers being used.
* FocusManager: both containers and their children may receive focus separately (to allow the container to scroll with the keyboard), thanks to the new IFocusContainer interface.
* HierarchicalCollection: added removeAll() function, similar to ListCollection.
* HorizontalLayout, VerticalLayout: when alignment is justified, the size of the item renderer is reset so that an accurate measurement can be taken instead of using the old justified size.
* HorizontalLayout: added requestColumnCount property for more control over width auto-measurement.
* HorizontalLayout, VerticalLayout: fixed issue where the number of item renderers didn't remain constant when using hasVariableItemDimensions when all item renderers were the same size.
* ILayout: added getNearestScrollPositionForIndex() function to support scrolling when changing selected index in components like List.
* Label: added backgroundSkin, backgroundDisabledSkin, and padding properties.
* LayoutGroup: added LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR.
* LayoutGroup: added autoSizeMode property to specify that it should fill the stage.
* List, GroupedList: fixed issue where scrolling backwards would sometimes cause item renderers to jump around instead of scrolling smoothly with a virtual layout with variable item dimensions where an item resized. Layout may adjust scroll position, if needed.
* List, GroupedList: updates scroll position, if needed, when using arrow keys to change selection.
* List, GroupedList: dispatches Event.TRIGGERED when an item renderer is triggered. The event data is the item from the data provider.
* List, GroupedList: added stricter === null check when checking if a typicalItem has been set because values like 0 could match == null.
* List, GroupedList: fixed issue where layout didn't update after an item renderer resized while the list wasn't validating.
* List, GroupedList: fixed issue where the typical item renderer resized, but the layout wasn't updated.
* List, GroupedList: fixed issue where changing the index of a typical item chosen from the data provider would not update the index of its item renderer.
* ListCollection: setting data property to null keeps null instead of removing all items from existing data.
* NumericStepper: added valueFormatFunction and valueParseFunction properties to support custom formatting.
* Panel: added new title and headerTitleField properties to use instead of going through headerProperties.
* Panel: fixed issue where outerPaddingBottom was ignored if the panel didn't have a footer.
* PanelScreen: added missing DEFAULT_CHILD_STYLE_NAME_FOOTER constant for use in themes.
* PickerList: dispatches Event.OPEN and Event.CLOSE when the pop-up list opens and closes.
* PickerList, TabBar: fixes issue where Event.CHANGE was incorrectly dispatched on disposal because dataProvider was set to null.
* Scale3Textures, Scale9Textures: fixed validation of region sizes when using a scaled texture that doesn't match Starling.contentScaleFactor.
* ScreenNavigator: fixes issue where new screen wasn't resized properly by validating self if validation queue is currently busy.
* ScreenNavigator: adds a delay of two frames before starting a transition animation because it significantly improves the performance of the transition.
* ScreenNavigator: added isTransition active property to indicate if a transition is currently in progress.
* ScreenNavigator: fixed issue where clearing a screen didn't dispatch FeathersEventType.TRANSITION_START.
* ScreenNavigator: added support for transitions that may cancel themselves.
* ScreenNavigator: added optional transition function argument to showScreen() and clearScreen().
* ScreenNavigator: fixes issue where active screen wasn't properly cleared if removed with removeScreen() or removeAllScreens().
* ScreenNavigator: dispatches FeathersEventType.TRANSITION_IN_START, FeathersEventType.TRANSITION_IN_COMPLETE, FeathersEventType.TRANSITION_OUT_START, and FeathersEventType.TRANSITION_OUT_COMPLETE on screens (not on self). Screens may listen for these events instead of the events dispatched by ScreenNavigator.
* ScreenNavigatorItem: added setFunctionForEvent() and setScreenIDForEvent().
* ScreenNavigatorItem: The properties getter will always be a valid object. It won't return null.
* ScrollBar: hides thumb when ranging is infinite.
* ScrollBar: sets touchable to false on tracks when range is 0 or infinite.
* Scroller: performance improvements from less garbage collection.
* Scroller: added support for scrolling horizontally with vertical scroll wheel.
* Scroller: can receive focus to control scroll position with keyboard.
* Scroller: fixed issue where snapToPages was ignored when using mouse wheel or throwing.
* Scroller: fixed issue where animation for elastic snapping would restart on every touch when the distance was less than 1 pixel, causing it to appear that the item renderers could not be touched.
* ScrollContainer: added autoSizeMode property to specify that it should fill the stage.
* ScrollContainer: fixed issue where outer container didn't invalidate when adding or removing children, or when children are resized, causing validate() to have no effect.
* StageTextTextEditor, TextFieldTextEditor: fixes issue where focus remained when parent was set invisible.
* StyleNameFunctionTheme: the getStyleProviderForClass() function is now public.
* TabBar, ToggleGroup, List, GroupedList, PickerList: fixed issue where Event.CHANGE was not dispatched when removing an item and the selectedIndex remains the same, but the selectedItem is different.
* TabBar: default selectedIndex is -1 until the data provider is set.
* TabBar: Event.CHANGE is dispatched immediately when selectedIndex property changes instead of waiting for validation. Makes it more consistent with other components, like List.
* TextFieldTextEditor: fixed issue where HTML formatting is lost if edited when isHTML is true.
* TextFieldTextEditor: fixed issue where snapshot wasn't updated when size changed, but data or styles did not.
* TextFieldTextEditorViewPort: added padding properties.
* TextFieldTextEditorViewPort: fixed issue where the selection index was wrong from touch.
* TextFieldTextRenderer, TextBlockTextRenderer: fixed issue where native filters could cause the text renderer to create a texture that is larger than the maximum dimensions allowed.
* TextFieldTextRenderer, TextBlockTextRenderer: fixed issue where only the first texture (if multiple textures were required) was positioned properly when using native filters.
* TextFieldTextRenderer, TextBlockTextRenderer: fixed issue where texture snapshots could be clipped too small when using native filters.
* VerticalLayout: added requestRowCount property for more control over height auto-measurement.

### 2.1.0 Deprecated APIs

All deprecated APIs are subject to the [Feathers deprecation policy](http://wiki.starling-framework.org/feathers/deprecation-policy). Please migrate to the new APIs as soon as possible because the deprecated APIs **will** be removed in a future version of Feathers.

The `nameList` property on the `IFeathersControl` interface has been deprecated, and it is replaced by the `styleNameList` property. The `name` property is no longer connected to style names, and situations where it failed to work with `getChildByName()` have been resolved. The `styleName` property has been added to replace the former usage of the `name` property as a concatenated version of `nameList` (now, `styleNameList`). The `nameList` property was deprecated in Feathers 2.0.0, and it remains deprecated in Feathers 2.1.0.

The `manageVisibility` property on layouts has been deprecated. In previous versions, this property could be used to improve performance of non-virtual layouts by hiding items that were outside the view port. However, other performance improvements have made it so that setting `manageVisibility` can now sometimes hurt performance instead of improving it. The `manageVisibility` property was deprecated in Feathers 2.0.0, and it remains deprecated in Feathers 2.1.0.

Similar to how the `nameList` property was renamed `styleNameList` in Feathers 2.0.0, properties such as `customThumbName` on the `Slider` component have have been renamed too. In this case, `customThumbName` is deprecated and replaced by `customThumbStyleName`. Similarly, the static constant `Slider.DEFAULT_CHILD_NAME_THUMB` has been deprecated and renamed `Slider.DEFAULT_CHILD_STYLE_NAME_THUMB`. Similarly, the static constant `Button.ALTERNATE_NAME_BACK_BUTTON` has been deprecated and renamed `Button.ALTERNATE_STYLE_NAME_BACK_BUTTON`. On all components, APIs that refer to the *name* of sub-components have been deprecated and they have been replaced by a similar API that refers to the *style name* instead. For brevity, the list below shows the mapping between the old naming conventions and the new naming conventions instead of listing each renamed property individually.

* `custom*Name` => `custom*StyleName`
* `DEFAULT_CHILD_NAME_*` => `DEFAULT_CHILD_STYLE_NAME_*`
* `ALTERNATE_NAME_*` => `ALTERNATE_STYLE_NAME_*`

The `List` and `GroupedList` components had some properties that didn't follow the original `custom*Name` naming convention. In both classes, the `itemRendererName` property has been deprecated and replaced by `customItemRendererStyleName`. In `GroupedList`, `firstItemRendererName`, `lastItemRendererName` and `singleItemRendererName` have been deprecated and replaced by `customFirstItemRendererStyleName`, `customLastItemRendererStyleName`, and `customSingleItemRendererStyleName` respectively. Similarly, `headerRendererName` and `footerRendererName` have been deprecated and replaced by `customHeaderRendererStyleName` and `customFooterRendererStyleName` respectively. With this change, these properties no longer diverge from the naming convention used for similar properties on other components.

### 2.1.0 API Changes

#### ILayout

The `getNearestScrollPositionForIndex()` method has been added to the `ILayout` interface. Custom implementations of `ILayout` created before Feathers 2.1.0 will have compiler errors until the required changes are made.

This method is meant to calculate an updated scroll position for a specific index that requires the minimum amount of scrolling to fully display the specified index within the container's view port. It was added so that components like `List` could update the scroll position when changing the selected index with the keyboard when the component has focus.

To maintain the existing behavior (where the container doesn't scroll at all) to simply bypass the compiler error, the following implementation will return the existing scroll position:

	public function getNearestScrollPositionForIndex(index:int, scrollX:Number, scrollY:Number, items:Vector.<DisplayObject>, x:Number, y:Number, width:Number, height:Number, result:Point = null):Point
	{
		if(!result)
		{
			return new Point(scrollX, scrollY);
		}
		result.setTo(scrollX, scrollY);
		return result;
	}

#### Scroller now implements IFocusDisplayObject

With the addition of the new `IFocusContainer` interface, it is now possible for a container and its children to both appear in the tab focus chain when the `FocusManager` is enabled. Previously, subclasses of `Scroller`, like `List` or `ScrollContainer`, could not receive focus to allow the user to control the scroll position with the keyboard because the children wouldn't be able to receive focus too. Now, with the new interface and an updated focus manager, that restriction is lifted, and `Scroller` implements `IFocusDisplayObject` to support keyboard scrolling.

Subclasses of `Scroller` that need to support passing focus to children must now implement `IFocusContainer`. `List`, `ScrollContainer`, `GroupedList` have been updated, obviously, but custom subclasses of `Scroller` may need to be updated to support focus. `IFocusContainer` requires one property, `isChildFocusEnabled`. For convenience, you may copy following implementation of `isChildFocusEnabled` into a subclass of `Scroller`:

	protected var _isChildFocusEnabled:Boolean = true;

	public function get isChildFocusEnabled():Boolean
	{
		return this._isEnabled && this._isChildFocusEnabled;
	}

	public function set isChildFocusEnabled(value:Boolean):void
	{
		this._isChildFocusEnabled = value;
	}

## 2.0.1 - November 2014

* AddOnFunctionStyleProvider: fixed issue where function passed into constructor would be ignored.
* LayoutGroup: fixed issue where background skin would not validate after setting its dimensions.
* Scale3Image, Scale9Image, TiledImage: updated to listen for Event.FLATTEN to validate instead of overriding flatten() to remain compatible with the new flatten() function signature in Starling 1.6.
* StageTextTextEditor: fixed issue where StageText.stage was null, and calling drawViewPortToBitmapData() resulted in a runtime error.
* StageTextTextEditor: fixed issue where setFocus() didn't work if StageText.stage was null.
* TextInput: fixed issue where runtime error would be thrown after changing prompt from null to a valid string after input had validated.
* Themes: fixed issue in desktop themes where assets displayed at 4x instead of 2x on HiDPI Macs.
* Themes: fixed issue in desktop themes where PanelScreen and ScrollScreen would incorrectly use mobile scroll bars and behaviors.
* Themes: fixed issue where a subclass would add a style function for the ToggleSwitch class, and that would cause some ToggleSwitch instances to be missing skins.
* Themes: fixed issue where wrong arguments were passed to Texture.fromBitmap().
* Added workarounds for stack overflow runtime errors when compiling with legacy Flex 4.6 compiler.

## 2.0.0 - October 2014

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

## 1.3.1 - July 2014

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

## 1.3.0 - April 2014

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

## 1.2.0 - November 2013

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

## 1.1.1 - September 2013

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

## 1.1.0 - June 2013

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

## 1.0.1 - February 2013

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

## 1.0.0 - January 2013

No major API changes since 1.0.0 BETA. Mostly bug fixes and minor improvements.

* Fix for memory leaks in List, GroupedList, and ImageLoader
* PageIndicator properly handles ImageLoader or other IFeathersControl as symbol
* IGroupedListHeaderOrFooterRenderer extends IFeathersControl
* Header: fix for "middle" vertical alignment
* Updated for Starling Framework 1.3

## 1.0.0 BETA - December 2012

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
