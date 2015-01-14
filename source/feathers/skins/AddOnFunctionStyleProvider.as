/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;

	/**
	 * Wraps an existing style provider to call an additional function after
	 * the existing style provider applies its styles.
	 *
	 * <p>Expected usage is to replace a component's existing style provider:</p>
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * function setExtraStyles( target:Button ):void
	 * {
	 *     target.defaultIcon = new Image( texture );
	 *     // set other styles, if desired...
	 * }
	 * button.styleProvider = new AddOnFunctionStyleProvider( button.styleProvider, setExtraStyles );
	 * this.addChild( button );</listing>
	 *
	 * @see ../../../help/skinning.html Skinning Feathers components
	 */
	public class AddOnFunctionStyleProvider implements IStyleProvider
	{
		/**
		 * Constructor.
		 */
		public function AddOnFunctionStyleProvider(originalStyleProvider:IStyleProvider = null, addOnFunction:Function = null)
		{
			this._originalStyleProvider = originalStyleProvider;
			this._addOnFunction = addOnFunction;
		}

		/**
		 * @private
		 */
		protected var _originalStyleProvider:IStyleProvider;

		/**
		 * The <code>addOnFunction</code> will be called after the original
		 * style provider applies its styles.
		 */
		public function get originalStyleProvider():IStyleProvider
		{
			return this._originalStyleProvider;
		}

		/**
		 * @private
		 */
		public function set originalStyleProvider(value:IStyleProvider):void
		{
			this._originalStyleProvider = value;
		}

		/**
		 * @private
		 */
		protected var _addOnFunction:Function;

		/**
		 * A function to call after applying the original style provider's
		 * styles.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:IFeathersControl ):void</pre>
		 */
		public function get addOnFunction():Function
		{
			return this._addOnFunction;
		}

		/**
		 * @private
		 */
		public function set addOnFunction(value:Function):void
		{
			this._addOnFunction = value;
		}

		/**
		 * @inheritDoc
		 */
		public function applyStyles(target:IFeathersControl):void
		{
			if(this._originalStyleProvider)
			{
				this._originalStyleProvider.applyStyles(target);
			}
			if(this._addOnFunction !== null)
			{
				this._addOnFunction(target);
			}
		}


	}
}
