/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;

	/**
	 * Passes a Feathers UI component to a function when <code>applyStyles()</code>
	 * is called to set skin and style properties.
	 */
	public class FunctionStyleProvider implements IStyleProvider
	{
		/**
		 * Constructor.
		 */
		public function FunctionStyleProvider(skinFunction:Function)
		{
			this._styleFunction = skinFunction;
		}

		/**
		 * @private
		 */
		protected var _styleFunction:Function;

		/**
		 * The target Feathers UI component is passed to this function when
		 * <code>applyStyles()</code> is called.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:IFeathersControl ):void</pre>
		 */
		public function get styleFunction():Function
		{
			return this._styleFunction;
		}

		/**
		 * @private
		 */
		public function set styleFunction(value:Function):void
		{
			this._styleFunction = value;
		}

		/**
		 * @inheritDoc
		 */
		public function applyStyles(target:IFeathersControl):void
		{
			if(this._styleFunction == null)
			{
				return;
			}
			this._styleFunction(target);
		}
	}
}
