/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.core.IGroupedToggle;
	import feathers.core.ToggleGroup;
	import feathers.events.FeathersEventType;
	import feathers.skins.IStyleProvider;
	import feathers.utils.keyboard.KeyToSelect;
	import feathers.utils.touch.TapToSelect;

	import flash.ui.Keyboard;

	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextFormat;

	[Exclude(name="defaultSelectedLabelProperties",kind="property")]
	[Exclude(name="selectedUpLabelProperties",kind="property")]
	[Exclude(name="selectedDownLabelProperties",kind="property")]
	[Exclude(name="selectedHoverLabelProperties",kind="property")]
	[Exclude(name="selectedDisabledLabelProperties",kind="property")]

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
	 * @see #style:defaultIcon
	 * @see #setIconForState()
	 */
	[Style(name="defaultSelectedIcon",type="starling.display.DisplayObject")]

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
	 * @see #style:defaultSkin
	 * @see #setSkinForState()
	 */
	[Style(name="defaultSelectedSkin",type="starling.display.DisplayObject")]

	/**
	 * If not <code>NaN</code>, the button renders at this scale when selected.
	 * Otherwise, defaults to <code>1</code>.
	 *
	 * <p>The following example scales the button when selected:</p>
	 *
	 * <listing version="3.0">
	 * button.scaleWhenSelected = 0.9;</listing>
	 *
	 * @default 1
	 * 
	 * @see #isSelected
	 * @see #getScaleForState()
	 * @see #setScaleForState()
	 */
	[Style(name="scaleWhenSelected",type="Number")]

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
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>ButtonState.DISABLED_AND_SELECTED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * button.setIconForState( ButtonState.DISABLED_AND_SELECTED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #style:defaultSelectedIcon
	 * @see feathers.controls.ButtonState#DISABLED_AND_SELECTED
	 */
	[Style(name="selectedDisabledIcon",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>ButtonState.DISABLED_AND_SELECTED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * button.setSkinForState( ButtonState.DISABLED_AND_SELECTED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultSkin
	 * @see #style:defaultSelectedSkin
	 * @see feathers.controls.ButtonState#DISABLED_AND_SELECTED
	 */
	[Style(name="selectedDisabledSkin",type="starling.display.DisplayObject")]

	/**
	 * The font styles used to display the button's text when the button is
	 * selected.
	 *
	 * <p>In the following example, the selected font styles are customized:</p>
	 *
	 * <listing version="3.0">
	 * button.selectedFontStyles = new TextFormat( "Helvetica", 20, 0x999999 );</listing>
	 *
	 * <p>Note: The <code>starling.text.TextFormat</code> class defines a
	 * number of common font styles, but the text renderer being used may
	 * support a larger number of ways to be customized. Use the
	 * <code>labelFactory</code> to set more advanced styles on the
	 * text renderer.</p>
	 *
	 * @default null
	 *
	 * @see http://doc.starling-framework.org/current/starling/text/TextFormat.html starling.text.TextFormat
	 * @see #style:fontStyles
	 */
	[Style(name="selectedFontStyles",type="starling.text.TextFormat")]

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
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>ButtonState.HOVER_AND_SELECTED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * button.setIconForState( ButtonState.HOVER_AND_SELECTED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #style:defaultSelectedIcon
	 * @see feathers.controls.ButtonState#HOVER_AND_SELECTED
	 */
	[Style(name="selectedHoverIcon",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>ButtonState.HOVER_AND_SELECTED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * button.setSkinForState( ButtonState.HOVER_AND_SELECTED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultSkin
	 * @see #style:defaultSelectedSkin
	 * @see feathers.controls.ButtonState#HOVER_AND_SELECTED
	 */
	[Style(name="selectedHoverSkin",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>ButtonState.DOWN_AND_SELECTED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * button.setIconForState( ButtonState.DOWN_AND_SELECTED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #style:defaultSelectedIcon
	 * @see feathers.controls.ButtonState#DOWN_AND_SELECTED
	 */
	[Style(name="selectedDownIcon",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>ButtonState.DOWN_AND_SELECTED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * button.setSkinForState( ButtonState.DOWN_AND_SELECTED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultSkin
	 * @see #style:defaultSelectedSkin
	 * @see feathers.controls.ButtonState#DOWN_AND_SELECTED
	 */
	[Style(name="selectedDownSkin",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setIconForState()</code> with
	 * <code>ButtonState.UP_AND_SELECTED</code> to set the same icon:</p>
	 *
	 * <listing version="3.0">
	 * var icon:Image = new Image( texture );
	 * button.setIconForState( ButtonState.UP_AND_SELECTED, icon );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultIcon
	 * @see #style:defaultSelectedIcon
	 * @see feathers.controls.ButtonState#UP_AND_SELECTED
	 */
	[Style(name="selectedUpIcon",type="starling.display.DisplayObject")]

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
	 * <p>Alternatively, you may use <code>setSkinForState()</code> with
	 * <code>ButtonState.UP_AND_SELECTED</code> to set the same skin:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * button.setSkinForState( ButtonState.UP_AND_SELECTED, skin );</listing>
	 *
	 * @default null
	 *
	 * @see #style:defaultSkin
	 * @see #style:defaultSelectedSkin
	 * @see feathers.controls.ButtonState#UP_AND_SELECTED
	 */
	[Style(name="selectedUpSkin",type="starling.display.DisplayObject")]

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
	 *
	 * @productversion Feathers 2.0.0
	 */
	public class ToggleButton extends Button implements IGroupedToggle
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
		protected var dpadEnterKeyToSelect:KeyToSelect;

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
		 * <p><strong>Warning:</strong> Do not listen to
		 * <code>Event.TRIGGERED</code> to be notified when the
		 * <code>isSelected</code> property changes. You must listen to
		 * <code>Event.CHANGE</code>.</p>
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

		/**
		 * @private
		 */
		protected var _defaultSelectedSkin:DisplayObject;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._defaultSelectedSkin === value)
			{
				return;
			}
			if(this._defaultSelectedSkin !== null &&
				this.currentSkin === this._defaultSelectedSkin)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentSkin(this._defaultSelectedSkin);
				this.currentSkin = null;
			}
			this._defaultSelectedSkin = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
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
		 * @private
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
		 * @private
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
		 * @private
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
		public function get selectedFontStyles():TextFormat
		{
			return this._fontStylesSet.selectedFormat;
		}

		/**
		 * @private
		 */
		public function set selectedFontStyles(value:TextFormat):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			var savedCallee:Function = arguments.callee;
			function changeHandler(event:Event):void
			{
				processStyleRestriction(savedCallee);
			}
			if(value !== null)
			{
				value.removeEventListener(Event.CHANGE, changeHandler);
			}
			this._fontStylesSet.selectedFormat = value;
			if(value !== null)
			{
				value.addEventListener(Event.CHANGE, changeHandler);
			}
		}

		/**
		 * @private
		 */
		protected var _defaultSelectedIcon:DisplayObject;

		/**
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._defaultSelectedIcon === value)
			{
				return;
			}
			if(this._defaultSelectedIcon !== null &&
				this.currentIcon === this._defaultSelectedIcon)
			{
				//if this icon needs to be reused somewhere else, we need to
				//properly clean it up
				this.removeCurrentIcon(this._defaultSelectedIcon);
				this.currentIcon = null;
			}
			this._defaultSelectedIcon = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
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
		 * @private
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
		 * @private
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
		 * @private
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
		protected var _scaleWhenSelected:Number = 1;

		/**
		 * @private
		 */
		public function get scaleWhenSelected():Number
		{
			return this._scaleWhenSelected;
		}

		/**
		 * @private
		 */
		public function set scaleWhenSelected(value:Number):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._scaleWhenSelected == value)
			{
				return;
			}
			this._scaleWhenSelected = value;
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
			if(this.keyToSelect !== null)
			{
				//setting the target to null will remove listeners and do any
				//other clean up that is needed
				this.keyToSelect.target = null;
			}
			if(this.dpadEnterKeyToSelect !== null)
			{
				this.dpadEnterKeyToSelect.target = null;
			}
			if(this.tapToSelect !== null)
			{
				this.tapToSelect.target = null;
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
			if(!this.dpadEnterKeyToSelect)
			{
				this.dpadEnterKeyToSelect = new KeyToSelect(this, Keyboard.ENTER);
				this.dpadEnterKeyToState.keyLocation = 4; //KeyLocation.D_PAD is only in AIR
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
				this.refreshSelectionEvents();
			}

			super.draw();
		}

		/**
		 * @private
		 */
		override protected function getCurrentSkin():DisplayObject
		{
			//we use the currentState getter here instead of the variable
			//because the variable does not keep track of the selection
			var result:DisplayObject = this._stateToSkin[this.currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			if(this._isSelected && this._defaultSelectedSkin !== null)
			{
				return this._defaultSelectedSkin;
			}
			return this._defaultSkin;
		}

		/**
		 * @private
		 */
		override protected function getCurrentIcon():DisplayObject
		{
			//we use the currentState getter here instead of the variable
			//because the variable does not keep track of the selection
			var result:DisplayObject = this._stateToIcon[this.currentState] as DisplayObject;
			if(result !== null)
			{
				return result;
			}
			if(this._isSelected && this._defaultSelectedIcon !== null)
			{
				return this._defaultSelectedIcon;
			}
			return this._defaultIcon;
		}

		/**
		 * @private
		 */
		override protected function getScaleForCurrentState(state:String = null):Number
		{
			if(state === null)
			{
				state = this.currentState;
			}
			if(state in this._stateToScale)
			{
				return this._stateToScale[state];
			}
			else if(this._isSelected)
			{
				return this._scaleWhenSelected;
			}
			return 1;
		}

		/**
		 * @private
		 */
		protected function refreshSelectionEvents():void
		{
			this.tapToSelect.isEnabled = this._isEnabled && this._isToggle;
			this.tapToSelect.tapToDeselect = this._isToggle;
			this.keyToSelect.isEnabled = this._isEnabled && this._isToggle;
			this.keyToSelect.keyToDeselect = this._isToggle;
			this.dpadEnterKeyToSelect.isEnabled = this._isEnabled && this._isToggle;
			this.dpadEnterKeyToSelect.keyToDeselect = this._isToggle;
		}
	}
}
