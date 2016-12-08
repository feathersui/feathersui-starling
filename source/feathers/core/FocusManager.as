/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

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
	 * @see ../../../help/focus.html Keyboard focus management in Feathers
	 *
	 * @productversion Feathers 1.1.0
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
		protected static const FOCUS_MANAGER_ROOT_MUST_BE_ON_STAGE_ERROR:String = "A focus manager may not be added or removed for a display object that is not on stage.";

		/**
		 * @private
		 */
		protected static const STAGE_TO_STACK:Dictionary = new Dictionary(true);

		/**
		 * Returns the active focus manager for the specified Starling stage.
		 * May return <code>null</code> if focus management has not been enabled
		 * for the specified stage.
		 *
		 * @see #isEnabledForStage()
		 * @see #setEnabledForStage()
		 */
		public static function getFocusManagerForStage(stage:Stage):IFocusManager
		{
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage] as Vector.<IFocusManager>;
			if(!stack)
			{
				return null;
			}
			return stack[stack.length - 1];
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
		 * Determines if the focus manager is enabled or disabled for the
		 * specified Starling stage.
		 *
		 * @see #setEnabledForStage()
		 * @see #getFocusManagerForStage()
		 */
		public static function isEnabledForStage(stage:Stage):Boolean
		{
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage];
			return stack != null;
		}

		/**
		 * Enables or disables focus management on the specified Starling stage.
		 * For mobile apps, the focus manager should generally remain disabled.
		 * For desktop apps, it is recommended to enable the focus manager to
		 * support keyboard navigation.
		 *
		 * <p>In the following example, focus management is enabled:</p>
		 *
		 * <listing version="3.0">
		 * FocusManager.setEnabledForStage(stage, true);</listing>
		 *
		 * @see #isEnabledForStage()
		 * @see #getFocusManagerForStage()
		 */
		public static function setEnabledForStage(stage:Stage, isEnabled:Boolean):void
		{
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage];
			if((isEnabled && stack) || (!isEnabled && !stack))
			{
				return;
			}
			if(isEnabled)
			{
				STAGE_TO_STACK[stage] = new <IFocusManager>[];
				pushFocusManager(stage);
			}
			else
			{
				while(stack.length > 0)
				{
					var manager:IFocusManager = stack.pop();
					manager.isEnabled = false;
				}
				delete STAGE_TO_STACK[stage];
			}
		}

		/**
		 * Disables focus management on all stages where it has previously been
		 * enabled.
		 */
		public function disableAll():void
		{
			for(var key:Object in STAGE_TO_STACK)
			{
				var stage:Stage = Stage(key);
				var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage];
				while(stack.length > 0)
				{
					var manager:IFocusManager = stack.pop();
					manager.isEnabled = false;
				}
				delete STAGE_TO_STACK[stage];
			}
		}

		/**
		 * The object that currently has focus on <code>Starling.current.stage</code>.
		 * May return <code>null</code> if no object has focus.
		 *
		 * <p>You can call <code>geFocusManagerForStage()</code> to access the
		 * active <code>IFocusManager</code> instance for any <code>Stage</code>
		 * instance that isn't equal to <code>Starling.current.stage</code>.</p>
		 *
		 * <p>In the following example, the focus is changed on the current stage:</p>
		 *
		 * <listing version="3.0">
		 * FocusManager.focus = someObject;</listing>
		 *
		 * @see #getFocusManagerForStage()
		 */
		public static function get focus():IFocusDisplayObject
		{
			var manager:IFocusManager = getFocusManagerForStage(Starling.current.stage);
			if(manager)
			{
				return manager.focus;
			}
			return null;
		}

		/**
		 * @private
		 */
		public static function set focus(value:IFocusDisplayObject):void
		{
			var manager:IFocusManager = getFocusManagerForStage(Starling.current.stage);
			if(!manager)
			{
				throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
			}
			manager.focus = value;
		}

		/**
		 * Adds a focus manager to the stack for the <code>root</code>
		 * argument's stage, and gives it exclusive focus. If focus management
		 * has not been enabled for the root's stage, then calling this function
		 * will throw a runtime error.
		 */
		public static function pushFocusManager(root:DisplayObjectContainer):IFocusManager
		{
			var stage:Stage = root.stage;
			if(!stage)
			{
				throw new ArgumentError(FOCUS_MANAGER_ROOT_MUST_BE_ON_STAGE_ERROR);
			}
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage] as Vector.<IFocusManager>;
			if(!stack)
			{
				throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
			}
			var manager:IFocusManager = FocusManager.focusManagerFactory(root);
			manager.isEnabled = true;
			if(stack.length > 0)
			{
				var oldManager:IFocusManager = stack[stack.length - 1];
				oldManager.isEnabled = false;
			}
			stack.push(manager);
			return manager;
		}

		/**
		 * Removes the specified focus manager from the stack. If it was
		 * the top-most focus manager, the next top-most focus manager is
		 * enabled.
		 */
		public static function removeFocusManager(manager:IFocusManager):void
		{
			var stage:Stage = manager.root.stage;
			var stack:Vector.<IFocusManager> = STAGE_TO_STACK[stage] as Vector.<IFocusManager>;
			if(!stack)
			{
				throw new Error(FOCUS_MANAGER_NOT_ENABLED_ERROR);
			}
			var index:int = stack.indexOf(manager);
			if(index < 0)
			{
				return;
			}
			manager.isEnabled = false;
			stack.removeAt(index);
			//if this is the top-level focus manager, enable the previous one
			if(index > 0 && index == stack.length)
			{
				manager = stack[stack.length - 1];
				manager.isEnabled = true;
			}
		}

	}
}
