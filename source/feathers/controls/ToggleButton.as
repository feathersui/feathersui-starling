/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IGroupedToggle;
	import feathers.core.PropertyProxy;
	import feathers.core.ToggleGroup;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.keyboard.KeyToSelect;
	import feathers.utils.touch.TapToSelect;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Dispatched when the button is selected or deselected either
	 * programmatically or as a result of user interaction. The value of the
	 * <code>isSelected</code> property indicates whether the button is selected
	 * or not. Use interaction may only change selection when the
	 * <code>isToggle</code> property is set to <code>true</code>.
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
	 * @eventType starling.events.Event.CHANGE
	 *
	 * @see #isSelected
	 * @see #isToggle
	 */
	[Event(name="change",type="starling.events.Event")]

	/**
	 * A button that may be selected and deselected when triggered.
	 *
	 * <p>The following example creates a toggle button, and listens for when
	 * its selection changes:</p>
	 *
	 * <listing version="3.0">
	 * var button:ToggleButton = new ToggleButton();
	 * button.label = "Click Me";
	 * button.addEventListener( Event.CHANGE, button_changeHandler );
	 * this.addChild( button );</listing>
	 *
	 * @see ../../../help/toggle-button.html How to use the Feathers ToggleButton component
	 */
	public class ToggleButton extends Button implements IGroupedToggle
	{
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP:String = "up";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER:String = "hover";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED:String = "disabled";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * @private
		 *
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED_AND_SELECTED:String = "disabledAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.TOP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_TOP:String = "top";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT:String = "right";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.BOTTOM</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.MANUAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.LEFT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.RelativePosition.RIGHT_BASELINE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_CENTER
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_RIGHT
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_TOP
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_BOTTOM
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * The default <code>IStyleProvider</code> for all <code>ToggleButton</code>
		 * components. If <code>null</code>, falls back to using
		 * <code>Button.globalStyleProvider</code> instead.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 * @see feathers.controls.Button#globalStyleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function ToggleButton()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(ToggleButton.globalStyleProvider)
			{
				return ToggleButton.globalStyleProvider;
			}
			return Button.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function get currentState():String
		{
			if(this._isSelected)
			{
				return super.currentState + "AndSelected";
			}
			return super.currentState;
		}

		/**
		 * @private
		 */
		protected var tapToSelect:TapToSelect;

		/**
		 * @private
		 */
		protected var keyToSelect:KeyToSelect;

		/**
		 * @private
		 */
		protected var _isToggle:Boolean = true;

		/**
		 * Determines if the button may be selected or deselected as a result of
		 * user interaction. If <code>true</code>, the value of the
		 * <code>isSelected</code> property will be toggled when the button is
		 * triggered.
		 *
		 * <p>The following example disables the ability to toggle:</p>
		 *
		 * <listing version="3.0">
		 * button.isToggle = false;</listing>
		 *
		 * @default true
		 *
		 * @see #isSelected
		 * @see #event:triggered Event.TRIGGERED
		 */
		public function get isToggle():Boolean
		{
			return this._isToggle;
		}

		/**
		 * @private
		 */
		public function set isToggle(value:Boolean):void
		{
			if(this._isToggle === value)
			{
				return;
			}
			this._isToggle = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _isSelected:Boolean = false;

		/**
		 * Indicates if the button is selected or not. The button may be
		 * selected programmatically, even if <code>isToggle</code> is <code>false</code>,
		 * but generally, <code>isToggle</code> should be set to <code>true</code>
		 * to allow the user to select and deselect it by triggering the button
		 * with a click or tap. If focus management is enabled, a button may
		 * also be triggered with the spacebar when the button has focus.
		 *
		 * <p>The following example enables the button to toggle and selects it
		 * automatically:</p>
		 *
		 * <listing version="3.0">
		 * button.isToggle = true;
		 * button.isSelected = true;</listing>
		 *
		 * @default false
		 *
		 * @see #event:change Event.CHANGE
		 * @see #isToggle
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
			if(this._isSelected === value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(Event.CHANGE);
			this.dispatchEventWith(FeathersEventType.STATE_CHANGE);
		}

		/**
		 * @private
		 */
		protected var _toggleGroup:ToggleGroup;

		/**
		 * @inheritDoc
		 */
		public function get toggleGroup():ToggleGroup
		{
			return this._toggleGroup;
		}

		/**
		 * @private
		 */
		public function set toggleGroup(value:ToggleGroup):void
		{
			if(this._toggleGroup == value)
			{
				return;
			}
			if(this._toggleGroup && this._toggleGroup.hasItem(this))
			{
				this._toggleGroup.removeItem(this);
			}
			this._toggleGroup = value;
			if(this._toggleGroup && !this._toggleGroup.hasItem(this))
			{
				this._toggleGroup.addItem(this);
			}
		}
		
		protected var _defaultSelectedSkin:DisplayObject;

		/**
		 * The skin used when no other skin is defined for the current state
		 * when the button is selected. Has a higher priority than
		 * <code>defaultSkin</code>, but a lower priority than other selected
		 * skins.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a default skin to use for
		 * all selected states when no specific skin is available:</p>
		 *
		 * <listing version="3.0">
		 * button.defaultSelectedSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #selectedUpSkin
		 * @see #selectedDownSkin
		 * @see #selectedHoverSkin
		 * @see #selectedDisabledSkin
		 */
		public function get defaultSelectedSkin():DisplayObject
		{
			return this._defaultSelectedSkin;
		}

		/**
		 * @private
		 */
		public function set defaultSelectedSkin(value:DisplayObject):void
		{
			if(this._defaultSelectedSkin === value)
			{
				return;
			}
			this._defaultSelectedSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The skin used for the button's up state when the button is selected.
		 * If <code>null</code>, then <code>defaultSelectedSkin</code> is used
		 * instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the selected up state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedUpSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 * @see feathers.controls.ButtonState.UP_AND_SELECTED
		 */
		public function get selectedUpSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.UP_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedUpSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.UP_AND_SELECTED, value);
		}

		/**
		 * The skin used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the selected down state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDownSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 * @see feathers.controls.ButtonState.DOWN_AND_SELECTED
		 */
		public function get selectedDownSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.DOWN_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedDownSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.DOWN_AND_SELECTED, value);
		}

		/**
		 * The skin used for the button's hover state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the selected hover state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedHoverSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 * @see feathers.controls.ButtonState.HOVER_AND_SELECTED
		 */
		public function get selectedHoverSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.HOVER_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedHoverSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.HOVER_AND_SELECTED, value);
		}

		/**
		 * The skin used for the button's disabled state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedSkin</code>
		 * is used instead. If <code>defaultSelectedSkin</code> is also
		 * <code>null</code>, then <code>defaultSkin</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToSkinFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a skin for the selected disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDisabledSkin = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultSkin
		 * @see #defaultSelectedSkin
		 * @see feathers.controls.ButtonState.DISABLED_AND_SELECTED
		 */
		public function get selectedDisabledSkin():DisplayObject
		{
			return this.getSkinForState(ButtonState.DISABLED_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedDisabledSkin(value:DisplayObject):void
		{
			this.setSkinForState(ButtonState.DISABLED_AND_SELECTED, value);
		}

		/**
		 * @private
		 */
		protected var _defaultSelectedLabelProperties:PropertyProxy;

		/**
		 * DEPRECATED: Use the appropriate API on the label text renderer to set
		 * font styles for a particular state.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get defaultSelectedLabelProperties():Object
		{
			if(this._defaultSelectedLabelProperties === null)
			{
				this._defaultSelectedLabelProperties = new PropertyProxy(childProperties_onChange);
			}
			return this._defaultSelectedLabelProperties;
		}

		/**
		 * @private
		 */
		public function set defaultSelectedLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			if(this._defaultSelectedLabelProperties !== null)
			{
				this._defaultSelectedLabelProperties.removeOnChangeCallback(childProperties_onChange);
			}
			this._defaultSelectedLabelProperties.defaultSelectedValue = value;
			if(this._defaultSelectedLabelProperties !== null)
			{
				this._defaultSelectedLabelProperties.addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Use the appropriate API on the label text renderer to set
		 * font styles for a particular state.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get selectedUpLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.UP_AND_SELECTED]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.UP_AND_SELECTED] = value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set selectedUpLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.UP_AND_SELECTED]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.UP_AND_SELECTED] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Use the appropriate API on the label text renderer to set
		 * font styles for a particular state.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get selectedDownLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DOWN_AND_SELECTED]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.DOWN_AND_SELECTED] = value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set selectedDownLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DOWN_AND_SELECTED]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.DOWN_AND_SELECTED] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Use the appropriate API on the label text renderer to set
		 * font styles for a particular state.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get selectedHoverLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.HOVER_AND_SELECTED]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.HOVER_AND_SELECTED] = value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set selectedHoverLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.HOVER_AND_SELECTED]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.HOVER_AND_SELECTED] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * DEPRECATED: Use the appropriate API on the label text renderer to set
		 * font styles for a particular state.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This property is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public function get selectedDisabledLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DISABLED_AND_SELECTED]);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._stateToLabelProperties[ButtonState.DISABLED_AND_SELECTED] = value;
			}
			return value;
		}

		/**
		 * @private
		 */
		public function set selectedDisabledLabelProperties(value:Object):void
		{
			if(!(value is PropertyProxy))
			{
				value = PropertyProxy.fromObject(value);
			}
			var oldValue:PropertyProxy = PropertyProxy(this._stateToLabelProperties[ButtonState.DISABLED_AND_SELECTED]);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._stateToLabelProperties[ButtonState.DISABLED_AND_SELECTED] = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _defaultSelectedIcon:DisplayObject;

		/**
		 * The icon used when no other icon is defined for the current state
		 * when the button is selected. Has a higher priority than
		 * <code>defaultIcon</code>, but a lower priority than other selected
		 * icons.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button a default icon to use for
		 * all selected states when no specific icon is available:</p>
		 *
		 * <listing version="3.0">
		 * button.defaultSelectedIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #selectedUpIcon
		 * @see #selectedDownIcon
		 * @see #selectedHoverIcon
		 * @see #selectedDisabledIcon
		 */
		public function get defaultSelectedIcon():DisplayObject
		{
			return this._defaultSelectedIcon;
		}

		/**
		 * @private
		 */
		public function set defaultSelectedIcon(value:DisplayObject):void
		{
			if(this._defaultSelectedIcon === value)
			{
				return;
			}
			this._defaultSelectedIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The icon used for the button's up state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the selected up state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedUpIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 * @see ButtonState.UP_AND_SELECTED
		 */
		public function get selectedUpIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.UP_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedUpIcon(value:DisplayObject):void
		{
			this.setIconForState(ButtonState.UP_AND_SELECTED, value);
		}

		/**
		 * The icon used for the button's down state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the selected down state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDownIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 * @see ButtonState.DOWN_AND_SELECTED
		 */
		public function get selectedDownIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.DOWN_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedDownIcon(value:DisplayObject):void
		{
			this.setIconForState(ButtonState.DOWN_AND_SELECTED, value);
		}

		/**
		 * The icon used for the button's hover state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the selected hover state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedHoverIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 * @see ButtonState.HOVER_AND_SELECTED
		 */
		public function get selectedHoverIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.HOVER_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedHoverIcon(value:DisplayObject):void
		{
			this.setIconForState(ButtonState.HOVER_AND_SELECTED, value);
		}

		/**
		 * The icon used for the button's disabled state when the button is
		 * selected. If <code>null</code>, then <code>defaultSelectedIcon</code>
		 * is used instead. If <code>defaultSelectedIcon</code> is also
		 * <code>null</code>, then <code>defaultIcon</code> is used.
		 *
		 * <p>This property will be ignored if a function is passed to the
		 * <code>stateToIconFunction</code> property.</p>
		 *
		 * <p>The following example gives the button an icon for the selected disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDisabledIcon = new Image( texture );</listing>
		 *
		 * @default null
		 *
		 * @see #defaultIcon
		 * @see #defaultSelectedIcon
		 * @see ButtonState.DISABLED_AND_SELECTED
		 */
		public function get selectedDisabledIcon():DisplayObject
		{
			return this.getIconForState(ButtonState.DISABLED_AND_SELECTED);
		}

		/**
		 * @private
		 */
		public function set selectedDisabledIcon(value:DisplayObject):void
		{
			this.setIconForState(ButtonState.DISABLED_AND_SELECTED, value);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._defaultSelectedSkin && this._defaultSelectedSkin.parent !== this)
			{
				this._defaultSelectedSkin.dispose();
			}
			if(this._defaultSelectedIcon && this._defaultSelectedIcon.parent !== this)
			{
				this._defaultSelectedIcon.dispose();
			}
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			super.initialize();
			if(!this.tapToSelect)
			{
				this.tapToSelect = new TapToSelect(this);
				this.longPress.tapToSelect = this.tapToSelect;
			}
			if(!this.keyToSelect)
			{
				this.keyToSelect = new KeyToSelect(this);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			var stylesInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STYLES);
			var stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			
			if(stylesInvalid || stateInvalid)
			{
				this.tapToSelect.isEnabled = this._isEnabled && this._isToggle;
				this.tapToSelect.tapToDeselect = this._isToggle;
				this.keyToSelect.isEnabled = this._isEnabled && this._isToggle;
				this.keyToSelect.keyToDeselect = this._isToggle;
			}
			
			super.draw();
		}

		/**
		 * @private
		 */
		override protected function getCurrentSkin():DisplayObject
		{
			if(this._stateToSkinFunction === null)
			{
				var result:DisplayObject = this._stateToSkin[this._currentState] as DisplayObject;
				if(result)
				{
					return result;
				}
				if(this._isSelected && this._defaultSelectedSkin !== null)
				{
					return this._defaultSelectedSkin;
				}
				return this._defaultSkin;
			}
			return super.getCurrentSkin();
		}

		/**
		 * @private
		 */
		override protected function getCurrentIcon():DisplayObject
		{
			if(this._stateToIconFunction === null)
			{
				var result:DisplayObject = this._stateToIcon[this._currentState] as DisplayObject;
				if(result)
				{
					return result;
				}
				if(this._isSelected && this._defaultSelectedIcon !== null)
				{
					return this._defaultSelectedIcon;
				}
				return this._defaultIcon;
			}
			return super.getCurrentIcon();
		}
	}
}
