/*
Feathers
Copyright 2012-2021 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Stage;
	import starling.filters.FragmentFilter;
	import starling.rendering.Painter;

	/**
	 * Public properties and functions from <code>starling.display.DisplayObject</code>
	 * in helpful interface form.
	 *
	 * <p>Never cast an object to this type. Cast to <code>DisplayObject</code>
	 * instead. This interface exists only to support easier code hinting for
	 * interfaces.</p>
	 *
	 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html Full description of starling.display.DisplayObject in Gamua's Starling Framework API Reference
	 *
	 * @productversion Feathers 1.1.0
	 */
	public interface IFeathersDisplayObject extends IFeathersEventDispatcher
	{
		/**
		 * The x, or horizontal, position of the display object in the parent's
		 * coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#x Full description of starling.display.DisplayObject.x in Gamua's Starling Framework API Reference
		 */
		function get x():Number;

		/**
		 * @private
		 */
		function set x(value:Number):void;

		/**
		 * The y, or vertical, position of the display object in the parent's
		 * coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#y Full description of starling.display.DisplayObject.y in Gamua's Starling Framework API Reference
		 */
		function get y():Number;

		/**
		 * @private
		 */
		function set y(value:Number):void;

		/**
		 * The width of the display object in the parent's coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#width Full description of starling.display.DisplayObject.width in Gamua's Starling Framework API Reference
		 */
		function get width():Number;

		/**
		 * @private
		 */
		function set width(value:Number):void;

		/**
		 * The height of the display object in the parent's coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#height Full description of starling.display.DisplayObject.height in Gamua's Starling Framework API Reference
		 */
		function get height():Number;

		/**
		 * @private
		 */
		function set height(value:Number):void;

		/**
		 * The x coordinate of the display object's origin in its own coordinate
		 * space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#pivotX Full description of starling.display.DisplayObject.pivotX in Gamua's Starling Framework API Reference
		 */
		function get pivotX():Number;

		/**
		 * @private
		 */
		function set pivotX(value:Number):void;

		/**
		 * The y coordinate of the display object's origin in its own coordinate
		 * space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#pivotY Full description of starling.display.DisplayObject.pivotY in Gamua's Starling Framework API Reference
		 */
		function get pivotY():Number;

		/**
		 * @private
		 */
		function set pivotY(value:Number):void;

		/**
		 * This horizontal scale factor.
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#scaleX Full description of starling.display.DisplayObject.scaleX in Gamua's Starling Framework API Reference
		 */
		function get scaleX():Number;

		/**
		 * @private
		 */
		function set scaleX(value:Number):void;

		/**
		 * The vertical scale factor.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#scaleY Full description of starling.display.DisplayObject.scaleY in Gamua's Starling Framework API Reference
		 */
		function get scaleY():Number;

		/**
		 * @private
		 */
		function set scaleY(value:Number):void;

		/**
		 * The horizontal skew, in radians.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#skewX Full description of starling.display.DisplayObject.skewX in Gamua's Starling Framework API Reference
		 */
		function get skewX():Number;

		/**
		 * @private
		 */
		function set skewX(value:Number):void;

		/**
		 * The vertical skew, in radians.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#skewY Full description of starling.display.DisplayObject.skewY in Gamua's Starling Framework API Reference
		 */
		function get skewY():Number;

		/**
		 * @private
		 */
		function set skewY(value:Number):void;

		/**
		 * The blend mode used when rendering the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#blendMode Full description of starling.display.DisplayObject.blendMode in Gamua's Starling Framework API Reference
		 */
		function get blendMode():String;

		/**
		 * @private
		 */
		function set blendMode(value:String):void;

		/**
		 * The name of the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#name Full description of starling.display.DisplayObject.name in Gamua's Starling Framework API Reference
		 */
		function get name():String;

		/**
		 * @private
		 */
		function set name(value:String):void;

		/**
		 * Determines if the display object may be touched.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#touchable Full description of starling.display.DisplayObject.touchable in Gamua's Starling Framework API Reference
		 */
		function get touchable():Boolean;

		/**
		 * @private
		 */
		function set touchable(value:Boolean):void;

		/**
		 * Determines the visibility of the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#visible Full description of starling.display.DisplayObject.visible in Gamua's Starling Framework API Reference
		 */
		function get visible():Boolean;

		/**
		 * @private
		 */
		function set visible(value:Boolean):void;

		/**
		 * The opacity of the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#alpha Full description of starling.display.DisplayObject.alpha in Gamua's Starling Framework API Reference
		 */
		function get alpha():Number;

		/**
		 * @private
		 */
		function set alpha(value:Number):void;

		/**
		 * The rotation of the display object, in radians.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#rotation Full description of starling.display.DisplayObject.rotation in Gamua's Starling Framework API Reference
		 */
		function get rotation():Number;

		/**
		 * @private
		 */
		function set rotation(value:Number):void;

		/**
		 * The display object's mask.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#mask Full description of starling.display.DisplayObject.mask in Gamua's Starling Framework API Reference
		 */
		function get mask():DisplayObject;

		/**
		 * @private
		 */
		function set mask(value:DisplayObject):void;

		/**
		 * The display object's parent, or <code>null</code> if it doesn't have
		 * a parent.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#parent Full description of starling.display.DisplayObject.parent in Gamua's Starling Framework API Reference
		 */
		function get parent():DisplayObjectContainer;

		/**
		 * The top-most object of the display tree that the display object is
		 * connected to.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#base Full description of starling.display.DisplayObject.base in Gamua's Starling Framework API Reference
		 */
		function get base():DisplayObject;

		/**
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#root Full description of starling.display.DisplayObject.root in Gamua's Starling Framework API Reference
		 */
		function get root():DisplayObject;

		/**
		 * The stage that the display object is connected to, or <code>null</code>
		 * if it is not connected to a stage.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#stage Full description of starling.display.DisplayObject.stage in Gamua's Starling Framework API Reference
		 */
		function get stage():Stage;

		/**
		 * The transformation matrix of the display object, relative to its
		 * parent.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#transformationMatrix Full description of starling.display.DisplayObject.transformationMatrix in Gamua's Starling Framework API Reference
		 */
		function get transformationMatrix():Matrix;

		/**
		 * Determines if the mouse cursor should turn into a hand when the mouse
		 * is over the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#useHandCursor Full description of starling.display.DisplayObject.useHandCursor in Gamua's Starling Framework API Reference
		 */
		function get useHandCursor():Boolean;

		/**
		 * @private
		 */
		function set useHandCursor(value:Boolean):void;

		/**
		 * The bounds of the display object in its local coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#bounds Full description of starling.display.DisplayObject.bounds in Gamua's Starling Framework API Reference
		 */
		function get bounds():Rectangle;

		/**
		 * The filter used when rendering the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#filter Full description of starling.display.DisplayObject.filter in Gamua's Starling Framework API Reference
		 */
		function get filter():FragmentFilter;

		/**
		 * @private
		 */
		function set filter(value:FragmentFilter):void;

		/**
		 * Removes a display object from its parent.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#removeFromParent() Full description of starling.display.DisplayObject.removeFromParent() in Gamua's Starling Framework API Reference
		 */
		function removeFromParent(dispose:Boolean = false):void;

		/**
		 * Determines if a point exists within the display object's bounds.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#hitTest() Full description of starling.display.DisplayObject.hitTest() in Gamua's Starling Framework API Reference
		 */
		function hitTest(localPoint:Point):DisplayObject;

		/**
		 * Converts a point from the display object's coordinate space to the
		 * stage's coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#localToGlobal() Full description of starling.display.DisplayObject.localToGlobal() in Gamua's Starling Framework API Reference
		 */
		function localToGlobal(localPoint:Point, resultPoint:Point = null):Point;

		/**
		 * Converts a point from the stage's coordinate space to the display
		 * object's coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#globalToLocal() Full description of starling.display.DisplayObject.globalToLocal() in Gamua's Starling Framework API Reference
		 */
		function globalToLocal(globalPoint:Point, resultPoint:Point = null):Point;

		/**
		 * Calculates a transformation matrix to convert values from the display
		 * object's coordinate space to a target coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#getTransformationMatrix() Full description of starling.display.DisplayObject.getTransformationMatrix() in Gamua's Starling Framework API Reference
		 */
		function getTransformationMatrix(targetSpace:DisplayObject, resultMatrix:Matrix = null):Matrix;

		/**
		 * Gets the display object's bounds in the target coordinate space.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#getBounds() Full description of starling.display.DisplayObject.getBounds() in Gamua's Starling Framework API Reference
		 */
		function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle;

		/**
		 * Renders the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#render() Full description of starling.display.DisplayObject.render() in Gamua's Starling Framework API Reference
		 */
		function render(painter:Painter):void;

		/**
		 * Disposes the display object.
		 *
		 * @see http://doc.starling-framework.org/core/starling/display/DisplayObject.html#dispose() Full description of starling.display.DisplayObject.dispose() in Gamua's Starling Framework API Reference
		 */
		function dispose():void;
	}
}
