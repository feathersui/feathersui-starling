/*
 Copyright (c) 2012 Josh Tynjala

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */
package feathers.controls
{
	import flash.errors.IllegalOperationError;

	import feathers.core.ToggleGroup;

	import starling.events.Event;

	[Exclude(name="isToggle",kind="property")]

	/**
	 * A toggleable control that exists in a set that requires a single,
	 * exclusive toggled item.
	 *
	 * @see feathers.core.ToggleGroup
	 */
	public class Radio extends Button
	{
		/**
		 * If a <code>Radio</code> has not been added to a <code>ToggleGroup</code>,
		 * it will automatically be added to this group. If the Radio's
		 * <code>toggleGroup</code> property is set to a different group, it
		 * will be automatically removed from this group, if required.
		 */
		public static const defaultRadioGroup:ToggleGroup = new ToggleGroup();

		/**
		 * Constructor.
		 */
		public function Radio()
		{
			super.isToggle = true;
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		/**
		 * @private
		 */
		override public function set isToggle(value:Boolean):void
		{
			throw IllegalOperationError("Radio isToggle must always be true.")
		}

		/**
		 * @private
		 */
		protected var _toggleGroup:ToggleGroup;

		/**
		 * @inheritDoc
		 */
		public function get toggleGroup():ToggleGroup
		{
			return this._toggleGroup;
		}

		/**
		 * @private
		 */
		public function set toggleGroup(value:ToggleGroup):void
		{
			if(this._toggleGroup == value)
			{
				return;
			}
			if(!value && this.stage)
			{
				value = defaultRadioGroup;
			}
			if(this._toggleGroup && this._toggleGroup.hasItem(this))
			{
				this._toggleGroup.removeItem(this);
			}
			this._toggleGroup = value;
			if(!this._toggleGroup.hasItem(this))
			{
				this._toggleGroup.addItem(this);
			}
		}

		/**
		 * @private
		 */
		protected function addedToStageHandler(event:Event):void
		{
			if(!this._toggleGroup)
			{
				this.toggleGroup = defaultRadioGroup;
			}
		}

		/**
		 * @private
		 */
		override protected function removedFromStageHandler(event:Event):void
		{
			if(this._toggleGroup == defaultRadioGroup)
			{
				this._toggleGroup.removeItem(this);
			}
			super.removedFromStageHandler(event);
		}
	}
}
