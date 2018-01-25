/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion
{
	import feathers.core.IFeathersControl;

	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * A move effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 * @see feathers.core.FeathersControl#moveEffect
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public class TweenMoveEffectContext extends TweenEffectContext implements IMoveEffectContext
	{
		/**
		 * Constructor.
		 */
		public function TweenMoveEffectContext(tween:Tween)
		{
			super(tween);
			var target:DisplayObject = DisplayObject(tween.target);
			this._oldX = target.x;
			this._oldY = target.y;
			this._newX = target.x;
			this._newY = target.y;
		}

		/**
		 * @private
		 */
		protected var _oldX:Number;

		/**
		 * @inheritDoc
		 */
		public function get oldX():Number
		{
			return this._oldX;
		}

		/**
		 * @private
		 */
		public function set oldX(value:Number):void
		{
			this._oldX = value;
		}

		/**
		 * @private
		 */
		protected var _oldY:Number;

		/**
		 * @inheritDoc
		 */
		public function get oldY():Number
		{
			return this._oldY;
		}

		/**
		 * @private
		 */
		public function set oldY(value:Number):void
		{
			this._oldY = value;
		}

		/**
		 * @private
		 */
		protected var _newX:Number;

		/**
		 * @inheritDoc
		 */
		public function get newX():Number
		{
			return this._newX;
		}

		/**
		 * @private
		 */
		public function set newX(value:Number):void
		{
			if(this._newX === value)
			{
				return;
			}
			this._newX = value;
			this._tween.animate("x", value);
		}

		/**
		 * @private
		 */
		protected var _newY:Number;

		/**
		 * @inheritDoc
		 */
		public function get newY():Number
		{
			return this._newY;
		}

		/**
		 * @private
		 */
		public function set newY(value:Number):void
		{
			if(this._newY === value)
			{
				return;
			}
			this._newY = value;
			this._tween.animate("y", value);
		}

		/**
		 * @private
		 */
		override public function play():void
		{
			var target:DisplayObject = DisplayObject(this._tween.target);
			if(target is IFeathersControl)
			{
				IFeathersControl(target).suspendEffects();
			}
			target.x = this._oldX;
			target.y = this._oldY;
			if(target is IFeathersControl)
			{
				IFeathersControl(target).resumeEffects();
			}
			super.play();
		}
	}
}