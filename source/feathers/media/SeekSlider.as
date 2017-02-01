/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Slider;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.events.MediaPlayerEventType;
	import feathers.layout.Direction;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;
	import starling.events.Event;

	/**
	 * An optional skin that acts similar to the fill skin of a progress bar
	 * that displays the download progres of the media.
	 *
	 * <p>In the following example, the progress skin is customized:</p>
	 *
	 * <listing version="3.0">
	 * var skin:Image = new Image( texture );
	 * skin.scale9Grid = new Rectangle( 2, 3, 6, 1 );
	 * slider.progressSkin = skin;</listing>
	 * 
	 * @default null
	 */
	[Style(name="progressSkin",type="starling.display.DisplayObject")]

	/**
	 * A specialized slider that displays and controls the current position of
	 * the playhead of a media player.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class SeekSlider extends Slider implements IMediaPlayerControl
	{
		[Deprecated(replacement="feathers.layout.Direction.HORIZONTAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.HORIZONAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		[Deprecated(replacement="feathers.layout.Direction.VERTICAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.layout.Direction.VERTICAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SINGLE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SINGLE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		[Deprecated(replacement="feathers.controls.TrackLayoutMode.SPLIT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackLayoutMode.SPLIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

		[Deprecated(replacement="feathers.controls.TrackScaleMode.EXACT_FIT",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackScaleMode.EXACT_FIT</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

		[Deprecated(replacement="feathers.controls.TrackScaleMode.DIRECTIONAL",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackScaleMode.DIRECTIONAL</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

		[Deprecated(replacement="feathers.controls.TrackInteractionMode.TO_VALUE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.TO_VALUE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";

		[Deprecated(replacement="feathers.controls.TrackInteractionMode.BY_PAGE",since="3.0.0")]
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.TrackInteractionMode.BY_PAGE</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const TRACK_INTERACTION_MODE_BY_PAGE:String = "byPage";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * minimum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK:String = "feathers-seek-slider-minimum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the
		 * maximum track.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK:String = "feathers-seek-slider-maximum-track";

		/**
		 * The default value added to the <code>styleNameList</code> of the thumb.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_THUMB:String = "feathers-seek-slider-thumb";
		
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>SeekSlider</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function SeekSlider()
		{
			super();
			this.thumbStyleName = SeekSlider.DEFAULT_CHILD_STYLE_NAME_THUMB;
			this.minimumTrackStyleName = SeekSlider.DEFAULT_CHILD_STYLE_NAME_MINIMUM_TRACK;
			this.maximumTrackStyleName = SeekSlider.DEFAULT_CHILD_STYLE_NAME_MAXIMUM_TRACK;
			this.addEventListener(Event.CHANGE, seekSlider_changeHandler);
			this.addEventListener(FeathersEventType.END_INTERACTION, seekSlider_endInteractionHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return SeekSlider.globalStyleProvider;
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
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.LOAD_PROGRESS, mediaPlayer_loadProgressHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.addEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
				if(this._mediaPlayer is IProgressiveMediaPlayer)
				{
					var progressivePlayer:IProgressiveMediaPlayer = IProgressiveMediaPlayer(this._mediaPlayer);
					progressivePlayer.addEventListener(MediaPlayerEventType.LOAD_PROGRESS, mediaPlayer_loadProgressHandler);
					if(progressivePlayer.bytesTotal > 0)
					{
						this._progress = progressivePlayer.bytesLoaded / progressivePlayer.bytesTotal;
					}
					else
					{
						this._progress = 0;
					}
				}
				else
				{
					this._progress = 0;
				}
				this.minimum = 0;
				this.maximum = this._mediaPlayer.totalTime;
				this.value = this._mediaPlayer.currentTime;
			}
			else
			{
				this.minimum = 0;
				this.maximum = 0;
				this.value = 0;
			}
		}

		/**
		 * @private
		 */
		protected var _progress:Number = 0;

		/**
		 * @private
		 */
		protected var _progressSkin:DisplayObject;

		/**
		 * @private
		 */
		public function get progressSkin():DisplayObject
		{
			return this._progressSkin;
		}

		/**
		 * @private
		 */
		public function set progressSkin(value:DisplayObject):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				if(value !== null)
				{
					value.dispose();
				}
				return;
			}
			if(this._progressSkin == value)
			{
				return;
			}
			if(this._progressSkin)
			{
				this.removeChild(this._progressSkin);
			}
			this._progressSkin = value;
			if(this._progressSkin)
			{
				if(this._progressSkin.parent != this)
				{
					this._progressSkin.visible = false;
					this.addChild(this._progressSkin);
				}
				this._progressSkin.touchable = false;
			}
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}

		/**
		 * @private
		 */
		override protected function layoutChildren():void
		{
			super.layoutChildren();
			this.layoutProgressSkin();
		}

		/**
		 * @private
		 */
		protected function layoutProgressSkin():void
		{
			if(this._progressSkin === null)
			{
				return;
			}

			if(this._minimum === this._maximum)
			{
				var percentage:Number = 1;
			}
			else
			{
				percentage = (this._value - this._minimum) / (this._maximum - this._minimum);
				if(percentage < 0)
				{
					percentage = 0;
				}
				else if(percentage > 1)
				{
					percentage = 1;
				}
			}
			if(this._progress === 0 || this._progress <= percentage)
			{
				this._progressSkin.visible = false;
				return;
			}

			this._progressSkin.visible = true;
			if(this._progressSkin is IValidating)
			{
				IValidating(this._progressSkin).validate();
			}
			
			if(this._direction === Direction.VERTICAL)
			{
				var trackScrollableHeight:Number = this.actualHeight - this.thumb.height / 2 - this._minimumPadding - this._maximumPadding;
				this._progressSkin.x = Math.round((this.actualWidth - this._progressSkin.width) / 2);
				var progressHeight:Number = Math.round(trackScrollableHeight * this._progress);
				var maxProgressHeight:Number = Math.round(this.thumb.y + this.thumb.height / 2);
				if(progressHeight < 0)
				{
					progressHeight = 0;
				}
				else if(progressHeight > maxProgressHeight)
				{
					progressHeight = maxProgressHeight;
				}
				this._progressSkin.height = progressHeight;
				this._progressSkin.y = maxProgressHeight - progressHeight;
			}
			else //horizontal
			{
				var trackScrollableWidth:Number = this.actualWidth - this._minimumPadding - this._maximumPadding;
				this._progressSkin.x = Math.round(this.thumb.x + this.thumb.width / 2);
				this._progressSkin.y = Math.round((this.actualHeight - this._progressSkin.height) / 2);
				var progressWidth:Number = Math.round((trackScrollableWidth * this._progress) - this._progressSkin.x);
				if(progressWidth < 0)
				{
					progressWidth = 0;
				}
				else
				{
					var maxProgressWidth:Number = Math.round(this.actualWidth - this._progressSkin.x);
					if(progressWidth > maxProgressWidth)
					{
						progressWidth = maxProgressWidth;
					}
				}
				this._progressSkin.width = progressWidth;
			}
		}

		/**
		 * @private
		 */
		protected function updateValueFromMediaPlayerCurrentTime():void
		{
			if(this.isDragging)
			{
				//if we're currently dragging, ignore changes by the player
				return;
			}
			this._value = this._mediaPlayer.currentTime;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function seekSlider_changeHandler(event:Event):void
		{
			if(!this._mediaPlayer)
			{
				return;
			}
			this._mediaPlayer.seek(this._value);
		}

		/**
		 * @private
		 */
		protected function seekSlider_endInteractionHandler(event:Event):void
		{
			//we may have ignored some changes from the media player while we
			//were dragging, so we should update the value if it's out of sync.
			this.updateValueFromMediaPlayerCurrentTime();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_currentTimeChangeHandler(event:Event):void
		{
			this.updateValueFromMediaPlayerCurrentTime();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_totalTimeChangeHandler(event:Event):void
		{
			this.maximum = this._mediaPlayer.totalTime;
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_loadProgressHandler(event:Event, progress:Number):void
		{
			if(this._progress === progress)
			{
				return;
			}
			this._progress = progress;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
	}
}
