/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.core.FeathersControl;

	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	import starling.display.Quad;
	import starling.display.QuadBatch;
	import starling.events.Event;

	/**
	 * A visualization of the audio spectrum of the runtime's currently playing
	 * audio content.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 */
	public class SpectrumBarGraphVisualizer extends FeathersControl implements IMediaPlayerControl
	{
		/**
		 * @private
		 */
		protected static var HELPER_QUAD:Quad = new Quad(1, 1);
		
		/**
		 * @private
		 */
		protected static const MAX_BAR_COUNT:int = 256;

		/**
		 * Constructor
		 */
		public function SpectrumBarGraphVisualizer()
		{
			this.isQuickHitAreaEnabled = true;
		}

		/**
		 * @private
		 */
		protected var _bars:QuadBatch;

		/**
		 * @private
		 */
		protected var _bytes:ByteArray = new ByteArray();

		/**
		 * @private
		 */
		protected var _barValues:Vector.<Number> = new <Number>[];

		/**
		 * @private
		 */
		protected var _barCount:int = 16;

		/**
		 * The number of bars displayed by the visualizer.
		 */
		public function get barCount():int
		{
			return this._barCount;
		}

		/**
		 * @private
		 */
		public function set barCount(value:int):void
		{
			if(value > MAX_BAR_COUNT)
			{
				value = MAX_BAR_COUNT;
			}
			else if(value < 1)
			{
				value = 1;
			}
			if(this._barCount == value)
			{
				return;
			}
			this._barCount = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

		/**
		 * The gap, in pixels, between the bars.
		 */
		public function get gap():Number
		{
			return this._gap;
		}

		/**
		 * @private
		 */
		public function set gap(value:Number):void
		{
			if(this._gap == value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _color:uint = 0x000000;

		/**
		 * The color of the bars.
		 */
		public function get color():uint
		{
			return this._color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			if(this._color == value)
			{
				return;
			}
			this._color = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:ITimedMediaPlayer;

		/**
		 * @inheritDoc
		 */
		public function get mediaPlayer():IMediaPlayer
		{
			return this._mediaPlayer;
		}

		/**
		 * @private
		 */
		public function set mediaPlayer(value:IMediaPlayer):void
		{
			if(this._mediaPlayer == value)
			{
				return;
			}
			if(this._mediaPlayer)
			{
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChange);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this.handlePlaybackStateChange();
				this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChange);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.mediaPlayer = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override protected function initialize():void
		{
			this._bars = new QuadBatch();
			this.addChild(this._bars);
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			this.autoSizeIfNeeded();
			this.layoutBarGraph();
			super.draw();
		}

		/**
		 * @private
		 */
		protected function autoSizeIfNeeded():Boolean
		{
			var needsWidth:Boolean = this.explicitWidth !== this.explicitWidth; //isNaN
			var needsHeight:Boolean = this.explicitHeight !== this.explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = this._barCount * (this._gap + 1) - this._gap;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = 10;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}

		/**
		 * @private
		 */
		protected function layoutBarGraph():void
		{
			this._bars.reset();
			if(!this._mediaPlayer.isPlaying)
			{
				return;
			}
			var barCount:int = this._barCount;
			var barWidth:Number = ((this.actualWidth + this._gap) / barCount) - this._gap;
			if(barWidth < 0 || this.actualHeight <= 0)
			{
				return;
			}
			
			SoundMixer.computeSpectrum(this._bytes, true, 0);
			
			this._barValues.length = barCount;
			var valuesPerBar:int = 256 / barCount;
			//read left values
			for(var i:int = 0; i < barCount; i++)
			{
				//reset to zero first
				this._barValues[i] = 0;
				for(var j:int = 0; j < valuesPerBar; j++)
				{
					var float:Number = this._bytes.readFloat();
					if(float > 1)
					{
						float = 1;
					}
					this._barValues[i] += float;
				}
			}
			//read right values
			this._bytes.position = 1024;
			for(i = 0; i < barCount; i++)
			{
				for(j = 0; j < valuesPerBar; j++)
				{
					float = this._bytes.readFloat();
					if(float > 1)
					{
						float = 1;
					}
					this._barValues[i] += float;
				}
				//calculate the average
				this._barValues[i] /= (2 * valuesPerBar);
			}
			
			var xPosition:Number = 0;
			var maxHeight:Number = this.actualHeight - 1;
			HELPER_QUAD.color = this._color;
			for(i = 0; i < barCount; i++)
			{
				HELPER_QUAD.x = xPosition;
				HELPER_QUAD.width = barWidth;
				HELPER_QUAD.height = Math.floor(maxHeight * this._barValues[i]);
				HELPER_QUAD.y = maxHeight - HELPER_QUAD.height;
				this._bars.addQuad(HELPER_QUAD);
				xPosition += barWidth + this._gap;
			}
		}

		/**
		 * @private
		 */
		protected function handlePlaybackStateChange():void
		{
			if(this._mediaPlayer.isPlaying)
			{
				this.addEventListener(Event.ENTER_FRAME, peakVisualizer_enterFrameHandler);
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, peakVisualizer_enterFrameHandler);
			}
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_playbackStateChange(event:Event):void
		{
			this.handlePlaybackStateChange();
		}

		/**
		 * @private
		 */
		protected function peakVisualizer_enterFrameHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
