/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.FeathersControl;
	import feathers.core.IFocusDisplayObject;
	import feathers.core.ITextRenderer;
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.skins.IStyleProvider;
	import feathers.system.DeviceCapabilities;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.SystemUtil;

	/**
	 * @copy feathers.core.IToggle#event:change
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * Similar to a light switch with on and off states. Generally considered an
	 * alternative to a check box.
	 *
	 * <p>The following example programmatically selects a toggle switch and
	 * listens for when the selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var toggle:ToggleSwitch = new ToggleSwitch();
	 * toggle.isSelected = true;
	 * toggle.addEventListener( Event.CHANGE, toggle_changeHandler );
	 * this.addChild( toggle );</listing>
	 *
	 * @see ../../../help/toggle-switch.html How to use the Feathers ToggleSwitch component
	 * @see feathers.controls.Check
	 */
	public class ToggleSwitch extends FeathersControl implements IToggle, IFocusDisplayObject
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
		 * @private
		 */
		protected static const INVALIDATION_FLAG_THUMB_FACTORY:String = "thumbFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_ON_TRACK_FACTORY:String = "onTrackFactory";

		/**
		 * @private
		 */
		protected static const INVALIDATION_FLAG_OFF_TRACK_FACTORY:String = "offTrackFactory";

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on the full character height of the font.
		 *
		 * @see #labelAlign
		 */
		public static const LABEL_ALIGN_MIDDLE:String = "middle";

		/**
		 * The ON and OFF labels will be aligned to the middle vertically,
		 * based on only the baseline value of the font.
		 *
		 * @see #labelAlign
		 */
		public static const LABEL_ALIGN_BASELINE:String = "baseline";

		/**
		 * The toggle switch has only one track skin, stretching to fill the
		 * full length of switch. In this layout mode, the on track is
		 * displayed and fills the entire length of the toggle switch. The off
		 * track will not exist.
		 *
		 * @see #trackLayoutMode
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
		 * using a special display object such as a <code>Scale9Image</code>,
		 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
		 * designed to be resized dynamically.</p>
		 *
		 * @see #trackLayoutMode
		 * @see feathers.display.Scale9Image
		 * @see feathers.display.Scale3Image
		 * @see feathers.display.TiledImage
		 */
		public static const TRACK_LAYOUT_MODE_ON_OFF:String = "onOff";

		/**
		 * The default value added to the <code>styleNameList</code> of the off label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_OFF_LABEL:String = "feathers-toggle-switch-off-label";

		/**
		 * DEPRECATED: Replaced by <code>ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_LABEL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see ToggleSwitch#DEFAULT_CHILD_STYLE_NAME_OFF_LABEL
		 */
		public static const DEFAULT_CHILD_NAME_OFF_LABEL:String = DEFAULT_CHILD_STYLE_NAME_OFF_LABEL;

		/**
		 * The default value added to the <code>styleNameList</code> of the on label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ON_LABEL:String = "feathers-toggle-switch-on-label";

		/**
		 * DEPRECATED: Replaced by <code>ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_LABEL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see ToggleSwitch#DEFAULT_CHILD_STYLE_NAME_ON_LABEL
		 */
		public static const DEFAULT_CHILD_NAME_ON_LABEL:String = DEFAULT_CHILD_STYLE_NAME_ON_LABEL;

		/**
		 * The default value added to the <code>styleNameList</code> of the off track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_OFF_TRACK:String = "feathers-toggle-switch-off-track";

		/**
		 * DEPRECATED: Replaced by <code>ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_OFF_TRACK</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see ToggleSwitch#DEFAULT_CHILD_STYLE_NAME_OFF_TRACK
		 */
		public static const DEFAULT_CHILD_NAME_OFF_TRACK:String = DEFAULT_CHILD_STYLE_NAME_OFF_TRACK;

		/**
		 * The default value added to the <code>styleNameList</code> of the on track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_ON_TRACK:String = "feathers-toggle-switch-on-track";

		/**
		 * DEPRECATED: Replaced by <code>ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_ON_TRACK</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see ToggleSwitch#DEFAULT_CHILD_STYLE_NAME_ON_TRACK
		 */
		public static const DEFAULT_CHILD_NAME_ON_TRACK:String = DEFAULT_CHILD_STYLE_NAME_ON_TRACK;

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-toggle-switch-thumb";

		/**
		 * DEPRECATED: Replaced by <code>ToggleSwitch.DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see ToggleSwitch#DEFAULT_CHILD_STYLE_NAME_THUMB
		 */
		public static const DEFAULT_CHILD_NAME_THUMB:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

		/**
		 * The default <code>IStyleProvider</code> for all <code>ToggleSwitch</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultThumbFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultOnTrackFactory():Button
		{
			return new Button();
		}

		/**
		 * @private
		 */
		protected static function defaultOffTrackFactory():Button
		{
			return new Button();
		}

		/**
		 * Constructor.
		 */
		public function ToggleSwitch()
		{
			super();
			this.addEventListener(TouchEvent.TOUCH, toggleSwitch_touchHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, toggleSwitch_removedFromStageHandler);
		}

		/**
		 * The value added to the <code>styleNameList</code> of the off label
		 * text renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the on label text renderer style name in
		 * their constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ON_LABEL</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var onLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_ON_LABEL;

		/**
		 * DEPRECATED: Replaced by <code>onLabelStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #onLabelStyleName
		 */
		protected function get onLabelName():String
		{
			return this.onLabelStyleName;
		}

		/**
		 * @private
		 */
		protected function set onLabelName(value:String):void
		{
			this.onLabelStyleName = value;
		}

		/**
		 * The value added to the <code>styleNameList</code> of the off label
		 * text renderer. This variable is <code>protected</code> so that
		 * sub-classes can customize the off label text renderer style name in
		 * their constructors instead of using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_OFF_LABEL</code>.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var offLabelStyleName:String = DEFAULT_CHILD_STYLE_NAME_OFF_LABEL;

		/**
		 * DEPRECATED: Replaced by <code>offLabelStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #offLabelStyleName
		 */
		protected function get offLabelName():String
		{
			return this.offLabelStyleName;
		}

		/**
		 * @private
		 */
		protected function set offLabelName(value:String):void
		{
			this.offLabelStyleName = value;
		}

		/**
		 * The value added to the <code>styleNameList</code> of the on track.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the on track style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_ON_TRACK</code>.
		 *
		 * <p>To customize the on track style name without subclassing, see
		 * <code>customOnTrackStyleName</code>.</p>
		 *
		 * @see #customOnTrackStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var onTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_ON_TRACK;

		/**
		 * DEPRECATED: Replaced by <code>onTrackStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #onTrackStyleName
		 */
		protected function get onTrackName():String
		{
			return this.onTrackStyleName;
		}

		/**
		 * @private
		 */
		protected function set onTrackName(value:String):void
		{
			this.onTrackStyleName = value;
		}

		/**
		 * The value added to the <code>styleNameList</code> of the off track.
		 * This variable is <code>protected</code> so that sub-classes can
		 * customize the off track style name in their constructors instead of
		 * using the default style name defined by
		 * <code>DEFAULT_CHILD_STYLE_NAME_OFF_TRACK</code>.
		 *
		 * <p>To customize the off track style name without subclassing, see
		 * <code>customOffTrackStyleName</code>.</p>
		 *
		 * @see #customOffTrackStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var offTrackStyleName:String = DEFAULT_CHILD_STYLE_NAME_OFF_TRACK;

		/**
		 * DEPRECATED: Replaced by <code>offTrackStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #offTrackStyleName
		 */
		protected function get offTrackName():String
		{
			return this.offTrackStyleName;
		}

		/**
		 * @private
		 */
		protected function set offTrackName(value:String):void
		{
			this.offTrackStyleName = value;
		}

		/**
		 * The value added to the <code>styleNameList</code> of the thumb. This
		 * variable is <code>protected</code> so that sub-classes can customize
		 * the thumb style name in their constructors instead of using the
		 * default stylename defined by <code>DEFAULT_CHILD_STYLE_NAME_THUMB</code>.
		 *
		 * <p>To customize the thumb style name without subclassing, see
		 * <code>customThumbStyleName</code>.</p>
		 *
		 * @see #customThumbStyleName
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		protected var thumbStyleName:String = DEFAULT_CHILD_STYLE_NAME_THUMB;

		/**
		 * DEPRECATED: Replaced by <code>tabStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #tabStyleName
		 */
		protected function get thumbName():String
		{
			return this.thumbStyleName;
		}

		/**
		 * @private
		 */
		protected function set thumbName(value:String):void
		{
			this.thumbStyleName = value;
		}

		/**
		 * The thumb sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #thumbFactory
		 * @see #createThumb()
		 */
		protected var thumb:Button;

		/**
		 * The "on" text renderer sub-component.
		 *
		 * @see #labelFactory
		 */
		protected var onTextRenderer:ITextRenderer;

		/**
		 * The "off" text renderer sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #labelFactory
		 */
		protected var offTextRenderer:ITextRenderer;

		/**
		 * The "on" track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #onTrackFactory
		 * @see #createOnTrack()
		 */
		protected var onTrack:Button;

		/**
		 * The "off" track sub-component.
		 *
		 * <p>For internal use in subclasses.</p>
		 *
		 * @see #offTrackFactory
		 * @see #createOffTrack()
		 */
		protected var offTrack:Button;

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return ToggleSwitch.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _paddingRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the switch's right edge and the
		 * switch's content.
		 *
		 * <p>In the following example, the toggle switch's right padding is
		 * set to 20 pixels:</p>
		 *
		 * <listing version="3.0">
		 * toggle.paddingRight = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the toggle switch's left padding is
		 * set to 20 pixels:</p>
		 * 
		 * <listing version="3.0">
		 * toggle.paddingLeft = 20;</listing>
		 *
		 * @default 0
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
		 *
		 * <p>In the following example, the toggle switch's labels are hidden:</p>
		 *
		 * <listing version="3.0">
		 * toggle.showLabels = false;</listing>
		 *
		 * @default true
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
		 *
		 * <p>In the following example, the toggle switch's thumb is hidden:</p>
		 *
		 * <listing version="3.0">
		 * toggle.showThumb = false;</listing>
		 *
		 * @default true
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
		 * <p>In the following example, the toggle switch's track layout mode is
		 * updated to use two tracks:</p>
		 *
		 * <listing version="3.0">
		 * toggle.trackLayoutMode = ToggleSwitch.TRACK_LAYOUT_MODE_ON_OFF;</listing>
		 *
		 * @default ToggleSwitch.TRACK_LAYOUT_MODE_SINGLE
		 *
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
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}

		/**
		 * @private
		 */
		protected var _defaultLabelProperties:PropertyProxy;

		/**
		 * An object that stores properties for the toggle switch's label text
		 * renderers when the toggle switch is enabled, and the properties will
		 * be passed down to the text renderers when the toggle switch
		 * validates. The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>labelFactory</code> (possibly <code>onLabelFactory</code> or
		 * <code>offLabelFactory</code> instead). Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>In the following example, the toggle switch's default label
		 * properties are updated (this example assumes that the label text
		 * renderers are of type <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * toggle.defaultLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * toggle.defaultLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see #onLabelFactory
		 * @see #offLabelFactory
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
		 * An object that stores properties for the toggle switch's label text
		 * renderers when the toggle switch is disabled, and the properties will
		 * be passed down to the text renderers when the toggle switch
		 * validates. The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>labelFactory</code> (possibly <code>onLabelFactory</code> or
		 * <code>offLabelFactory</code> instead). Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.
		 *
		 * <p>In the following example, the toggle switch's disabled label
		 * properties are updated (this example assumes that the label text
		 * renderers are of type <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * toggle.disabledLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * toggle.disabledLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see #onLabelFactory
		 * @see #offLabelFactory
		 * @see feathers.core.ITextRenderer
		 * @see #defaultLabelProperties
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
		 * An object that stores properties for the toggle switch's "on" label
		 * text renderer, and the properties will be passed down to the text
		 * renderer when the toggle switch validates. If <code>null</code>, then
		 * <code>defaultLabelProperties</code> is used instead.
		 * 
		 * <p>The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>labelFactory</code> (possibly <code>onLabelFactory</code>
		 * instead). Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.</p>
		 *
		 * <p>In the following example, the toggle switch's on label properties
		 * are updated (this example assumes that the on label text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * toggle.onLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * toggle.onLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see feathers.core.ITextRenderer
		 * @see #defaultLabelProperties
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
		 * An object that stores properties for the toggle switch's "off" label
		 * text renderer, and the properties will be passed down to the text
		 * renderer when the toggle switch validates. If <code>null</code>, then
		 * <code>defaultLabelProperties</code> is used instead.
		 * 
		 * <p>The available properties depend on which
		 * <code>ITextRenderer</code> implementation is returned by
		 * <code>labelFactory</code> (possibly <code>offLabelFactory</code>
		 * instead). Refer to
		 * <a href="../core/ITextRenderer.html"><code>feathers.core.ITextRenderer</code></a>
		 * for a list of available text renderer implementations.</p>
		 *
		 * <p>In the following example, the toggle switch's off label properties
		 * are updated (this example assumes that the off label text renderer is a
		 * <code>TextFieldTextRenderer</code>):</p>
		 *
		 * <listing version="3.0">
		 * toggle.offLabelProperties.textFormat = new TextFormat( "Source Sans Pro", 16, 0x333333 );
		 * toggle.offLabelProperties.embedFonts = true;</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see feathers.core.ITextRenderer
		 * @see #defaultLabelProperties
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
		 *
		 * <p>In the following example, the toggle switch's label alignment is
		 * updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.labelAlign = ToggleSwitch.LABEL_ALIGN_MIDDLE;</listing>
		 *
		 * @default ToggleSwitch.LABEL_ALIGN_BASELINE
		 *
		 * @see #LABEL_ALIGN_BASELINE
		 * @see #LABEL_ALIGN_MIDDLE
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
		 * A function used to instantiate the toggle switch's label text
		 * renderer sub-components, if specific factories for those label text
		 * renderers are not provided. The label text renderers must be
		 * instances of <code>ITextRenderer</code>. This factory can be used to
		 * change properties of the label text renderers when they are first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the label text
		 * renderers.
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, the toggle switch uses a custom label
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * toggle.labelFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #onLabelFactory
		 * @see #offLabelFactory
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
		protected var _onLabelFactory:Function;

		/**
		 * A function used to instantiate the toggle switch's on label text
		 * renderer sub-component. The on label text renderer must be an
		 * instance of <code>ITextRenderer</code>. This factory can be used to
		 * change properties of the on label text renderer when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the on label
		 * text renderer.
		 *
		 * <p>If an <code>onLabelFactory</code> is not provided, the default
		 * <code>labelFactory</code> will be used.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, the toggle switch uses a custom on label
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * toggle.onLabelFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see #offLabelFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get onLabelFactory():Function
		{
			return this._onLabelFactory;
		}

		/**
		 * @private
		 */
		public function set onLabelFactory(value:Function):void
		{
			if(this._onLabelFactory == value)
			{
				return;
			}
			this._onLabelFactory = value;
			this.invalidate(INVALIDATION_FLAG_TEXT_RENDERER);
		}

		/**
		 * @private
		 */
		protected var _offLabelFactory:Function;

		/**
		 * A function used to instantiate the toggle switch's off label text
		 * renderer sub-component. The off label text renderer must be an
		 * instance of <code>ITextRenderer</code>. This factory can be used to
		 * change properties of the off label text renderer when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use this factory to style the off label
		 * text renderer.
		 *
		 * <p>If an <code>offLabelFactory</code> is not provided, the default
		 * <code>labelFactory</code> will be used.</p>
		 *
		 * <p>The factory should have the following function signature:</p>
		 * <pre>function():ITextRenderer</pre>
		 *
		 * <p>In the following example, the toggle switch uses a custom on label
		 * factory:</p>
		 *
		 * <listing version="3.0">
		 * toggle.offLabelFactory = function():ITextRenderer
		 * {
		 *     return new TextFieldTextRenderer();
		 * }</listing>
		 *
		 * @default null
		 *
		 * @see #labelFactory
		 * @see #onLabelFactory
		 * @see feathers.core.ITextRenderer
		 * @see feathers.core.FeathersControl#defaultTextRendererFactory
		 */
		public function get offLabelFactory():Function
		{
			return this._offLabelFactory;
		}

		/**
		 * @private
		 */
		public function set offLabelFactory(value:Function):void
		{
			if(this._offLabelFactory == value)
			{
				return;
			}
			this._offLabelFactory = value;
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

		[Bindable(event="change")]
		/**
		 * Indicates if the toggle switch is selected (ON) or not (OFF).
		 *
		 * <p>In the following example, the toggle switch is selected:</p>
		 *
		 * <listing version="3.0">
		 * toggle.isSelected = true;</listing>
		 *
		 * @default false
		 *
		 * @see #setSelectionWithAnimation()
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
			this._animateSelectionChange = false;
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.dispatchEventWith(Event.CHANGE);
		}

		/**
		 * @private
		 */
		protected var _toggleThumbSelection:Boolean = false;

		/**
		 * Determines if the <code>isSelected</code> property of the thumb
		 * is updated to match the <code>isSelected</code> property of the
		 * toggle switch, if the class used to create the thumb implements the
		 * <code>IToggle</code> interface. Useful for skinning to provide a
		 * different appearance for the thumb based on whether the toggle switch
		 * is selected or not.
		 *
		 * <p>In the following example, the thumb selection is toggled:</p>
		 *
		 * <listing version="3.0">
		 * toggle.toggleThumbSelection = true;</listing>
		 *
		 * @default false
		 *
		 * @see feathers.core.IToggle
		 * @see feathers.controls.ToggleButton
		 */
		public function get toggleThumbSelection():Boolean
		{
			return this._toggleThumbSelection;
		}

		/**
		 * @private
		 */
		public function set toggleThumbSelection(value:Boolean):void
		{
			if(this._toggleThumbSelection == value)
			{
				return;
			}
			this._toggleThumbSelection = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
		}

		/**
		 * @private
		 */
		protected var _toggleDuration:Number = 0.15;

		/**
		 * The duration, in seconds, of the animation when the toggle switch
		 * is toggled and animates the position of the thumb.
		 *
		 * <p>In the following example, the duration of the toggle switch thumb
		 * animation is updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.toggleDuration = 0.5;</listing>
		 *
		 * @default 0.15
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
		 *
		 * <p>In the following example, the easing function used by the toggle
		 * switch's thumb animation is updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.toggleEase = Transitions.EASE_IN_OUT;</listing>
		 *
		 * @default starling.animation.Transitions.EASE_OUT
		 *
		 * @see http://doc.starling-framework.org/core/starling/animation/Transitions.html starling.animation.Transitions
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
		 *
		 * <p>In the following example, the toggle switch's on label text is
		 * updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.onText = "on";</listing>
		 *
		 * @default "ON"
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
		 *
		 * <p>In the following example, the toggle switch's off label text is
		 * updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.offText = "off";</listing>
		 *
		 * @default "OFF"
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
		protected var _animateSelectionChange:Boolean = false;

		/**
		 * @private
		 */
		protected var _onTrackFactory:Function;

		/**
		 * A function used to generate the toggle switch's "on" track
		 * sub-component. The "on" track must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the "on" track when it is first created. For instance, if you are
		 * skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the "on" track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom on track factory is passed to
		 * the toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.onTrackFactory = function():Button
		 * {
		 *     var onTrack:Button = new Button();
		 *     onTrack.defaultSkin = new Image( texture );
		 *     return onTrack;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #onTrackProperties
		 */
		public function get onTrackFactory():Function
		{
			return this._onTrackFactory;
		}

		/**
		 * @private
		 */
		public function set onTrackFactory(value:Function):void
		{
			if(this._onTrackFactory == value)
			{
				return;
			}
			this._onTrackFactory = value;
			this.invalidate(INVALIDATION_FLAG_ON_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customOnTrackStyleName:String;

		/**
		 * A style name to add to the toggle switch's on track sub-component.
		 * Typically used by a theme to provide different styles to different
		 * toggle switches.
		 *
		 * <p>In the following example, a custom on track style name is passed to
		 * the toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.customOnTrackStyleName = "my-custom-on-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-on-track", setCustomOnTrackStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_ON_TRACK
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #onTrackFactory
		 * @see #onTrackProperties
		 */
		public function get customOnTrackStyleName():String
		{
			return this._customOnTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customOnTrackStyleName(value:String):void
		{
			if(this._customOnTrackStyleName == value)
			{
				return;
			}
			this._customOnTrackStyleName = value;
			this.invalidate(INVALIDATION_FLAG_ON_TRACK_FACTORY);
		}

		/**
		 * DEPRECATED: Replaced by <code>customOnTrackStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customOnTrackStyleName
		 */
		public function get customOnTrackName():String
		{
			return this.customOnTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customOnTrackName(value:String):void
		{
			this.customOnTrackStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _onTrackProperties:PropertyProxy;

		/**
		 * An object that stores properties for the toggle switch's "on" track,
		 * and the properties will be passed down to the "on" track when the
		 * toggle switch validates. For a list of available properties,
		 * refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>onTrackFactory</code> function
		 * instead of using <code>onTrackProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the toggle switch's on track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.onTrackProperties.defaultSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.controls.Button
		 * @see #onTrackFactory
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		protected var _offTrackFactory:Function;

		/**
		 * A function used to generate the toggle switch's "off" track
		 * sub-component. The "off" track must be an instance of
		 * <code>Button</code>. This factory can be used to change properties on
		 * the "off" track when it is first created. For instance, if you are
		 * skinning Feathers components without a theme, you might use this
		 * factory to set skins and other styles on the "off" track.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom off track factory is passed to
		 * the toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.offTrackFactory = function():Button
		 * {
		 *     var offTrack:Button = new Button();
		 *     offTrack.defaultSkin = new Image( texture );
		 *     return offTrack;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see feathers.controls.Button
		 * @see #offTrackProperties
		 */
		public function get offTrackFactory():Function
		{
			return this._offTrackFactory;
		}

		/**
		 * @private
		 */
		public function set offTrackFactory(value:Function):void
		{
			if(this._offTrackFactory == value)
			{
				return;
			}
			this._offTrackFactory = value;
			this.invalidate(INVALIDATION_FLAG_OFF_TRACK_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customOffTrackStyleName:String;

		/**
		 * A style name to add to the toggle switch's off track sub-component.
		 * Typically used by a theme to provide different styles to different
		 * toggle switches.
		 *
		 * <p>In the following example, a custom off track style name is passed
		 * to the toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.customOffTrackStyleName = "my-custom-off-track";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-off-track", setCustomOffTrackStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_OFF_TRACK
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #offTrackFactory
		 * @see #offTrackProperties
		 */
		public function get customOffTrackStyleName():String
		{
			return this._customOffTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customOffTrackStyleName(value:String):void
		{
			if(this._customOffTrackStyleName == value)
			{
				return;
			}
			this._customOffTrackStyleName = value;
			this.invalidate(INVALIDATION_FLAG_OFF_TRACK_FACTORY);
		}

		/**
		 * DEPRECATED: Replaced by <code>customOffTrackStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customOffTrackStyleName
		 */
		public function get customOffTrackName():String
		{
			return this.customOffTrackStyleName;
		}

		/**
		 * @private
		 */
		public function set customOffTrackName(value:String):void
		{
			this.customOffTrackStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _offTrackProperties:PropertyProxy;

		/**
		 * An object that stores properties for the toggle switch's "off" track,
		 * and the properties will be passed down to the "off" track when the
		 * toggle switch validates. For a list of available properties,
		 * refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>offTrackFactory</code> function
		 * instead of using <code>offTrackProperties</code> will result in
		 * better performance.</p>
		 *
		 * <p>In the following example, the toggle switch's off track properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.offTrackProperties.defaultSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.controls.Button
		 * @see #offTrackFactory
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		protected var _thumbFactory:Function;

		/**
		 * A function used to generate the toggle switch's thumb sub-component.
		 * This can be used to change properties on the thumb when it is first
		 * created. For instance, if you are skinning Feathers components
		 * without a theme, you might use <code>thumbFactory</code> to set
		 * skins and text styles on the thumb.
		 *
		 * <p>The function should have the following signature:</p>
		 * <pre>function():Button</pre>
		 *
		 * <p>In the following example, a custom thumb factory is passed to the
		 * toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.thumbFactory = function():Button
		 * {
		 *     var button:Button = new Button();
		 *     button.defaultSkin = new Image( texture );
		 *     return button;
		 * };</listing>
		 *
		 * @default null
		 *
		 * @see #thumbProperties
		 */
		public function get thumbFactory():Function
		{
			return this._thumbFactory;
		}

		/**
		 * @private
		 */
		public function set thumbFactory(value:Function):void
		{
			if(this._thumbFactory == value)
			{
				return;
			}
			this._thumbFactory = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * @private
		 */
		protected var _customThumbStyleName:String;

		/**
		 * A style name to add to the toggle switch's thumb sub-component.
		 * Typically used by a theme to provide different styles to different
		 * toggle switches.
		 *
		 * <p>In the following example, a custom thumb style name is passed to
		 * the toggle switch:</p>
		 *
		 * <listing version="3.0">
		 * toggle.customThumbStyleName = "my-custom-thumb";</listing>
		 *
		 * <p>In your theme, you can target this sub-component style name to
		 * provide different styles than the default:</p>
		 *
		 * <listing version="3.0">
		 * getStyleProviderForClass( Button ).setFunctionForStyleName( "my-custom-thumb", setCustomThumbStyles );</listing>
		 *
		 * @default null
		 *
		 * @see #DEFAULT_CHILD_STYLE_NAME_THUMB
		 * @see feathers.core.FeathersControl#styleNameList
		 * @see #thumbFactory
		 * @see #thumbProperties
		 */
		public function get customThumbStyleName():String
		{
			return this._customThumbStyleName;
		}

		/**
		 * @private
		 */
		public function set customThumbStyleName(value:String):void
		{
			if(this._customThumbStyleName == value)
			{
				return;
			}
			this._customThumbStyleName = value;
			this.invalidate(INVALIDATION_FLAG_THUMB_FACTORY);
		}

		/**
		 * DEPRECATED: Replaced by <code>customThumbStyleName</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 2.1. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 *
		 * @see #customThumbStyleName
		 */
		public function get customThumbName():String
		{
			return this.customThumbStyleName;
		}

		/**
		 * @private
		 */
		public function set customThumbName(value:String):void
		{
			this.customThumbStyleName = value;
		}

		/**
		 * @private
		 */
		protected var _thumbProperties:PropertyProxy;

		/**
		 * An object that stores properties for the toggle switch's thumb
		 * sub-component, and the properties will be passed down to the thumb
		 * when the toggle switch validates. For a list of available properties,
		 * refer to <a href="Button.html"><code>feathers.controls.Button</code></a>.
		 *
		 * <p>If the subcomponent has its own subcomponents, their properties
		 * can be set too, using attribute <code>&#64;</code> notation. For example,
		 * to set the skin on the thumb which is in a <code>SimpleScrollBar</code>,
		 * which is in a <code>List</code>, you can use the following syntax:</p>
		 * <pre>list.verticalScrollBarProperties.&#64;thumbProperties.defaultSkin = new Image(texture);</pre>
		 *
		 * <p>Setting properties in a <code>thumbFactory</code> function instead
		 * of using <code>thumbProperties</code> will result in better
		 * performance.</p>
		 *
		 * <p>In the following example, the toggle switch's thumb properties
		 * are updated:</p>
		 *
		 * <listing version="3.0">
		 * toggle.thumbProperties.defaultSkin = new Image( texture );</listing>
		 *
		 * @default null
		 * 
		 * @see feathers.controls.Button
		 * @see #thumbFactory
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
				var newValue:PropertyProxy = new PropertyProxy();
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
		 * Changes the <code>isSelected</code> property, but animates the thumb
		 * to the new position, as if the user tapped the toggle switch.
		 *
		 * @see #isSelected
		 */
		public function setSelectionWithAnimation(isSelected:Boolean):void
		{
			if(this._isSelected == isSelected)
			{
				return;
			}
			this.isSelected = isSelected;
			this._animateSelectionChange = true;
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			var focusInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_FOCUS);
			var layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var textRendererInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_TEXT_RENDERER);
			var thumbFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_THUMB_FACTORY);
			var onTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_ON_TRACK_FACTORY);
			var offTrackFactoryInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_OFF_TRACK_FACTORY);

			if(thumbFactoryInvalid)
			{
				this.createThumb();
			}

			if(onTrackFactoryInvalid)
			{
				this.createOnTrack();
			}

			if(offTrackFactoryInvalid || layoutInvalid)
			{
				this.createOffTrack();
			}

			if(textRendererInvalid)
			{
				this.createLabels();
			}

			if(textRendererInvalid || stylesInvalid || stateInvalid)
			{
				this.refreshOnLabelStyles();
				this.refreshOffLabelStyles();
			}

			if(thumbFactoryInvalid || stylesInvalid)
			{
				this.refreshThumbStyles();
			}
			if(onTrackFactoryInvalid || stylesInvalid)
			{
				this.refreshOnTrackStyles();
			}
			if((offTrackFactoryInvalid || layoutInvalid || stylesInvalid) && this.offTrack)
			{
				this.refreshOffTrackStyles();
			}

			if(thumbFactoryInvalid || stateInvalid)
			{
				this.thumb.isEnabled = this._isEnabled;
			}
			if(onTrackFactoryInvalid || stateInvalid)
			{
				this.onTrack.isEnabled = this._isEnabled;
			}
			if((offTrackFactoryInvalid || layoutInvalid || stateInvalid) && this.offTrack)
			{
				this.offTrack.isEnabled = this._isEnabled;
			}
			if(textRendererInvalid || stateInvalid)
			{
				this.onTextRenderer.isEnabled = this._isEnabled;
				this.offTextRenderer.isEnabled = this._isEnabled;
			}

			sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

			if(sizeInvalid || stylesInvalid || selectionInvalid)
			{
				this.updateSelection();
			}

			this.layoutChildren();

			if(sizeInvalid || focusInvalid)
			{
				this.refreshFocusIndicator();
			}
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
		 * <p>Calls <code>setSizeInternal()</code> to set up the
		 * <code>actualWidth</code> and <code>actualHeight</code> member
		 * variables used for layout.</p>
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			if(this.onTrackSkinOriginalWidth !== this.onTrackSkinOriginalWidth || //isNaN
				this.onTrackSkinOriginalHeight !== this.onTrackSkinOriginalHeight) //isNaN
			{
				this.onTrack.validate();
				this.onTrackSkinOriginalWidth = this.onTrack.width;
				this.onTrackSkinOriginalHeight = this.onTrack.height;
			}
			if(this.offTrack)
			{
				if(this.offTrackSkinOriginalWidth !== this.offTrackSkinOriginalWidth || //isNaN
					this.offTrackSkinOriginalHeight !== this.offTrackSkinOriginalHeight) //isNaN
				{
					this.offTrack.validate();
					this.offTrackSkinOriginalWidth = this.offTrack.width;
					this.offTrackSkinOriginalHeight = this.offTrack.height;
				}
			}

			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
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
		 * Creates and adds the <code>thumb</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #thumb
		 * @see #thumbFactory
		 * @see #customThumbStyleName
		 */
		protected function createThumb():void
		{
			if(this.thumb)
			{
				this.thumb.removeFromParent(true);
				this.thumb = null;
			}

			var factory:Function = this._thumbFactory != null ? this._thumbFactory : defaultThumbFactory;
			var thumbStyleName:String = this._customThumbStyleName != null ? this._customThumbStyleName : this.thumbStyleName;
			this.thumb = Button(factory());
			this.thumb.styleNameList.add(thumbStyleName);
			this.thumb.keepDownStateOnRollOut = true;
			this.thumb.addEventListener(TouchEvent.TOUCH, thumb_touchHandler);
			this.addChild(this.thumb);
		}

		/**
		 * Creates and adds the <code>onTrack</code> sub-component and
		 * removes the old instance, if one exists.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #onTrack
		 * @see #onTrackFactory
		 * @see #customOnTrackStyleName
		 */
		protected function createOnTrack():void
		{
			if(this.onTrack)
			{
				this.onTrack.removeFromParent(true);
				this.onTrack = null;
			}

			var factory:Function = this._onTrackFactory != null ? this._onTrackFactory : defaultOnTrackFactory;
			var onTrackStyleName:String = this._customOnTrackStyleName != null ? this._customOnTrackStyleName : this.onTrackStyleName;
			this.onTrack = Button(factory());
			this.onTrack.styleNameList.add(onTrackStyleName);
			this.onTrack.keepDownStateOnRollOut = true;
			this.addChildAt(this.onTrack, 0);
		}

		/**
		 * Creates and adds the <code>offTrack</code> sub-component and
		 * removes the old instance, if one exists. If the off track is not
		 * needed, it will not be created.
		 *
		 * <p>Meant for internal use, and subclasses may override this function
		 * with a custom implementation.</p>
		 *
		 * @see #offTrack
		 * @see #offTrackFactory
		 * @see #customOffTrackStyleName
		 */
		protected function createOffTrack():void
		{
			if(this._trackLayoutMode == TRACK_LAYOUT_MODE_ON_OFF)
			{
				if(this.offTrack)
				{
					this.offTrack.removeFromParent(true);
					this.offTrack = null;
				}
				var factory:Function = this._offTrackFactory != null ? this._offTrackFactory : defaultOffTrackFactory;
				var offTrackStyleName:String = this._customOffTrackStyleName != null ? this._customOffTrackStyleName : this.offTrackStyleName;
				this.offTrack = Button(factory());
				this.offTrack.styleNameList.add(offTrackStyleName);
				this.offTrack.keepDownStateOnRollOut = true;
				this.addChildAt(this.offTrack, 1);
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

			var index:int = this.getChildIndex(this.thumb);
			var offLabelFactory:Function = this._offLabelFactory;
			if(offLabelFactory == null)
			{
				offLabelFactory = this._labelFactory;
			}
			if(offLabelFactory == null)
			{
				offLabelFactory = FeathersControl.defaultTextRendererFactory;
			}
			this.offTextRenderer = ITextRenderer(offLabelFactory());
			this.offTextRenderer.styleNameList.add(this.offLabelName);
			this.offTextRenderer.clipRect = new Rectangle();
			this.addChildAt(DisplayObject(this.offTextRenderer), index);

			var onLabelFactory:Function = this._onLabelFactory;
			if(onLabelFactory == null)
			{
				onLabelFactory = this._labelFactory;
			}
			if(onLabelFactory == null)
			{
				onLabelFactory = FeathersControl.defaultTextRendererFactory;
			}
			this.onTextRenderer = ITextRenderer(onLabelFactory());
			this.onTextRenderer.styleNameList.add(this.onLabelName);
			this.onTextRenderer.clipRect = new Rectangle();
			this.addChildAt(DisplayObject(this.onTextRenderer), index);
		}

		/**
		 * @private
		 */
		protected function layoutChildren():void
		{
			this.thumb.validate();
			this.thumb.y = (this.actualHeight - this.thumb.height) / 2;

			var maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
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

			var clipRect:Rectangle = this.onTextRenderer.clipRect;
			clipRect.width = maxLabelWidth;
			clipRect.height = totalLabelHeight;
			this.onTextRenderer.clipRect = clipRect;

			this.onTextRenderer.y = (this.actualHeight - labelHeight) / 2;

			clipRect = this.offTextRenderer.clipRect;
			clipRect.width = maxLabelWidth;
			clipRect.height = totalLabelHeight;
			this.offTextRenderer.clipRect = clipRect;

			this.offTextRenderer.y = (this.actualHeight - labelHeight) / 2;

			this.layoutTracks();
		}

		/**
		 * @private
		 */
		protected function layoutTracks():void
		{
			var maxLabelWidth:Number = Math.max(0, this.actualWidth - this.thumb.width - this._paddingLeft - this._paddingRight);
			var thumbOffset:Number = this.thumb.x - this._paddingLeft;

			var onScrollOffset:Number = maxLabelWidth - thumbOffset - (maxLabelWidth - this.onTextRenderer.width) / 2;
			var currentClipRect:Rectangle = this.onTextRenderer.clipRect;
			currentClipRect.x = onScrollOffset
			this.onTextRenderer.clipRect = currentClipRect;
			this.onTextRenderer.x = this._paddingLeft - onScrollOffset;

			var offScrollOffset:Number = -thumbOffset - (maxLabelWidth - this.offTextRenderer.width) / 2;
			currentClipRect = this.offTextRenderer.clipRect;
			currentClipRect.x = offScrollOffset
			this.offTextRenderer.clipRect = currentClipRect;
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
		protected function updateSelection():void
		{
			if(this.thumb is IToggle)
			{
				var toggleThumb:IToggle = IToggle(this.thumb);
				if(this._toggleThumbSelection)
				{
					toggleThumb.isSelected = this._isSelected;
				}
				else
				{
					toggleThumb.isSelected = false;
				}
			}
			this.thumb.validate();

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

			if(this._animateSelectionChange)
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
			this._animateSelectionChange = false;
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
				var displayRenderer:DisplayObject = DisplayObject(this.onTextRenderer);
				for(var propertyName:String in properties)
				{
					var propertyValue:Object = properties[propertyName];
					displayRenderer[propertyName] = propertyValue;
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
				var displayRenderer:DisplayObject = DisplayObject(this.offTextRenderer);
				for(var propertyName:String in properties)
				{
					var propertyValue:Object = properties[propertyName];
					displayRenderer[propertyName] = propertyValue;
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
				var propertyValue:Object = this._thumbProperties[propertyName];
				this.thumb[propertyName] = propertyValue;
			}
			this.thumb.visible = this._showThumb;
		}

		/**
		 * @private
		 */
		protected function refreshOnTrackStyles():void
		{
			for(var propertyName:String in this._onTrackProperties)
			{
				var propertyValue:Object = this._onTrackProperties[propertyName];
				this.onTrack[propertyName] = propertyValue;
			}
		}

		/**
		 * @private
		 */
		protected function refreshOffTrackStyles():void
		{
			if(!this.offTrack)
			{
				return;
			}
			for(var propertyName:String in this._offTrackProperties)
			{
				var propertyValue:Object = this._offTrackProperties[propertyName];
				this.offTrack[propertyName] = propertyValue;
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

			//final validation to avoid juggler next frame issues
			this.onTrack.validate();
			this.offTrack.validate();
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

			//final validation to avoid juggler next frame issues
			this.onTrack.validate();
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
		protected function toggleSwitch_removedFromStageHandler(event:Event):void
		{
			this._touchPointID = -1;
		}

		/**
		 * @private
		 */
		override protected function focusInHandler(event:Event):void
		{
			super.focusInHandler(event);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}

		/**
		 * @private
		 */
		override protected function focusOutHandler(event:Event):void
		{
			super.focusOutHandler(event);
			this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			this.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}

		/**
		 * @private
		 */
		protected function toggleSwitch_touchHandler(event:TouchEvent):void
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

			var touch:Touch = event.getTouch(this, TouchPhase.ENDED);
			if(!touch)
			{
				return;
			}
			this._touchPointID = -1;
			touch.getLocation(this.stage, HELPER_POINT);
			var isInBounds:Boolean = this.contains(this.stage.hitTest(HELPER_POINT, true));
			if(isInBounds)
			{
				this.setSelectionWithAnimation(!this._isSelected);
			}
		}

		/**
		 * @private
		 */
		protected function thumb_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled)
			{
				this._touchPointID = -1;
				return;
			}

			if(this._touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this.thumb, null, this._touchPointID);
				if(!touch)
				{
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				var trackScrollableWidth:Number = this.actualWidth - this._paddingLeft - this._paddingRight - this.thumb.width;
				if(touch.phase == TouchPhase.MOVED)
				{
					var xOffset:Number = HELPER_POINT.x - this._touchStartX;
					var xPosition:Number = Math.min(Math.max(this._paddingLeft, this._thumbStartX + xOffset), this._paddingLeft + trackScrollableWidth);
					this.thumb.x = xPosition;
					this.layoutTracks();
				}
				else if(touch.phase == TouchPhase.ENDED)
				{
					var pixelsMoved:Number = Math.abs(HELPER_POINT.x - this._touchStartX);
					var inchesMoved:Number = pixelsMoved / DeviceCapabilities.dpi;
					if(inchesMoved > MINIMUM_DRAG_DISTANCE || (SystemUtil.isDesktop && pixelsMoved >= 1))
					{
						this._touchPointID = -1;
						this._ignoreTapHandler = true;
						this.setSelectionWithAnimation(this.thumb.x > (this._paddingLeft + trackScrollableWidth / 2));
						//we still need to invalidate, even if there's no change
						//because the thumb may be in the middle!
						this.invalidate(INVALIDATION_FLAG_SELECTED);
					}
				}
			}
			else
			{
				touch = event.getTouch(this.thumb, TouchPhase.BEGAN);
				if(!touch)
				{
					return;
				}
				touch.getLocation(this, HELPER_POINT);
				this._touchPointID = touch.id;
				this._thumbStartX = this.thumb.x;
				this._touchStartX = HELPER_POINT.x;
			}
		}

		/**
		 * @private
		 */
		protected function stage_keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.ESCAPE)
			{
				this._touchPointID = -1;
			}
			if(this._touchPointID >= 0 || event.keyCode != Keyboard.SPACE)
			{
				return;
			}
			this._touchPointID = int.MAX_VALUE;
		}

		/**
		 * @private
		 */
		protected function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if(this._touchPointID != int.MAX_VALUE || event.keyCode != Keyboard.SPACE)
			{
				return;
			}
			this._touchPointID = -1;
			this.setSelectionWithAnimation(!this._isSelected);
		}

		/**
		 * @private
		 */
		protected function selectionTween_onUpdate():void
		{
			this.layoutTracks();
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