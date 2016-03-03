/*
Feathers
Copyright 2012-2016 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;

	/**
	 * Manages tool tips. Should not be enabled on touch screens, since
	 * TouchPhase.HOVER is not dispatched for touches.
	 *
	 * @see ../../../help/tool-tips.html Tool tips in Feathers
	 * @see feathers.core.FeathersControl#toolTip
	 */
	public class ToolTipManager
	{
		/**
		 * @private
		 */
		protected static const STAGE_TO_MANAGER:Dictionary = new Dictionary(true);
		
		/**
		 * Returns the active tool tip manager for the specified Starling stage.
		 * May return <code>null</code> if tool tip management has not been
		 * enabled for the specified stage.
		 *
		 * @see #isEnabledForStage()
		 * @see #setEnabledForStage()
		 */
		public static function getToolTipManagerForStage(stage:Stage):IToolTipManager
		{
			return IToolTipManager(STAGE_TO_MANAGER[stage]);
		}

		/**
		 * The default factory that creates a tool tip manager.
		 *
		 * @see #toolTipManagerFactory
		 * @see feathers.core.DefaultToolTipManager
		 */
		public static function defaultToolTipManagerFactory(root:DisplayObjectContainer):IToolTipManager
		{
			return new DefaultToolTipManager(root);
		}

		/**
		 * A function that creates a tool tip manager.
		 *
		 * <p>This function is expected to have the following signature:</p>
		 * <pre>function():IToolTipManager</pre>
		 *
		 * <p>In the following example, the tool tip manager factory is modified:</p>
		 *
		 * <listing version="3.0">
		 * ToolTipManager.toolTipManagerFactory = function(root:DisplayObjectContainer):IToolTipManager
		 * {
		 *     return new CustomToolTipManager(); //a custom class that implements IToolTipManager
		 * };</listing>
		 *
		 * @see feathers.core.IToolTipManager
		 */
		public static var toolTipManagerFactory:Function = defaultToolTipManagerFactory;

		/**
		 * Determines if the tool tip manager is enabled or disabled for the
		 * specified Starling stage.
		 *
		 * @see #setEnabledForStage()
		 * @see #getToolTipManagerForStage()
		 */
		public static function isEnabledForStage(stage:Stage):Boolean
		{
			return IToolTipManager(STAGE_TO_MANAGER[stage]) !== null;
		}

		/**
		 * Enables or disables toll tip management on the specified Starling
		 * stage. For mobile apps, the tool tip manager should generally remain
		 * disabled. For desktop apps, it is recommended to enable the tool tip
		 * manager.
		 *
		 * <p>In the following example, tool tip management is enabled:</p>
		 *
		 * <listing version="3.0">
		 * ToolTipManager.setEnabledForStage(stage, true);</listing>
		 *
		 * @see #isEnabledForStage()
		 * @see #getToolTipManagerForStage()
		 */
		public static function setEnabledForStage(stage:Stage, isEnabled:Boolean):void
		{
			var manager:IToolTipManager = IToolTipManager(STAGE_TO_MANAGER[stage]);
			if((isEnabled && manager) || (!isEnabled && !manager))
			{
				return;
			}
			if(isEnabled)
			{
				STAGE_TO_MANAGER[stage] = toolTipManagerFactory(stage);
			}
			else
			{
				manager.dispose();
				delete STAGE_TO_MANAGER[stage];
			}
		}

		/**
		 * Disables tool tip management on all stages where it has previously
		 * been enabled.
		 */
		public function disableAll():void
		{
			for(var key:Object in STAGE_TO_MANAGER)
			{
				var stage:Stage = Stage(key);
				var manager:IToolTipManager = IToolTipManager(STAGE_TO_MANAGER[stage]);
				manager.dispose();
				delete STAGE_TO_MANAGER[stage];
			}
		}
	}
}
