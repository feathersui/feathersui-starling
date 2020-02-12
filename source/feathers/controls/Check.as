/*
Feathers
Copyright 2012-2020 Bowler Hat LLC. All Rights Reserved.

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
	 *
	 * @productversion Feathers 1.0.0
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
