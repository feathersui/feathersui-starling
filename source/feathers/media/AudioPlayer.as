/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import starling.events.Event;

	public class AudioPlayer extends BaseTimedMediaPlayer implements IAudioPlayer
	{
		/**
		 * Constructor.
		 */
		public function AudioPlayer()
		{
		}
		
		/**
		 * @private
		 */
		protected var _sound:Sound;

		public function get sound():Sound
		{
			return this._sound;
		}
		
		/**
		 * @private
		 */
		protected var _soundChannel:SoundChannel;
		
		public function get soundChannel():SoundChannel
		{
			return this._soundChannel;
		}

		/**
		 * @private
		 */
		protected var _audioSource:Object;
		
		public function get audioSource():Object
		{
			return this._audioSource;
		}

		/**
		 * @private
		 */
		public function set audioSource(value:Object):void
		{
			if(this._audioSource === value)
			{
				return;
			}
			this._audioSource = value;
			this._isLoaded = false;
			if(this._audioSource is String)
			{
				this.loadSourceFromURL(value as String);
			}
			else if(this._audioSource is URLRequest)
			{
				this.loadSourceFromURLRequest(URLRequest(value));
			}
			else if(this._audioSource is Sound)
			{
				this._sound = Sound(this._audioSource);
			}
			else
			{
				throw new ArgumentError("Invalid source type for AudioPlayer. Expected a URL as a String, an URLRequest, or a Sound object.")
			}
		}

		/**
		 * @private
		 */
		protected var _isLoading:Boolean = false;

		public function get isLoading():Boolean
		{
			return this._isLoading;
		}

		/**
		 * @private
		 */
		protected var _isLoaded:Boolean = false;

		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @private
		 */
		protected var _soundTransform:SoundTransform;
		
		public function get soundTransform():SoundTransform
		{
			if(!this._soundTransform)
			{
				this._soundTransform = new SoundTransform();
			}
			return this._soundTransform;
		}

		/**
		 * @private
		 */
		public function set soundTransform(value:SoundTransform):void
		{
			this._soundTransform = value;
			if(this._soundChannel)
			{
				this._soundChannel.soundTransform = this._soundTransform;
			}
		}

		/**
		 * @private
		 */
		protected var _autoPlay:Boolean = true;

		public function get autoPlay():Boolean
		{
			return this._autoPlay;
		}

		/**
		 * @private
		 */
		public function set autoPlay(value:Boolean):void
		{
			this._autoPlay = value;
		}

		/**
		 * @private
		 */
		protected var _autoRewind:Boolean = true;

		public function get autoRewind():Boolean
		{
			return this._autoRewind;
		}

		/**
		 * @private
		 */
		public function set autoRewind(value:Boolean):void
		{
			this._autoRewind = value;
		}
		
		override public function play():void
		{
			if(this._isPlaying)
			{
				return;
			}
			if(this._isLoading)
			{
				this._autoPlay = true;
				return;
			}
			super.play();
		}

		/**
		 * @private
		 */
		override protected function playMedia():void
		{
			if(this._currentTime == this._totalTime)
			{
				this.handleSoundComplete();
				return;
			}
			if(!this._soundTransform)
			{
				this._soundTransform = new SoundTransform();
			}
			this._soundChannel = this._sound.play(this._currentTime * 1000, 0, this._soundTransform);
			this._soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, soundChannel_soundCompleteHandler);
			this.addEventListener(starling.events.Event.ENTER_FRAME, audioPlayer_enterFrameHandler);
		}

		/**
		 * @private
		 */
		override protected function pauseMedia():void
		{
			if(!this._soundChannel)
			{
				//this could be null when seeking
				return;
			}
			this.removeEventListener(starling.events.Event.ENTER_FRAME, audioPlayer_enterFrameHandler);
			this._soundChannel.stop();
			this._soundChannel.removeEventListener(flash.events.Event.SOUND_COMPLETE, soundChannel_soundCompleteHandler);
			this._soundChannel = null;
		}

		/**
		 * @private
		 */
		override protected function seekMedia(seconds:Number):void
		{
			this.pauseMedia();
			this._currentTime = seconds;
			if(this._isPlaying)
			{
				this.playMedia();
			}
		}

		/**
		 * @private
		 */
		protected function handleSoundComplete():void
		{
			if(this._autoRewind)
			{
				this.stop();
			}
			else
			{
				this.pause();
			}
		}

		/**
		 * @private
		 */
		protected function loadSourceFromURL(url:String):void
		{
			this.loadSourceFromURLRequest(new URLRequest(url));
		}

		/**
		 * @private
		 */
		protected function loadSourceFromURLRequest(request:URLRequest):void
		{
			this._isLoading = true;
			if(this._sound)
			{
				this._sound.removeEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
				this._sound.removeEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
				this._sound.removeEventListener(Event.COMPLETE, sound_completeHandler);
			}
			this._sound = new Sound();
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
			this._sound.addEventListener(Event.COMPLETE, sound_completeHandler);
			this._sound.load(request);
		}

		/**
		 * @private
		 */
		protected function audioPlayer_enterFrameHandler(event:starling.events.Event):void
		{
			this._currentTime = this._soundChannel.position / 1000;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}

		/**
		 * @private
		 */
		protected function sound_completeHandler(event:flash.events.Event):void
		{
			this._totalTime = this._sound.length / 1000;
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
			this._isLoading = false;
			this._isLoaded = true;
			this.dispatchEventWith(MediaPlayerEventType.LOAD_COMPLETE);
			if(this._autoPlay)
			{
				this.play();
			}
		}

		/**
		 * @private
		 */
		protected function sound_progressHandler(event:ProgressEvent):void
		{
			this.dispatchEventWith(MediaPlayerEventType.LOAD_PROGRESS, false, event.bytesLoaded / event.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function sound_errorHandler(event:ErrorEvent):void
		{
			trace("sound error", event);
		}

		/**
		 * @private
		 */
		protected function soundChannel_soundCompleteHandler(event:flash.events.Event):void
		{
			this.handleSoundComplete();
		}
		
	}
}
