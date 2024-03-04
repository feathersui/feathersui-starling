/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.core.IFeathersEventDispatcher;

	import starling.core.Starling;

	/**
	 * Dispatched when the theme's assets are loaded, and the theme has
	 * initialized. Feathers component cannot be skinned automatically by the
	 * theme until this event is dispatched.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>Starling</code> instance that
	 *   is associated with the assets that have finished loading.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #isCompleteForStarling()
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * A theme that uses an asynchronous loading mechanism (such as the Starling
	 * <code>AssetManager</code>), during initialization to load textures and
	 * other assets. This type of theme may not be ready to style components
	 * immediately, and it will dispatch <code>Event.COMPLETE</code> once the
	 * it has fully initialized. Attempting to create Feathers components before
	 * the theme has dispatched <code>Event.COMPLETE</code> may result in no
	 * skins or even runtime errors.
	 *
	 * @productversion Feathers 2.3.0
	 */
	public interface IAsyncTheme extends IFeathersEventDispatcher
	{
		/**
		 * Indicates if the assets have been loaded and the theme has been
		 * initialized for a specific Starling instance.
		 *
		 * @see #event:complete starling.events.Event.COMPLETE
		 */
		function isCompleteForStarling(starling:Starling):Boolean;
	}
}
