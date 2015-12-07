/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	import starling.events.Event;

	/**
	 * Dispatched when the MP3 ID3 metadata becomes available on the
	 * <code>Sound</code> instance.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>flash.media.ID3Info</code>
	 *   instance returned by the <code>id3</code> property of the
	 *   <code>Sound</code> instance.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html#id3 flash.media.Sound.id3
	 *
	 * @eventType feathers.events.MediaPlayerEventType.METADATA_RECEIVED
	 */
	[Event(name="metadataReceived",type="starling.events.Event")]

	/**
	 * Dispatched periodically when a media player's content is loading to
	 * indicate the current progress. The <code>bytesLoaded</code> and
	 * <code>bytesTotal</code> properties may be accessed to determine the
	 * exact number of bytes loaded.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>A numeric value between <code>0</code>
	 *   and <code>1</code> that indicates how much of the media has loaded so far.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see #bytesLoaded
	 * @see #bytesTotal
	 *
	 * @eventType feathers.events.MediaPlayerEventType.LOAD_PROGRESS
	 */
	[Event(name="loadProgress",type="starling.events.Event")]

	/**
	 * Dispatched when a media player's content is fully loaded and it
	 * may be played to completion without buffering.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #isLoaded
	 *
	 * @eventType feathers.events.MediaPlayerEventType.LOAD_COMPLETE
	 */
	[Event(name="loadComplete",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>flash.media.Sound</code> object dispatches
	 * <code>flash.events.IOErrorEvent.IO_ERROR</code>.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>flash.events.IOErrorEvent</code>
	 *   dispatched by the <code>flash.media.Sound</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html#event:ioError flash.media.Sound: flash.events.IOErrorEvent.IO_ERROR
	 *
	 * @eventType starling.events.Event.IO_ERROR
	 */
	[Event(name="ioError",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>flash.media.Sound</code> object dispatches
	 * <code>flash.events.SecurityErrorEvent.SECURITY_ERROR</code>.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The <code>flash.events.SecurityErrorEvent</code>
	 *   dispatched by the <code>flash.media.Sound</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/Sound.html#event:securityError flash.media.Sound: flash.events.SecurityErrorEvent.SECURITY_ERROR
	 *
	 * @eventType starling.events.Event.SECURITY_ERROR
	 */
	[Event(name="securityError",type="starling.events.Event")]

	/**
	 * Dispatched when the media player's sound transform changes.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>null</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see #soundTransform
	 *
	 * @eventType feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
	 */
	[Event(name="soundTransformChange",type="starling.events.Event")]

	/**
	 * Controls playback of audio with a <code>flash.media.Sound</code> object.
	 *
	 * <p><strong>Beta Component:</strong> This is a new component, and its APIs
	 * may need some changes between now and the next version of Feathers to
	 * account for overlooked requirements or other issues. Upgrading to future
	 * versions of Feathers may involve manual changes to your code that uses
	 * this component. The
	 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>
	 * will not go into effect until this component's status is upgraded from
	 * beta to stable.</p>
	 * 
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 */
	public class SoundPlayer extends BaseTimedMediaPlayer implements IAudioPlayer, IProgressiveMediaPlayer
	{
		/**
		 * @private
		 */
		protected static const NO_SOUND_SOURCE_PLAY_ERROR:String = "Cannot play media when soundSource property has not been set.";
		
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
			super();
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
		 * content specified by <code>soundSource</code>.
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
		 * <p>In the following example, a sound file URL is passed in:</p>
		 *
		 * <listing version="3.0">
		 * soundPlayer.soundSource = "http://example.com/sound.mp3";</listing>
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
			if(this._isPlaying)
			{
				this.stop();
			}
			this._soundSource = value;
			//reset the current and total time if we were playing a different
			//sound previously
			if(this._currentTime !== 0)
			{
				this._currentTime = 0;
				this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
			}
			if(this._totalTime !== 0)
			{
				this._totalTime = 0;
				this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
			}
			if(this._sound)
			{
				this.cleanupSound();
			}
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
				var newTotalTime:Number = this._sound.length / 1000;
				if(this._totalTime !== newTotalTime)
				{
					this._totalTime = newTotalTime;
					this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
				}
				if(this._sound.isBuffering)
				{
					this._sound.addEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
					this._sound.addEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
					this._sound.addEventListener(flash.events.Event.COMPLETE, sound_completeHandler);
					this._sound.addEventListener(flash.events.Event.ID3, sound_id3Handler);
				}
			}
			else if(this._soundSource === null)
			{
				this._sound = null;
			}
			else
			{
				throw new ArgumentError("Invalid source type for SoundPlayer. Expected a URL as a String, an URLRequest, a Sound object, or null.")
			}
			if(this._autoPlay && this._sound)
			{
				this.play();
			}
		}

		/**
		 * @private
		 */
		protected var _isLoading:Boolean = false;

		/**
		 * Indicates if the <code>flash.media.Sound</code> object is currently
		 * loading its content.
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
		 * Indicates if the <code>flash.media.Sound</code> object has finished
		 * loading its content.
		 * 
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 * @see #event:loadComplete feathers.events.MediaPlayerEventType.LOAD_COMPLETE
		 */
		public function get isLoaded():Boolean
		{
			return this._isLoaded;
		}

		/**
		 * @copy feathers.media.IProgressiveMediaPlayer#bytesLoaded
		 * 
		 * @see #bytesTotal
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		public function get bytesLoaded():uint
		{
			if(!this._sound)
			{
				return 0;
			}
			return this._sound.bytesLoaded;
		}

		/**
		 * @copy feathers.media.IProgressiveMediaPlayer#bytesTotal
		 *
		 * @see #bytesLoaded
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		public function get bytesTotal():uint
		{
			if(!this._sound)
			{
				return 0;
			}
			return this._sound.bytesTotal;
		}

		/**
		 * @private
		 */
		protected var _soundTransform:SoundTransform;

		/**
		 * @inheritDoc
		 *
		 * <p>In the following example, the audio is muted:</p>
		 *
		 * <listing version="3.0">
		 * soundPlayer.soundTransform = new SoundTransform(0);</listing>
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/media/SoundTransform.html flash.media.SoundTransform
		 * @see #event:soundTransformChange feathers.events.MediaPlayerEventType.SOUND_TRANSFORM_CHANGE
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
			this.dispatchEventWith(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE);
		}

		/**
		 * @private
		 */
		protected var _autoPlay:Boolean = true;

		/**
		 * Determines if the sound starts playing immediately when the
		 * <code>soundSource</code> property is set.
		 *
		 * <p>In the following example, automatic playback is disabled:</p>
		 *
		 * <listing version="3.0">
		 * soundPlayer.autoPlay = false;</listing>
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
		protected var _loop:Boolean = false;

		/**
		 * Determines if, upon reaching the end of the sound, the playhead
		 * automatically returns to the start of the media and plays again.
		 * 
		 * <p>If <code>loop</code> is <code>true</code>, the
		 * <code>autoRewind</code> property will be ignored because looping will
		 * always automatically rewind to the beginning.</p>
		 *
		 * <p>In the following example, looping is enabled:</p>
		 *
		 * <listing version="3.0">
		 * soundPlayer.loop = true;</listing>
		 */
		public function get loop():Boolean
		{
			return this._loop;
		}

		/**
		 * @private
		 */
		public function set loop(value:Boolean):void
		{
			this._loop = value;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.soundSource = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function play():void
		{
			if(this._sound === null)
			{
				return;
			}
			super.play();
		}

		/**
		 * @private
		 */
		override protected function playMedia():void
		{
			if(!this._soundSource)
			{
				throw new IllegalOperationError(NO_SOUND_SOURCE_PLAY_ERROR);
			}
			if(!this._sound.isBuffering && this._currentTime == this._totalTime)
			{
				//flash.events.Event.SOUND_COMPLETE may not be dispatched (or
				//maybe it is dispatched, but before the listener can be added)
				//if currentTime is equal to totalTime, so we need to do it
				//manually.
				this.handleSoundComplete();
				return;
			}
			if(!this._soundTransform)
			{
				this._soundTransform = new SoundTransform();
			}
			this._soundChannel = this._sound.play(this._currentTime * 1000, 0, this._soundTransform);
			this._soundChannel.addEventListener(flash.events.Event.SOUND_COMPLETE, soundChannel_soundCompleteHandler);
			this.addEventListener(starling.events.Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
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
			this.removeEventListener(starling.events.Event.ENTER_FRAME, soundPlayer_enterFrameHandler);
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
			//return to the beginning
			this.stop();
			this.dispatchEventWith(starling.events.Event.COMPLETE);
			if(this._loop)
			{
				this.play();
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
				this.cleanupSound();
			}
			this._sound = new Sound();
			this._sound.addEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			this._sound.addEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
			this._sound.addEventListener(flash.events.Event.COMPLETE, sound_completeHandler);
			this._sound.addEventListener(flash.events.Event.ID3, sound_id3Handler);
			this._sound.load(request);
		}

		/**
		 * @private
		 */
		protected function cleanupSound():void
		{
			if(!this._sound)
			{
				return;
			}
			this._sound.removeEventListener(IOErrorEvent.IO_ERROR, sound_errorHandler);
			this._sound.removeEventListener(ProgressEvent.PROGRESS, sound_progressHandler);
			this._sound.removeEventListener(flash.events.Event.COMPLETE, sound_completeHandler);
			this._sound.removeEventListener(flash.events.Event.ID3, sound_id3Handler);
			this._sound = null;
		}

		/**
		 * @private
		 */
		protected function soundPlayer_enterFrameHandler(event:starling.events.Event):void
		{
			this._currentTime = this._soundChannel.position / 1000;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}

		/**
		 * @private
		 * This isn't when the sound finishes playing. It's when the sound has
		 * finished loading.
		 */
		protected function sound_completeHandler(event:flash.events.Event):void
		{
			this._totalTime = this._sound.length / 1000;
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
			this._isLoading = false;
			this._isLoaded = true;
			this.dispatchEventWith(MediaPlayerEventType.LOAD_COMPLETE);
		}

		/**
		 * @private
		 */
		protected function sound_id3Handler(event:flash.events.Event):void
		{
			this.dispatchEventWith(MediaPlayerEventType.METADATA_RECEIVED, false, this._sound.id3);
		}

		/**
		 * @private
		 */
		protected function sound_progressHandler(event:ProgressEvent):void
		{
			var oldTotalTime:Number = this._totalTime;
			this._totalTime = this._sound.length / 1000;
			if(oldTotalTime !== this._totalTime)
			{
				this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
			}
			this.dispatchEventWith(MediaPlayerEventType.LOAD_PROGRESS, false, event.bytesLoaded / event.bytesTotal);
		}

		/**
		 * @private
		 */
		protected function sound_errorHandler(event:ErrorEvent):void
		{
			//since it's just a string in both cases, we'll reuse event.type for
			//the Starling event.
			this.dispatchEventWith(event.type, false, event);
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
