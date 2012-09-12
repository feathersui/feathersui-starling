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
	 * screen and slides in the new screen from the right or left (depending on
	 * if the manager determines if this is a push or a pop).
	 */
	public class OldFadeNewSlideTransitionManager
	{
		/**
		 * Constructor.
		 */
		public function OldFadeNewSlideTransitionManager(navigator:ScreenNavigator, quickStack:Class = null)
		{
			if(!navigator)
			{
				throw new ArgumentError("ScreenNavigator cannot be null.");
			}
			this._navigator = navigator;
			if(quickStack)
			{
				this._stack.push(quickStack);
			}
			this._navigator.transition = this.onTransition;
		}
		
		private var _navigator:ScreenNavigator;
		private var _stack:Vector.<Class> = new <Class>[];
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
		 * Removes all saved classes from the stack that are used to determine
		 * which side of the <code>ScreenNavigator</code> the new screen will
		 * slide in from.
		 */
		public function clearStack():void
		{
			this._stack.length = 0;
		}
		
		/**
		 * @private
		 */
		private function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, onComplete:Function):void
		{
			if(!oldScreen)
			{
				if(newScreen)
				{
					newScreen.x = 0;
				}
				onComplete();
				return;
			}
			
			if(this._activeTransition)
			{
				this._activeTransition.paused = true;
				this._activeTransition = null;
			}
			
			this._savedCompleteHandler = onComplete;
			
			if(!newScreen)
			{
				oldScreen.x = 0;
				this._activeTransition = new GTween(oldScreen, this.duration,
				{
					alpha: 0
				},
				{
					ease: this.ease,
					onComplete: activeTransition_onComplete
				});
				return;
			}
			
			var NewScreenType:Class = Object(newScreen).constructor;
			var stackIndex:int = this._stack.indexOf(NewScreenType);
			var targetX:Number;
			if(stackIndex < 0)
			{
				var OldScreenType:Class = Object(oldScreen).constructor;
				this._stack.push(OldScreenType);
				oldScreen.x = 0;
				newScreen.x = this._navigator.width;
			}
			else
			{
				this._stack.length = stackIndex;
				oldScreen.x = 0;
				newScreen.x = -this._navigator.width;
			}
			this._activeTransition = new GTween(newScreen, this.duration,
			{
				x: 0
			},
			{
				data: oldScreen,
				ease: this.ease,
				onChange: activeTransition_onChange,
				onComplete: activeTransition_onComplete
			});
		}
		
		/**
		 * @private
		 */
		private function activeTransition_onChange(tween:GTween):void
		{
			var oldScreen:DisplayObject = DisplayObject(tween.data);
			if(oldScreen)
			{
				oldScreen.alpha = 1 - tween.ratio;
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