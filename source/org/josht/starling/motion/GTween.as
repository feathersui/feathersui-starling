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
package org.josht.starling.motion
{
	import com.gskinner.motion.GTween;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	
	public class GTween extends com.gskinner.motion.GTween implements IAnimatable
	{
		public function GTween(target:Object=null, duration:Number=1, values:Object=null, props:Object=null, pluginData:Object=null)
		{
			if(!props.hasOwnProperty("juggler"))
			{
				props.juggler = Starling.juggler;
			}
			super(target, duration, values, props, pluginData);
		}
		
		private var _juggler:Juggler;

		public function get juggler():Juggler
		{
			return this._juggler;
		}

		public function set juggler(value:Juggler):void
		{
			this._juggler = value;
		}
		
		override public function set paused(value:Boolean):void
		{
			if(this._paused == value)
			{
				return;
			}
			this._paused = value;
			if(this._paused)
			{
				this._juggler.remove(this);
			}
			else
			{
				if (isNaN(_position) || (repeatCount != 0 && _position >= repeatCount*duration)) {
					// reached the end, reset.
					_inited = false;
					calculatedPosition = calculatedPositionOld = ratio = ratioOld = positionOld = 0;
					_position = -delay;
				}
				this._juggler.add(this);
			}
		}
		
		public function advanceTime(time:Number):void
		{
			this.position = this._position + (this.useFrames ? timeScaleAll : time) * this.timeScale;
		}
	}
}