/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.Label;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import flash.geom.Point;

	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.Pool;

	/**
	 * When the value of <code>displayMode</code> is
	 * <code>MediaTimeMode.CURRENT_AND_TOTAL_TIMES</code>, this text is
	 * inserted between the two times to separate them.
	 *
	 * @default " / "
	 *
	 * @see feathers.media.MediaTimeMode#CURRENT_AND_TOTAL_TIMES
	 */
	[Style(name="delimiter",type="String")]

	/**
	 * Determines how the time is displayed by the label.
	 *
	 * @default feathers.media.MediaTimeMode.CURRENT_AND_TOTAL_TIMES
	 *
	 * @see feathers.media.MediaTimeMode#CURRENT_AND_TOTAL_TIMES
	 * @see feathers.media.MediaTimeMode#CURRENT_TIME
	 * @see feathers.media.MediaTimeMode#TOTAL_TIME
	 * @see feathers.media.MediaTimeMode#REMAINING_TIME
	 */
	[Style(name="displayMode",type="String")]

	/**
	 * If the <code>displayMode</code> property is set to
	 * <code>MediaTimeMode.CURRENT_TIME</code> or
	 * <code>MediaTimeMode.REMAINING_TIME</code>, and this property
	 * is set to <code>true</code>, the label will switch to displaying the
	 * current time and the remaining time, if tapped or clicked. If the
	 * <code>displayMode</code> property is not set to one of the specified
	 * values, this property is ignored.
	 *
	 * @default false
	 *
	 * @see #style:displayMode
	 */
	[Style(name="toggleDisplayMode",type="Boolean")]

	/**
	 * A specialized label that can display the current playhead time, total
	 * time, remaining time, or a combined current and total time for a media
	 * player.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 *
	 * @productversion Feathers 2.2.0
	 */
	public class TimeLabel extends Label implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>TimeLabel</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function TimeLabel()
		{
			this.addEventListener(TouchEvent.TOUCH, timeLabel_touchHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			if(TimeLabel.globalStyleProvider)
			{
				return TimeLabel.globalStyleProvider;
			}
			return Label.globalStyleProvider;
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
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this._mediaPlayer.addEventListener(MediaPlayerEventType.CURRENT_TIME_CHANGE, mediaPlayer_currentTimeChangeHandler);
				this._mediaPlayer.addEventListener(MediaPlayerEventType.TOTAL_TIME_CHANGE, mediaPlayer_totalTimeChangeHandler);
			}
			this.updateText();
		}

		/**
		 * @private
		 */
		protected var _delimiter:String = " / ";

		/**
		 * @private
		 */
		public function get delimiter():String
		{
			return this._delimiter;
		}

		/**
		 * @private
		 */
		public function set delimiter(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._delimiter === value)
			{
				return;
			}
			this._delimiter = value;
			this.updateText();
		}

		/**
		 * @private
		 */
		protected var _displayMode:String = MediaTimeMode.CURRENT_AND_TOTAL_TIMES;

		[Inspectable(type="String",enumeration="currentAndTotalTimes,currentTime,totalTime,remainingTime")]
		/**
		 * @private
		 */
		public function get displayMode():String
		{
			return this._displayMode;
		}

		/**
		 * @private
		 */
		public function set displayMode(value:String):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._displayMode === value)
			{
				return;
			}
			this._displayMode = value;
			//reset this value because it would be unexpected for the label
			//not to change when changing this property.
			this._isToggled = false;
			this.updateText();
		}

		/**
		 * @private
		 */
		protected var _isToggled:Boolean = false;

		/**
		 * @private
		 */
		protected var touchPointID:int = -1;

		/**
		 * @private
		 */
		protected var _toggleDisplayMode:Boolean = false;

		/**
		 * @private
		 */
		public function get toggleDisplayMode():Boolean
		{
			return this._toggleDisplayMode;
		}

		/**
		 * @private
		 */
		public function set toggleDisplayMode(value:Boolean):void
		{
			if(this.processStyleRestriction(arguments.callee))
			{
				return;
			}
			if(this._toggleDisplayMode === value)
			{
				return;
			}
			this._toggleDisplayMode = value;
			this._isToggled = false;
		}

		/**
		 * @private
		 */
		protected function updateText():void
		{
			var currentTime:Number = this._mediaPlayer ? this._mediaPlayer.currentTime : 0;
			var totalTime:Number = this._mediaPlayer ? this._mediaPlayer.totalTime : 0;
			var displayMode:String = this._displayMode;
			if(this._isToggled)
			{
				if(displayMode === MediaTimeMode.CURRENT_TIME)
				{
					displayMode = MediaTimeMode.REMAINING_TIME;
				}
				else
				{
					displayMode = MediaTimeMode.CURRENT_TIME;
				}
			}
			switch(displayMode)
			{
				case MediaTimeMode.CURRENT_TIME:
				{
					this.text = this.secondsToTimeString(currentTime);
					break;
				}
				case MediaTimeMode.TOTAL_TIME:
				{
					this.text = this.secondsToTimeString(totalTime);
					break;
				}
				case MediaTimeMode.REMAINING_TIME:
				{
					this.text = this.secondsToTimeString(currentTime - totalTime);
					break;
				}
				default:
				{
					this.text = this.secondsToTimeString(currentTime) + this._delimiter + this.secondsToTimeString(totalTime);
				}
			}
		}

		/**
		 * @private
		 */
		protected function secondsToTimeString(seconds:Number):String
		{
			var isNegative:Boolean = seconds < 0;
			if(isNegative)
			{
				seconds = -seconds;
			}
			var hours:int = int(seconds / 3600);
			seconds = int(seconds - (hours * 3600));
			var minutes:int = int(seconds / 60);
			seconds = int(seconds - (minutes * 60));
			var time:String = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
			if(hours > 0)
			{
				if(minutes < 10)
				{
					time = "0" + time;
				}
				time = hours + ":" + time;
			}
			if(isNegative)
			{
				time = "-" + time;
			}
			return time;
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_currentTimeChangeHandler(event:Event):void
		{
			this.updateText();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_totalTimeChangeHandler(event:Event):void
		{
			this.updateText();
		}

		/**
		 * @private
		 */
		protected function timeLabel_touchHandler(event:TouchEvent):void
		{
			if(!this._isEnabled || !this._toggleDisplayMode ||
				!(this._displayMode === MediaTimeMode.CURRENT_TIME || this._displayMode === MediaTimeMode.CURRENT_TIME))
			{
				this.touchPointID = -1;
				return;
			}

			if(this.touchPointID >= 0)
			{
				var touch:Touch = event.getTouch(this, null, this.touchPointID);
				if(!touch)
				{
					//this should never happen
					return;
				}

				if(touch.phase === TouchPhase.ENDED)
				{
					var point:Point = Pool.getPoint();
					touch.getLocation(this.stage, point);
					var isInBounds:Boolean = this.contains(this.stage.hitTest(point));
					Pool.putPoint(point);
					if(isInBounds)
					{
						this._isToggled = !this._isToggled;
						this.updateText();
					}
				}
				return;
			}
			else //if we get here, we don't have a saved touch ID yet
			{
				touch = event.getTouch(this, TouchPhase.BEGAN);
				if(touch)
				{
					this.touchPointID = touch.id;
					return;
				}
			}
		}
	}
}
