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

	import starling.display.Quad;
	import starling.events.Event;

	public class SoundChannelPeakVisualizer extends FeathersControl implements IMediaPlayerControl
	{
		public function SoundChannelPeakVisualizer()
		{
		}
		
		protected var leftPeakBar:Quad;
		protected var rightPeakBar:Quad;

		/**
		 * @private
		 */
		protected var _gap:Number = 0;

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
		protected var _mediaPlayer:AudioPlayer;

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
			this._mediaPlayer = value as AudioPlayer;
			if(this._mediaPlayer)
			{
				this.handlePlaybackStateChange();
				this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChange);
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		override public function dispose():void
		{
			this.mediaPlayer = null;
			super.dispose();
		}
		
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
				newWidth = 4 + this._gap;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = 3;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
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
		
		protected function mediaPlayer_playbackStateChange(event:Event):void
		{
			this.handlePlaybackStateChange();
		}
		
		protected function peakVisualizer_enterFrameHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
	}
}
