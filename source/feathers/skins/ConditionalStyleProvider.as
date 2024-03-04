/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;

	/**
	 * A style provider that chooses between two different style providers.
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ConditionalStyleProvider implements IStyleProvider
	{
		/**
		 * Constructor.
		 */
		public function ConditionalStyleProvider(conditionalFunction:Function,
			trueStyleProvider:IStyleProvider = null, falseStyleProvider:IStyleProvider = null)
		{
			this._conditionalFunction = conditionalFunction;
			this._trueStyleProvider = trueStyleProvider;
			this._falseStyleProvider = falseStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _trueStyleProvider:IStyleProvider;

		/**
		 * A call to <code>applyStyles()</code> is passed to this style provider
		 * when the <code>conditionalFunction</code> returns <code>true</code>.
		 */
		public function get trueStyleProvider():IStyleProvider
		{
			return this._trueStyleProvider;
		}

		/**
		 * @private
		 */
		public function set trueStyleProvider(value:IStyleProvider):void
		{
			this._trueStyleProvider = value;
		}

		/**
		 * @private
		 */
		protected var _falseStyleProvider:IStyleProvider;

		/**
		 * A call to <code>applyStyles()</code> is passed to this style provider
		 * when the <code>conditionalFunction</code> returns <code>false</code>.
		 */
		public function get falseStyleProvider():IStyleProvider
		{
			return this._falseStyleProvider;
		}

		/**
		 * @private
		 */
		public function set falseStyleProvider(value:IStyleProvider):void
		{
			this._falseStyleProvider = value;
		}

		/**
		 * @private
		 */
		protected var _conditionalFunction:Function;

		/**
		 * When <code>applyStyles()</code> is called, the target is passed to
		 * this function to determine which style provider should be called.
		 *
		 * <pre>function(target:IFeathersControl):Boolean</pre>
		 */
		public function get conditionalFunction():Function
		{
			return this._conditionalFunction;
		}

		/**
		 * @private
		 */
		public function set conditionalFunction(value:Function):void
		{
			this._conditionalFunction = value;
		}

		/**
		 * @private
		 */
		public function applyStyles(target:IFeathersControl):void
		{
			var result:Boolean = false;
			if(this._conditionalFunction !== null)
			{
				result = this._conditionalFunction(target) as Boolean;
			}
			if(result === true)
			{
				if(this._trueStyleProvider !== null)
				{
					this._trueStyleProvider.applyStyles(target);
				}
			}
			else if(this._falseStyleProvider !== null)
			{
				this._falseStyleProvider.applyStyles(target);
			}
		}
	}
}
