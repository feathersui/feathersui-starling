/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import starling.animation.Juggler;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.display.DisplayObject;
	import feathers.core.IFeathersControl;

	/**
	 * A move effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public class TweenMoveEffectContext extends TweenEffectContext implements IMoveEffectContext
	{
		public function TweenMoveEffectContext(tween:Tween)
		{
			super(tween);
		}

		public function playMove(x:Number, y:Number, oldX:Number, oldY:Number):void
		{
			var target:DisplayObject = DisplayObject(this._tween.target);
			if(target is IFeathersControl)
			{
				IFeathersControl(target).suspendEffects();
			}
			target.x = oldX;
			target.y = oldY;
			if(target is IFeathersControl)
			{
				IFeathersControl(target).resumeEffects();
			}
			this._tween.moveTo(x, y);
			this.play();
		}
	}
}