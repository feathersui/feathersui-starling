/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.touch
{
	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * Dispatches <code>Event.TRIGGERED</code> from the target when the target
	 * is tapped. Conveniently handles all <code>TouchEvent</code> listeners
	 * automatically. Useful for custom item renderers that should be triggered
	 * when tapped.
	 *
	 * <p>In the following example, a custom item renderer will be triggered
	 * when tapped:</p>
	 *
	 * <listing version="3.0">
	 * public class CustomItemRenderer extends LayoutGroupListItemRenderer
	 * {
	 *     public function CustomItemRenderer()
	 *     {
	 *         super();
	 *         this._tapToTrigger = new TapToTrigger(this);
	 *     }
	 *     
	 *     private var _tapToTrigger:TapToTrigger;
	 * }</listing>
	 * 
	 * <p>Note: When combined with a <code>TapToSelect</code> instance, the
	 * <code>TapToTrigger</code> instance should be created first because
	 * <code>Event.TRIGGERED</code> should be dispatched before
	 * <code>Event.CHANGE</code>.</p>
	 * 
	 * @see http://doc.starling-framework.org/current/starling/events/Event.html#TRIGGERED starling.events.Event.TRIGGERED
	 * @see feathers.utils.touch.TapToSelect
	 * @see feathers.utils.touch.LongPress
	 *
	 * @productversion Feathers 2.3.0
	 */
	public class TapToTrigger extends TapToEvent
	{
		/**
		 * Constructor.
		 */
		public function TapToTrigger(target:DisplayObject = null)
		{
			super(target, Event.TRIGGERED);
		}
	}
}