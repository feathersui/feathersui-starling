/*
Feathers
Copyright 2012-2018 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.skins
{
	import feathers.core.IFeathersControl;

	/**
	 * Sets skin and style properties on a Feathers UI component.
	 *
	 * @productversion Feathers 2.0.0
	 */
	public interface IStyleProvider
	{
		/**
		 * Applies styles to a specific Feathers UI component, unless that
		 * component has been excluded.
		 *
		 * @see #exclude()
		 */
		function applyStyles(target:IFeathersControl):void;
	}
}
