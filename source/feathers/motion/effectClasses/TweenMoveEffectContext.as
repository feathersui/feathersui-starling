/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import feathers.core.IFeathersControl;

	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * A move effect context for a <code>starling.animation.Tween</code>.
	 *
	 * @see ../../../help/effects.html Effects and animation for Feathers components
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
		public function TweenMoveEffectContext(target:DisplayObject, tween:Tween)
		{
			super(target, tween);
			this._oldX = this._target.x;
			this._oldY = this._target.y;
			this._newX = this._target.x;
			this._tween.animate("x", this._newX);
			this._newY = this._target.y;
			this._tween.animate("y", this._newY);
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
			if(this._newX == value)
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
			if(this._newY == value)
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
			if(this._target is IFeathersControl)
			{
				IFeathersControl(this._target).suspendEffects();
			}
			this._target.x = this._oldX;
			this._target.y = this._oldY;
			if(this._target is IFeathersControl)
			{
				IFeathersControl(this._target).resumeEffects();
			}
			super.play();
		}
	}
}