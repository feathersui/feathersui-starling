/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.LayoutGroup;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.errors.IllegalOperationError;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.textures.Texture;

	/**
	 * Dispatched when the original native width or height of the video content
	 * is calculated.
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
	 * @see #nativeWidth
	 * @see #nativeHeight
	 *
	 * @eventType feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
	 */
	[Event(name="dimensionsChange",type="starling.events.Event")]

	/**
	 * Dispatched when the media player changes to the full-screen display mode
	 * or back to the normal display mode.
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
	 * @see #isFullScreen
	 * @see #toggleFullScreen()
	 *
	 * @eventType feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
	 */
	[Event(name="displayStateChange",type="starling.events.Event")]

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
	 * Dispatched when the video texture is ready to be rendered. Indicates that
	 * the <code>texture</code> property will return a
	 * <code>starling.textures.Texture</code> that may be displayed in an
	 * <code>ImageLoader</code> or another component.
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
	 *   dispatched by the <code>flash.net.NetStream</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see #texture
	 *
	 * @eventType starling.events.Event.READY
	 */
	[Event(name="ready",type="starling.events.Event")]

	/**
	 * Dispatched when the <code>flash.net.NetStream</code> object dispatches
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
	 *   dispatched by the <code>flash.net.NetStream</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#event:ioError flash.net.NetStream: flash.events.IOErrorEvent.IO_ERROR
	 *
	 * @eventType starling.events.Event.IO_ERROR
	 */
	[Event(name="ioError",type="starling.events.Event")]

	/**
	 * Controls playback of video with a <code>flash.net.NetStream</code> object.
	 *
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class VideoPlayer extends BaseTimedMediaPlayer implements IVideoPlayer
	{
		/**
		 * @private
		 */
		protected static const NET_STATUS_CODE_NETSTREAM_PLAY_STOP:String = "NetStream.Play.Stop";

		/**
		 * @private
		 */
		protected static const NET_STATUS_CODE_NETSTREAM_PLAY_STREAMNOTFOUND:String = "NetStream.Play.StreamNotFound";

		/**
		 * @private
		 */
		protected static const NET_STATUS_CODE_NETSTREAM_SEEK_NOTIFY:String = "NetStream.Seek.Notify";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>VideoPlayer</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function VideoPlayer()
		{
			super();
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return VideoPlayer.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _fullScreenContainer:LayoutGroup;

		/**
		 * @private
		 */
		protected var _ignoreDisplayListEvents:Boolean = false;

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
		 * videoPlayer.soundTransform = new SoundTransform(0);</listing>
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
			if(this._netStream)
			{
				this._netStream.soundTransform = this._soundTransform;
			}
			this.dispatchEventWith(MediaPlayerEventType.SOUND_TRANSFORM_CHANGE);
		}

		/**
		 * @private
		 */
		protected var _isWaitingForTextureReady:Boolean = false;

		/**
		 * @private
		 */
		protected var _texture:Texture;

		/**
		 * The texture used to display the video. This texture is not
		 * automatically rendered by the <code>VideoPlayer</code> component. A
		 * component like an <code>ImageLoader</code> should be added as a child
		 * of the <code>VideoPlayer</code> to display the texture when it is
		 * ready.
		 * 
		 * <p>The <code>texture</code> property will initially return
		 * <code>null</code>. Listen for <code>Event.READY</code> to know when
		 * a valid texture is available to render.</p>
		 * 
		 * <p>In the following example, a listener is added for
		 * <code>Event.READY</code>, and the texture is displayed by an
		 * <code>ImageLoader</code> component:</p>
		 * 
		 * <listing version="3.0">
		 * function videoPlayer_readyHandler( event:Event ):void
		 * {
		 * 	var view:ImageLoader = new ImageLoader();
		 * 	view.source = videoPlayer.texture;
		 * 	videoPlayer.addChildAt(view, 0);
		 * }
		 * 
		 * videoPlayer.addEventListener( Event.READY, videoPlayer_readyHandler );</listing>
		 * 
		 * @see #event:ready starling.events.Event.READY
		 * @see feathers.controls.ImageLoader
		 */
		public function get texture():Texture
		{
			//there can be runtime errors if the texture is rendered before it
			//is ready, so we must return null until we're sure it's safe
			if(this._isWaitingForTextureReady)
			{
				return null;
			}
			return this._texture;
		}

		/**
		 * @inheritDoc
		 *
		 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
		 */
		public function get nativeWidth():Number
		{
			if(this._texture)
			{
				return this._texture.nativeWidth;
			}
			return 0;
		}

		/**
		 * @inheritDoc
		 *
		 * @see #event:dimensionsChange feathers.events.MediaPlayerEventType.DIMENSIONS_CHANGE
		 */
		public function get nativeHeight():Number
		{
			if(this._texture)
			{
				return this._texture.nativeHeight;
			}
			return 0;
		}

		/**
		 * @private
		 */
		protected var _netConnection:NetConnection;

		/**
		 * @private
		 */
		protected var _netStream:NetStream;

		/**
		 * The <code>flash.net.NetStream</code> object used to play the video.
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html flash.net.NetStream
		 */
		public function get netStream():NetStream
		{
			return this._netStream;
		}

		/**
		 * @private
		 */
		protected var _videoSource:String;
		
		public var pseudoStreaming:Boolean;
		
		public var timePlayed:Number;

		/**
		 * A string representing the video URL or any other accepted value that
		 * may be passed to the <code>play()</code> function of a
		 * <code>NetStream</code> object.
		 * 
		 * <p>In the following example, a video file URL is passed in:</p>
		 * 
		 * <listing version="3.0">
		 * videoPlayer.videoSource = "http://example.com/video.m4v";</listing>
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#play() Full description of flash.net.NetStream.play() in Adobe's Flash Platform API Reference
		 */
		public function get videoSource():String
		{
			return this._videoSource;
		}

		/**
		 * @private
		 */
		public function set videoSource(value:String):void
		{
			if(this._videoSource === value)
			{
				return;
			}
			timePlayed = 0;
			this._videoSource = value;
			if(this._autoPlay)
			{
				this.play();
			}
		}

		/**
		 * @private
		 */
		protected var _autoPlay:Boolean = true;

		/**
		 * Determines if the video starts playing immediately when the
		 * <code>videoSource</code> property is set.
		 *
		 * <p>In the following example, automatic playback is disabled:</p>
		 *
		 * <listing version="3.0">
		 * videoPlayer.autoPlay = false;</listing>
		 *
		 * @see #videoSource
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
		protected var _isFullScreen:Boolean = false;

		/**
		 * Indicates if the video player is currently full screen or not.
		 * 
		 * @see #toggleFullScreen()
		 * @see #event:displayStateChange feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
		 */
		public function get isFullScreen():Boolean
		{
			return this._isFullScreen;
		}

		/**
		 * @private
		 */
		protected var _fullScreenDisplayState:String = StageDisplayState.FULL_SCREEN_INTERACTIVE;

		[Inspectable(type="String",enumeration="fullScreenInteractive,fullScreen")]
		/**
		 * When the video player is displayed full-screen, determines the value
		 * of the native stage's <code>displayState</code> property.
		 * 
		 * <p>In the following example, the display state for full-screen mode
		 * is changed:</p>
		 * 
		 * <listing version="3.0">
		 * videoPlayer.fullScreenDisplayState = StageDisplayState.FULL_SCREEN;</listing>
		 * 
		 * @default StageDisplayState.FULL_SCREEN_INTERACTIVE
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN_INTERACTIVE StageDisplayState.FULL_SCREEN_INTERACTIVE
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN StageDisplayState.FULL_SCREEN
		 */
		public function get fullScreenDisplayState():String
		{
			return this._fullScreenDisplayState;
		}

		/**
		 * @private
		 */
		public function set fullScreenDisplayState(value:String):void
		{
			if(this._fullScreenDisplayState == value)
			{
				return;
			}
			this._fullScreenDisplayState = value;
			if(this._isFullScreen)
			{
				var nativeStage:Stage = Starling.current.nativeStage;
				nativeStage.displayState = this._fullScreenDisplayState;
			}
		}

		/**
		 * @private
		 */
		protected var _hideRootWhenFullScreen:Boolean = true;

		/**
		 * Determines if the Starling root display object is hidden when the
		 * video player switches to full screen mode. By hiding the root display
		 * object, rendering performance is optimized because Starling skips a
		 * portion of the display list that is obscured by the video player.
		 *
		 * <p>In the following example, the root display object isn't hidden
		 * when the video player is displayed in full screen:</p>
		 *
		 * <listing version="3.0">
		 * videoPlayer.hideRootWhenFullScreen = false;</listing>
		 *
		 * @default true
		 */
		public function get hideRootWhenFullScreen():Boolean
		{
			return this._hideRootWhenFullScreen;
		}

		/**
		 * @private
		 */
		public function set hideRootWhenFullScreen(value:Boolean):void
		{
			this._hideRootWhenFullScreen = value;
		}

		/**
		 * @private
		 */
		override public function get hasVisibleArea():Boolean
		{
			if(this._isFullScreen)
			{
				return false;
			}
			return super.hasVisibleArea;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			if(this._texture)
			{
				this._texture.dispose();
				this._texture = null;
			}
			if(this._netStream)
			{
				this._netStream.close();
				this._netStream = null;
				this._netConnection = null;
			}
			super.dispose();
		}

		/**
		 * Goes to full screen or returns to normal display.
		 * 
		 * @see #isFullScreen
		 * @see #event:displayStateChange feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
		 */
		public function toggleFullScreen():void
		{
			if(!this.stage)
			{
				throw new IllegalOperationError("Cannot enter full screen mode if the video player does not have access to the Starling stage.")
			}
			var nativeStage:Stage = Starling.current.nativeStage;
			var oldIgnoreDisplayListEvents:Boolean = this._ignoreDisplayListEvents;
			this._ignoreDisplayListEvents = true;
			if(this._isFullScreen)
			{
				this.root.visible = true;
				PopUpManager.removePopUp(this._fullScreenContainer, false);
				var childCount:int = this._fullScreenContainer.numChildren;
				for(var i:int = 0; i < childCount; i++)
				{
					var child:DisplayObject = this._fullScreenContainer.getChildAt(0);
					this.addChild(child);
				}
				nativeStage.displayState = StageDisplayState.NORMAL;
			}
			else
			{
				if(this._hideRootWhenFullScreen)
				{
					this.root.visible = false;
				}
				nativeStage.displayState = this._fullScreenDisplayState;
				if(!this._fullScreenContainer)
				{
					this._fullScreenContainer = new LayoutGroup();
					this._fullScreenContainer.autoSizeMode = LayoutGroup.AUTO_SIZE_MODE_STAGE;
				}
				this._fullScreenContainer.layout = this._layout;
				childCount = this.numChildren;
				for(i = 0; i < childCount; i++)
				{
					child = this.getChildAt(0);
					this._fullScreenContainer.addChild(child);
				}
				PopUpManager.addPopUp(this._fullScreenContainer, true, false);
			}
			this._ignoreDisplayListEvents = oldIgnoreDisplayListEvents;
			this._isFullScreen = !this._isFullScreen;
			this.dispatchEventWith(MediaPlayerEventType.DISPLAY_STATE_CHANGE);
		}

		/**
		 * @private
		 */
		override protected function playMedia():void
		{
			if(!this._netStream)
			{
				this._netConnection = new NetConnection();
				this._netConnection.connect(null);
				this._netStream = new NetStream(this._netConnection);
				this._netStream.client = new VideoPlayerNetStreamClient(this.netStream_onMetaData);
				this._netStream.addEventListener(NetStatusEvent.NET_STATUS, netStream_netStatusHandler);
				this._netStream.addEventListener(IOErrorEvent.IO_ERROR, netStream_ioErrorHandler);
			}
			if(!this._soundTransform)
			{
				this._soundTransform = new SoundTransform();
			}
			this._netStream.soundTransform = this._soundTransform;
			if(this._texture)
			{
				this._netStream.resume();
			}
			else
			{
				this._isWaitingForTextureReady = true;
				this._texture = Texture.fromNetStream(this._netStream, Starling.current.contentScaleFactor, videoTexture_onComplete);
				//don't call play() until after Texture.fromNetStream() because
				//the texture needs to be created first.
				//however, we need to call play() even though a video texture
				//isn't ready to be rendered yet.
				this._netStream.play(this._videoSource);
			}
			this.addEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
		}

		/**
		 * @private
		 */
		override protected function pauseMedia():void
		{
			this.removeEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
			this._netStream.pause();
		}

		/**
		 * @private
		 */
		override protected function seekMedia(seconds:Number):void
		{
			this._currentTime = seconds;
			this._netStream.seek(seconds);
		}

		/**
		 * @private
		 */
		protected function videoPlayer_enterFrameHandler(event:Event):void
		{
			this._currentTime = this._netStream.time + this.timePlayed;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}

		/**
		 * @private
		 */
		protected function videoTexture_onComplete():void
		{
			this._isWaitingForTextureReady = false;
			//the texture is ready to be displayed.
			this.dispatchEventWith(Event.READY);
		}

		/**
		 * @private
		 */
		protected function netStream_onMetaData(metadata:Object):void
		{
			this.dispatchEventWith(MediaPlayerEventType.DIMENSIONS_CHANGE);
			this._totalTime = metadata.duration;
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
		}

		/**
		 * @private
		 */
		protected function netStream_ioErrorHandler(event:IOErrorEvent):void
		{
			this.dispatchEventWith(event.type, false, event);
		}

		/**
		 * @private
		 */
		protected function netStream_netStatusHandler(event:NetStatusEvent):void
		{
			var code:String = event.info.code;
			switch(code)
			{
				case NET_STATUS_CODE_NETSTREAM_PLAY_STREAMNOTFOUND:
				{
					this.dispatchEventWith(FeathersEventType.ERROR, false, code);
					break;
				}
				case NET_STATUS_CODE_NETSTREAM_PLAY_STOP:
				{
					if(this._isPlaying)
					{
						this.stop();
					}
					break;
				}
				case "NetStream.Play.Start":
				{
					if(!this._isPlaying)
					{
						this._netStream.pause();
					}
					this._currentTime = this._netStream.time + this.timePlayed;
					this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
					break;
				}
				case NET_STATUS_CODE_NETSTREAM_SEEK_NOTIFY:
				{
					this._currentTime = this._netStream.time + this.timePlayed;
					this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
					break;
				}
			}
		}

		/**
		 * @private
		 */
		override protected function mediaPlayer_addedHandler(event:Event):void
		{
			if(this._ignoreDisplayListEvents)
			{
				return;
			}
			super.mediaPlayer_addedHandler(event);
		}

		/**
		 * @private
		 */
		override protected function mediaPlayer_removedHandler(event:Event):void
		{
			if(this._ignoreDisplayListEvents)
			{
				return;
			}
			super.mediaPlayer_removedHandler(event);
		}
	}
}

dynamic class VideoPlayerNetStreamClient
{
	public function VideoPlayerNetStreamClient(onMetaDataCallback:Function)
	{
		this.onMetaDataCallback = onMetaDataCallback;
	}
	
	public var onMetaDataCallback:Function;
	
	public function onMetaData(metadata:Object):void
	{
		this.onMetaDataCallback(metadata);
	}
}
