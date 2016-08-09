/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.controls.supportClasses.IScreenNavigatorItem;

	import mx.core.IMXMLObject;

	import starling.display.DisplayObject;

	/**
	 * Data for an individual tab that will be displayed by a
	 * <code>TabNavigator</code> component.
	 *
	 * @see ../../../help/tab-navigator.html How to use the Feathers TabNavigator component
	 * @see feathers.controls.TabNavigator
	 */
	public class TabNavigatorItem implements IScreenNavigatorItem, IMXMLObject
	{
		/**
		 * Constructor.
		 */
		public function TabNavigatorItem(classOrFunctionOrDisplayObject:Object = null,
			label:String = null, icon:DisplayObject = null)
		{
			if(classOrFunctionOrDisplayObject is DisplayObject)
			{
				this.screenDisplayObject = DisplayObject(classOrFunctionOrDisplayObject);
			}
			else if(classOrFunctionOrDisplayObject is Class)
			{
				this.screenClass = classOrFunctionOrDisplayObject as Class;
			}
			else if(classOrFunctionOrDisplayObject is Function)
			{
				this.screenFunction = classOrFunctionOrDisplayObject as Function;
			}
			else if(classOrFunctionOrDisplayObject !== null)
			{
				throw new ArgumentError("Unknown view type. Must be Class, Function, or DisplayObject.")
			}
			this._label = label;
			this._icon = icon;
		}

		/**
		 * @private
		 */
		protected var _screenClass:Class;

		/**
		 * A <code>Class</code> that may be instantiated to create a
		 * <code>DisplayObject</code> instance to display when the associated
		 * tab is selected. A new instance of the screen will be instantiated
		 * every time that it is shown by the <code>TabNavigator</code>. The
		 * screen's state will not be saved automatically, but it may be saved
		 * in <code>properties</code>, if needed.
		 *
		 * @default null
		 *
		 * @see #screenFunction
		 * @see #screenDisplayObject
		 */
		public function get screenClass():Class
		{
			return this._screenClass;
		}

		/**
		 * @private
		 */
		public function set screenClass(value:Class):void
		{
			if(this._screenClass === value)
			{
				return;
			}
			this._screenClass = value;
			if(value !== null)
			{
				this.screenFunction = null;
				this.screenDisplayObject = null;
			}
		}

		/**
		 * @private
		 */
		protected var _screenFunction:Function;

		/**
		 * A <code>Function</code> that may be called to return a
		 * <code>DisplayObject</code> instance to display when the associated
		 * tab is selected. A new instance of the screen will be instantiated
		 * every time that it is shown by the <code>TabNavigator</code>. The
		 * screen's state will not be saved automatically, but it may be saved
		 * in <code>properties</code>, if needed.
		 *
		 * @default null
		 *
		 * @see #screenClass
		 * @see #screenDisplayObject
		 */
		public function get screenFunction():Function
		{
			return this._screenFunction;
		}

		/**
		 * @private
		 */
		public function set screenFunction(value:Function):void
		{
			if(this._screenFunction === value)
			{
				return;
			}
			this._screenFunction = value;
			if(value !== null)
			{
				this.screenClass = null;
				this.screenDisplayObject = null;
			}
		}

		/**
		 * @private
		 */
		protected var _screenDisplayObject:DisplayObject;

		/**
		 * A display object to be displayed by the <code>TabNavigator</code>
		 * when the associted tab is selected. The same instance will be reused
		 * every time that it is shown by the <code>TabNavigator</code>. Whe
		 * the screen is hidden and shown again, its state will remain the same
		 * as when it was hidden. However, the screen will also be kept in
		 * memory even when it isn't displayed, limiting the resources that are
		 * available for other views.
		 * 
		 * <p>Using <code>screenClass</code> or <code>screenFunction</code>
		 * instead of <code>screenDisplayObject</code> is the recommended best
		 * practice. In general, <code>screenDisplayObject</code> should only be
		 * used in rare situations where instantiating a new screen would be
		 * extremely expensive.</p>
		 *
		 * @default null
		 *
		 * @see #screenClass
		 * @see #screenFunction
		 */
		public function get screenDisplayObject():DisplayObject
		{
			return this._screenDisplayObject;
		}

		/**
		 * @private
		 */
		public function set screenDisplayObject(value:DisplayObject):void
		{
			if(this._screenDisplayObject === value)
			{
				return;
			}
			this._screenDisplayObject = value;
			if(value !== null)
			{
				this.screenClass = null;
				this.screenFunction = null;
			}
		}

		/**
		 * @private
		 */
		protected var _label:String;

		/**
		 * The label to display on the tab.
		 */
		public function get label():String
		{
			return this._label;
		}

		/**
		 * @private
		 */
		public function set label(value:String):void
		{
			this._label = value;
		}

		/**
		 * @private
		 */
		protected var _icon:DisplayObject;

		/**
		 * The optional icon to display on the tab.
		 */
		public function get icon():DisplayObject
		{
			return this._icon;
		}

		/**
		 * @private
		 */
		public function set icon(value:DisplayObject):void
		{
			this._icon = value;
		}

		/**
		 * @private
		 */
		protected var _properties:Object;

		/**
		 * A set of key-value pairs representing properties to be set on the
		 * screen when it is shown. A pair's key is the name of the screen's
		 * property, and a pair's value is the value to be passed to the
		 * screen's property.
		 */
		public function get properties():Object
		{
			return this._properties;
		}

		/**
		 * @private
		 */
		public function set properties(value:Object):void
		{
			if(!value)
			{
				value = {};
			}
			this._properties = value;
		}

		/**
		 * @private
		 */
		protected var _transition:Function;

		/**
		 * A custom transition for this screen only. If <code>null</code>,
		 * the default <code>transition</code> defined by the
		 * <code>TabNavigator</code> will be used.
		 *
		 * <p>In the following example, the tab navigator item is given a custom
		 * transition:</p>
		 *
		 * <listing version="3.0">
		 * item.transition = Fade.createFadeInTransition();</listing>
		 *
		 * <p>A number of animated transitions may be found in the
		 * <a href="../motion/package-detail.html">feathers.motion</a> package.
		 * However, you are not limited to only these transitions. It's possible
		 * to create custom transitions too.</p>
		 *
		 * <p>A custom transition function should have the following signature:</p>
		 * <pre>function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void</pre>
		 *
		 * <p>Either of the <code>oldScreen</code> and <code>newScreen</code>
		 * arguments may be <code>null</code>, but never both. The
		 * <code>oldScreen</code> argument will be <code>null</code> when the
		 * first screen is displayed or when a new screen is displayed after
		 * clearing the screen. The <code>newScreen</code> argument will
		 * be null when clearing the screen.</p>
		 *
		 * <p>The <code>completeCallback</code> function <em>must</em> be called
		 * when the transition effect finishes. This callback indicate to the
		 * tab navigator that the transition has finished. This function has
		 * the following signature:</p>
		 *
		 * <pre>function(cancelTransition:Boolean = false):void</pre>
		 *
		 * <p>The first argument defaults to <code>false</code>, meaning that
		 * the transition completed successfully. In most cases, this callback
		 * may be called without arguments. If a transition is cancelled before
		 * completion (perhaps through some kind of user interaction), and the
		 * previous screen should be restored, pass <code>true</code> as the
		 * first argument to the callback to inform the tab navigator that
		 * the transition is cancelled.</p>
		 *
		 * @default null
		 *
		 * @see feathers.controls.TabNavigator#transition
		 * @see ../../../help/transitions.html Transitions for Feathers screen navigators
		 */
		public function get transition():Function
		{
			return this._transition;
		}

		/**
		 * @private
		 */
		public function set transition(value:Function):void
		{
			this._transition = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get canDispose():Boolean
		{
			return this._screenDisplayObject === null;
		}

		/**
		 * @private
		 */
		private var _mxmlID:String;

		/**
		 * @private
		 */
		public function get mxmlID():String
		{
			return this._mxmlID;
		}

		/**
		 * @private
		 */
		public function initialized(document:Object, id:String):void
		{
			if(!id)
			{
				throw new Error("TabNavigatorItem must have an \"id\" in MXML.");
			}
			this._mxmlID = id;
		}

		/**
		 * @inheritDoc
		 */
		public function getScreen():DisplayObject
		{
			var viewInstance:DisplayObject;
			if(this._screenDisplayObject !== null)
			{
				viewInstance = this._screenDisplayObject;
			}
			else if(this._screenClass !== null)
			{
				var ViewType:Class = Class(this._screenClass);
				viewInstance = new ViewType();
			}
			else if(this._screenFunction !== null)
			{
				viewInstance = DisplayObject(this._screenFunction.call());
			}
			if(!(viewInstance is DisplayObject))
			{
				throw new ArgumentError("TabNavigatorItem \"getScreen()\" must return a Starling display object.");
			}
			if(this._properties)
			{
				for(var propertyName:String in this._properties)
				{
					viewInstance[propertyName] = this._properties[propertyName];
				}
			}

			return viewInstance;
		}
	}
}
