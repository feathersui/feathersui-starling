/*
Feathers
Copyright 2012-2017 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.motion.effectClasses
{
	import feathers.core.IFeathersControl;

	import starling.animation.Tween;
	import starling.display.DisplayObject;

	/**
	 * A resize effect context for a <code>starling.animation.Tween</code>.
	 * 
	 * @see http://doc.starling-framework.org/core/starling/animation/Tween.html starling.animation.Tween
	 * @see feathers.core.FeathersControl#resizeEffect
	 * 
	 * @productversion Feathers 3.5.0
	 */
	public class TweenResizeEffectContext extends TweenEffectContext implements IResizeEffectContext
	{
		/**
		 * Constructor.
		 */
		public function TweenResizeEffectContext(tween:Tween)
		{
			super(tween);
			var target:DisplayObject = DisplayObject(tween.target);
			this._oldWidth = target.width;
			this._oldHeight = target.height;
			this._newWidth = target.width;
			this._newHeight = target.height;
		}

		/**
		 * @private
		 */
		protected var _oldWidth:Number;

		/**
		 * @inheritDoc
		 */
		public function get oldWidth():Number
		{
			return this._oldWidth;
		}

		/**
		 * @private
		 */
		public function set oldWidth(value:Number):void
		{
			this._oldWidth = value;
		}

		/**
		 * @private
		 */
		protected var _oldHeight:Number;

		/**
		 * @inheritDoc
		 */
		public function get oldHeight():Number
		{
			return this._oldHeight;
		}

		/**
		 * @private
		 */
		public function set oldHeight(value:Number):void
		{
			this._oldHeight = value;
		}

		/**
		 * @private
		 */
		protected var _newWidth:Number;

		/**
		 * @inheritDoc
		 */
		public function get newWidth():Number
		{
			return this._newWidth;
		}

		/**
		 * @private
		 */
		public function set newWidth(value:Number):void
		{
			if(this._newWidth === value)
			{
				return;
			}
			this._newWidth = value;
			trace("animating width", value);
			this._tween.animate("width", value);
		}

		/**
		 * @private
		 */
		protected var _newHeight:Number;

		/**
		 * @inheritDoc
		 */
		public function get newHeight():Number
		{
			return this._newHeight;
		}

		/**
		 * @private
		 */
		public function set newHeight(value:Number):void
		{
			if(this._newHeight === value)
			{
				return;
			}
			this._newHeight = value;
			trace("animating height", value);
			this._tween.animate("height", value);
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
			target.width = this._oldWidth;
			target.height = this._oldHeight;
			if(target is IFeathersControl)
			{
				IFeathersControl(target).resumeEffects();
			}
			super.play();
		}
	}
}