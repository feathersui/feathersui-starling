/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.ToggleButton;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.core.PropertyProxy;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.media.SoundTransform;

	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Dispatched when the pop-up volume slider is opened.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.OPEN
	 */
	[Event(name="open",type="starling.events.Event")]

	/**
	 * Dispatched when the pop-up volume slider is closed.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.CLOSE
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * A specialized toggle button that controls whether a media player's volume
	 * is muted or not.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class MuteToggleButton extends ToggleButton implements IMediaPlayerControl
	{
		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY:String = "volumeSliderFactory";
		
		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * pop-up volume slider.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER:String = "feathers-volume-toggle-button-volume-slider";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>MuteToggleButton</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultVolumeSliderFactory():VolumeSlider
		{
			var slider:VolumeSlider = new VolumeSlider();
			slider.direction = VolumeSlider.DIRECTION_VERTICAL;
			return slider;
		}

		/**
		 * Constructor.
		 */
		public function MuteToggleButton()
		{
			super();
			this.addEventListener(Event.CHANGE, muteToggleButton_changeHandler);
			this.addEventListener(TouchEvent.TOUCH, muteToggleButton_touchHandler);
		}

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * pop-up volume slider. This variable is <code>protected</code> so that
		 * sub-classes can customize the list style name in their constructors
		 * instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER</code>.
		 *
		 * <p>To customize the pop-up list name without subclassing, see
		 * <code>customListStyleName</code>.</p>
		 *
		 * @see #customListStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var volumeSliderStyleName:String = DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER;

		/**
		 * @private
		 */
		protected var slider:VolumeSlider;

		/**
		 * @private
		 */
		protected var _oldVolume:Number;

		/**
		 * @private
		 */
		protected var _ignoreChanges:Boolean = false;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _popUpTouchPointID:int = -1;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return MuteToggleButton.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:IAudioPlayer;

		/**
		 * @inheritDoc
		 */
		public function get mediaPlayer():IMediaPlayer
		{
			return this._mediaPlayer;
		}

		/**
		 * @private
		 */
		public function set mediaPlayer(value:IMediaPlayer):void
		{
			if(this._mediaPlayer == value)
			{
				return;
			}
			this._mediaPlayer = value as IAudioPlayer;
			this.refreshVolumeFromMediaPlayer();
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE, mediaPlayer_soundTransformChangeHandler);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected var _popUpContentManager:IPopUpContentManager;

		/**
		 * A manager that handles the details of how to display the pop-up
		 * volume slider.
		 *
		 * <p>In the following example, a pop-up content manager is provided:</p>
		 *
		 * <listing version="3.0">
		 * button.popUpContentManager = new CalloutPopUpContentManager();</listing>
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
		protected var _showVolumeSliderOnHover:Boolean = false;

		/**
		 * Determines if a <code>VolumeSlider</code> component is displayed as a
		 * pop-up when hovering over the toggle button. This property is
		 * intended for use on desktop platforms only. On mobile platforms,
		 * Starling does not dispatch events for hover, so the volume slider
		 * will not be shown.
		 *
		 * <p>In the following example, showing the volume slider is enabled:</p>
		 *
		 * <listing version="3.0">
		 * button.showVolumeSliderOnHover = true;</listing>
		 *
		 * @default false
		 *
		 * @see feathers.media.VolumeSlider
		 */
		public function get showVolumeSliderOnHover():Boolean
		{
			return this._showVolumeSliderOnHover;
		}

		/**
		 * @private
		 */
		public function set showVolumeSliderOnHover(value:Boolean):void
		{
			if(this._showVolumeSliderOnHover == value)
			{
				return;
			}
			this._showVolumeSliderOnHover = value;
			this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _volumeSliderFactory:Function;

		/**
		 * A function used to generate the button's pop-up volume slider
		 * sub-component. The volume slider must be an instance of
		 * <code>VolumeSlider</code>. This factory can be used to change
		 * properties on the volume slider when it is first created. For
		 * instance, if you are skinning Feathers components without a theme,
		 * you might use this factory to set skins and other styles on the
		 * volume slider.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():VolumeSlider</pre>
		 *
		 * <p>In the following example, a custom volume slider factory is passed
		 * to the button:</p>
		 *
		 * <listing version="3.0">
		 * button.volumeSliderFactory = function():VolumeSlider
		 * {
		 *     var popUpSlider:VolumeSlider = new VolumeSlider();
		 *     popUpSlider.direction = VolumeSlider.DIRECTION_VERTICAL;
		 *     return popUpSlider;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.media.VolumeSlider
		 * @see #showVolumeSliderOnHover
		 * @see #volumeSliderProperties
		 */
		public function get volumeSliderFactory():Function
		{
			return this._volumeSliderFactory;
		}

		/**
		 * @private
		 */
		public function set volumeSliderFactory(value:Function):void
		{
			if(this._volumeSliderFactory == value)
			{
				return;
			}
			this._volumeSliderFactory = value;
			this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customVolumeSliderStyleName:String;

		/**
		 * A style name to add to the button's volume slider sub-component.
		 * Typically used by a theme to provide different styles to different
		 * buttons.
		 *
		 * <p>In the following example, a custom volume slider style name is
		 * passed to the button:</p>
		 *
		 * <listing version="3.0">
		 * button.customVolumeSliderStyleName = "my-custom-volume-slider";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to provide
		 * different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( VolumeSlider ).setFunctionForStyleName( "my-custom-volume-slider", setCustomVolumeSliderStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #showVolumeSliderOnHover
		 * @see #DEFAULT_CHILD_STYLE_NAME_VOLUME_SLIDER
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #volumeSliderFactory
		 * @see #volumeSliderProperties
		 */
		public function get customVolumeSliderStyleName():String
		{
			return this._customVolumeSliderStyleName;
		}

		/**
		 * @private
		 */
		public function set customVolumeSliderStyleName(value:String):void
		{
			if(this._customVolumeSliderStyleName == value)
			{
				return;
			}
			this._customVolumeSliderStyleName = value;
			this.invalidate(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _volumeSliderProperties:PropertyProxy;

		/**
		 * An object that stores properties for the button's pop-up volume
		 * slider sub-component, and the properties will be passed down to the
		 * volume slider when the button validates. For a list of available
		 * properties, refer to <a href="VolumeSlider.html"><code>feathers.media.VolumeSlider</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>volumeSliderFactory</code> function
		 * instead of using <code>volumeSliderProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the volume slider properties are passed
		 * to the button:</p>
		 *
		 * <listing version="3.0">
		 * button.volumeSliderProperties.direction = VolumeSlider.DIRECTION_VERTICAL;</listing>
		 *
		 * @default null
		 *
		 * @see #showVolumeSliderOnHover
		 * @see #volumeSliderFactory
		 * @see feathers.media.VolumeSlider
		 */
		public function get volumeSliderProperties():Object
		{
			if(!this._volumeSliderProperties)
			{
				this._volumeSliderProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._volumeSliderProperties;
		}

		/**
		 * @private
		 */
		public function set volumeSliderProperties(value:Object):void
		{
			if(this._volumeSliderProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				var newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._volumeSliderProperties)
			{
				this._volumeSliderProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._volumeSliderProperties = PropertyProxy(value);
			if(this._volumeSliderProperties)
			{
				this._volumeSliderProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isOpenPopUpPending:Boolean = false;

		/**
		 * @private
		 */
		protected var _isClosePopUpPending:Boolean = false;

		/**
		 * Opens the pop-up list, if it isn't already open.
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
			this._popUpContentManager.open(this.slider, this);
			this.slider.validate();
			this._popUpTouchPointID = -1;
			this.slider.addEventListener(TouchEvent.TOUCH, volumeSlider_touchHandler);
		}

		/**
		 * Closes the pop-up list, if it is open.
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
			this.slider.validate();
			//don't clean up anything from openList() in closeList(). The list
			//may be closed by removing it from the PopUpManager, which would
			//result in closeList() never being called.
			//instead, clean up in the Event.REMOVED_FROM_STAGE listener.
			this._popUpContentManager.close();
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(this.slider)
			{
				this.closePopUp();
				this.slider.mediaPlayer = null;
				this.slider.dispose();
				this.slider = null;
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
		override protected function initialize():void
		{
			if(!this._popUpContentManager)
			{
				var popUpContentManager:DropDownPopUpContentManager = new DropDownPopUpContentManager();
				popUpContentManager.fitContentMinWidthToOrigin = false;
				popUpContentManager.primaryDirection = DropDownPopUpContentManager.PRIMARY_DIRECTION_UP;
				this.popUpContentManager = popUpContentManager;
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var volumeSliderFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_VOLUME_SLIDER_FACTORY);
			
			if(volumeSliderFactoryInvalid)
			{
				this.createVolumeSlider();
			}

			if(this.slider && (volumeSliderFactoryInvalid || stylesInvalid))
			{
				this.refreshVolumeSliderProperties();
			}
			
			super.draw();
			
			this.handlePendingActions();
		}

		/**
		 * Creates and adds the <code>list</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #list
		 * @see #listFactory
		 * @see #customListStyleName
		 */
		protected function createVolumeSlider():void
		{
			if(this.slider)
			{
				this.slider.removeFromParent(false);
				//disposing separately because the slider may not have a parent
				this.slider.dispose();
				this.slider = null;
			}
			if(!this._showVolumeSliderOnHover)
			{
				return;
			}

			var factory:Function = this._volumeSliderFactory != null ? this._volumeSliderFactory : defaultVolumeSliderFactory;
			var volumeSliderStyleName:String = this._customVolumeSliderStyleName != null ? this._customVolumeSliderStyleName : this.volumeSliderStyleName;
			this.slider = VolumeSlider(factory());
			this.slider.focusOwner = this;
			this.slider.styleNameList.add(volumeSliderStyleName);
		}

		/**
		 * @private
		 */
		protected function refreshVolumeSliderProperties():void
		{
			for(var propertyName:String in this._volumeSliderProperties)
			{
				var propertyValue:Object = this._volumeSliderProperties[propertyName];
				this.slider[propertyName] = propertyValue;
			}
			this.slider.mediaPlayer = this._mediaPlayer;
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
		protected function refreshVolumeFromMediaPlayer():void
		{
			var oldIgnoreChanges:Boolean = this._ignoreChanges;
			this._ignoreChanges = true;
			if(this._mediaPlayer)
			{
				this.isSelected = this._mediaPlayer.soundTransform.volume == 0;
			}
			else
			{
				this.isSelected = false;
			}
			this._ignoreChanges = oldIgnoreChanges;
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_soundTransformChangeHandler(event:Event):void
		{
			this.refreshVolumeFromMediaPlayer();
		}

		/**
		 * @private
		 */
		protected function muteToggleButton_changeHandler(event:Event):void
		{
			if(this._ignoreChanges || !this._mediaPlayer)
			{
				return;
			}
			var soundTransform:SoundTransform = this._mediaPlayer.soundTransform;
			if(this._isSelected)
			{
				this._oldVolume = soundTransform.volume;
				if(this._oldVolume === 0)
				{
					this._oldVolume = 1;
				}
				soundTransform.volume = 0;
				this._mediaPlayer.soundTransform = soundTransform;
			}
			else
			{
				var newVolume:Number = this._oldVolume;
				if(newVolume !== newVolume) //isNaN
				{
					//volume was already zero, so we should fall back to some
					//default value
					newVolume = 1;
				}
				soundTransform.volume = newVolume;
				this._mediaPlayer.soundTransform = soundTransform;
			}
		}

		/**
		 * @private
		 */
		protected function muteToggleButton_touchHandler(event:TouchEvent):void
		{
			if(!this.slider)
			{
				this._touchPointID = -1;
				return;
			}
			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this._touchPointID);
				if(touch)
				{
					return;
				}
				this._touchPointID = -1;
				touch = event.getTouch(this.slider);
				if(this._popUpTouchPointID < 0 && !touch)
				{
					this.closePopUp();
				}
			}
			else
			{
				touch = event.getTouch(this, TouchPhase.HOVER);
				if(!touch)
				{
					return;
				}
				this._touchPointID = touch.id;
				this.openPopUp();
			}
		}

		/**
		 * @private
		 */
		protected function volumeSlider_touchHandler(event:TouchEvent):void
		{
			if(this._popUpTouchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.slider, null, this._popUpTouchPointID);
				if(touch)
				{
					return;
				}
				this._popUpTouchPointID = -1;
				touch = event.getTouch(this);
				if(this._touchPointID < 0 && !touch)
				{
					this.closePopUp();
				}
			}
			else
			{
				touch = event.getTouch(this.slider, TouchPhase.HOVER);
				if(!touch)
				{
					return;
				}
				this._popUpTouchPointID = touch.id;
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
			this.slider.removeEventListener(TouchEvent.TOUCH, volumeSlider_touchHandler);
			this.dispatchEventWith(Event.CLOSE);
		}
	}
}
