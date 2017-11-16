/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Tween;

	/**
	 * An effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 */
	public class TweenEffectContext implements IEffectContext
	{
		public function TweenEffectContext(tween:Tween)
		{
			this._tween = tween;
		}

		protected var _tween:Tween;

		private var _position:Number = 0;

		public function get position():Number
		{
			return this._tween.currentTime / this._tween.totalTime;
		}

		public function set position(value:Number):void
		{
			var newCurrentTime:Number = value * this._tween.totalTime;
			this._tween.advanceTime(newCurrentTime - this._tween.currentTime);
		}
	}	
}