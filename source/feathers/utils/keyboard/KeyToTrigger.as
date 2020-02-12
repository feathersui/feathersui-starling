/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.keyboard
{
	import feathers.core.IFocusDisplayObject;

	import flash.ui.Keyboard;

	import starling.events.Event;

	/**
	 * Dispatches <code>Event.TRIGGERED</code> from the target when a key is
	 * pressed and released and the target has focus. Conveniently handles all
	 * <code>KeyboardEvent</code> listeners automatically.
	 *
	 * <p>In the following example, a custom item renderer will be triggered
	 * when a key is pressed and released:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomComponent extends FeathersControl implements IFocusDisplayObject
	 * {
	 *     public function CustomComponent()
	 *     {
	 *         super();
	 *         this._keyToTrigger = new KeyToTrigger(this);
	 *         this._keyToTrigger.keyCode = Keyboard.ENTER;
	 *     }
	 *     
	 *     private var _keyToTrigger:KeyToTrigger;
	 * // ...</listing>
	 *
	 * <p>Note: When combined with a <code>KeyToSelect</code> instance, the
	 * <code>KeyToTrigger</code> instance should be created first because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 *
	 * @see http://doc.starling-framework.org/current/starling/events/Event.html#TRIGGERED starling.events.Event.TRIGGERED
	 * @see feathers.utils.keyboard.KeyToSelect
	 * @see feathers.utils.touch.TapToTrigger
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class KeyToTrigger extends KeyToEvent
	{
		/**
		 * Constructor.
		 */
		public function KeyToTrigger(target:IFocusDisplayObject = null, keyCode:uint = Keyboard.SPACE)
		{
			super(target, keyCode, Event.TRIGGERED);
		}
	}
}
