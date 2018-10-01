package feathers.controls.renderers
{
	import starling.display.DisplayObject;

	public interface IDragAndDropItemRenderer
	{
		/**
		 * Indicates if the owner has enabled drag actions.
		 *
		 * <p>This property is set by the list, and should not be set manually.</p>
		 */
		function get dragEnabled():Boolean;

		/**
		 * @private
		 */
		function set dragEnabled(value:Boolean):void;
		

		/**
		 * An optional display object to use to trigger drag and drop in the
		 * list component. If <code>null</code>, the entire item renderer can
		 * be dragged.
		 */
		function get dragProxy():DisplayObject;
	}
}