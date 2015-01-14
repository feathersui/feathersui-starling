/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IToggle;

	import flash.utils.Dictionary;

	/**
	 * Maps a component's states to values, perhaps for one of the component's
	 * properties such as a skin or text format.
	 */
	public class StateWithToggleValueSelector
	{
		/**
		 * Constructor.
		 */
		public function StateWithToggleValueSelector()
		{
		}

		/**
		 * @private
		 * Stores the values for each state.
		 */
		protected var stateToValue:Dictionary = new Dictionary(true);

		/**
		 * @private
		 * Stores the values for each state where isSelected is true.
		 */
		protected var stateToSelectedValue:Dictionary = new Dictionary(true);

		/**
		 * If there is no value for the specified state, a default value can
		 * be used as a fallback.
		 */
		public var defaultValue:Object;

		/**
		 * If the target is a selected IToggle instance, and if there is no
		 * value for the specified state, a default value may be used as a
		 * fallback (with a higher priority than the regular default fallback).
		 *
		 * @see feathers.core.IToggle
		 */
		public var defaultSelectedValue:Object;

		/**
		 * Stores a value for a specified state to be returned from
		 * getValueForState().
		 */
		public function setValueForState(value:Object, state:Object, isSelected:Boolean = false):void
		{
			if(isSelected)
			{
				this.stateToSelectedValue[state] = value;
			}
			else
			{
				this.stateToValue[state] = value;
			}
		}

		/**
		 * Clears the value stored for a specific state.
		 */
		public function clearValueForState(state:Object, isSelected:Boolean = false):Object
		{
			if(isSelected)
			{
				var value:Object = this.stateToSelectedValue[state];
				delete this.stateToSelectedValue[state];
			}
			else
			{
				value = this.stateToValue[state];
				delete this.stateToValue[state];
			}
			return value;
		}

		/**
		 * Returns the value stored for a specific state.
		 */
		public function getValueForState(state:Object, isSelected:Boolean = false):Object
		{
			if(isSelected)
			{
				return this.stateToSelectedValue[state];
			}
			return this.stateToValue[state];
		}

		/**
		 * Returns the value stored for a specific state. May generate a value,
		 * if none is present.
		 *
		 * @param target		The object receiving the stored value. The manager may query properties on the target to customize the returned value.
		 * @param state			The current state.
		 * @param oldValue		The previous value. May be reused for the new value.
		 */
		public function updateValue(target:Object, state:Object, oldValue:Object = null):Object
		{
			var value:Object;
			if(target is IToggle && IToggle(target).isSelected)
			{
				value = this.stateToSelectedValue[state];
				if(value === null)
				{
					value = this.defaultSelectedValue;
				}
			}
			else
			{
				value = this.stateToValue[state];
			}
			if(value === null)
			{
				value = this.defaultValue;
			}
			return value;
		}
	}
}
