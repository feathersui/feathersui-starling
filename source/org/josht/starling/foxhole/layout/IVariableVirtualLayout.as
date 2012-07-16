package org.josht.starling.foxhole.layout
{
	public interface IVariableVirtualLayout extends IVirtualLayout
	{
		/**
		 * Used to access the width and height, in pixels, of the virtual item
		 * at the specified index. This should be used instead of
		 * <code>typicalItemWidth</code> and <code>typicalItemHeight</code> if
		 * the items in the layout have variable dimensions.
		 *
		 * <p>The function is expected to have the following signature:</p>
		 * <pre>function(index:int, result:Point = null):Point</pre>
		 */
		function get indexToItemBoundsFunction():Function;

		/**
		 * @private
		 */
		function set indexToItemBoundsFunction(value:Function):void;
	}
}
