/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.system.DeviceCapabilities;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * @inheritDoc
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Similar to a light switch with on and off states. Generally considered an
	 * alternative to a check box.
	 *
	 * @see http://wiki.starling-framework.org/feathers/toggle-switch
	 * @see Check
	 */
	public class ToggleSwitch extends FeathersControl implements IToggle
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

		/**
		 * @private
		 */
		private static const HELPER_TOUCHES_VECTOR:Vector.<Touch> = new <Touch>[];

		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on the full character height of the font.
		 */
		public static const LABEL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on only the baseline value of the font.
		 */
		public static const LABEL_ALIGN_BASELINE:String = "baseline";

		/**
		 * The toggle switch has only one track skin, stretching to fill the
		 * full length of switch. In this layout mode, the on track is
		 * displayed and fills the entire length of the slider. The off
		 * track will not exist.
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The toggle switch has two tracks, stretching to fill each side of the
		 * scroll bar with the thumb in the middle. The tracks will be resized
		 * as the thumb moves. This layout mode is designed for toggle switches
		 * where the two sides of the track may be colored differently to better
		 * differentiate between the on state and the off state.
		 *
		 * <p>Since the width and height of the tracks will change, consider
		 * sing a special display object such as a <code>Scale9Image</code>,
		 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
		 * designed to be resized dynamically.</p>
		 *
		 * @see feathers.display.Scale9Image
		 * @see feathers.display.Scale3Image
		 * @see feathers.display.TiledImage
		 */
		public static const TRACK_LAYOUT_MODE_ON_OFF:String = "onOff";

		/**
		 * The default value added to the <code>nameList</code> of the off label.
		 */
		public static const DEFAULT_CHILD_NAME_OFF_LABEL:String = "feathers-toggle-switch-off-label";

		/**
		 * The default value added to the <code>nameList</code> of the on label.
		 */
		public static const DEFAULT_CHILD_NAME_ON_LABEL:String = "feathers-toggle-switch-on-label";

		/**
		 * The default value added to the <code>nameList</code> of the off track.
		 */
		public static const DEFAULT_CHILD_NAME_OFF_TRACK:String = "feathers-toggle-switch-off-track";

		/**
		 * The default value added to the <code>nameList</code> of the on track.
		 */
		public static const DEFAULT_CHILD_NAME_ON_TRACK:String = "feathers-toggle-switch-on-track";

		/**
		 * The default value added to the <code>nameList</code> of the thumb.
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = "feathers-toggle-switch-thumb";

		/**
		 * Constructor.
		 */
		public function ToggleSwitch()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		/**
		 * The value added to the <code>nameList</code> of the off label.
		 */
		protected var onLabelName:String = DEFAULT_CHILD_NAME_ON_LABEL;

		/**
		 * The value added to the <code>nameList</code> of the on label.
		 */
		protected var offLabelName:String = DEFAULT_CHILD_NAME_OFF_LABEL;

		/**
		 * The value added to the <code>nameList</code> of the on track.
		 */
		protected var onTrackName:String = DEFAULT_CHILD_NAME_ON_TRACK;

		/**
		 * The value added to the <code>nameList</code> of the off track.
		 */
		protected var offTrackName:String = DEFAULT_CHILD_NAME_OFF_TRACK;

		/**
		 * The value added to the <code>nameList</code> of the thumb.
		 */
		protected var thumbName:String = DEFAULT_CHILD_NAME_THUMB;

		/**
		 * The thumb sub-component.
		 */
		protected var thumb:Button;

		/**
		 * The "on" text renderer sub-component.
		 */
		protected var onTextRenderer:ITextRenderer;

		/**
		 * The "off" text renderer sub-component.
		 */
		protected var offTextRenderer:ITextRenderer;

		/**
		 * The "on" track sub-component.
		 */
		protected var onTrack:Button;

		/**
		 * The "off" track sub-component.
		 */
		protected var offTrack:Button;

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the switch's right edge and the
		 * switch's content.
		 */
		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
			{
				return;
			}
			this._paddingRight = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _paddingLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the switch's left edge and the
		 * switch's content.
		 */
		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
			{
				return;
			}
			this._paddingLeft = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _showLabels:Boolean = true;

		/**
		 * Determines if the labels should be drawn. The onTrackSkin and
		 * offTrackSkin backgrounds may include the text instead.
		 */
		public function get showLabels():Boolean
		{
			return _showLabels;
		}

		/**
		 * @private
		 */
		public function set showLabels(value:Boolean):void
		{
			if(this._showLabels == value)
			{
				return;
			}
			this._showLabels = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _showThumb:Boolean = true;

		/**
		 * Determines if the thumb should be displayed. This stops interaction
		 * while still displaying the background.
		 */
		public function get showThumb():Boolean
		{
			return this._showThumb;
		}

		/**
		 * @private
		 */
		public function set showThumb(value:Boolean):void
		{
			if(this._showThumb == value)
			{
				return;
			}
			this._showThumb = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		[Inspectable(type="String",enumeration="single,onOff")]
		/**
		 * Determines how the on and off track skins are positioned and sized.
		 *
		 * @default TRACK_LAYOUT_MODE_SINGLE
		 * @see #TRACK_LAYOUT_MODE_SINGLE
		 * @see #TRACK_LAYOUT_MODE_ON_OFF
		 */
		public function get trackLayoutMode():String
		{
			return this._trackLayoutMode;
		}

		/**
		 * @private
		 */
		public function set trackLayoutMode(value:String):void
		{
			if(this._trackLayoutMode == value)
			{
				return;
			}
			this._trackLayoutMode = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _defaultLabelProperties:PropertyProxy;

		/**
		 * The key/value pairs to pass to the labels, if no higher priority
		 * format is available. For the ON label, <code>onLabelProperties</code>
		 * takes priority. For the OFF label, <code>offLabelProperties</code>
		 * takes priority.
		 *
		 * @see feathers.core.ITextRenderer
		 * @see #onLabelProperties
		 * @see #offLabelProperties
		 * @see #disabledLabelProperties
		 */
		public function get defaultLabelProperties():Object
		{
			if(!this._defaultLabelProperties)
			{
				this._defaultLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._defaultLabelProperties;
		}

		/**
		 * @private
		 */
		public function set defaultLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._defaultLabelProperties)
			{
				this._defaultLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._defaultLabelProperties = PropertyProxy(value);
			if(this._defaultLabelProperties)
			{
				this._defaultLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _disabledLabelProperties:PropertyProxy;

		/**
		 * The key/value pairs to pass to the labels, if the toggle switch is
		 * disabled.
		 *
		 * @see feathers.core.ITextRenderer
		 */
		public function get disabledLabelProperties():Object
		{
			if(!this._disabledLabelProperties)
			{
				this._disabledLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._disabledLabelProperties;
		}

		/**
		 * @private
		 */
		public function set disabledLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._disabledLabelProperties)
			{
				this._disabledLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._disabledLabelProperties = PropertyProxy(value);
			if(this._disabledLabelProperties)
			{
				this._disabledLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _onLabelProperties:PropertyProxy;

		/**
		 * The key/value pairs passed to the ON label. If <code>null</code>,
		 * then <code>defaultLabelProperties</code> will be used instead.
		 *
		 * @see feathers.core.ITextRenderer
		 */
		public function get onLabelProperties():Object
		{
			if(!this._onLabelProperties)
			{
				this._onLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._onLabelProperties;
		}

		/**
		 * @private
		 */
		public function set onLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._onLabelProperties)
			{
				this._onLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._onLabelProperties = PropertyProxy(value);
			if(this._onLabelProperties)
			{
				this._onLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _offLabelProperties:PropertyProxy;

		/**
		 * The key/value pairs passed to the OFF label. If <code>null</code>,
		 * then <code>defaultLabelProperties</code> will be used instead.
		 *
		 * @see feathers.core.ITextRenderer
		 */
		public function get offLabelProperties():Object
		{
			if(!this._offLabelProperties)
			{
				this._offLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._offLabelProperties;
		}

		/**
		 * @private
		 */
		public function set offLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._offLabelProperties)
			{
				this._offLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._offLabelProperties = PropertyProxy(value);
			if(this._offLabelProperties)
			{
				this._offLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _labelAlign:String = LABEL_ALIGN_BASELINE;

		[Inspectable(type="String",enumeration="baseline,middle")]
		/**
		 * The vertical alignment of the label.
		 */
		public function get labelAlign():String
		{
			return this._labelAlign;
		}

		/**
		 * @private
		 */
		public function set labelAlign(value:String):void
		{
			if(this._labelAlign == value)
			{
				return;
			}
			this._labelAlign = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _labelFactory:Function;

		/**
		 * A function used to instantiate the toggle switch's label subcomponents.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get labelFactory():Function
		{
			return this._labelFactory;
		}

		/**
		 * @private
		 */
		public function set labelFactory(value:Function):void
		{
			if(this._labelFactory == value)
			{
				return;
			}
			this._labelFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var onTrackSkinOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var onTrackSkinOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var offTrackSkinOriginalWidth:Number = NaN;

		/**
		 * @private
		 */
		protected var offTrackSkinOriginalHeight:Number = NaN;

		/**
		 * @private
		 */
		protected var _isSelected:Boolean = false;

		/**
		 * Indicates if the toggle switch is selected (ON) or not (OFF).
		 */
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}

		/**
		 * @private
		 */
		public function set isSelected(value:Boolean):void
		{
			//normally, we'd check to see if selected actually changed or not
			//but the animation is triggered by the draw cycle, so we always
			//need to invalidate. notice that the event isn't dispatched
			//unless the value changes.
			const oldSelected:Boolean = this._isSelected;
			this._isSelected = value;
			this._isSelectionChangedByUser = false;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			if(this._isSelected != oldSelected)
			{
				this.dispatchEventWith(Event.CHANGE);
			}
		}

		/**
		 * @private
		 */
		protected var _toggleDuration:Number = 0.15;

		/**
		 * The duration, in seconds, of the animation when the toggle switch
		 * is toggled and animates the position of the thumb.
		 */
		public function get toggleDuration():Number
		{
			return this._toggleDuration;
		}

		/**
		 * @private
		 */
		public function set toggleDuration(value:Number):void
		{
			this._toggleDuration = value;
		}

		/**
		 * @private
		 */
		protected var _toggleEase:Object = Transitions.EASE_OUT;

		/**
		 * The easing function used for toggle animations.
		 */
		public function get toggleEase():Object
		{
			return this._toggleEase;
		}

		/**
		 * @private
		 */
		public function set toggleEase(value:Object):void
		{
			this._toggleEase = value;
		}

		/**
		 * @private
		 */
		protected var _onText:String = "ON";

		/**
		 * The text to display in the ON label.
		 */
		public function get onText():String
		{
			return this._onText;
		}

		/**
		 * @private
		 */
		public function set onText(value:String):void
		{
			if(value === null)
			{
				value = "";
			}
			if(this._onText == value)
			{
				return;
			}
			this._onText = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _offText:String = "OFF";

		/**
		 * The text to display in the OFF label.
		 */
		public function get offText():String
		{
			return this._offText;
		}

		/**
		 * @private
		 */
		public function set offText(value:String):void
		{
			if(value === null)
			{
				value = "";
			}
			if(this._offText == value)
			{
				return;
			}
			this._offText = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _toggleTween:Tween;

		/**
		 * @private
		 */
		protected var _ignoreTapHandler:Boolean = false;

		/**
		 * @private
		 */
		protected var _touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _thumbStartX:Number;

		/**
		 * @private
		 */
		protected var _touchStartX:Number;

		/**
		 * @private
		 */
		protected var _isSelectionChangedByUser:Boolean = false;

		/**
		 * @private
		 */
		protected var _onTrackProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the toggle switch's on
		 * track sub-component. The on track is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get onTrackProperties():Object
		{
			if(!this._onTrackProperties)
			{
				this._onTrackProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._onTrackProperties;
		}

		/**
		 * @private
		 */
		public function set onTrackProperties(value:Object):void
		{
			if(this._onTrackProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._onTrackProperties)
			{
				this._onTrackProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._onTrackProperties = PropertyProxy(value);
			if(this._onTrackProperties)
			{
				this._onTrackProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _offTrackProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the toggle switch's off
		 * track sub-component. The off track is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get offTrackProperties():Object
		{
			if(!this._offTrackProperties)
			{
				this._offTrackProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._offTrackProperties;
		}

		/**
		 * @private
		 */
		public function set offTrackProperties(value:Object):void
		{
			if(this._offTrackProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._offTrackProperties)
			{
				this._offTrackProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._offTrackProperties = PropertyProxy(value);
			if(this._offTrackProperties)
			{
				this._offTrackProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _thumbProperties:PropertyProxy;

		/**
		 * A set of key/value pairs to be passed down to the toggle switch's
		 * thumb sub-component. The thumb is a
		 * <code>feathers.controls.Button</code> instance.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb of a <code>SimpleScrollBar</code>
		 * which is in a <code>Scroller</code> which is in a <code>List</code>,
		 * you can use the following syntax:</p>
		 * <pre>list.scrollerProperties.&#64;verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 * 
		 * @see feathers.controls.Button
		 */
		public function get thumbProperties():Object
		{
			if(!this._thumbProperties)
			{
				this._thumbProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._thumbProperties;
		}

		/**
		 * @private
		 */
		public function set thumbProperties(value:Object):void
		{
			if(this._thumbProperties == value)
			{
				return;
			}
			if(!value)
			{
				value = new PropertyProxy();
			}
			if(!(value is PropertyProxy))
			{
				const newValue:PropertyProxy = new PropertyProxy();
				for(var propertyName:String in value)
				{
					newValue[propertyName] = value[propertyName];
				}
				value = newValue;
			}
			if(this._thumbProperties)
			{
				this._thumbProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			if(!this.onTrack)
			{
				this.onTrack = new Button();
				this.onTrack.nameList.add(this.onTrackName);
				this.onTrack.label = "";
				this.onTrack.keepDownStateOnRollOut = true;
				this.addChild(this.onTrack);
			}

			if(!this.thumb)
			{
				this.thumb = new Button();
				this.thumb.nameList.add(this.thumbName);
				this.thumb.label = "";
				this.thumb.keepDownStateOnRollOut = true;
				this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
				this.addChild(this.thumb);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);

			if(textRendererInvalid)
			{
				this.createLabels();
			}

			this.createOrDestroyOffTrackIfNeeded();

			if(stylesInvalid)
			{
				this.refreshOnLabelStyles();
				this.refreshOffLabelStyles();
				this.refreshThumbStyles();
				this.refreshTrackStyles();
			}

			if(stateInvalid)
			{
				this.thumb.isEnabled = this.onTrack.isEnabled = this._isEnabled;
				if(this.offTrack)
				{
					this.offTrack.isEnabled = this._isEnabled;
				}
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(stylesInvalid || sizeInvalid || stateInvalid)
			{
				this.thumb.y = (this.actualHeight - this.thumb.height) / 2;
				this.drawLabels();
			}

			if(sizeInvalid || stylesInvalid || selectionInvalid)
			{
				this.updateSelection();
			}
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			if(isNaN(this.onTrackSkinOriginalWidth) || isNaN(this.onTrackSkinOriginalHeight))
			{
				this.onTrack.validate();
				this.onTrackSkinOriginalWidth = this.onTrack.width;
				this.onTrackSkinOriginalHeight = this.onTrack.height;
			}
			if(this.offTrack)
			{
				if(isNaN(this.offTrackSkinOriginalWidth) || isNaN(this.offTrackSkinOriginalHeight))
				{
					this.offTrack.validate();
					this.offTrackSkinOriginalWidth = this.offTrack.width;
					this.offTrackSkinOriginalHeight = this.offTrack.height;
				}
			}

			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			this.thumb.validate();
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = this.explicitHeight;
			if(needsWidth)
			{
				if(this.offTrack)
				{
					newWidth = Math.min(this.onTrackSkinOriginalWidth, this.offTrackSkinOriginalWidth) + this.thumb.width / 2;
				}
				else
				{
					newWidth = this.onTrackSkinOriginalWidth;
				}
			}
			if(needsHeight)
			{
				if(this.offTrack)
				{
					newHeight = Math.max(this.onTrackSkinOriginalHeight, this.offTrackSkinOriginalHeight);
				}
				else
				{
					newHeight = this.onTrackSkinOriginalHeight;
				}
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function createLabels():void
		{
			if(this.offTextRenderer)
			{
				this.removeChild(DisplayObject(this.offTextRenderer), true);
				this.offTextRenderer = null;
			}
			if(this.onTextRenderer)
			{
				this.removeChild(DisplayObject(this.onTextRenderer), true);
				this.onTextRenderer = null;
			}

			const index:int = this.getChildIndex(this.thumb);
			const factory:Function = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
			this.offTextRenderer = ITextRenderer(factory());
			this.offTextRenderer.nameList.add(this.offLabelName);
			if(this.offTextRenderer is FeathersControl)
			{
				FeathersControl(this.offTextRenderer).clipRect = new Rectangle();
			}
			this.addChildAt(DisplayObject(this.offTextRenderer), index);

			this.onTextRenderer = ITextRenderer(factory());
			this.onTextRenderer.nameList.add(this.onLabelName);
			if(this.onTextRenderer is FeathersControl)
			{
				FeathersControl(this.onTextRenderer).clipRect = new Rectangle();
			}
			this.addChildAt(DisplayObject(this.onTextRenderer), index);
		}

		/**
		 * @private
		 */
		protected function updateSelection():void
		{
			var xPosition:Number = this._paddingLeft;
			if(this._isSelected)
			{
				xPosition = this.actualWidth - this.thumb.width - this._paddingRight;
			}

			//stop the tween, no matter what
			if(this._toggleTween)
			{
				Starling.juggler.remove(this._toggleTween);
				this._toggleTween = null;
			}

			if(this._isSelectionChangedByUser)
			{
				this._toggleTween = new Tween(this.thumb, this._toggleDuration, this._toggleEase);
				this._toggleTween.animate("x", xPosition);
				this._toggleTween.onUpdate = selectionTween_onUpdate;
				this._toggleTween.onComplete = selectionTween_onComplete;
				Starling.juggler.add(this._toggleTween);
			}
			else
			{
				this.thumb.x = xPosition;
			}
			this._isSelectionChangedByUser = false;

			//we want to be sure that the onLabel isn't visible behind the thumb
			//on init so that if we fade out the toggle switch alpha, on won't
			//suddenly appear due to the way that flash changes alpha values
			//of containers.
			this.layout();
		}

		/**
		 * @private
		 */
		protected function refreshOnLabelStyles():void
		{
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				this.onTextRenderer.visible = false;
				return;
			}

			var properties:PropertyProxy;
			if(!this._isEnabled)
			{
				properties = this._disabledLabelProperties;
			}
			if(!properties && this._onLabelProperties)
			{
				properties = this._onLabelProperties;
			}
			if(!properties)
			{
				properties = this._defaultLabelProperties;
			}

			this.onTextRenderer.text = this._onText;
			if(properties)
			{
				const displayRenderer:DisplayObject = DisplayObject(this.onTextRenderer);
				for(var propertyName:String in properties)
				{
					if(displayRenderer.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = properties[propertyName];
						displayRenderer[propertyName] = propertyValue;
					}
				}
			}
			this.onTextRenderer.validate();
			this.onTextRenderer.visible = true;
		}

		/**
		 * @private
		 */
		protected function refreshOffLabelStyles():void
		{
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				this.offTextRenderer.visible = false;
				return;
			}

			var properties:PropertyProxy;
			if(!this._isEnabled)
			{
				properties = this._disabledLabelProperties;
			}
			if(!properties && this._offLabelProperties)
			{
				properties = this._offLabelProperties;
			}
			if(!properties)
			{
				properties = this._defaultLabelProperties;
			}

			this.offTextRenderer.text = this._offText;
			if(properties)
			{
				const displayRenderer:DisplayObject = DisplayObject(this.offTextRenderer);
				for(var propertyName:String in properties)
				{
					if(displayRenderer.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = properties[propertyName];
						displayRenderer[propertyName] = propertyValue;
					}
				}
			}
			this.offTextRenderer.validate();
			this.offTextRenderer.visible = true;
		}

		/**
		 * @private
		 */
		protected function refreshThumbStyles():void
		{
			for(var propertyName:String in this._thumbProperties)
			{
				if(this.thumb.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._thumbProperties[propertyName];
					this.thumb[propertyName] = propertyValue;
				}
			}
			this.thumb.visible = this._showThumb;
		}

		/**
		 * @private
		 */
		protected function refreshTrackStyles():void
		{
			for(var propertyName:String in this._onTrackProperties)
			{
				if(this.onTrack.hasOwnProperty(propertyName))
				{
					var propertyValue:Object = this._onTrackProperties[propertyName];
					this.onTrack[propertyName] = propertyValue;
				}
			}
			if(this.offTrack)
			{
				for(propertyName in this._offTrackProperties)
				{
					if(this.offTrack.hasOwnProperty(propertyName))
					{
						propertyValue = this._offTrackProperties[propertyName];
						this.offTrack[propertyName] = propertyValue;
					}
				}
			}
		}

		/**
		 * @private
		 */
		protected function drawLabels():void
		{
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			var totalLabelHeight:Number = Math.max(this.onTextRenderer.height, this.offTextRenderer.height);
			var labelHeight:Number;
			if(this._labelAlign == LABEL_ALIGN_MIDDLE)
			{
				labelHeight = totalLabelHeight;
			}
			else //baseline
			{
				labelHeight = Math.max(this.onTextRenderer.baseline, this.offTextRenderer.baseline);
			}

			if(this.onTextRenderer is FeathersControl)
			{
				var clipRect:Rectangle = FeathersControl(this.onTextRenderer).clipRect;
				clipRect.width = maxLabelWidth;
				clipRect.height = totalLabelHeight;
				FeathersControl(this.onTextRenderer).clipRect = clipRect;
			}

			this.onTextRenderer.y = (this.actualHeight - labelHeight) / 2;

			if(this.offTextRenderer is FeathersControl)
			{
				clipRect = FeathersControl(this.offTextRenderer).clipRect;
				clipRect.width = maxLabelWidth;
				clipRect.height = totalLabelHeight;
				FeathersControl(this.offTextRenderer).clipRect = clipRect;
			}

			this.offTextRenderer.y = (this.actualHeight - labelHeight) / 2;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			const thumbOffset:Number = this.thumb.x - this._paddingLeft;

			var onScrollOffset:Number = maxLabelWidth - thumbOffset - (maxLabelWidth - this.onTextRenderer.width) / 2;
			if(this.onTextRenderer is FeathersControl)
			{
				const displayOnLabelRenderer:FeathersControl = FeathersControl(this.onTextRenderer);
				var currentClipRect:Rectangle = displayOnLabelRenderer.clipRect;
				currentClipRect.x = onScrollOffset
				displayOnLabelRenderer.clipRect = currentClipRect;
			}
			this.onTextRenderer.x = this._paddingLeft - onScrollOffset;

			var offScrollOffset:Number = -thumbOffset - (maxLabelWidth - this.offTextRenderer.width) / 2;
			if(this.offTextRenderer is FeathersControl)
			{
				const displayOffLabelRenderer:FeathersControl = FeathersControl(this.offTextRenderer);
				currentClipRect = displayOffLabelRenderer.clipRect;
				currentClipRect.x = offScrollOffset
				displayOffLabelRenderer.clipRect = currentClipRect;
			}
			this.offTextRenderer.x = this.actualWidth - this._paddingRight - maxLabelWidth - offScrollOffset;

			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_ON_OFF)
			{
				this.layoutTrackWithOnOff();
			}
			else
			{
				this.layoutTrackWithSingle();
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithOnOff():void
		{
			this.onTrack.x = 0;
			this.onTrack.y = 0;
			this.onTrack.width = this.thumb.x + this.thumb.width / 2;
			this.onTrack.height = this.actualHeight;

			this.offTrack.x = this.onTrack.width;
			this.offTrack.y = 0;
			this.offTrack.width = this.actualWidth - this.offTrack.x;
			this.offTrack.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			this.onTrack.x = 0;
			this.onTrack.y = 0;
			this.onTrack.width = this.actualWidth;
			this.onTrack.height = this.actualHeight;
		}

		/**
		 * @private
		 */
		protected function createOrDestroyOffTrackIfNeeded():void
		{
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_ON_OFF)
			{
				if(!this.offTrack)
				{
					this.offTrack = new Button();
					this.offTrack.nameList.add(this.offTrackName);
					this.offTrack.label = "";
					this.offTrack.keepDownStateOnRollOut = true;
					this.addChildAt(this.offTrack, 1);
				}
			}
			else if(this.offTrack) //single
			{
				this.offTrack.removeFromParent(true);
				this.offTrack = null;
			}
		}

		/**
		 * @private
		 */
		protected function childProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
		}

		/**
		 * @private
		 */
		protected function touchHandler(event:TouchEvent):void
		{
			if(this._ignoreTapHandler)
			{
				this._ignoreTapHandler = false;
				return;
			}
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			const touches:Vector.<Touch> = event.getTouches(this, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			var touch:Touch;
			for each(var currentTouch:Touch in touches)
			{
				if((this._touchPointID >= 0 && currentTouch.id == this._touchPointID) ||
					(this._touchPointID < 0 && currentTouch.phase == TouchPhase.ENDED))
				{
					touch = currentTouch;
					break;
				}
			}
			if(!touch || touch.phase != TouchPhase.ENDED)
			{
				HELPER_TOUCHES_VECTOR.length = 0;
				return;
			}

			this._touchPointID = -1;
			touch.getLocation(this, HELPER_POINT);
			if(this.hitTest(HELPER_POINT, true))
			{
				this.isSelected = !this._isSelected;
				this._isSelectionChangedByUser = true;
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.thumb, null, HELPER_TOUCHES_VECTOR);
			if(touches.length == 0)
			{
				return;
			}
			if(this._touchPointID >= 0)
			{
				var touch:Touch;
				for each(var currentTouch:Touch in touches)
				{
					if(currentTouch.id == this._touchPointID)
					{
						touch = currentTouch;
						break;
					}
				}
				if(!touch)
				{
					HELPER_TOUCHES_VECTOR.length = 0;
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				const trackScrollableWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
				if(touch.phase == TouchPhase.MOVED)
				{
					const xOffset:Number = HELPER_POINT.x - this._touchStartX;
					const xPosition:Number = Math.min(Math.max(this._paddingLeft, this._thumbStartX + xOffset), this._paddingLeft + trackScrollableWidth);
					this.thumb.x = xPosition;
					this.layout();
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					const inchesMoved:Number = Math.abs(HELPER_POINT.x - this._touchStartX) / DeviceCapabilities.dpi;
					if(inchesMoved > MINIMUM_DRAG_DISTANCE)
					{
						this._touchPointID = -1;
						this.isSelected = this.thumb.x > (this._paddingLeft + trackScrollableWidth / 2);
						this._isSelectionChangedByUser = true;
						this._ignoreTapHandler = true;
					}
				}
			}
			else
			{
				for each(touch in touches)
				{
					if(touch.phase == TouchPhase.BEGAN)
					{
						touch.getLocation(this, HELPER_POINT);
						this._touchPointID = touch.id;
						this._thumbStartX = this.thumb.x;
						this._touchStartX = HELPER_POINT.x;
						break;
					}
				}
			}
			HELPER_TOUCHES_VECTOR.length = 0;
		}

		/**
		 * @private
		 */
		protected function selectionTween_onUpdate():void
		{
			this.layout();
		}

		/**
		 * @private
		 */
		protected function selectionTween_onComplete():void
		{
			this._toggleTween = null;
		}
	}
}