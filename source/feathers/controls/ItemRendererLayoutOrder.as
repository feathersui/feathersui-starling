/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls
{
	/**
	 * Layout options for the default item renderers.
	 * 
	 * @see feathers.controls.DefaultListItemRenderer
	 * @see feathers.controls.DefaultGroupedListItemRenderer
	 *
	 * @productversion Feathers 3.0.0
	 */
	public class ItemRendererLayoutOrder
	{
		/**
		 * The layout order will be the label first, then the accessory relative
		 * to the label, then the icon relative to both. Best used when the
		 * accessory should be between the label and the icon or when the icon
		 * position shouldn't be affected by the accessory.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const LABEL_ACCESSORY_ICON:String = "labelAccessoryIcon";

		/**
		 * The layout order will be the label first, then the icon relative to
		 * label, then the accessory relative to both.
		 *
		 * @productversion Feathers 3.0.0
		 */
		public static const LABEL_ICON_ACCESSORY:String = "labelIconAccessory";
	}
}
