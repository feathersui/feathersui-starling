/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;
	import feathers.core.TokenList;

	import starling.display.DisplayObjectContainer;

	public class StyleNameFunctionStyleProvider implements IStyleProvider
	{
		/**
		 * Constructor.
		 */
		public function StyleNameFunctionStyleProvider(styleFunction:Function = null)
		{
			this._defaultStyleFunction = styleFunction;
		}

		/**
		 * @private
		 */
		protected var _defaultStyleFunction:Function;

		/**
		 * The target Feathers UI component is passed to this function when
		 * <code>applyStyles()</code> is called and the component's
		 * <code>styleNameList</code> doesn't contain any style names that are
		 * set with <code>setFunctionForStyleName()</code>.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:IFeathersControl ):void</pre>
		 *
		 * @see #setFunctionForStyleName()
		 */
		public function get defaultStyleFunction():Function
		{
			return this._defaultStyleFunction;
		}

		/**
		 * @private
		 */
		public function set defaultStyleFunction(value:Function):void
		{
			this._defaultStyleFunction = value;
		}

		/**
		 * @private
		 */
		protected var _styleNameMap:Object;

		/**
		 * The target Feathers UI component is passed to this function when
		 * <code>applyStyles()</code> is called and the component's
		 * <code>styleNameList</code> contains the specified style name.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function( item:IFeathersControl ):void</pre>
		 *
		 * @see #defaultStyleFunction
		 */
		public function setFunctionForStyleName(styleName:String, styleFunction:Function):void
		{
			if(!this._styleNameMap)
			{
				this._styleNameMap = {};
			}
			this._styleNameMap[styleName] = styleFunction;
		}

		/**
		 * @inheritDoc
		 */
		public function applyStyles(target:IFeathersControl):void
		{
			if(this._styleNameMap)
			{
				var hasNameInitializers:Boolean = false;
				var styleNameList:TokenList = target.styleNameList;
				var styleNameCount:int = styleNameList.length;
				for(var i:int = 0; i < styleNameCount; i++)
				{
					var name:String = styleNameList.item(i);
					var initializer:Function = this._styleNameMap[name] as Function;
					if(initializer != null)
					{
						hasNameInitializers = true;
						initializer(target);
					}
				}
				if(hasNameInitializers)
				{
					return;
				}
			}
			if(this._defaultStyleFunction != null)
			{
				this._defaultStyleFunction(target);
			}
		}
	}
}
