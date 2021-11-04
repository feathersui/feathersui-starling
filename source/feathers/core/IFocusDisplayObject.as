/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	/**
	 * Dispatched when the display object receives focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_IN
	 */
	[Event(name="focusIn",type="starling.events.Event")]

	/**
	 * Dispatched when the display object loses focus.
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
	 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
	 */
	[Event(name="focusOut",type="starling.events.Event")]

	/**
	 * A component that can receive focus if a focus manager is enabled.
	 *
	 * @see ../../../help/focus.html Keyboard focus management in Feathers
	 *
	 * @productversion Feathers 1.1.0
	 */
	public interface IFocusDisplayObject extends IFeathersDisplayObject
	{
		/**
		 * The current focus manager for this component. May be
		 * <code>null</code> if no focus manager is enabled.
		 */
		function get focusManager():IFocusManager;

		/**
		 * @private
		 */
		function set focusManager(value:IFocusManager):void;

		/**
		 * Determines if this component can receive focus.
		 *
		 * <p>In the following example, the focus is disabled:</p>
		 *
		 * <listing version="3.0">
		 * object.isFocusEnabled = false;</listing>
		 */
		function get isFocusEnabled():Boolean;

		/**
		 * @private
		 */
		function set isFocusEnabled(value:Boolean):void;

		/**
		 * The next object that will receive focus when the tab key is pressed
		 * when a focus manager is enabled. If <code>null</code>, defaults to
		 * the next child on the display list.
		 *
		 * <p>In the following example, the next tab focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextTabFocus = otherObject;</listing>
		 */
		function get nextTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextTabFocus(value:IFocusDisplayObject):void;

		/**
		 * The previous object that will receive focus when the tab key is
		 * pressed while holding shift when a focus manager is enabled. If
		 * <code>null</code>, defaults to the previous child on the display
		 * list.
		 *
		 * <p>In the following example, the previous tab focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.previousTabFocus = otherObject;</listing>
		 */
		function get previousTabFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set previousTabFocus(value:IFocusDisplayObject):void;

		/**
		 * The next object that will receive focus when
		 * <code>Keyboard.UP</code> is pressed at
		 * <code>KeyLocation.D_PAD</code> and a focus manager is enabled. If
		 * <code>null</code>, defaults to the best available child, as
		 * determined by the focus manager.
		 *
		 * <p>In the following example, the next up focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextUpFocus = otherObject;</listing>
		 *
		 * <p>To simulate <code>KeyLocation.D_PAD</code> in the AIR Debug
		 * Launcher on desktop for debugging purposes, set
		 * <code>DeviceCapabilities.simulateDPad</code> to <code>true</code>.</p>
		 *
		 * @see feathers.system.DeviceCapabilities#simulateDPad
		 *
		 * @productversion Feathers 3.4.0
		 */
		function get nextUpFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextUpFocus(value:IFocusDisplayObject):void;

		/**
		 * The next object that will receive focus when
		 * <code>Keyboard.RIGHT</code> is pressed at
		 * <code>KeyLocation.D_PAD</code> and a focus manager is enabled. If
		 * <code>null</code>, defaults to the best available child, as
		 * determined by the focus manager.
		 *
		 * <p>In the following example, the next right focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextRightFocus = otherObject;</listing>
		 *
		 * <p>To simulate <code>KeyLocation.D_PAD</code> in the AIR Debug
		 * Launcher on desktop for debugging purposes, set
		 * <code>DeviceCapabilities.simulateDPad</code> to <code>true</code>.</p>
		 *
		 * @see feathers.system.DeviceCapabilities#simulateDPad
		 *
		 * @productversion Feathers 3.4.0
		 */
		function get nextRightFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextRightFocus(value:IFocusDisplayObject):void;

		/**
		 * The next object that will receive focus when
		 * <code>Keyboard.DOWN</code> is pressed at
		 * <code>KeyLocation.D_PAD</code> and a focus manager is enabled. If
		 * <code>null</code>, defaults to the best available child, as
		 * determined by the focus manager.
		 *
		 * <p>In the following example, the next down focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextDownFocus = otherObject;</listing>
		 *
		 * <p>To simulate <code>KeyLocation.D_PAD</code> in the AIR Debug
		 * Launcher on desktop for debugging purposes, set
		 * <code>DeviceCapabilities.simulateDPad</code> to <code>true</code>.</p>
		 *
		 * @see feathers.system.DeviceCapabilities#simulateDPad
		 *
		 * @productversion Feathers 3.4.0
		 */
		function get nextDownFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextDownFocus(value:IFocusDisplayObject):void;

		/**
		 * The next object that will receive focus when
		 * <code>Keyboard.LEFT</code> is pressed at
		 * <code>KeyLocation.D_PAD</code> and a focus manager is enabled. If
		 * <code>null</code>, defaults to the best available child, as
		 * determined by the focus manager.
		 *
		 * <p>In the following example, the next left focus is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.nextLeftFocus = otherObject;</listing>
		 *
		 * <p>To simulate <code>KeyLocation.D_PAD</code> in the AIR Debug
		 * Launcher on desktop for debugging purposes, set
		 * <code>DeviceCapabilities.simulateDPad</code> to <code>true</code>.</p>
		 *
		 * @see feathers.system.DeviceCapabilities#simulateDPad
		 *
		 * @productversion Feathers 3.4.0
		 */
		function get nextLeftFocus():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set nextLeftFocus(value:IFocusDisplayObject):void;

		/**
		 * Used for associating focusable display objects that are not direct
		 * children with an "owner" focusable display object, such as pop-ups.
		 * A focus manager may use this property to influence the tab order.
		 *
		 * <p>In the following example, the focus owner is changed:</p>
		 *
		 * <listing version="3.0">
		 * object.focusOwner = otherObject;</listing>
		 */
		function get focusOwner():IFocusDisplayObject;

		/**
		 * @private
		 */
		function set focusOwner(value:IFocusDisplayObject):void;

		/**
		 * Indicates if the <code>showFocus()</code> method has been called on
		 * the object when it has focus.
		 *
		 * <listing version="3.0">
		 * if(object.isShowingFocus)
		 * {
		 * 
		 * }</listing>
		 *
		 * @see #showFocus()
		 * @see #hideFocus()
		 */
		function get isShowingFocus():Boolean;

		/**
		 * If <code>true</code>, the display object should remain in focus,
		 * even if something else is touched. If <code>false</code>, touching
		 * another object will pass focus normally.
		 */
		function get maintainTouchFocus():Boolean;

		/**
		 * If the object has focus, an additional visual indicator may
		 * optionally be displayed to highlight the object. Calling this
		 * function may have no effect. It's merely a suggestion to the object.
		 *
		 * <p><strong>Important:</strong> This function will not give focus to
		 * the display object if it doesn't have focus. To give focus to the
		 * display object, you should set the <code>focus</code> property on
		 * the focus manager.</p>
		 *
		 * <listing version="3.0">
		 * object.focusManager.focus = object;</listing>
		 *
		 * @see #hideFocus()
		 * @see feathers.core.IFocusManager#focus
		 */
		function showFocus():void;

		/**
		 * If the visual indicator of focus has been displayed by
		 * <code>showFocus()</code>, call this function to hide it.
		 *
		 * <p><strong>Important:</strong> This function will not clear focus
		 * from the display object if it has focus. To clear focus from the
		 * display object, you should set the <code>focus</code> property on
		 * the focus manager to <code>null</code> or another display object.</p>
		 *
		 * @see #showFocus()
		 * @see feathers.core.IFocusManager#focus
		 */
		function hideFocus():void;
	}
}
