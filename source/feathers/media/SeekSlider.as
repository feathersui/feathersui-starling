/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Slider;
	import feathers.core.IValidating;
	import feathers.events.FeathersEventType;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import starling.display.DisplayObject;

	import starling.events.Event;

	/**
	 * A specialized slider that displays and controls the current position of
	 * the playhead of a media player.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class SeekSlider extends Slider implements IMediaPlayerControl
	{
		/**
		 * The slider's thumb may be dragged horizontally (on the x-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_HORIZONTAL:String = "horizontal";

		/**
		 * The slider's thumb may be dragged vertically (on the y-axis).
		 *
		 * @see #direction
		 */
		public static const DIRECTION_VERTICAL:String = "vertical";

		/**
		 * The slider has only one track, that fills the full length of the
		 * slider. In this layout mode, the "minimum" track is displayed and
		 * fills the entire length of the slider. The maximum track will not
		 * exist.
		 *
		 * @see #trackLayoutMode
		 */
		public static const TRACK_LAYOUT_MODE_SINGLE:String = "single";

		/**
		 * The slider has two tracks, stretching to fill each side of the slider
		 * with the thumb in the middle. The tracks will be resized as the thumb
		 * moves. This layout mode is designed for sliders where the two sides
		 * of the track may be colored differently to show the value
		 * "filling up" as the slider is dragged.
		 *
		 * <p>Since the width and height of the tracks will change, consider
		 * using a special display object such as a <code>Scale9Image</code>,
		 * <code>Scale3Image</code> or a <code>TiledImage</code> that is
		 * designed to be resized dynamically.</p>
		 *
		 * @see #trackLayoutMode
		 * @see feathers.display.Scale9Image
		 * @see feathers.display.Scale3Image
		 * @see feathers.display.TiledImage
		 */
		public static const TRACK_LAYOUT_MODE_MIN_MAX:String = "minMax";

		/**
		 * The slider's track dimensions fill the full width and height of the
		 * slider.
		 *
		 * @see #trackScaleMode
		 */
		public static const TRACK_SCALE_MODE_EXACT_FIT:String = "exactFit";

		/**
		 * If the slider's direction is horizontal, the width of the track will
		 * fill the full width of the slider, and if the slider's direction is
		 * vertical, the height of the track will fill the full height of the
		 * slider. The other edge will not be scaled.
		 *
		 * @see #trackScaleMode
		 */
		public static const TRACK_SCALE_MODE_DIRECTIONAL:String = "directional";

		/**
		 * When the track is touched, the slider's thumb jumps directly to the
		 * touch position, and the slider's <code>value</code> property is
		 * updated to match as if the thumb were dragged to that position.
		 *
		 * @see #trackInteractionMode
		 */
		public static const TRACK_INTERACTION_MODE_TO_VALUE:String = "toValue";

		/**
		 * When the track is touched, the <code>value</code> is increased or
		 * decreased (depending on the location of the touch) by the value of
		 * the <code>page</code> property.
		 *
		 * @see #trackInteractionMode
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
		 * 
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
			
			if(this._direction === DIRECTION_VERTICAL)
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
