/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;

	/**
	 * Manages touch and keyboard focus.
	 *
	 * <p>Note: When enabling focus management, you should always use
	 * <code>TextFieldTextEditor</code> as the text editor for <code>TextInput</code>
	 * components. <code>StageTextTextEditor</code> is not compatible with the
	 * focus manager.</p>
	 */
	public class FocusManager
	{
		/**
		 * @private
		 */
		protected static const FOCUS_MANAGER_NOT_ENABLED_ERROR:String = "The specified action is not permitted when the focus manager is not enabled.";

		/**
		 * @private
		 */
		protected static const STAGE_TO_STACK:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected static function getStackForStage(stage:Stage):Vector.<IFocusManager>
		{
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage] as Vector.<IFocusManager>;
			if(!stack)
			{
				STAGE_TO_STACK[stage] = stack = new <IFocusManager>[];
			}
			return stack;
		}

		/**
		 * The default factory that creates a focus manager.
		 *
		 * @see #focusManagerFactory
		 * @see feathers.core.DefaultFocusManager
		 */
		public static function defaultFocusManagerFactory(root:DisplayObjectContainer):IFocusManager
		{
			return new DefaultFocusManager(root);
		}

		/**
		 * A function that creates a focus manager.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():IFocusManager</pre>
		 *
		 * <p>In the following example, the focus manager factory is modified:</p>
		 *
		 * <listing version="3.0">
		 * FocusManager.focusManagerFactory = function(root:DisplayObjectContainer):IPopUpManager
		 * {
		 *     return new CustomFocusManager(); //a custom class that implements IFocusManager
		 * };</listing>
		 *
		 * @see feathers.core.IFocusManager
		 */
		public static var focusManagerFactory:Function = defaultFocusManagerFactory;

		/**
		 * @private
		 */
		protected static var _isEnabled:Boolean = false;

		/**
		 * Determines if the default focus manager is enabled. For mobile apps,
		 * the focus manager should generally remain disabled. For desktop apps,
		 * it is recommended to enable the focus manager to support keyboard
		 * navigation.
		 *
		 * <p>In the following example, focus management is enabled:</p>
		 *
		 * <listing version="3.0">
		 * FocusManager.isEnabled = true;</listing>
		 *
		 * @default false
		 */
		public static function get isEnabled():Boolean
		{
			return _isEnabled;
		}

		/**
		 * @private
		 */
		public static function set isEnabled(value:Boolean):void
		{
			if(value == _isEnabled)
			{
				return;
			}
			_isEnabled = value;
			if(_isEnabled)
			{
				pushFocusManager(Starling.current.stage);
			}
			else
			{
				for(var stage:Stage in STAGE_TO_STACK)
				{
					var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage];
					while(stack.length > 0)
					{
						var manager:IFocusManager = stack.pop();
						manager.isEnabled = false;
					}
					delete STAGE_TO_STACK[stage];
				}
			}
		}

		/**
		 * Adds a focus manager to the stack, and gives it exclusive focus.
		 */
		public static function pushFocusManager(root:DisplayObjectContainer):IFocusManager
		{
			if(!_isEnabled)
			{
				throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
			}
			var manager:IFocusManager = FocusManager.focusManagerFactory(root);
			var stage:Stage = root.stage;
			var stack:Vector.<IFocusManager> = getStackForStage(stage);
			if(stack.length > 0)
			{
				var oldManager:IFocusManager = stack[stack.length - 1];
				oldManager.isEnabled = false;
			}
			stack.push(manager);
			manager.isEnabled = true;
			return manager;
		}

		/**
		 * Removes the specified focus manager from the stack. If it was
		 * the top-most focus manager, the next top-most focus manager is
		 * enabled.
		 */
		public static function removeFocusManager(manager:IFocusManager):void
		{
			if(!_isEnabled)
			{
				throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
			}
			var stage:Stage = manager.root.stage;
			var stack:Vector.<IFocusManager> = getStackForStage(stage);
			var index:int = stack.indexOf(manager);
			if(index < 0)
			{
				return;
			}
			manager.isEnabled = false;
			stack.splice(index, 1);
			//if this is the top-level focus manager, enable the previous one
			if(index > 0 && index == stack.length)
			{
				manager = stack[stack.length - 1];
				manager.isEnabled = true;
			}
		}

	}
}
