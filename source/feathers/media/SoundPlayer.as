/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	import starling.events.Event;

	/**
	 * Controls playback of audio with a <code>flash.media.Sound</code> object.
	 * 
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 */
	public class SoundPlayer extends BaseTimedMediaPlayer implements IAudioPlayer
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>SoundPlayer</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function SoundPlayer()
		{
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SoundPlayer.globalStyleProvider;
		}
		
		/**
		 * @private
		 */
		protected var _sound:Sound;
		
		/**
		 * The <code>flash.media.Sound</code> object that has loaded the
		 * content specified by <code>audioSource</code>.
		 * 
		 * @see #soundSource
		 */
		public function get sound():Sound
		{
			return this._sound;
		}
		
		/**
		 * @private
		 */
		protected var _soundChannel:SoundChannel;

		/**
		 * The currently playing <code>flash.media.SoundChannel</code>.
		 */
		public function get soundChannel():SoundChannel
		{
			return this._soundChannel;
		}

		/**
		 * @private
		 */
		protected var _soundSource:Object;

		/**
		 * A URL specified as a <code>String</code> representing a URL, a
		 * <code>flash.net.URLRequest</code>, or a
		 * <code>flash.media.Sound</code> object. In the case of a
		 * <code>String</code> or a <code>URLRequest</code>, a new
		 * <code>flash.media.Sound</code> object will be created internally and
		 * the content will by loaded automatically.
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html flash.net.URLRequest
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html flash.media.Sound
		 */
		public function get soundSource():Object
		{
			return this._soundSource;
		}

		/**
		 * @private
		 */
		public function set soundSource(value:Object):void
		{
			if(this._soundSource === value)
			{
				return;
			}
			this._soundSource = value;
			this._isLoaded = false;
			if(this._soundSource is String)
			{
				this.loadSourceFromURL(value as String);
			}
			else if(this._soundSource is URLRequest)
			{
				this.loadSourceFromURLRequest(URLRequest(value));
			}
			else if(this._soundSource is Sound)
			{
				this._sound = Sound(this._soundSource);
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

		/**
		 * Indicates if the audio data is currently loading.
		 */
		public function get isLoading():Boolean
		{
			return this._isLoading;
		}

		/**
		 * @private
		 */
		protected var _isLoaded:Boolean = false;

		/**
		 * Indicates if the audio content has finished loading.
		 * 
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 * @see #event:loadComplete feathers.events.MediaPlayerEventType.LOAD_COMPLETE
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @private
		 */
		protected var _soundTransform:SoundTransform;

		/**
		 * @inheritDoc
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/SoundTransform.html flash.media.SoundTransform
		 */
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

		/**
		 * Determines if the video starts playing immediately when the
		 * <code>audioSource</code> property is set.
		 * 
		 * @see #soundSource
		 */
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

		/**
		 * Determines if the playhead automatically returns to the start time of
		 * the media after it completes playback.
		 */
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

		/**
		 * @private
		 */
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
			this.addEventListener(Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
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
			this.removeEventListener(Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
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
		protected function soundPlayer_enterFrameHandler(event:Event):void
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
