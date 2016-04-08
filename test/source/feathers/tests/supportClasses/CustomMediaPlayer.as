package feathers.tests.supportClasses
{
	import feathers.events.MediaPlayerEventType;
	import feathers.media.ITimedMediaPlayer;

	import starling.events.EventDispatcher;

	public class CustomMediaPlayer extends EventDispatcher implements ITimedMediaPlayer
	{
		public function CustomMediaPlayer(totalTime:Number)
		{
			this._totalTime = totalTime;
		}
		
		protected var _currentTime:Number = 0;
		
		public function get currentTime():Number
		{
			return this._currentTime;
		}

		protected var _totalTime:Number = 0;

		public function get totalTime():Number
		{
			return this._totalTime;
		}

		protected var _isPlaying:Boolean = false;

		public function get isPlaying():Boolean
		{
			return this._isPlaying;
		}

		public function togglePlayPause():void
		{
			if(this._isPlaying)
			{
				this.pause();
			}
			else
			{
				this.play();
			}
		}

		public function play():void
		{
			if(this._isPlaying)
			{
				return;
			}
			this._isPlaying = true;
			this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
		}

		public function pause():void
		{
			if(!this._isPlaying)
			{
				return;
			}
			this._isPlaying = false;
			this.dispatchEventWith(MediaPlayerEventType.PLAYBACK_STATE_CHANGE);
		}

		public function stop():void
		{
			this.pause();
			this.seek(0);
		}

		public function seek(seconds:Number):void
		{
			this._currentTime = seconds;
			this.dispatchEventWith(MediaPlayerEventType.CURRENT_TIME_CHANGE);
		}
	}
}
