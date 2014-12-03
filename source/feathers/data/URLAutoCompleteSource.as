/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.data
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Dispatched when the suggestions finish loading.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A <code>ListCollection</code> containing
	 *   the suggestions to display.</td></tr>
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
	 * Creates a list of suggestions for an <code>AutoComplete</code> component
	 * by loading data from a URL.
	 *
	 * <p>By default, the <code>URLAutoCompleteSource</code> will parse JSON.
	 * However, a custom <code>parseResultFunction</code> can be provided to
	 * parse other formats.</p>
	 *
	 * @see feathers.data.ListCollection
	 */
	public class URLAutoCompleteSource extends EventDispatcher implements IAutoCompleteSource
	{
		/**
		 * @private
		 */
		protected static function defaultParseResultFunction(result:String):Object
		{
			return JSON.parse(result);
		}

		/**
		 * Constructor.
		 */
		public function URLAutoCompleteSource(urlRequestFunction:Function, parseResultFunction:Function = null)
		{
			this.urlRequestFunction = urlRequestFunction;
			this.parseResultFunction = parseResultFunction;
		}

		/**
		 * @private
		 */
		private var _urlRequestFunction:Function;

		/**
		 * A function called by the auto-complete source that builds the
		 * <code>flash.net.URLRequest</a> that is to be loaded.
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html Full description of flash.net.URLRequest in Adobe's Flash Platform API Reference
		 */
		public function get urlRequestFunction():Function
		{
			return this._urlRequestFunction;
		}

		/**
		 * @private
		 */
		public function set urlRequestFunction(value:Function):void
		{
			this._urlRequestFunction = value;
		}

		/**
		 * @private
		 */
		private var _parseResultFunction:Function = defaultParseResultFunction;

		/**
		 * A function called by the auto-complete source that parses the result
		 * of the loaded URL.
		 */
		public function get parseResultFunction():Function
		{
			return this._parseResultFunction;
		}

		/**
		 * @private
		 */
		public function set parseResultFunction(value:Function):void
		{
			if(value === null)
			{
				value = defaultParseResultFunction;
			}
			this._parseResultFunction = value;
		}

		/**
		 * @private
		 */
		protected var _savedResult:ListCollection;

		/**
		 * @private
		 */
		protected var _urlLoader:URLLoader;

		/**
		 * @copy feathers.data.IAutoCompleteSource#load()
		 */
		public function load(text:String, result:ListCollection = null):void
		{
			if(!result)
			{
				result = new ListCollection();
			}
			this._savedResult = result;

			var request:URLRequest = this._urlRequestFunction(text) as URLRequest;
			if(this._urlLoader)
			{
				this._urlLoader.close();
			}
			else
			{
				this._urlLoader = new URLLoader();
				this._urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
				this._urlLoader.addEventListener(flash.events.Event.COMPLETE, urlLoader_completeHandler);
				this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_errorHandler);
				this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoader_errorHandler);
			}
			this._urlLoader.load(request);
		}

		/**
		 * @private
		 */
		protected function urlLoader_completeHandler(event:flash.events.Event):void
		{
			var result:ListCollection = this._savedResult;
			this._savedResult = null;

			var loadedData:String = this._urlLoader.data as String;
			if(loadedData)
			{
				result.data = this._parseResultFunction(loadedData);
				this.dispatchEventWith(starling.events.Event.COMPLETE, false, result);
			}
			else
			{
				result.removeAll();
				this.dispatchEventWith(starling.events.Event.COMPLETE, false, result);
			}
		}

		/**
		 * @private
		 */
		protected function urlLoader_errorHandler(event:ErrorEvent):void
		{
			var result:ListCollection = this._savedResult;
			result.removeAll();
			this._savedResult = null;
			this.dispatchEventWith(starling.events.Event.COMPLETE, false, result);
		}

	}
}
