/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.core.FeathersControl;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.media.SoundMixer;
	import flash.utils.ByteArray;

	import starling.display.MeshBatch;
	import starling.display.Quad;
	import starling.events.Event;

	/**
	 * The number of bars to display in the graph.
	 *
	 * <p>In the following example, 32 bars are displayed:</p>
	 *
	 * <listing version="3.0">
	 * graph.barCount = 32;</listing>
	 *
	 * @default 16
	 */
	[Style(name="barCount",type="Number")]

	/**
	 * The color of the bars in the graph.
	 *
	 * <p>In the following example, the bar color is customized:</p>
	 *
	 * <listing version="3.0">
	 * graph.color = 0xff0000;</listing>
	 *
	 * @default 0
	 */
	[Style(name="color",type="Number")]

	/**
	 * The gap, in pixels, between the bars in the graph.
	 *
	 * <p>In the following example, the gap is set to 10 pixels:</p>
	 *
	 * <listing version="3.0">
	 * graph.gap = 10;</listing>
	 *
	 * @default 0
	 */
	[Style(name="gap",type="Number")]

	/**
	 * A visualization of the audio spectrum of the runtime's currently playing
	 * audio content.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class SpectrumBarGraphVisualizer extends FeathersControl implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>SpectrumBarGraphVisualizer</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
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
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SpectrumBarGraphVisualizer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _bars:MeshBatch;

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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
		 * @private
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
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
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
			this._bars = new MeshBatch();
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
			var needsWidth:Boolean = this._explicitWidth !== this._explicitWidth; //isNaN
			var needsHeight:Boolean = this._explicitHeight !== this._explicitHeight; //isNaN
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			var newWidth:Number = this._explicitWidth;
			if(needsWidth)
			{
				newWidth = this._barCount * (this._gap + 1) - this._gap;
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = 10;
			}
			return this.saveMeasurements(newWidth, newHeight, newWidth, newHeight);
		}

		/**
		 * @private
		 */
		protected function layoutBarGraph():void
		{
			this._bars.clear();
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
				this._bars.addMesh(HELPER_QUAD);
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
