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
package feathers.controls.supportClasses
{
	import org.osflash.signals.ISignal;

	[ExcludeClass]
	public interface IViewPort
	{
		function get visibleWidth():Number;
		function set visibleWidth(value:Number):void;
		function get minVisibleWidth():Number;
		function set minVisibleWidth(value:Number):void;
		function get maxVisibleWidth():Number;
		function set maxVisibleWidth(value:Number):void;
		function get visibleHeight():Number;
		function set visibleHeight(value:Number):void;
		function get minVisibleHeight():Number;
		function set minVisibleHeight(value:Number):void;
		function get maxVisibleHeight():Number;
		function set maxVisibleHeight(value:Number):void;

		function get horizontalScrollPosition():Number;
		function set horizontalScrollPosition(value:Number):void;
		function get verticalScrollPosition():Number;
		function set verticalScrollPosition(value:Number):void;

		function get width():Number;
		function get height():Number;

		function get onResize():ISignal;
	}
}
