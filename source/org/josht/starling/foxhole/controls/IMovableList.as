package org.josht.starling.foxhole.controls
{
	import org.osflash.signals.ISignal;

	/**
	 * List wich items can be in left, right o center zone.
	 * @author g.konnov
	 */	
	public interface IMovableList
	{
		/**
		 *  Dispatched when touch is ended and itemRenderer is in left zone.
		 *  Parameters: data:Object, renderer:IListItemRenderer
		 */
		function get onLeftAction():ISignal;

		/**
		 *  Dispatched when touch is ended and itemRenderer is in right zone.
		 *  Parameters: data:Object, renderer:IListItemRenderer;
		 */
		function get onRightAction():ISignal;

		/**
		 *  Dispatched when touch is ended and itemRenderer is in center zone.
		 *  Parameters: data:Object, renderer:IListItemRenderer;
		 */
		function get onCenterAction():ISignal;
	}
}

