/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.color
{
	import feathers.controls.popups.BottomDrawerPopUpContentManager;
	import feathers.controls.popups.CalloutPopUpContentManager;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.IPersistentPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.ui.Keyboard;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.SystemUtil;

	/**
	 * A pop-up color picker.
	 */
	public class ColorPicker extends FeathersControl implements IColorControl, IFocusDisplayObject
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_SWATCH_FACTORY:String = "swatchFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_POP_UP_FACTORY:String = "popUpFactory";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * swatch button.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_SWATCH:String = "feathers-color-picker-swatch";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * color picker's pop-up.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_POP_UP:String = "feathers-color-picker-pop-up";

		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>ColorPicker</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultSwatchFactory():ColorSwatchButton
		{
			return new ColorSwatchButton();
		}

		/**
		 * @private
		 */
		protected static function defaultPopUpFactory():IColorControl
		{
			return new DefaultColorPopUp();
		}

		/**
		 * Constructor.
		 */
		public function ColorPicker()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ColorPicker.globalStyleProvider;
		}

		/**
		 * The value added to the <code>styleNameList</code> of the swatch
		 * button. This variable is <code>protected</code> so that sub-classes
		 * can customize the swatch button style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_SWATCH</code>.
		 *
		 * <p>To customize the swatch button style name without subclassing, see
		 * <code>customSwatchStyleName</code>.</p>
		 *
		 * @see #customSwatchStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var swatchStyleName:String = DEFAULT_CHILD_STYLE_NAME_SWATCH;

		/**
		 * The value added to the <code>styleNameList</code> of the color
		 * picker's pop-up. This variable is <code>protected</code> so that
		 * sub-classes can customize the pop-up style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_POP_UP</code>.
		 *
		 * <p>To customize the pop-up style name without subclassing, see
		 * <code>customPopUpStyleName</code>.</p>
		 *
		 * @see #customPopUpStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var popUpStyleName:String = DEFAULT_CHILD_STYLE_NAME_POP_UP;

		/**
		 * @private
		 */
		protected var popUp:IColorControl;

		/**
		 * @private
		 */
		protected var swatch:ColorSwatchButton;

		/**
		 * @private
		 */
		protected var swatchExplicitWidth:Number;

		/**
		 * @private
		 */
		protected var swatchExplicitHeight:Number;

		/**
		 * @private
		 */
		protected var swatchExplicitMinWidth:Number;

		/**
		 * @private
		 */
		protected var swatchExplicitMinHeight:Number;

		/**
		 * @private
		 */
		protected var _swatchHasFocus:Boolean = false;

		/**
		 * @private
		 */
		protected var _color:uint = 0x000000;

		/**
		 * The currently selected color value;
		 * 
		 * @default 0x000000
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color === value)
			{
				return;
			}
			this._color = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _swatchFactory:Function;

		/**
		 * A function used to generate the color picker's swatch button
		 * sub-component. The swatch button must be an instance of
		 * <code>ColorSwatchButton</code>. This factory can be used to change
		 * properties on the swatch button when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * swatch button.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():ColorSwatchButton</pre>
		 *
		 * <p>In the following example, a custom swatch button factory is passed
		 * to the picker:</p>
		 *
		 * <listing version="3.0">
		 * picker.swatchFactory = function():ColorSwatchButton
		 * {
		 *     var swatch:ColorSwatchButton = new ColorSwatchButton();
		 *     swatch.defaultSkin = new Image( texture );
		 *     return swatch;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.ColorSwatchButton
		 */
		public function get swatchFactory():Function
		{
			return this._swatchFactory;
		}

		/**
		 * @private
		 */
		public function set swatchFactory(value:Function):void
		{
			if(this._swatchFactory == value)
			{
				return;
			}
			this._swatchFactory = value;
			this.invalidate(INVALIDATION_FLAG_SWATCH_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customSwatchStyleName:String;

		/**
		 * A style name to add to the picker's swatch button sub-component.
		 * Typically used by a theme to provide different styles to different
		 * color pickers.
		 *
		 * <p>In the following example, a custom swatch button style name is passed
		 * to the picker:</p>
		 *
		 * <listing version="3.0">
		 * picker.customSwatchStyleName = "my-custom-swatch";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( ColorSwatchButton ).setFunctionForStyleName( "my-custom-swatch", setCustomSwatchStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_SWATCH
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #swatchFactory
		 */
		public function get customSwatchStyleName():String
		{
			return this._customSwatchStyleName;
		}

		/**
		 * @private
		 */
		public function set customSwatchStyleName(value:String):void
		{
			if(this._customSwatchStyleName == value)
			{
				return;
			}
			this._customSwatchStyleName = value;
			this.invalidate(INVALIDATION_FLAG_SWATCH_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _popUpFactory:Function;

		/**
		 * A function used to generate the color picker's pop-up sub-component.
		 * The pop-up must be an instance of the <code>IColorPicker</code>
		 * interface. This factory can be used to change properties on the
		 * pop-up when it is first created. For instance, if you are skinning
		 * Feathers components without a theme, you might use this factory to
		 * set skins and other styles on the pop-up.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():IColorPicker</pre>
		 *
		 * <p>In the following example, a custom pop-up factory is passed to the
		 * color picker:</p>
		 *
		 * <listing version="3.0">
		 * picker.popUpFactory = function():IColorPicker
		 * {
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.IColorPicker
		 */
		public function get popUpFactory():Function
		{
			return this._popUpFactory;
		}

		/**
		 * @private
		 */
		public function set popUpFactory(value:Function):void
		{
			if(this._popUpFactory === value)
			{
				return;
			}
			this._popUpFactory = value;
			this.invalidate(INVALIDATION_FLAG_POP_UP_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customPopUpStyleName:String;

		/**
		 * 
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_POP_UP
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #popUpFactory
		 */
		public function get customPopUpStyleName():String
		{
			return this._customPopUpStyleName;
		}

		/**
		 * @private
		 */
		public function set customPopUpStyleName(value:String):void
		{
			if(this._customPopUpStyleName === value)
			{
				return;
			}
			this._customPopUpStyleName = value;
			this.invalidate(INVALIDATION_FLAG_POP_UP_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _popUpContentManager:IPopUpContentManager;

		/**
		 * A manager that handles the details of how to display the pop-up list.
		 *
		 * <p>In the following example, a pop-up content manager is provided:</p>
		 *
		 * <listing version="3.0">
		 * list.popUpContentManager = new CalloutPopUpContentManager();</listing>
		 *
		 * @default null
		 */
		public function get popUpContentManager():IPopUpContentManager
		{
			return this._popUpContentManager;
		}

		/**
		 * @private
		 */
		public function set popUpContentManager(value:IPopUpContentManager):void
		{
			if(this._popUpContentManager == value)
			{
				return;
			}
			if(this._popUpContentManager is EventDispatcher)
			{
				var dispatcher:EventDispatcher = EventDispatcher(this._popUpContentManager);
				dispatcher.removeEventListener(Event.OPEN, popUpContentManager_openHandler);
				dispatcher.removeEventListener(Event.CLOSE, popUpContentManager_closeHandler);
			}
			this._popUpContentManager = value;
			if(this._popUpContentManager is EventDispatcher)
			{
				dispatcher = EventDispatcher(this._popUpContentManager);
				dispatcher.addEventListener(Event.OPEN, popUpContentManager_openHandler);
				dispatcher.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _triggered:Boolean = false;

		/**
		 * @private
		 */
		protected var _isOpenPopUpPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isClosePopUpPending:Boolean = false;

		/**
		 * Opens the pop-up, if it isn't already open.
		 */
		public function openPopUp():void
		{
			this._isClosePopUpPending = false;
			if(this._popUpContentManager.isOpen)
			{
				return;
			}
			if(!this._isValidating && this.isInvalid())
			{
				this._isOpenPopUpPending = true;
				return;
			}
			this._isOpenPopUpPending = false;
			this._popUpContentManager.open(DisplayObject(this.popUp), this);
			this.popUp.validate();
			if(this._focusManager !== null)
			{
				this._focusManager.focus = this.popUp;
				this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this.popUp.addEventListener(FeathersEventType.FOCUS_OUT, popUp_focusOutHandler);
			}
		}

		/**
		 * Closes the pop-up, if it is open.
		 */
		public function closePopUp():void
		{
			this._isOpenPopUpPending = false;
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			if(!this._isValidating && this.isInvalid())
			{
				this._isClosePopUpPending = true;
				return;
			}
			this._isClosePopUpPending = false;
			this.popUp.validate();
			//don't clean up anything from openPopUp() in closePopUp(). The list
			//may be closed by removing it from the PopUpManager, which would
			//result in closePopUp() never being called.
			//instead, clean up in the Event.REMOVED_FROM_STAGE listener.
			this._popUpContentManager.close();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(this.popUp)
			{
				this.closePopUp();
				this.popUp.dispose();
				this.popUp = null;
			}
			if(this._popUpContentManager)
			{
				this._popUpContentManager.dispose();
				this._popUpContentManager = null;
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function showFocus():void
		{
			if(!this.swatch)
			{
				return;
			}
			this.swatch.showFocus();
		}

		/**
		 * @private
		 */
		override public function hideFocus():void
		{
			if(!this.swatch)
			{
				return;
			}
			this.swatch.hideFocus();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this._popUpContentManager)
			{
				if(SystemUtil.isDesktop)
				{
					this.popUpContentManager = new DropDownPopUpContentManager();
				}
				else if(DeviceCapabilities.isTablet(Starling.current.nativeStage))
				{
					this.popUpContentManager = new CalloutPopUpContentManager();
				}
				else
				{
					this.popUpContentManager = new BottomDrawerPopUpContentManager();
				}
			}

		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var swatchFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SWATCH_FACTORY);
			var popUpFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_POP_UP_FACTORY);

			if(swatchFactoryInvalid)
			{
				this.createSwatch();
			}

			if(popUpFactoryInvalid)
			{
				this.createPopUp();
			}

			if(dataInvalid || swatchFactoryInvalid)
			{
				this.swatch.color = this._color;
				this.popUp.color = this._color;
			}

			if(stateInvalid || swatchFactoryInvalid)
			{
				this.refreshEnabled();
			}

			this.autoSizeIfNeeded();

			this.layoutContent();

			this.handlePendingActions();
		}

		/**
		 * If the component's dimensions have not been set explicitly, it will
		 * measure its content and determine an ideal size for itself. If the
		 * <code>explicitWidth</code> or <code>explicitHeight</code> member
		 * variables are set, those value will be used without additional
		 * measurement. If one is set, but not the other, the dimension with the
		 * explicit value will not be measured, but the other non-explicit
		 * dimension will still need measurement.
		 *
		 * <p>Calls <code>saveMeasurements()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			var needsMinWidth:Boolean = this._explicitMinWidth !== this._explicitMinWidth; //isNaN
			var needsMinHeight:Boolean = this._explicitMinHeight !== this._explicitMinHeight; //isNaN
			if(!needsWidth && !needsHeight && !needsMinWidth && !needsMinHeight)
			{
				return false;
			}

			var swatchWidth:Number = this._explicitWidth;
			if(swatchWidth !== swatchWidth)
			{
				//we save the swatch's explicitWidth (and other explicit
				//dimensions) after the swatchFactory() returns so that
				//measurement always accounts for it, even after the swatch's
				//width is set by the ColorPicker
				swatchWidth = this.swatchExplicitWidth;
			}
			var swatchHeight:Number = this._explicitHeight;
			if(swatchHeight !== swatchHeight)
			{
				swatchHeight = this.swatchExplicitHeight;
			}
			var swatchMinWidth:Number = this._explicitMinWidth;
			if(swatchMinWidth !== swatchMinWidth)
			{
				swatchMinWidth = this.swatchExplicitMinWidth;
			}
			var swatchMinHeight:Number = this._explicitMinHeight;
			if(swatchMinHeight !== swatchMinHeight)
			{
				swatchMinHeight = this.swatchExplicitMinHeight;
			}
			this.swatch.width = swatchWidth;
			this.swatch.height = swatchHeight;
			this.swatch.minWidth = swatchMinWidth;
			this.swatch.minHeight = swatchMinHeight;
			this.swatch.validate();

			var newWidth:Number = this._explicitWidth;
			var newHeight:Number = this._explicitHeight;
			var newMinWidth:Number = this._explicitMinWidth;
			var newMinHeight:Number = this._explicitMinHeight;

			if(needsWidth)
			{
				newWidth = this.swatch.width;
			}
			if(needsHeight)
			{
				newHeight = this.swatch.height;
			}
			if(needsMinWidth)
			{
				newMinWidth = this.swatch.minWidth;
			}
			if(needsMinHeight)
			{
				newMinHeight = this.swatch.minHeight;
			}

			return this.saveMeasurements(newWidth, newHeight, newMinWidth, newMinHeight);
		}

		/**
		 * @private
		 */
		protected function layoutContent():void
		{
			this.swatch.width = this.actualWidth;
			this.swatch.height = this.actualHeight;

			//final validation to avoid juggler next frame issues
			this.swatch.validate();
		}

		/**
		 * @private
		 */
		protected function handlePendingActions():void
		{
			if(this._isOpenPopUpPending)
			{
				this.openPopUp();
			}
			if(this._isClosePopUpPending)
			{
				this.closePopUp();
			}
		}

		/**
		 * @private
		 */
		protected function refreshEnabled():void
		{
			this.swatch.isEnabled = this._isEnabled;
			this.popUp.isEnabled = this._isEnabled;
		}

		/**
		 * Creates and adds the <code>swatch</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #swatch
		 * @see #swatchFactory
		 * @see #customSwatchStyleName
		 */
		protected function createSwatch():void
		{
			if(this.swatch !== null)
			{
				this.swatch.removeFromParent(true);
				this.swatch = null;
			}

			var factory:Function = this._swatchFactory != null ? this._swatchFactory : defaultSwatchFactory;
			var swatchStyleName:String = this._customSwatchStyleName !== null ? this._customSwatchStyleName : this.swatchStyleName;
			this.swatch = ColorSwatchButton(factory());
			this.swatch.styleNameList.add(swatchStyleName);
			this.swatch.addEventListener(Event.TRIGGERED, swatch_triggeredHandler);
			this.addChild(this.swatch);

			//we will use these values for measurement, if possible
			this.swatchExplicitWidth = this.swatch.explicitWidth;
			this.swatchExplicitHeight = this.swatch.explicitHeight;
			this.swatchExplicitMinWidth = this.swatch.explicitMinWidth;
			this.swatchExplicitMinHeight = this.swatch.explicitMinHeight;
		}

		/**
		 * Creates and adds the <code>popUp</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #popUp
		 * @see #popUpFactory
		 * @see #customPopUpStyleName
		 */
		protected function createPopUp():void
		{
			if(this.popUp)
			{
				this.popUp.removeFromParent(false);
				//disposing separately because the popUp may not have a parent
				this.popUp.dispose();
				this.popUp = null;
			}

			var factory:Function = this._popUpFactory != null ? this._popUpFactory : defaultPopUpFactory;
			var popUpStyleName:String = this._customPopUpStyleName != null ? this._customPopUpStyleName : this.popUpStyleName;
			this.popUp = IColorControl(factory());
			this.popUp.focusOwner = this;
			this.popUp.styleNameList.add(popUpStyleName);
			this.popUp.addEventListener(Event.CHANGE, popUp_changeHandler);
			this.popUp.addEventListener(Event.UPDATE, popUp_updateHandler);
			this.popUp.addEventListener(Event.TRIGGERED, popUp_triggeredHandler);
			this.popUp.addEventListener(TouchEvent.TOUCH, popUp_touchHandler);
			this.popUp.addEventListener(Event.REMOVED_FROM_STAGE, popUp_removedFromStageHandler);
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			this._swatchHasFocus = true;
			this.swatch.dispatchEventWith(FeathersEventType.FOCUS_IN);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			if(this._swatchHasFocus)
			{
				this.swatch.dispatchEventWith(FeathersEventType.FOCUS_OUT);
				this._swatchHasFocus = false;
			}
			super.focusOutHandler(event);
		}

		/**
		 * @private
		 */
		protected function swatch_triggeredHandler(event:Event):void
		{
			if(this._popUpContentManager.isOpen)
			{
				this.closePopUp();
				return;
			}
			this.openPopUp();
		}

		/**
		 * @private
		 */
		protected function popUp_updateHandler(event:Event, color:Object):void
		{
			if(color === null)
			{
				this.swatch.color = this.color;
			}
			else
			{
				this.swatch.color = color as uint;
			}
		}

		/**
		 * @private
		 */
		protected function popUp_changeHandler(event:Event):void
		{
			if(this._popUpContentManager is IPersistentPopUpContentManager)
			{
				return;
			}
			this.color = this.popUp.color;
		}

		/**
		 * @private
		 */
		protected function popUp_triggeredHandler(event:Event):void
		{
			if(!this._isEnabled ||
				this._popUpContentManager is IPersistentPopUpContentManager)
			{
				return;
			}
			this._triggered = true;
		}

		/**
		 * @private
		 */
		protected function popUp_touchHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(DisplayObject(this.popUp));
			if(touch === null)
			{
				return;
			}
			if(touch.phase === TouchPhase.BEGAN)
			{
				this._triggered = false;
			}
			if(touch.phase === TouchPhase.ENDED && this._triggered)
			{
				this.closePopUp();
			}
		}

		/**
		 * @private
		 */
		protected function popUp_removedFromStageHandler(event:Event):void
		{
			if(this._focusManager !== null)
			{
				this.popUp.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
				this.popUp.removeEventListener(FeathersEventType.FOCUS_OUT, popUp_focusOutHandler);
			}
		}

		/**
		 * @private
		 */
		protected function popUp_focusOutHandler(event:Event):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			this.closePopUp();
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(!this._popUpContentManager.isOpen)
			{
				return;
			}
			if(event.keyCode === Keyboard.ENTER)
			{
				this.closePopUp();
			}
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_openHandler(event:Event):void
		{
			this.dispatchEventWith(Event.OPEN);
		}

		/**
		 * @private
		 */
		protected function popUpContentManager_closeHandler(event:Event):void
		{
			if(this._popUpContentManager is IPersistentPopUpContentManager)
			{
				this.color = this.popUp.color;
			}
			this.dispatchEventWith(Event.CLOSE);
		}
	}
}
