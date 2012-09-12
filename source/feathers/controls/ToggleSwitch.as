/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.motion.GTween;
	import feathers.system.DeviceCapabilities;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Similar to a light switch. May be selected or not, like a check box.
	 */
	public class ToggleSwitch extends FeathersControl implements IToggle
	{
		/**
		 * @private
		 */
		private static const HELPER_POINT:Point = new Point();

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
		 * The switch's on and off track skins will by resized by changing
		 * their width and height values. Consider using a special display
		 * object such as a Scale9Image, Scale3Image or a TiledImage if the
		 * skins should be resizable.
		 */
		public static const TRACK_LAYOUT_MODE_STRETCH:String = "stretch";

		/**
		 * The switch's on and off track skins will be resized and cropped
		 * using a scrollRect to ensure that the skins maintain a static
		 * appearance without altering the aspect ratio.
		 */
		public static const TRACK_LAYOUT_MODE_SCROLL:String = "scroll";

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
		 * @private
		 */
		protected var thumb:Button;

		/**
		 * @private
		 */
		protected var onTextRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var offTextRenderer:ITextRenderer;

		/**
		 * @private
		 */
		protected var onTrack:Button;

		/**
		 * @private
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
		private var _showThumb:Boolean = true;

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
		private var _trackLayoutMode:String = TRACK_LAYOUT_MODE_SINGLE;

		/**
		 * Determines how the on and off track skins are positioned and sized.
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
		 * @see #onLabelProperties
		 * @see #offLabelProperties
		 * @see #disabledLabelProperties
		 */
		public function get defaultLabelProperties():Object
		{
			if(!this._defaultLabelProperties)
			{
				this._defaultLabelProperties = new PropertyProxy(labelProperties_onChange);
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
				this._defaultLabelProperties.onChange.remove(labelProperties_onChange);
			}
			this._defaultLabelProperties = PropertyProxy(value);
			if(this._defaultLabelProperties)
			{
				this._defaultLabelProperties.onChange.add(labelProperties_onChange);
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
		 */
		public function get disabledLabelProperties():Object
		{
			if(!this._disabledLabelProperties)
			{
				this._disabledLabelProperties = new PropertyProxy(labelProperties_onChange);
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
				this._disabledLabelProperties.onChange.remove(labelProperties_onChange);
			}
			this._disabledLabelProperties = PropertyProxy(value);
			if(this._disabledLabelProperties)
			{
				this._disabledLabelProperties.onChange.add(labelProperties_onChange);
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
		 */
		public function get onLabelProperties():Object
		{
			if(!this._onLabelProperties)
			{
				this._onLabelProperties = new PropertyProxy(labelProperties_onChange);
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
				this._onLabelProperties.onChange.remove(labelProperties_onChange);
			}
			this._onLabelProperties = PropertyProxy(value);
			if(this._onLabelProperties)
			{
				this._onLabelProperties.onChange.add(labelProperties_onChange);
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
		 */
		public function get offLabelProperties():Object
		{
			if(!this._offLabelProperties)
			{
				this._offLabelProperties = new PropertyProxy(labelProperties_onChange);
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
				this._offLabelProperties.onChange.remove(labelProperties_onChange);
			}
			this._offLabelProperties = PropertyProxy(value);
			if(this._offLabelProperties)
			{
				this._offLabelProperties.onChange.add(labelProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _labelAlign:String = LABEL_ALIGN_BASELINE;

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
		private var _isSelected:Boolean = false;

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
			//need to invalidate. notice that the signal isn't dispatched
			//unless the value changes.
			const oldSelected:Boolean = this._isSelected;
			this._isSelected = value;
			this._isSelectionChangedByUser = false;
			this.invalidate(INVALIDATION_FLAG_DATA, INVALIDATION_FLAG_SELECTED);
			if(this._isSelected != oldSelected)
			{
				this._onChange.dispatch(this);
			}
		}

		/**
		 * @private
		 */
		private var _onText:String = "ON";

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
			if(!value)
			{
				//don't allow null or undefined
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
		private var _offText:String = "OFF";

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
			if(!value)
			{
				//don't allow null or undefined
				value = "";
			}
			if(this._offText == value)
			{
				return;
			}
			this._offText = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		private var _selectionChangeTween:GTween;

		private var _ignoreTapHandler:Boolean = false;
		private var _touchPointID:int = -1;
		private var _thumbStartX:Number;
		private var _touchStartX:Number;
		private var _isSelectionChangedByUser:Boolean = false;

		/**
		 * @private
		 */
		protected var _onChange:Signal = new Signal(ToggleSwitch);

		/**
		 * Dispatched when the selection changes.
		 */
		public function get onChange():ISignal
		{
			return this._onChange;
		}

		/**
		 * @private
		 */
		private var _onTrackProperties:PropertyProxy;

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
				this._onTrackProperties = new PropertyProxy(onTrackProperties_onChange);
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
				this._onTrackProperties.onChange.remove(onTrackProperties_onChange);
			}
			this._onTrackProperties = PropertyProxy(value);
			if(this._onTrackProperties)
			{
				this._onTrackProperties.onChange.add(onTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _offTrackProperties:PropertyProxy;

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
				this._offTrackProperties = new PropertyProxy(offTrackProperties_onChange);
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
				this._offTrackProperties.onChange.remove(offTrackProperties_onChange);
			}
			this._offTrackProperties = PropertyProxy(value);
			if(this._offTrackProperties)
			{
				this._offTrackProperties.onChange.add(offTrackProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		private var _thumbProperties:PropertyProxy;

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
				this._thumbProperties = new PropertyProxy(thumbProperties_onChange);
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
				this._thumbProperties.onChange.remove(thumbProperties_onChange);
			}
			this._thumbProperties = PropertyProxy(value);
			if(this._thumbProperties)
			{
				this._thumbProperties.onChange.add(thumbProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			this._onChange.removeAll();
			super.dispose();
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
				this.onTrack.scrollRect = new Rectangle();
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
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
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

			if(sizeInvalid || stylesInvalid || dataInvalid)
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
				this.removeChild(FeathersControl(this.offTextRenderer), true);
				this.offTextRenderer = null;
			}
			if(this.onTextRenderer)
			{
				this.removeChild(FeathersControl(this.onTextRenderer), true);
				this.onTextRenderer = null;
			}

			const index:int = this.getChildIndex(this.thumb);
			const factory:Function = this._labelFactory != null ? this._labelFactory : FeathersControl.defaultTextRendererFactory;
			this.offTextRenderer = factory();
			var uiTextRenderer:FeathersControl = FeathersControl(this.offTextRenderer);
			uiTextRenderer.nameList.add(this.offLabelName);
			uiTextRenderer.scrollRect = new Rectangle();
			this.addChildAt(uiTextRenderer, index);

			this.onTextRenderer = factory();
			uiTextRenderer = FeathersControl(this.onTextRenderer);
			uiTextRenderer.nameList.add(this.onLabelName);
			uiTextRenderer.scrollRect = new Rectangle();
			this.addChildAt(uiTextRenderer, index);
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
			if(this._selectionChangeTween)
			{
				this._selectionChangeTween.paused = true;
				this._selectionChangeTween = null;
			}

			if(this._isSelectionChangedByUser)
			{
				this._selectionChangeTween = new GTween(this.thumb, 0.15,
				{
					x: xPosition
				},
				{
					onChange: selectionTween_onChange,
					onComplete: selectionTween_onComplete
				});
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
			const uiOnLabelRenderer:FeathersControl = FeathersControl(this.onTextRenderer);
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				uiOnLabelRenderer.visible = false;
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
				for(var propertyName:String in properties)
				{
					if(uiOnLabelRenderer.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = properties[propertyName];
						uiOnLabelRenderer[propertyName] = propertyValue;
					}
				}
			}
			uiOnLabelRenderer.validate();
			uiOnLabelRenderer.visible = true;
		}

		/**
		 * @private
		 */
		protected function refreshOffLabelStyles():void
		{
			const uiOffLabelRenderer:FeathersControl = FeathersControl(this.offTextRenderer);
			//no need to style the label field if there's no text to display
			if(!this._showLabels || !this._showThumb)
			{
				uiOffLabelRenderer.visible = false;
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
				for(var propertyName:String in properties)
				{
					if(uiOffLabelRenderer.hasOwnProperty(propertyName))
					{
						var propertyValue:Object = properties[propertyName];
						uiOffLabelRenderer[propertyName] = propertyValue;
					}
				}
			}
			uiOffLabelRenderer.validate();
			uiOffLabelRenderer.visible = true;
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
		private function drawLabels():void
		{
			const uiOnLabelRenderer:FeathersControl = FeathersControl(this.onTextRenderer);
			const uiOffLabelRenderer:FeathersControl = FeathersControl(this.offTextRenderer);
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			var totalLabelHeight:Number = Math.max(uiOnLabelRenderer.height, uiOffLabelRenderer.height);
			var labelHeight:Number;
			if(this._labelAlign == LABEL_ALIGN_MIDDLE)
			{
				labelHeight = totalLabelHeight;
			}
			else //baseline
			{
				labelHeight = Math.max(this.onTextRenderer.baseline, this.offTextRenderer.baseline);
			}

			var onScrollRect:Rectangle = uiOnLabelRenderer.scrollRect;
			onScrollRect.width = maxLabelWidth;
			onScrollRect.height = totalLabelHeight;
			uiOnLabelRenderer.scrollRect = onScrollRect;

			uiOnLabelRenderer.x = this._paddingLeft;
			uiOnLabelRenderer.y = (this.actualHeight - labelHeight) / 2;

			var offScrollRect:Rectangle = uiOffLabelRenderer.scrollRect;
			offScrollRect.width = maxLabelWidth;
			offScrollRect.height = totalLabelHeight;
			uiOffLabelRenderer.scrollRect = offScrollRect;

			uiOffLabelRenderer.x = this.actualWidth - this._paddingRight - maxLabelWidth;
			uiOffLabelRenderer.y = (this.actualHeight - labelHeight) / 2;
		}

		/**
		 * @private
		 */
		protected function layout():void
		{
			const maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			const thumbOffset:Number = this.thumb.x - this._paddingLeft;

			const uiOnLabelRenderer:FeathersControl = FeathersControl(this.onTextRenderer);
			const uiOffLabelRenderer:FeathersControl = FeathersControl(this.offTextRenderer);
			var currentScrollRect:Rectangle = uiOnLabelRenderer.scrollRect;
			currentScrollRect.x = maxLabelWidth - thumbOffset - (maxLabelWidth - uiOnLabelRenderer.width) / 2;
			uiOnLabelRenderer.scrollRect = currentScrollRect;

			currentScrollRect = uiOffLabelRenderer.scrollRect;
			currentScrollRect.x = -thumbOffset - (maxLabelWidth - uiOffLabelRenderer.width) / 2;
			uiOffLabelRenderer.scrollRect = currentScrollRect;

			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL)
			{
				this.layoutTrackWithScrollRect();
			}
			else if(this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
			{
				this.layoutTrackWithStretch();
			}
			else
			{
				this.layoutTrackWithSingle();
			}
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithStretch():void
		{
			if(this.onTrack.scrollRect)
			{
				this.onTrack.scrollRect = null;
			}
			if(this.offTrack.scrollRect)
			{
				this.offTrack.scrollRect = null;
			}

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
		protected function layoutTrackWithScrollRect():void
		{
			//we want to scale the skins to match the height of the slider,
			//but we also want to keep the original aspect ratio.
			const onTrackScaledWidth:Number = this.onTrackSkinOriginalWidth * this.actualHeight / this.onTrackSkinOriginalHeight;
			const offTrackScaledWidth:Number = this.offTrackSkinOriginalWidth * this.actualHeight / this.offTrackSkinOriginalHeight;
			this.onTrack.width = onTrackScaledWidth;
			this.onTrack.height = this.actualHeight;
			this.offTrack.width = offTrackScaledWidth;
			this.offTrack.height = this.actualHeight;

			var middleOfThumb:Number = this.thumb.x + this.thumb.width / 2;
			this.onTrack.x = 0;
			this.onTrack.y = 0;
			var currentScrollRect:Rectangle = this.onTrack.scrollRect;
			if(!currentScrollRect)
			{
				currentScrollRect = new Rectangle();
			}
			currentScrollRect.x = 0;
			currentScrollRect.y = 0;
			currentScrollRect.width = Math.min(onTrackScaledWidth, middleOfThumb);
			currentScrollRect.height = this.actualHeight;
			this.onTrack.scrollRect = currentScrollRect;

			this.offTrack.x = Math.max(this.actualWidth - offTrackScaledWidth, middleOfThumb);
			this.offTrack.y = 0;
			currentScrollRect = this.offTrack.scrollRect;
			if(!currentScrollRect)
			{
				currentScrollRect = new Rectangle();
			}
			currentScrollRect.width = Math.min(offTrackScaledWidth, this.actualWidth - middleOfThumb);
			currentScrollRect.height = this.actualHeight;
			currentScrollRect.x = Math.max(0, offTrackScaledWidth - currentScrollRect.width);
			currentScrollRect.y = 0;
			this.offTrack.scrollRect = currentScrollRect;
		}

		/**
		 * @private
		 */
		protected function layoutTrackWithSingle():void
		{
			if(this.onTrack.scrollRect)
			{
				this.onTrack.scrollRect = null;
			}
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
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_SCROLL || this._trackLayoutMode == TRACK_LAYOUT_MODE_STRETCH)
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
		protected function onTrackProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function offTrackProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function thumbProperties_onChange(proxy:PropertyProxy, name:Object):void
		{
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected function labelProperties_onChange(proxy:PropertyProxy, name:Object):void
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
		private function touchHandler(event:TouchEvent):void
		{
			if(this._ignoreTapHandler)
			{
				this._ignoreTapHandler = false;
				return;
			}
			if(!this._isEnabled)
			{
				return;
			}

			const touches:Vector.<Touch> = event.getTouches(this);
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
				return;
			}

			this._touchPointID = -1;
			touch.getLocation(this, HELPER_POINT);
			if(this.hitTest(HELPER_POINT, true))
			{
				this.isSelected = !this._isSelected;
				this._isSelectionChangedByUser = true;
			}
		}

		/**
		 * @private
		 */
		private function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				return;
			}
			const touches:Vector.<Touch> = event.getTouches(this.thumb);
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
					return;
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
					return;
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
						return;
					}
				}
			}
		}

		/**
		 * @private
		 */
		private function selectionTween_onChange(tween:GTween):void
		{
			this.layout();
		}

		/**
		 * @private
		 */
		private function selectionTween_onComplete(tween:GTween):void
		{
			this._selectionChangeTween = null;
		}
	}
}