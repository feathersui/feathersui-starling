/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.core.FeathersControl;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.media.SoundChannel;

	import starling.display.Quad;
	import starling.events.Event;

	/**
	 * The gap, in pixels, between the bars.
	 *
	 * <p>In the following example, the gap is set to 10 pixels:</p>
	 *
	 * <listing version="3.0">
	 * control.gap = 10;</listing>
	 *
	 * @default 0
	 */
	[Style(name="gap",type="Number")]

	/**
	 * A visualization of the left and right peaks of the
	 * <code>flash.media.SoundChannel</code> from a <code>SoundPlayer</code>
	 * component.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class SoundChannelPeakVisualizer extends FeathersControl implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>SoundChannelPeakVisualizer</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function SoundChannelPeakVisualizer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SoundChannelPeakVisualizer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var leftPeakBar:Quad;

		/**
		 * @private
		 */
		protected var rightPeakBar:Quad;

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
			if(this._gap === value)
			{
				return;
			}
			this._gap = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:SoundPlayer;

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
			this._mediaPlayer = value as SoundPlayer;
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
			if(!this.leftPeakBar)
			{
				this.leftPeakBar = new Quad(1, 1);
				this.addChild(this.leftPeakBar);
			}
			if(!this.rightPeakBar)
			{
				this.rightPeakBar = new Quad(1, 1);
				this.addChild(this.rightPeakBar);
			}
		}

		/**
		 * @private
		 */
		override protected function draw():void
		{
			this.autoSizeIfNeeded();
			
			if(this._mediaPlayer && this._mediaPlayer.soundChannel)
			{
				var soundChannel:SoundChannel = this._mediaPlayer.soundChannel;
				var maxHeight:Number = this.actualHeight - 1;
				this.leftPeakBar.height = 1 + maxHeight * soundChannel.leftPeak;
				this.rightPeakBar.height = 1 + maxHeight * soundChannel.rightPeak;
			}
			else
			{
				this.leftPeakBar.height = 1;
				this.rightPeakBar.height = 1;
			}
			var barWidth:Number = (this.actualWidth / 2) - this._gap;
			this.leftPeakBar.y = this.actualHeight - this.leftPeakBar.height;
			this.leftPeakBar.width = barWidth;
			this.rightPeakBar.x = barWidth + this._gap;
			this.rightPeakBar.y = this.actualHeight - this.rightPeakBar.height;
			this.rightPeakBar.width = barWidth;
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
				newWidth = 4 + this._gap;
			}
			var newHeight:Number = this._explicitHeight;
			if(needsHeight)
			{
				newHeight = 3;
			}
			return this.saveMeasurements(newWidth, newHeight, newWidth, newHeight);
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
