/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IToggle;
	import feathers.core.PropertyProxy;
	import feathers.skins.IStyleProvider;

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
	public class ToggleButton extends Button implements IToggle
	{
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
			this._isToggle = value;
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
			if(this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			this.invalidate(INVALIDATION_FLAG_SELECTED);
			this.invalidate(INVALIDATION_FLAG_STATE);
			this.dispatchEventWith(Event.CHANGE);
		}

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
			return DisplayObject(this._skinSelector.defaultSelectedValue);
		}

		/**
		 * @private
		 */
		public function set defaultSelectedSkin(value:DisplayObject):void
		{
			if(this._skinSelector.defaultSelectedValue == value)
			{
				return;
			}
			this._skinSelector.defaultSelectedValue = value;
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
		 */
		public function get selectedUpSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_UP, true));
		}

		/**
		 * @private
		 */
		public function set selectedUpSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_UP, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_UP, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedDownSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_DOWN, true));
		}

		/**
		 * @private
		 */
		public function set selectedDownSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DOWN, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DOWN, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedHoverSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_HOVER, true));
		}

		/**
		 * @private
		 */
		public function set selectedHoverSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_HOVER, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_HOVER, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedDisabledSkin():DisplayObject
		{
			return DisplayObject(this._skinSelector.getValueForState(STATE_DISABLED, true));
		}

		/**
		 * @private
		 */
		public function set selectedDisabledSkin(value:DisplayObject):void
		{
			if(this._skinSelector.getValueForState(STATE_DISABLED, true) == value)
			{
				return;
			}
			this._skinSelector.setValueForState(value, STATE_DISABLED, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * The default selected label properties are a set of key/value pairs to
		 * be passed down ot the button's label text renderer, and it is used
		 * when the button is selected and no specific properties are defined
		 * for the button's current state. If <code>null</code>, then
		 * <code>defaultLabelProperties</code> is used instead. The label
		 * text renderer is an <code>ITextRenderer</code> instance. The
		 * available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>labelFactory</code>. The most
		 * common implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>The following example gives the button default label properties to
		 * use for all selected states when no specific label properties are
		 * available:</p>
		 *
		 * <listing version="3.0">
		 * button.defaultSelectedLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );
		 * button.defaultSelectedLabelProperties.wordWrap = true;</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 * @see #defaultLabelProperties
		 */
		public function get defaultSelectedLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._labelPropertiesSelector.defaultSelectedValue = value;
			}
			return value;
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
			var oldValue:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.defaultSelectedValue);
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._labelPropertiesSelector.defaultSelectedValue = value;
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * A set of key/value pairs to be passed down ot the button's label
		 * text renderer when the button is in the up state and is selected. If
		 * <code>null</code>, then <code>defaultSelectedLabelProperties</code>
		 * is used instead. If <code>defaultSelectedLabelProperties</code> is also
		 * <code>null</code>, then <code>defaultLabelProperties</code> is used.
		 * The label text renderer is an <code>ITextRenderer</code> instance.
		 * The available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>labelFactory</code>. The most
		 * common implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>The following example gives the button label properties for the
		 * selected up state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedUpLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 * @see #defaultLabelProperties
		 * @see #defaultSelectedLabelProperties
		 * @see #upLabelProperties
		 */
		public function get selectedUpLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, true));
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._labelPropertiesSelector.setValueForState(value, STATE_UP, true);
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
			var oldValue:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_UP, true));
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._labelPropertiesSelector.setValueForState(value, STATE_UP, true);
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * A set of key/value pairs to be passed down ot the button's label
		 * text renderer when the button is in the down state and is selected.
		 * If <code>null</code>, then <code>defaultSelectedLabelProperties</code>
		 * is used instead. If <code>defaultSelectedLabelProperties</code> is also
		 * <code>null</code>, then <code>defaultLabelProperties</code> is used.
		 * The label text renderer is an <code>ITextRenderer</code> instance.
		 * The available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>labelFactory</code>. The most
		 * common implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>The following example gives the button label properties for the
		 * selected down state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDownLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 * @see #defaultLabelProperties
		 * @see #defaultSelectedLabelProperties
		 * @see #downLabelProperties
		 */
		public function get selectedDownLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, true));
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._labelPropertiesSelector.setValueForState(value, STATE_DOWN, true);
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
			var oldValue:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DOWN, true));
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._labelPropertiesSelector.setValueForState(value, STATE_DOWN, true);
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * A set of key/value pairs to be passed down ot the button's label
		 * text renderer when the button is in the hover state and is selected.
		 * If <code>null</code>, then <code>defaultSelectedLabelProperties</code>
		 * is used instead. If <code>defaultSelectedLabelProperties</code> is also
		 * <code>null</code>, then <code>defaultLabelProperties</code> is used.
		 * The label text renderer is an <code>ITextRenderer</code> instance.
		 * The available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>labelFactory</code>. The most
		 * common implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>The following example gives the button label properties for the
		 * selected hover state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedHoverLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 * @see #defaultLabelProperties
		 * @see #defaultSelectedLabelProperties
		 * @see #hoverLabelProperties
		 */
		public function get selectedHoverLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, true));
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._labelPropertiesSelector.setValueForState(value, STATE_HOVER, true);
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
			var oldValue:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_HOVER, true));
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._labelPropertiesSelector.setValueForState(value, STATE_HOVER, true);
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * A set of key/value pairs to be passed down ot the button's label
		 * text renderer when the button is in the disabled state and is
		 * selected. If <code>null</code>, then <code>defaultSelectedLabelProperties</code>
		 * is used instead. If <code>defaultSelectedLabelProperties</code> is also
		 * <code>null</code>, then <code>defaultLabelProperties</code> is used.
		 * The label text renderer is an <code>ITextRenderer</code> instance.
		 * The available properties depend on which <code>ITextRenderer</code>
		 * implementation is returned by <code>labelFactory</code>. The most
		 * common implementations are <code>BitmapFontTextRenderer</code> and
		 * <code>TextFieldTextRenderer</code>.
		 *
		 * <p>The following example gives the button label properties for the
		 * selected disabled state:</p>
		 *
		 * <listing version="3.0">
		 * button.selectedDisabledLabelProperties.textFormat = new BitmapFontTextFormat( bitmapFont );</listing>
		 *
		 * @default null
		 *
		 * @see feathers.core.ITextRenderer
		 * @see feathers.controls.text.BitmapFontTextRenderer
		 * @see feathers.controls.text.TextFieldTextRenderer
		 * @see #defaultLabelProperties
		 * @see #defaultSelectedLabelProperties
		 * @see #disabledLabelProperties
		 */
		public function get selectedDisabledLabelProperties():Object
		{
			var value:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, true));
			if(!value)
			{
				value = new PropertyProxy(childProperties_onChange);
				this._labelPropertiesSelector.setValueForState(value, STATE_DISABLED, true);
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
			var oldValue:PropertyProxy = PropertyProxy(this._labelPropertiesSelector.getValueForState(STATE_DISABLED, true));
			if(oldValue)
			{
				oldValue.removeOnChangeCallback(childProperties_onChange);
			}
			this._labelPropertiesSelector.setValueForState(value, STATE_DISABLED, true);
			if(value)
			{
				PropertyProxy(value).addOnChangeCallback(childProperties_onChange);
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

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
			return DisplayObject(this._iconSelector.defaultSelectedValue);
		}

		/**
		 * @private
		 */
		public function set defaultSelectedIcon(value:DisplayObject):void
		{
			if(this._iconSelector.defaultSelectedValue == value)
			{
				return;
			}
			this._iconSelector.defaultSelectedValue = value;
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
		 */
		public function get selectedUpIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_UP, true));
		}

		/**
		 * @private
		 */
		public function set selectedUpIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_UP, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_UP, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedDownIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_DOWN, true));
		}

		/**
		 * @private
		 */
		public function set selectedDownIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DOWN, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DOWN, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedHoverIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_HOVER, true));
		}

		/**
		 * @private
		 */
		public function set selectedHoverIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_HOVER, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_HOVER, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
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
		 */
		public function get selectedDisabledIcon():DisplayObject
		{
			return DisplayObject(this._iconSelector.getValueForState(STATE_DISABLED, true));
		}

		/**
		 * @private
		 */
		public function set selectedDisabledIcon(value:DisplayObject):void
		{
			if(this._iconSelector.getValueForState(STATE_DISABLED, true) == value)
			{
				return;
			}
			this._iconSelector.setValueForState(value, STATE_DISABLED, true);
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function trigger():void
		{
			super.trigger();
			if(this._isToggle)
			{
				this.isSelected = !this._isSelected;
			}
		}
	}
}
