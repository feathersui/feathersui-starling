/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;
	import feathers.core.TokenList;

	/**
	 * Similar to <code>FunctionStyleProvider</code>, sets styles on a Feathers
	 * UI component by passing it to a function, but also provides a way to
	 * define alternate functions that may be called based on the contents of
	 * the component's <code>styleNameList</code>.
	 *
	 * <p>Alternate functions may be registered with the style provider by
	 * calling <code>setFunctionForStyleName()</code> and passing in a style
	 * name and a function. For each style name in the component's
	 * <code>styleNameList</code>, the style provider will search its registered
	 * style names to see if a function should be called. If none of a
	 * component's style names have been registered with the style provider (or
	 * if the component has no style names), then the default style function
	 * will be called.</p>
	 *
	 * <p>If a component's <code>styleNameList</code> contains multiple values,
	 * each of those values is eligible to trigger a call to a function
	 * registered with the style provider. In other words, adding multiple
	 * values to a component's <code>styleNameList</code> may be used to call
	 * multiple functions.</p>
	 *
	 * <p>In the following example, a <code>StyleNameFunctionStyleProvider</code> is
	 * created with a default style function (passed to the constructor) and
	 * an alternate style function:</p>
	 * <listing version="3.0">
	 * var styleProvider:StyleNameFunctionStyleProvider = new StyleNameFunctionStyleProvider( function( target:Button ):void
	 * {
	 *     target.defaultSkin = new Image( defaultTexture );
	 *     // set other styles...
	 * });
	 * styleProvider.setFunctionForStyleName( "alternate-button", function( target:Button ):void
	 * {
	 *     target.defaultSkin = new Image( alternateTexture );
	 *     // set other styles...
	 * });
	 * 
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * button.styleProvider = styleProvider;
	 * this.addChild(button);
	 * 
	 * var alternateButton:Button = new Button()
	 * button.label = "No, click me!";
	 * alternateButton.styleProvider = styleProvider;
	 * alternateButton.styleNameList.add( "alternate-button" );
	 * this.addChild( alternateButton );</listing>
	 *
	 * @see ../../../help/skinning.html Skinning Feathers components
	 *
	 * @productversion Feathers 2.0.0
	 */
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
