/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 *
	 * <listing version="3.0">
	 * function listener( event:Event ):void
	 * {
	 *     trace( "creation complete" );
	 * }
	 * component.addEventListener( FeathersEventType.CREATION_COMPLETE, listener );</listing>
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
		 * The <code>FeathersEventType.CREATION_COMPLETE</code> event type is
		 * meant to be used when an <code>IFeathersControl</code> has finished
		 * validating for the first time. A well-designed component will have
		 * created all of its children and it will be fully ready for user
		 * interaction.
		 */
		public static const CREATION_COMPLETE:String = "creationComplete";

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
		 * The <code>FeathersEventType.SCROLL_START</code> event type is used
		 * when a control starts scrolling in either direction as a result of
		 * either user interaction or animation.
		 */
		public static const SCROLL_START:String = "scrollStart";

		/**
		 * The <code>FeathersEventType.SCROLL_COMPLETE</code> event type is used
		 * when a control finishes scrolling in either direction as a result of
		 * either user interaction or animation.
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
		 *
		 * <p>Depending on the control, the result of the interaction may
		 * continue after the interaction ends. For instance, a <code>Scroller</code>
		 * may be "thrown", and the scrolling will continue animating after the
		 * user has finished interacting with it.</p>
		 */
		public static const END_INTERACTION:String = "endInteraction";

		/**
		 * The <code>FeathersEventType.TRANSITION_START</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate when a
		 * transition between screens begins.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_START:String = "transitionStart";

		/**
		 * The <code>FeathersEventType.TRANSITION_COMPLETE</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate when a
		 * transition between screens ends.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_COMPLETE:String = "transitionComplete";

		/**
		 * The <code>FeathersEventType.TRANSITION_IN_START</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate to a new screen
		 * when it begins to transition in.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_IN_START:String = "transitionInStart";

		/**
		 * The <code>FeathersEventType.TRANSITION_IN_COMPLETE</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate to a new screen
		 * when it has completed transitioning in.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_IN_COMPLETE:String = "transitionInComplete";

		/**
		 * The <code>FeathersEventType.TRANSITION_OUT_START</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate to an existing
		 * screen when it begins to transition out.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_OUT_START:String = "transitionOutStart";

		/**
		 * The <code>FeathersEventType.TRANSITION_OUT_COMPLETE</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate to an existing
		 * screen when it has completed transitioning out.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_OUT_COMPLETE:String = "transitionOutComplete";

		/**
		 * The <code>FeathersEventType.TRANSITION_CANCEL</code> event type is
		 * used by the <code>ScreenNavigator</code> to indicate when a
		 * transition between screens is cancelled.
		 *
		 * @see feathers.controls.ScreenNavigator
		 */
		public static const TRANSITION_CANCEL:String = "transitionCancel";

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
		 * Feathers controls when an error occurs that can be caught and
		 * safely ignored.
		 */
		public static const ERROR:String = "error";

		/**
		 * The <code>FeathersEventType.LAYOUT_DATA_CHANGE</code> event type is
		 * used by Feathers controls when their layout data has changed.
		 */
		public static const LAYOUT_DATA_CHANGE:String = "layoutDataChange";

		/**
		 * The <code>FeathersEventType.LONG_PRESS</code> event type is used by
		 * the Feathers <code>Button</code> when it is pressed for a long time.
		 *
		 * @see feathers.controls.Button#event:longPress
		 */
		public static const LONG_PRESS:String = "longPress";

		/**
		 * The <code>FeathersEventType.SOFT_KEYBOARD_ACTIVATE</code> event type
		 * is used by Feathers text editors when they activate a device's soft
		 * keyboard.
		 *
		 * @see feathers.core.ITextEditor
		 */
		public static const SOFT_KEYBOARD_ACTIVATE:String = "softKeyboardActivate";

		/**
		 * The <code>FeathersEventType.SOFT_KEYBOARD_DEACTIVATE</code> event type
		 * is used by Feathers text editors when they deactivate a device's soft
		 * keyboard.
		 *
		 * @see feathers.core.ITextEditor
		 */
		public static const SOFT_KEYBOARD_DEACTIVATE:String = "softKeyboardDeactivate";

		/**
		 * The <code>FeathersEventType.PROGRESS</code> event type is used by
		 * Feathers classes with long-running tasks to indicate that progress
		 * has been made, but the task is incomplete.
		 */
		public static const PROGRESS:String = "progress";

		/**
		 * The <code>FeathersEventType.LOCATION_CHANGE</code> event type is used
		 * by the Feathers <code>WebView</code> component to indicate that its
		 * location has changed.
		 */
		public static const LOCATION_CHANGE:String = "locationChange";

		/**
		 * The <code>FeathersEventType.STATE_CHANGE</code> event type is used by
		 * Feathers classes that implement the <code>IStateContext</code>
		 * interface.
		 * 
		 * @see feathers.core.IStateContext
		 */
		public static const STATE_CHANGE:String = "stageChange";
	}
}
