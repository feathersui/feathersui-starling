/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.popups
{
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.core.IFeathersControl;
	
	import starling.core.Starling;
	import starling.events.Event;

	/**
	 * @inheritDoc
	 */
	[Event(name="close",type="starling.events.Event")]

	/**
	 * Displays a pop-up at the bottom of the stage, filling the vertical space.
	 * The content will be sized horizontally so that it is no larger than the
	 * the width or height of the stage (whichever is smaller).
	 */
	public class VerticalBottomedPopUpContentManager extends VerticalCenteredPopUpContentManager
	{

		/**
		 * Constructor.
		 */
		public function VerticalBottomedPopUpContentManager()
		{
			super();
		}

		override protected function layout():void
		{
			const maxWidth:Number = Math.min(Starling.current.stage.stageWidth, Starling.current.stage.stageHeight) - this.marginLeft - this.marginRight;
			const maxHeight:Number = Starling.current.stage.stageHeight - this.marginTop - this.marginBottom;
			if(this.content is IFeathersControl)
			{
				const uiContent:IFeathersControl = IFeathersControl(this.content);
				uiContent.minWidth = uiContent.maxWidth = maxWidth;
				uiContent.maxHeight = maxHeight;
				uiContent.validate();
			}
			else
			{
				//if it's a ui control that is able to auto-size, the above
				//section will ensure that the control stays within the required
				//bounds.
				//if it's not a ui control, or if the control's explicit width
				//and height values are greater than our maximum bounds, then we
				//will enforce the maximum bounds the hard way.
				if(this.content.width > maxWidth)
				{
					this.content.width = maxWidth;
				}
				if(this.content.height > maxHeight)
				{
					this.content.height = maxHeight;
				}
			}
			this.content.x = (Starling.current.stage.stageWidth - this.content.width) / 2;
			this.content.y = Starling.current.stage.stageHeight - this.content.height - marginBottom;
		}

	}
}
