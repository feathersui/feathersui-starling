/*
Copyright (c) 2012 Josh Tynjala

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.motion.transitions
{
	import com.gskinner.motion.easing.Sine;

	import feathers.controls.ScreenNavigator;
	import feathers.motion.GTween;

	import starling.display.DisplayObject;

	/**
	 * A transition for <code>ScreenNavigator</code> that fades out the old
	 * screen and fades in the new screen.
	 */
	public class ScreenFadeTransitionManager
	{
		/**
		 * Constructor.
		 */
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
		
		/**
		 * The duration of the transition.
		 */
		public var duration:Number = 0.25;
		
		/**
		 * The GTween easing function to use.
		 */
		public var ease:Function = Sine.easeOut;
		
		/**
		 * @private
		 */
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
		
		/**
		 * @private
		 */
		private function activeTransition_onChange(tween:GTween):void
		{
			var oldScreen:DisplayObject = tween.data as DisplayObject;
			if(oldScreen)
			{
				var newScreen:DisplayObject = DisplayObject(tween.target);
				oldScreen.alpha = 1 - newScreen.alpha;
			}
		}
		
		/**
		 * @private
		 */
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