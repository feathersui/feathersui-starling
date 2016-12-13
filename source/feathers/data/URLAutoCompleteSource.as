/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * <p>Data may be filtered on the server or on the client. The
	 * <code>urlRequestFunction</code> may be used to include the text from the
	 * <code>AutoComplete</code> in the request sent to the server.
	 * Alternatively, the <code>parseResultFunction</code> may filter the
	 * result on the client.</p>
	 *
	 * <p>By default, the <code>URLAutoCompleteSource</code> will parse a JSON
	 * string. However, a custom <code>parseResultFunction</code> may be
	 * provided to parse other formats.</p>
	 *
	 * @see feathers.controls.AutoComplete
	 *
	 * @productversion Feathers 2.1.0
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
		protected var _cachedResult:String;

		/**
		 * @private
		 */
		protected var _urlRequestFunction:Function;

		/**
		 * A function called by the auto-complete source that builds the
		 * <code>flash.net.URLRequest</code> that is to be loaded.
		 *
		 * <p>The function is expected to have one of the following signatures:</p>
		 * <pre>function( textToMatch:String ):URLRequest</pre>
		 * <pre>function():URLRequest</pre>
		 *
		 * <p>The function may optionally accept one argument, the text
		 * entered into the <code>AutoComplete</code> component. If available,
		 * this argument should be included in the <code>URLRequest</code>, and
		 * the server-side script should use it to return a pre-filtered result.
		 * Alternatively, if the function accepts zero arguments, a static URL
		 * will be called, and the <code>parseResultFunction</code> may be used
		 * to filter the result on the client side instead.</p>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html Full description of flash.net.URLRequest in Adobe's Flash Platform API Reference
		 * @see #parseResultFunction
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
			if(this._urlRequestFunction === value)
			{
				return;
			}
			this._urlRequestFunction = value;
			this._cachedResult = null;
		}

		/**
		 * @private
		 */
		protected var _parseResultFunction:Function = defaultParseResultFunction;

		/**
		 * A function that parses the result loaded from the URL. Any plain-text
		 * data format may be accepted by providing a custom parse function. The
		 * default function parses the result as JSON.
		 *
		 * <p>The function is expected to have one of the following signatures:</p>
		 * <pre>function( loadedText:String ):Object</pre>
		 * <pre>function( loadedText:String, textToMatch:String ):Object</pre>
		 *
		 * <p>The function may accept one or two arguments. The first argument
		 * is always the plain-text result returned from the URL. Optionally,
		 * the second argument is the text entered into the
		 * <code>AutoComplete</code> component. It may be used to filter the
		 * result on the client side. It is meant to be used when the
		 * <code>urlRequestFunction</code> accepts zero arguments and does not
		 * pass the text entered into the <code>AutoComplete</code> component
		 * to the server.</p>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/JSON.html#parse() Full description of JSON.parse() in Adobe's Flash Platform API Reference
		 * @see #urlRequestFunction
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
			if(this._parseResultFunction === value)
			{
				return;
			}
			this._parseResultFunction = value;
			this._cachedResult = null;
		}

		/**
		 * @private
		 */
		protected var _savedSuggestionsCollection:ListCollection;

		/**
		 * @private
		 */
		protected var _savedTextToMatch:String;

		/**
		 * @private
		 */
		protected var _urlLoader:URLLoader;

		/**
		 * @copy feathers.data.IAutoCompleteSource#load()
		 */
		public function load(textToMatch:String, suggestionsResult:ListCollection = null):void
		{
			if(!suggestionsResult)
			{
				suggestionsResult = new ListCollection();
			}
			var urlRequestFunction:Function = this._urlRequestFunction;
			var request:URLRequest;
			if(urlRequestFunction.length === 1)
			{
				request = URLRequest(urlRequestFunction(textToMatch));
			}
			else
			{
				if(this._cachedResult !== null)
				{
					this.parseData(this._cachedResult, textToMatch, suggestionsResult);
					return;
				}
				request = URLRequest(urlRequestFunction());
			}
			this._savedSuggestionsCollection = suggestionsResult;
			this._savedTextToMatch = textToMatch;
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
		protected function parseData(resultText:String, textToMatch:String, suggestions:ListCollection):void
		{
			var parseResultFunction:Function = this._parseResultFunction;
			if(parseResultFunction.length === 2)
			{
				suggestions.data = parseResultFunction(resultText, textToMatch);
			}
			else
			{
				suggestions.data = parseResultFunction(resultText);
			}
			this.dispatchEventWith(starling.events.Event.COMPLETE, false, suggestions);
		}


		/**
		 * @private
		 */
		protected function urlLoader_completeHandler(event:flash.events.Event):void
		{
			var suggestions:ListCollection = this._savedSuggestionsCollection;
			this._savedSuggestionsCollection = null;
			var textToMatch:String = this._savedTextToMatch;
			this._savedTextToMatch = null;

			var loadedData:String = this._urlLoader.data as String;
			if(this._urlRequestFunction.length === 0)
			{
				this._cachedResult = loadedData;
			}
			if(loadedData)
			{
				this.parseData(loadedData, textToMatch, suggestions);
			}
			else
			{
				suggestions.removeAll();
				this.dispatchEventWith(starling.events.Event.COMPLETE, false, suggestions);
			}
		}

		/**
		 * @private
		 */
		protected function urlLoader_errorHandler(event:ErrorEvent):void
		{
			var result:ListCollection = this._savedSuggestionsCollection;
			result.removeAll();
			this._savedSuggestionsCollection = null;
			this.dispatchEventWith(starling.events.Event.COMPLETE, false, result);
		}

	}
}
