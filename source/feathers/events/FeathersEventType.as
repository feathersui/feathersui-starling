/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	/**
	 * Event <code>type</code> constants for Feathers controls. This class is
	 * not a subclass of <code>starling.events.Event</code> because these
	 * constants are meant to be used with <code>dispatchEventWith()</code> and
	 * take advantage of the Starling's event object pooling. The object passed
	 * to an event listener will be of type <code>starling.events.Event</code>.
	 */
	public class FeathersEventType
	{
		/**
		 * The <code>FeathersEventType.INITIALIZE</code> event type is meant to
		 * be used when an <code>IFeathersControl</code> has finished running
		 * its <code>initialize()</code> function.
		 */
		public static const INITIALIZE:String = "initialize";

		/**
		 * The <code>FeathersEventType.RESIZE</code> event type is meant to
		 * be used when an <code>IFeathersControl</code> has resized.
		 */
		public static const RESIZE:String = "resize";

		/**
		 * The <code>FeathersEventType.ENTER</code> event type is meant to
		 * be used when the enter key has been pressed in an input control.
		 */
		public static const ENTER:String = "enter";

		/**
		 * The <code>FeathersEventType.CLEAR</code> event type is a generic
		 * event type for when something is "cleared".
		 */
		public static const CLEAR:String = "clear";

		/**
		 * The <code>FeathersEventType.SCROLL_COMPLETE</code> event type is used
		 * when a "throw" completes in a scrolling control.
		 */
		public static const SCROLL_COMPLETE:String = "scrollComplete";

		/**
		 * The <code>FeathersEventType.BEGIN_INTERACTION</code> event type is
		 * used by many UI controls where a drag or other interaction happens
		 * over time. An example is a <code>Slider</code> control where the
		 * user touches the thumb to begin dragging.
		 */
		public static const BEGIN_INTERACTION:String = "beginInteraction";

		/**
		 * The <code>FeathersEventType.END_INTERACTION</code> event type is
		 * used by many UI controls where a drag or other interaction happens
		 * over time. An example is a <code>Slider</code> control where the
		 * user stops touching the thumb after dragging.
		 */
		public static const END_INTERACTION:String = "endInteraction";

		/**
		 * The <code>FeathersEventType.TRANSITION_START</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate when a
		 * transition between screens begins.
		 */
		public static const TRANSITION_START:String = "transitionStart";

		/**
		 * The <code>FeathersEventType.TRANSITION_COMPLETE</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate when a
		 * transition between screens ends.
		 */
		public static const TRANSITION_COMPLETE:String = "transitionComplete";

		/**
		 * The <code>FeathersEventType.FOCUS_IN</code> event type is used by
		 * Feathers components to indicate when they have received focus.
		 */
		public static const FOCUS_IN:String = "focusIn";

		/**
		 * The <code>FeathersEventType.FOCUS_OUT</code> event type is used by
		 * Feathers components to indicate when they have lost focus.
		 */
		public static const FOCUS_OUT:String = "focusOut";

		/**
		 * The <code>FeathersEventType.RENDERER_ADD</code> event type is used by
		 * Feathers components with item renderers to indicate when a new
		 * renderer has been added. This event type is meant to be used with
		 * virtualized layouts where only a limited set of renderers will be
		 * created for a data provider that may include a larger number of items.
		 */
		public static const RENDERER_ADD:String = "rendererAdd";

		/**
		 * The <code>FeathersEventType.RENDERER_REMOVE</code> event type is used
		 * by Feathers controls with item renderers to indicate when a renderer
		 * is removed. This event type is meant to be used with virtualized
		 * layouts where only a limited set of renderers will be created for
		 * a data provider that may include a larger number items.
		 */
		public static const RENDERER_REMOVE:String = "rendererRemove";

		/**
		 * The <code>FeathersEventType.ERROR</code> event type is used by
		 * by Feathers controls when an error occurs that can be caught and
		 * safely ignored.
		 */
		public static const ERROR:String = "error";
	}
}
