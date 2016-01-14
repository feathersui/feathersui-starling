/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	import feathers.skins.IStyleProvider;

	import flash.errors.IllegalOperationError;

	[Exclude(name="isToggle",kind="property")]

	/**
	 * A toggle control that contains a label and a box that may be checked
	 * or not to indicate selection.
	 *
	 * <p>In the following example, a check is created and selected, and a
	 * listener for <code>Event.CHANGE</code> is added:</p>
	 *
	 * <listing version="3.0">
	 * var check:Check = new Check();
	 * check.label = "Pick Me!";
	 * check.isSelected = true;
	 * check.addEventListener( Event.CHANGE, check_changeHandler );
	 * this.addChild( check );</listing>
	 *
	 * @see ../../../help/check.html How to use the Feathers Check component
	 * @see feathers.controls.ToggleSwitch
	 */
	public class Check extends ToggleButton
	{
		/**
		 * The default value added to the <code>styleNameList</code> of the label.
		 *
		 * @see feathers.core.FeathersControl#styleNameList
		 */
		public static const DEFAULT_CHILD_STYLE_NAME_LABEL:String = "feathers-check-label";
		
		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP:String = "up";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN:String = "down";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER:String = "hover";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED:String = "disabled";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.UP_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_UP_AND_SELECTED:String = "upAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DOWN_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DOWN_AND_SELECTED:String = "downAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.HOVER_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_HOVER_AND_SELECTED:String = "hoverAndSelected";

		/**
		 * @private
		 * DEPRECATED: Replaced by <code>feathers.controls.ButtonState.DISABLED_AND_SELECTED</code>.
		 *
		 * <p><strong>DEPRECATION WARNING:</strong> This constant is deprecated
		 * starting with Feathers 3.0. It will be removed in a future version of
		 * Feathers according to the standard
		 * <a target="_top" href="../../../help/deprecation-policy.html">Feathers deprecation policy</a>.</p>
		 */
		public static const STATE_DISABLED_AND_SELECTED:String = "disabledAndSelected";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_TOP
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_TOP:String = "top";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_RIGHT
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_BOTTOM
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_BOTTOM:String = "bottom";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_LEFT
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_MANUAL
		 *
		 * @see #iconPosition
		 * @see #iconOffsetX
		 * @see #iconOffsetY
		 */
		public static const ICON_POSITION_MANUAL:String = "manual";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_LEFT_BASELINE
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_LEFT_BASELINE:String = "leftBaseline";

		/**
		 * @copy feathers.controls.Button#ICON_POSITION_RIGHT_BASELINE
		 *
		 * @see #iconPosition
		 */
		public static const ICON_POSITION_RIGHT_BASELINE:String = "rightBaseline";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_LEFT
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_LEFT:String = "left";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_CENTER
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_CENTER:String = "center";

		/**
		 * @copy feathers.controls.Button#HORIZONTAL_ALIGN_RIGHT
		 *
		 * @see #horizontalAlign
		 */
		public static const HORIZONTAL_ALIGN_RIGHT:String = "right";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_TOP
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_TOP:String = "top";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_MIDDLE
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_MIDDLE:String = "middle";

		/**
		 * @copy feathers.controls.Button#VERTICAL_ALIGN_BOTTOM
		 *
		 * @see #verticalAlign
		 */
		public static const VERTICAL_ALIGN_BOTTOM:String = "bottom";
		
		/**
		 * The default <code>IStyleProvider</code> for all <code>Check</code>
		 * components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;

		/**
		 * Constructor.
		 */
		public function Check()
		{
			super();
			this.labelStyleName = DEFAULT_CHILD_STYLE_NAME_LABEL;
			super.isToggle = true;
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return Check.globalStyleProvider;
		}

		/**
		 * @private
		 */
		override public function set isToggle(value:Boolean):void
		{
			throw IllegalOperationError("CheckBox isToggle must always be true.");
		}
	}
}
