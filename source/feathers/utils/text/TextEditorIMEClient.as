/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.text
{
	import feathers.core.IIMETextEditor;

	import flash.display.Sprite;
	import flash.events.IMEEvent;
	import flash.geom.Rectangle;
	import flash.text.ime.CompositionAttributeRange;
	import flash.text.ime.IIMEClient;

	import starling.core.Starling;
	import starling.display.Stage;

	/**
	 * @private
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class TextEditorIMEClient extends Sprite implements IIMEClient
	{
		/**
		 * Constructor.
		 */
		public function TextEditorIMEClient(textEditor:IIMETextEditor, startCallback:Function,
			updateCallback:Function, confirmCallback:Function)
		{
			super();
			this._textEditor = textEditor;
			this._startCallback = startCallback;
			this._updateCallback = updateCallback;
			this._confirmCallback = confirmCallback;
			this.addEventListener(IMEEvent.IME_START_COMPOSITION, imeStartCompositionHandler);
		}

		/**
		 * @private
		 */
		protected var _textEditor:IIMETextEditor;

		/**
		 * @private
		 */
		protected var _startCallback:Function;

		/**
		 * @private
		 */
		protected var _updateCallback:Function;

		/**
		 * @private
		 */
		protected var _confirmCallback:Function;

		/**
		 * @private
		 */
		protected var _compositionStartIndex:int = -1;

		/**
		 * @private
		 */
		protected var _compositionEndIndex:int = -1;

		/**
		 * @private
		 */
		public function get verticalTextLayout():Boolean
		{
			return false;
		}

		/**
		 * @private
		 */
		public function get compositionStartIndex():int
		{
			return this._compositionStartIndex;
		}

		/**
		 * @private
		 */
		public function get compositionEndIndex():int
		{
			return this._compositionEndIndex;
		}

		/**
		 * @private
		 */
		public function get selectionAnchorIndex():int
		{
			return this._textEditor.selectionAnchorIndex;
		}

		/**
		 * @private
		 */
		public function get selectionActiveIndex():int
		{
			return this._textEditor.selectionActiveIndex;
		}

		/**
		 * @private
		 */
		public function getTextBounds(startIndex:int, endIndex:int):Rectangle
		{
			var stage:Stage = this._textEditor.stage;
			if(stage === null)
			{
				return new Rectangle();
			}
			var result:Rectangle = this._textEditor.getBounds(stage);
			var starling:Starling = this._textEditor.stage !== null ? this._textEditor.stage.starling : Starling.current;
			var nativeScaleFactor:Number = 1;
			if(starling.supportHighResolutions)
			{
				nativeScaleFactor = starling.nativeStage.contentsScaleFactor;
			}
			var scaleFactor:Number = starling.contentScaleFactor / nativeScaleFactor;
			result.x *= scaleFactor;
			result.y *= scaleFactor;
			result.width *= scaleFactor;
			result.height *= scaleFactor;
			var viewPort:Rectangle = starling.viewPort;
			result.x += viewPort.x;
			result.y += viewPort.y;
			return result;
		}

		/**
		 * @private
		 */
		public function confirmComposition(text:String = null, preserveSelection:Boolean = false):void
		{
			this._confirmCallback(text, preserveSelection);
		}

		/**
		 * @private
		 */
		public function updateComposition(text:String,attributes:Vector.<CompositionAttributeRange>, compositionStartIndex:int, compositionEndIndex:int):void
		{
			this._compositionStartIndex = compositionStartIndex;
			this._compositionEndIndex = compositionEndIndex;
			this._updateCallback(text, attributes, compositionStartIndex, compositionEndIndex);
		}

		/**
		 * @private
		 */
		public function selectRange(startIndex:int, endIndex:int):void
		{
			this._textEditor.selectRange(startIndex, endIndex);
		}

		/**
		 * @private
		 */
		public function getTextInRange(startIndex:int, endIndex:int):String
		{
			return this._textEditor.text.substring(startIndex, endIndex);
		}

		/**
		 * @private
		 */
		protected function imeStartCompositionHandler(event:IMEEvent):void
		{
			event.imeClient = this;
			this._startCallback();
		}
	}
}
