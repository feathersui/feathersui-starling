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
	import feathers.controls.TabBar;
	import feathers.motion.GTween;

	import starling.display.DisplayObject;

	/**
	 * Slides new screens from the left or right depending on the old and new
	 * selected index values of a TabBar control.
	 *
	 * @see feathers.controls.TabBar
	 */
	public class TabBarSlideTransitionManager
	{
		/**
		 * Constructor.
		 */
		public function TabBarSlideTransitionManager(navigator:ScreenNavigator, tabBar:TabBar)
		{
			if(!navigator)
			{
				throw new ArgumentError("ScreenNavigator cannot be null.");
			}
			this._navigator = navigator;
			this._tabBar = tabBar;
			this._oldIndex = tabBar.selectedIndex;
			this._tabBar.onChange.add(tabBar_onChange);
			this._navigator.transition = this.onTransition;
		}

		private var _navigator:ScreenNavigator;
		private var _tabBar:TabBar;
		private var _activeTransition:GTween;
		private var _savedCompleteHandler:Function;

		private var _oldScreen:DisplayObject;
		private var _newScreen:DisplayObject;
		private var _oldIndex:int;
		private var _isFromRight:Boolean = true;
		private var _isWaitingOnTabBarChange:Boolean = true;
		private var _isWaitingOnTransitionChange:Boolean = true;

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
			this._oldScreen = oldScreen;
			this._newScreen = newScreen;
			this._savedCompleteHandler = onComplete;

			if(!this._isWaitingOnTabBarChange)
			{
				this.transitionNow();
			}
			else
			{
				this._isWaitingOnTransitionChange = false;
			}
		}

		/**
		 * @private
		 */
		private function transitionNow():void
		{
			if(this._activeTransition)
			{
				this._activeTransition.paused = true;
				this._activeTransition = null;
			}

			if(!this._oldScreen || !this._newScreen)
			{
				if(this._newScreen)
				{
					this._newScreen.x = 0;
				}
				if(this._oldScreen)
				{
					this._oldScreen.x = 0;
				}
				if(this._savedCompleteHandler != null)
				{
					this._savedCompleteHandler();
				}
				return;
			}

			this._oldScreen.x = 0;
			var activeTransition_onChange:Function;
			if(this._isFromRight)
			{
				this._newScreen.x = this._navigator.width;
				activeTransition_onChange = this.activeTransitionFromRight_onChange;
			}
			else
			{
				this._newScreen.x = -this._navigator.width;
				activeTransition_onChange = this.activeTransitionFromLeft_onChange;
			}
			this._activeTransition = new GTween(this._newScreen, this.duration,
			{
				x: 0
			},
			{
				data: this._oldScreen,
				ease: this.ease,
				onChange: activeTransition_onChange,
				onComplete: activeTransition_onComplete
			});

			this._oldScreen = null;
			this._newScreen = null;
			this._isWaitingOnTabBarChange = true;
			this._isWaitingOnTransitionChange = true;
		}

		/**
		 * @private
		 */
		private function activeTransitionFromRight_onChange(tween:GTween):void
		{
			var newScreen:DisplayObject = DisplayObject(tween.target);
			var oldScreen:DisplayObject = DisplayObject(tween.data);
			oldScreen.x = newScreen.x - this._navigator.width;
		}

		/**
		 * @private
		 */
		private function activeTransitionFromLeft_onChange(tween:GTween):void
		{
			var newScreen:DisplayObject = DisplayObject(tween.target);
			var oldScreen:DisplayObject = DisplayObject(tween.data);
			oldScreen.x = newScreen.x + this._navigator.width;
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

		/**
		 * @private
		 */
		private function tabBar_onChange(tabBar:TabBar):void
		{
			var newIndex:int = tabBar.selectedIndex;
			this._isFromRight = newIndex > this._oldIndex;
			this._oldIndex = newIndex;

			if(!this._isWaitingOnTransitionChange)
			{
				this.transitionNow();
			}
			else
			{
				this._isWaitingOnTabBarChange = false;
			}
		}
	}
}