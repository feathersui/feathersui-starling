/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.themes
{
	import feathers.core.IFeathersEventDispatcher;

	import starling.core.Starling;

	/**
	 * Dispatched when the theme's assets are loaded, and the theme has
	 * initialized. Feathers component will not be skinned automatically by the
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
	 * <tr><td><code>data</code></td><td>The Starling instance that the theme
	 *   is ready for.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @eventType starling.events.Event.COMPLETE
	 */
	[Event(name="complete",type="starling.events.Event")]

	/**
	 * A theme that uses an AssetManager to load textures and other assets.
	 * Dispatches <code>Event.COMPLETE</code> when the assets are loaded.
	 */
	public interface IThemeWithAssetManager extends IFeathersEventDispatcher
	{
		/**
		 * Indicates if the assets have been loaded and the theme has been
		 * initialized for a specific Starling instance.
		 */
		function isCompleteForStarling(starling:Starling):Boolean;
	}
}
