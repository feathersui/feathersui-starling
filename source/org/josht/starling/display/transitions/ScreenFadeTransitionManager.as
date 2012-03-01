package org.josht.starling.display.transitions
{
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.Sine;
	
	import org.josht.starling.display.ScreenNavigator;
	
	import starling.display.DisplayObject;

	public class ScreenFadeTransitionManager
	{
		public function ScreenFadeTransitionManager(navigator:ScreenNavigator)
		{
			if(!navigator)
			{
				throw new ArgumentError("ScreenNavigator cannot be null.");
			}
			this._navigator = navigator;
			this._navigator.transition = this.onTransition;
		}
		
		private var _navigator:ScreenNavigator;
		private var _activeTransition:GTween;
		private var _savedCompleteHandler:Function;
		
		public var duration:Number = 0.25;
		public var ease:Function = Sine.easeOut;
		
		private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			if(!oldScreen && !newScreen)
			{
				throw new ArgumentError("Cannot transition if both old screen and new screen are null.");
			}
			
			if(this._activeTransition)
			{
				this._activeTransition.end();
				this._activeTransition = null;
			}
			
			this._savedCompleteHandler = onComplete;
			
			if(newScreen)
			{
				newScreen.alpha = 0;
				if(oldScreen) //oldScreen can be null, that's okay
				{
					oldScreen.alpha = 1;
				}
				this._activeTransition = new GTween(newScreen, this.duration,
				{
					alpha: 1
				},
				{
					ease: this.ease,
					onChange: activeTransition_onChange,
					onComplete: activeTransition_onComplete
				});
			}
			else //we only have the old screen
			{
				oldScreen.alpha = 1;
				this._activeTransition = new GTween(oldScreen, this.duration,
				{
					alpha: 0
				},
				{
					ease: this.ease,
					onComplete: activeTransition_onComplete
				});
			}
		}
		
		private function activeTransition_onChange(tween:GTween):void
		{
			var oldScreen:DisplayObject = tween.data as DisplayObject;
			if(oldScreen)
			{
				var newScreen:DisplayObject = DisplayObject(tween.target);
				oldScreen.alpha = 1 - newScreen.alpha;
			}
		}
		
		private function activeTransition_onComplete(tween:GTween):void
		{
			this._activeTransition = null;
			if(this._savedCompleteHandler != null)
			{
				this._savedCompleteHandler();
			}
		}
	}
}