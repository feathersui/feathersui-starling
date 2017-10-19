/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.AutoSizeMode;
	import feathers.controls.LayoutGroup;
	import feathers.core.PopUpManager;
	import feathers.events.FeathersEventType;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.errors.IllegalOperationError;
	import flash.events.FullScreenEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.rendering.Painter;
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
	 * or back to the normal display mode. The value of the
	 * <code>isFullScreen</code> property indicates if the media player is
	 * displayed in full screen mode or normally. 
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
	 * Dispatched when the video metadata becomes available with the
	 * <code>onMetaData</code> callback from the <code>NetStream</code> instance.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The metadata object passed with the
	 *   <code>onMetaData</code> callback from the <code>NetStream</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 * 
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#event:onMetaData flash.net.NetStream onMetaData callback
	 *
	 * @eventType feathers.events.MediaPlayerEventType.METADATA_RECEIVED
	 */
	[Event(name="metadataReceived",type="starling.events.Event")]

	/**
	 * Dispatched when a cue point is reached with the <code>onCuePoint</code>
	 * callback from the <code>NetStream</code> instance.
	 *
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 * <tr><th>Property</th><th>Value</th></tr>
	 * <tr><td><code>bubbles</code></td><td>false</td></tr>
	 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
	 *   event listener that handles the event. For example, if you use
	 *   <code>myButton.addEventListener()</code> to register an event listener,
	 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
	 * <tr><td><code>data</code></td><td>The cue point object passed with the
	 *   <code>onCuePoint</code> callback from the <code>NetStream</code>.</td></tr>
	 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
	 *   it is not always the Object listening for the event. Use the
	 *   <code>currentTarget</code> property to always access the Object
	 *   listening for the event.</td></tr>
	 * </table>
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html#event:onCuePoint flash.net.NetStream onCuePoint callback
	 *
	 * @eventType feathers.events.MediaPlayerEventType.CUE_POINT
	 */
	[Event(name="metadataReceived",type="starling.events.Event")]

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
	 * <tr><td><code>data</code></td><td>null</td></tr>
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
	 * Dispatched when the video texture is no longer valid. Indicates that
	 * the <code>texture</code> property will return a <code>null</code> value,
	 * and that that the previous texture has been disposed and should not be
	 * rendered any more.
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
	 * @see #texture
	 *
	 * @eventType feathers.events.FeathersEventType.CLEAR
	 */
	[Event(name="clear",type="starling.events.Event")]

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
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class VideoPlayer extends BaseTimedMediaPlayer implements IVideoPlayer, IProgressiveMediaPlayer
	{
		/**
		 * @private
		 */
		protected static const NET_STATUS_CODE_NETCONNECTION_CONNECT_SUCCESS:String = "NetConnection.Connect.Success";

		/**
		 * @private
		 */
		protected static const NET_STATUS_CODE_NETSTREAM_PLAY_START:String = "NetStream.Play.Start";

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
		protected static const NET_STATUS_CODE_NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String = "NetStream.Play.NoSupportedTrackFound";

		/**
		 * @private
		 */
		protected static const NO_VIDEO_SOURCE_PLAY_ERROR:String = "Cannot play media when videoSource property has not been set.";

		/**
		 * @private
		 */
		protected static const NO_VIDEO_SOURCE_PAUSE_ERROR:String = "Cannot pause media when videoSource property has not been set.";

		/**
		 * @private
		 */
		protected static const NO_VIDEO_SOURCE_SEEK_ERROR:String = "Cannot seek media when videoSource property has not been set.";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>VideoPlayer</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * @private
		 */
		protected static function defaultNetConnectionFactory():NetConnection
		{
			var connection:NetConnection = new NetConnection();
			connection.connect(null);
			return connection;
		}

		/**
		 * @private
		 */
		protected static function defaultNetStreamFactory(netConnection:NetConnection):NetStream
		{
			return new NetStream(netConnection);
		}
		
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
		 *     var view:ImageLoader = new ImageLoader();
		 *     view.source = videoPlayer.texture;
		 *     videoPlayer.addChildAt(view, 0);
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
		protected var _hasPlayedToEnd:Boolean = false;

		/**
		 * @private
		 */
		protected var _videoSource:String;

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
			if(this._isPlaying)
			{
				this.stop();
			}
			this.disposeNetStream();
			if(!value)
			{
				this.disposeNetConnection();
			}
			if(this._texture !== null)
			{
				this._texture.dispose();
				this._texture = null;
				this.dispatchEventWith(FeathersEventType.CLEAR);
			}
			this._videoSource = value;
			//reset the current and total time if we were playing a different
			//video previously
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
			//same with the bytes loaded and total
			this._bytesLoaded = 0;
			this._bytesTotal = 0;
			if(this._autoPlay && this._videoSource)
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
		 * Indicates if the video player is currently full screen or not. When
		 * the player is full screen, it will be displayed as a modal pop-up
		 * that fills the entire Starling stage. Depending on the value of
		 * <code>fullScreenDisplayState</code>, it may also change the value of
		 * the native stage's <code>displayState</code> property.
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
		protected var _normalDisplayState:String = StageDisplayState.NORMAL;

		[Inspectable(type="String",enumeration="fullScreenInteractive,fullScreen,normal")]
		/**
		 * When the video player is displayed normally (in other words, when it
		 * isn't full-screen), determines the value of the native stage's
		 * <code>displayState</code> property.
		 * 
		 * <p>Using this property, it is possible to set the native stage's
		 * <code>displayState</code> property to
		 * <code>StageDisplayState.FULL_SCREEN_INTERACTIVE</code> or
		 * <code>StageDisplayState.FULL_SCREEN</code> when the video player
		 * is not in full screen mode. This might be useful for mobile apps that
		 * should always display in full screen, while allowing a video player
		 * to toggle between filling the entire stage and displaying at a
		 * smaller size within its parent's layout.</p>
		 *
		 * <p>In the following example, the display state for normal mode
		 * is changed:</p>
		 *
		 * <listing version="3.0">
		 * videoPlayer.fullScreenDisplayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;</listing>
		 *
		 * @default StageDisplayState.NORMAL
		 *
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN_INTERACTIVE StageDisplayState.FULL_SCREEN_INTERACTIVE
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#FULL_SCREEN StageDisplayState.FULL_SCREEN
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#NORMAL StageDisplayState.NORMAL
		 * @see #fullScreenDisplayState
		 */
		public function get normalDisplayState():String
		{
			return this._normalDisplayState;
		}

		/**
		 * @private
		 */
		public function set normalDisplayState(value:String):void
		{
			if(this._normalDisplayState == value)
			{
				return;
			}
			this._normalDisplayState = value;
			if(!this._isFullScreen && this.stage)
			{
				var starling:Starling = this.stage.starling;
				var nativeStage:Stage = starling.nativeStage;
				nativeStage.displayState = this._normalDisplayState;
			}
		}

		/**
		 * @private
		 */
		protected var _fullScreenDisplayState:String = StageDisplayState.FULL_SCREEN_INTERACTIVE;

		[Inspectable(type="String",enumeration="fullScreenInteractive,fullScreen,normal")]
		/**
		 * When the video player is displayed full-screen, determines the value
		 * of the native stage's <code>displayState</code> property.
		 *
		 * <p>Using this property, it is possible to set the native stage's
		 * <code>displayState</code> property to
		 * <code>StageDisplayState.NORMAL</code> when the video player is in
		 * full screen mode. The video player will still be displayed as a modal
		 * pop-up that fills the entire Starling stage, in this situation.</p>
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
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/display/StageDisplayState.html#NORMAL StageDisplayState.NORMAL
		 * @see #normalDisplayState
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
			if(this._isFullScreen && this.stage)
			{
				var starling:Starling = this.stage.starling;
				var nativeStage:Stage = starling.nativeStage;
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
		protected var _netConnectionFactory:Function = defaultNetConnectionFactory;

		/**
		 * Creates the <code>flash.net.NetConnection</code> object used to play
		 * the video, and calls the <code>connect()</code> method. By default, a
		 * value of <code>null</code> is passed to the <code>connect()</code>
		 * method. To pass different parameters, you may use a custom
		 * <code>netConnectionFactory</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function():NetConnection</pre>
		 *
		 * <p>In the following example, a custom factory for the
		 * <code>NetConnection</code> is passed to the video player:</p>
		 *
		 * <listing version="3.0">
		 * videoPlayer.netConnectionFactory = function():NetConnection
		 * {
		 *     var connection:NetConnection = new NetConnection();
		 *     connection.connect( command );
		 *     return connection;
		 * };</listing>
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetConnection.html flash.net.NetConnection
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetConnection.html#connect() flash.net.NetConnection.connect()
		 */
		public function get netConnectionFactory():Function
		{
			return this._netConnectionFactory;
		}

		/**
		 * @private
		 */
		public function set netConnectionFactory(value:Function):void
		{
			if(this._netConnectionFactory === value)
			{
				return;
			}
			this._netConnectionFactory = value;
			this.stop();
			this.disposeNetStream();
			this.disposeNetConnection();
		}

		/**
		 * @private
		 */
		protected var _netStreamFactory:Function = defaultNetStreamFactory;

		/**
		 * Creates the <code>flash.net.NetStream</code> object used to play
		 * the video.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function(netConnection:NetConnection):NetStream</pre>
		 *
		 * <p>In the following example, a custom factory for the
		 * <code>NetStream</code> is passed to the video player:</p>
		 *
		 * <listing version="3.0">
		 * videoPlayer.netConnectionFactory = function(netConnection:NetConnection):NetStream
		 * {
		 *     var stream:NetStream = new NetStream(netConnection);
		 *     //change properties here
		 *     return stream;
		 * };</listing>
		 * 
		 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/NetStream.html flash.net.NetStream
		 */
		public function get netStreamFactory():Function
		{
			return this._netStreamFactory;
		}

		/**
		 * @private
		 */
		public function set netStreamFactory(value:Function):void
		{
			if(this._netStreamFactory === value)
			{
				return;
			}
			this._netStreamFactory = value;
			this.stop();
			this.disposeNetStream();
			this.disposeNetConnection();
		}

		/**
		 * @private
		 */
		protected var _bytesLoaded:uint = 0;

		/**
		 * @copy feathers.media.IProgressiveMediaPlayer#bytesLoaded
		 *
		 * @see #bytesTotal
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		public function get bytesLoaded():uint
		{
			return this._bytesLoaded;
		}

		/**
		 * @private
		 */
		protected var _bytesTotal:uint = 0;

		/**
		 * @copy feathers.media.IProgressiveMediaPlayer#bytesTotal
		 *
		 * @see #bytesLoaded
		 * @see #event:loadProgress feathers.events.MediaPlayerEventType.LOAD_PROGRESS
		 */
		public function get bytesTotal():uint
		{
			return this._bytesTotal;
		}

		/**
		 * @private
		 */
		override public function dispose():void
		{
			this.videoSource = null;
			super.dispose();
		}

		/**
		 * @private
		 */
		override public function play():void
		{
			if(this._videoSource === null)
			{
				return;
			}
			super.play();
		}

		/**
		 * @private
		 */
		override public function stop():void
		{
			if(this._videoSource === null)
			{
				return;
			}
			super.stop();
		}

		/**
		 * @private
		 */
		override public function render(painter:Painter):void
		{
			if(this._isFullScreen)
			{
				return;
			}
			super.render(painter);
		}

		/**
		 * Goes to full screen or returns to normal display.
		 * 
		 * <p> When the player is full screen, it will be displayed as a modal
		 * pop-up that fills the entire Starling stage. Depending on the value
		 * of <code>fullScreenDisplayState</code>, it may also change the value
		 * of the native stage's <code>displayState</code> property.</p>
		 * 
		 * <p>When the player is displaying normally (in other words, when it is
		 * not full screen), it will be displayed in its parent's layout like
		 * any other Feathers component.</p>
		 * 
		 * @see #isFullScreen
		 * @see #fullScreenDisplayState
		 * @see #normalDisplayState
		 * @see #event:displayStateChange feathers.events.MediaPlayerEventType.DISPLAY_STATE_CHANGE
		 */
		public function toggleFullScreen():void
		{
			if(!this.stage)
			{
				throw new IllegalOperationError("Cannot enter full screen mode if the video player does not have access to the Starling stage.")
			}
			var starling:Starling = this.stage.starling;
			var nativeStage:Stage = starling.nativeStage;
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
				nativeStage.removeEventListener(FullScreenEvent.FULL_SCREEN, nativeStage_fullScreenHandler);
				nativeStage.displayState = this._normalDisplayState;
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
					this._fullScreenContainer.autoSizeMode = AutoSizeMode.STAGE;
				}
				this._fullScreenContainer.layout = this._layout;
				childCount = this.numChildren;
				for(i = 0; i < childCount; i++)
				{
					child = this.getChildAt(0);
					this._fullScreenContainer.addChild(child);
				}
				PopUpManager.addPopUp(this._fullScreenContainer, true, false);
				nativeStage.addEventListener(FullScreenEvent.FULL_SCREEN, nativeStage_fullScreenHandler, false, 0, true);
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
			if(!this._videoSource)
			{
				throw new IllegalOperationError(NO_VIDEO_SOURCE_PLAY_ERROR);
			}
			if(this._netConnection === null)
			{
				var netConnectionFactory:Function = this._netConnectionFactory !== null ? this._netConnectionFactory : defaultNetConnectionFactory;
				this._netConnection = NetConnection(netConnectionFactory());
			}
			if(this._netStream === null)
			{
				if(!this._netConnection.connected)
				{
					//wait for the NetConnection to connect before trying to
					//create the NetStream. we'll call playMedia later.
					this._netConnection.addEventListener(NetStatusEvent.NET_STATUS, netConnection_netStatusHandler);
					return;
				}
				var netStreamFactory:Function = this._netStreamFactory !== null ? this._netStreamFactory : defaultNetStreamFactory;
				this._netStream = NetStream(netStreamFactory(this._netConnection));
				this._netStream.client = new VideoPlayerNetStreamClient(
					this.netStream_onMetaData, this.netStream_onCuePoint,
					this.netStream_onXMPData);
				this._netStream.addEventListener(NetStatusEvent.NET_STATUS, netStream_netStatusHandler);
				this._netStream.addEventListener(IOErrorEvent.IO_ERROR, netStream_ioErrorHandler);
			}
			if(this._soundTransform === null)
			{
				this._soundTransform = new SoundTransform();
			}
			this._netStream.soundTransform = this._soundTransform;
			var onCompleteCallback:Function = videoTexture_onComplete;
			if(this._texture !== null)
			{
				if(this._hasPlayedToEnd)
				{
					//after playing the media until the end, if we restart from the
					//beginning, the audio plays, but we cannot see the video.
					//however, we can ask the NetStream to play the video source
					//again from the beginning, and the video displays. if we need
					//to restore the time, we can do it after the NetStream
					//dispatches NetStream.Play.Start
					this._netStream.play(this._videoSource);
				}
				else
				{
					//this case happens if the video is paused and resumed without
					//reaching the end.
					//NetStream.Play.Start will not be dispatched after calling
					//resume(), so we need to manually add the ENTER_FRAME listener.
					//there's no need to seek. we're resuming from where the video
					//was paused.
					this.addEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
					this._netStream.resume();
				}
			}
			else
			{
				//in the final case, the texture hasn't been created yet.
				this._isWaitingForTextureReady = true;
				var starling:Starling = this.stage !== null ? this.stage.starling : Starling.current;
				this._texture = Texture.fromNetStream(this._netStream, starling.contentScaleFactor, onCompleteCallback);
				this._texture.root.onRestore = videoTexture_onRestore;
				//don't call play() until after Texture.fromNetStream() because
				//the texture needs to be created first.
				//however, we need to call play() even though a video texture
				//isn't ready to be rendered yet.
				this._netStream.play(this._videoSource);
			}
			this._hasPlayedToEnd = false;
		}

		/**
		 * @private
		 */
		override protected function pauseMedia():void
		{
			if(!this._videoSource)
			{
				throw new IllegalOperationError(NO_VIDEO_SOURCE_PAUSE_ERROR);
			}
			this.removeEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
			this._netStream.pause();
		}

		/**
		 * @private
		 */
		override protected function seekMedia(seconds:Number):void
		{
			if(!this._videoSource)
			{
				throw new IllegalOperationError(NO_VIDEO_SOURCE_SEEK_ERROR);
			}
			this._currentTime = seconds;
			if(this._hasPlayedToEnd)
			{
				//the video played until the end, which means that the current
				//texture cannot seek properly without reloading the media.
				this.playMedia();
				return;
			}
			this._netStream.seek(seconds);
		}

		/**
		 * @private
		 */
		protected function disposeNetConnection():void
		{
			if(this._netConnection === null)
			{
				return;
			}
			this._netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netConnection_netStatusHandler);
			this._netConnection.close();
			this._netConnection = null;
		}

		/**
		 * @private
		 */
		protected function disposeNetStream():void
		{
			if(this._netStream === null)
			{
				return;
			}
			this._netStream.removeEventListener(NetStatusEvent.NET_STATUS, netStream_netStatusHandler);
			this._netStream.removeEventListener(IOErrorEvent.IO_ERROR, netStream_ioErrorHandler);
			this._netStream.close();
			this._netStream = null;
		}

		/**
		 * @private
		 */
		protected function videoPlayer_enterFrameHandler(event:Event):void
		{
			this._currentTime = this._netStream.time;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}

		/**
		 * @private
		 */
		protected function videoPlayer_progress_enterFrameHandler(event:Event):void
		{
			var newBytesTotal:Number = this._netStream.bytesTotal;
			if(newBytesTotal > 0)
			{
				var needsDispatch:Boolean = false;
				var newBytesLoaded:Number = this._netStream.bytesLoaded;
				if(this._bytesTotal !== newBytesTotal)
				{
					this._bytesTotal = newBytesTotal;
					needsDispatch = true;
				}
				if(this._bytesLoaded !== newBytesLoaded)
				{
					this._bytesLoaded = newBytesLoaded;
					needsDispatch = true;
				}
				if(needsDispatch)
				{
					this.dispatchEventWith(MediaPlayerEventType.LOAD_PROGRESS, false, newBytesLoaded / newBytesTotal);
				}
				if(newBytesLoaded === newBytesTotal)
				{
					this.removeEventListener(Event.ENTER_FRAME, videoPlayer_progress_enterFrameHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function videoTexture_onRestore():void
		{
			this.pauseMedia();
			this._isWaitingForTextureReady = true;
			this._texture.root.attachNetStream(this._netStream, videoTexture_onComplete);
			//this will start playback from the beginning again, but we can seek
			//back to the current time once the video texture is ready.
			this._netStream.play(this._videoSource);
		}

		/**
		 * @private
		 */
		protected function videoTexture_onComplete():void
		{
			this._isWaitingForTextureReady = false;
			//the texture is ready to be displayed
			this.dispatchEventWith(Event.READY);
			//in many cases, the layout will be affected by the new texture
			//dimensions, so invalidate immediately
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
			var bytesTotal:Number = this._netStream.bytesTotal;
			if(this._bytesTotal === 0 && bytesTotal > 0)
			{
				this._bytesLoaded = this._netStream.bytesLoaded;
				this._bytesTotal = bytesTotal;
				this.dispatchEventWith(MediaPlayerEventType.LOAD_PROGRESS, false, this._bytesLoaded / bytesTotal);
				if(this._bytesLoaded !== this._bytesTotal)
				{
					this.addEventListener(Event.ENTER_FRAME, videoPlayer_progress_enterFrameHandler);
				}
			}
		}

		/**
		 * @private
		 */
		protected function netConnection_netStatusHandler(event:NetStatusEvent):void
		{
			var code:String = event.info.code;
			switch(code)
			{
				case NET_STATUS_CODE_NETCONNECTION_CONNECT_SUCCESS:
				{
					this.playMedia();
					break;
				}
			}
		}

		/**
		 * @private
		 */
		protected function netStream_onMetaData(metadata:Object):void
		{
			this.dispatchEventWith(MediaPlayerEventType.DIMENSIONS_CHANGE);
			this._totalTime = metadata.duration;
			this.dispatchEventWith(MediaPlayerEventType.TOTAL_TIME_CHANGE);
			this.dispatchEventWith(MediaPlayerEventType.METADATA_RECEIVED, false, metadata);
		}

		/**
		 * @private
		 */
		protected function netStream_onCuePoint(cuePoint:Object):void
		{
			this.dispatchEventWith(MediaPlayerEventType.CUE_POINT, false, cuePoint);
		}

		/**
		 * @private
		 */
		protected function netStream_onXMPData(xmpData:Object):void
		{
			this.dispatchEventWith(MediaPlayerEventType.XMP_DATA, false, xmpData);
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
				case NET_STATUS_CODE_NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:
				{
					this.dispatchEventWith(FeathersEventType.ERROR, false, code);
					break;
				}
				case NET_STATUS_CODE_NETSTREAM_PLAY_START:
				{
					if(this._netStream.time !== this._currentTime)
					{
						//if we're restoring from a lost context, or we've
						//restarted the video after it had reached the end, the
						//NetStream may have restarted from the beginning. in
						//that case, we can manually seek to the last known good
						//position.
						this._netStream.seek(this._currentTime);
					}
					if(this._isPlaying)
					{
						//only add the listener if a video is playing. it may be
						//paused when restoring lost context, but we need to
						//temporarily start playing the NetStream in order to
						//restore the video texture.
						this.addEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);
					}
					else
					{
						//the only way to prepare the video texture is to start
						//playing the NetStream. the media player is not in a
						//playing state, though, so we should pause the
						//NetStream now.
						this.pauseMedia();
					}
					break;
				}
				case NET_STATUS_CODE_NETSTREAM_PLAY_STOP:
				{
					if(this._hasPlayedToEnd)
					{
						//we haven't cleared this flag yet after calling play()
						//on the NetStream. it is safe to ignore this case.
						return;
					}
					
					//any time that the NetStream stops, we want to remove the
					//Event.ENTER_FRAME listener. in most cases, we don't want
					//a listener being called every frame for no reason. on iOS,
					//context loss resets the NetStream time to 0, and we need
					//to keep the current time so that we can seek back.
					this.removeEventListener(Event.ENTER_FRAME, videoPlayer_enterFrameHandler);

					//on iOS, when context is lost, the NetStream will stop
					//automatically, and the time property will be reset to 0.
					//on other platforms, the NetStream will continue playing on
					//context loss, and the time will be correct.
					//we need to check if the context is lost or not to decide
					//if we've reached the end of the video or not.
					if(Starling.context.driverInfo !== "Disposed")
					{
						this.stop();
						
						//set this flag after calling stop() because stopping
						//will seek to the beginning and may check for the flag.
						this._hasPlayedToEnd = true;
						this.dispatchEventWith(Event.COMPLETE);
					}
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

		/**
		 * @private
		 */
		protected function nativeStage_fullScreenHandler(event:FullScreenEvent):void
		{
			this.toggleFullScreen();
		}
	}
}

dynamic class VideoPlayerNetStreamClient
{
	public function VideoPlayerNetStreamClient(onMetaDataCallback:Function,
		onCuePointCallback:Function, onXMPDataCallback:Function)
	{
		this.onMetaDataCallback = onMetaDataCallback;
		this.onCuePointCallback = onCuePointCallback;
		this.onXMPDataCallback = onXMPDataCallback;
	}

	public var onMetaDataCallback:Function;

	public var onCuePointCallback:Function;

	public function onMetaData(metadata:Object):void
	{
		this.onMetaDataCallback(metadata);
	}

	public function onCuePoint(cuePoint:Object):void
	{
		this.onCuePointCallback(cuePoint);
	}

	public function onXMPData(xmpData:Object):void
	{
		this.onXMPDataCallback(xmpData);
	}
}