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
package org.josht.starling.foxhole.core
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import starling.display.DisplayObject;
	import starling.events.Event;

	public class AddedWatcher
	{
		public function AddedWatcher(root:DisplayObject)
		{
			this._root = root;
			this._root.addEventListener(Event.ADDED, addedHandler);
		}
		
		public var requiredBaseClass:Class = FoxholeControl;
		
		private var _root:DisplayObject;
		private var _typeMap:Dictionary = new Dictionary(true);
		
		public function setInitializerForClass(type:Class, initializer:Function):void
		{
			this._typeMap[type] = initializer;
		}
		
		public function getInitializerForClass(type:Class):Function
		{
			return this._typeMap[type];
		}
		
		public function clearInitializerForClass(type:Class):void
		{
			delete this._typeMap[type];
		}
		
		protected function applyAllStyles(target:DisplayObject):void
		{
			var combinedStyles:Object = {};
			const description:XML = describeType(target);
			const extendedClasses:XMLList = description.extendsClass;
			for(var i:int = extendedClasses.length() - 1; i >= 0; i--)
			{
				var extendedClass:XML = extendedClasses[i];
				var typeName:String = extendedClass.attribute("type").toString();
				var type:Class = Class(getDefinitionByName(typeName));
				var initializer:Function = this._typeMap[type];
				if(initializer != null)
				{
					initializer(target);
				}
			}
			type = Object(target).constructor;
			initializer = this._typeMap[type];
			if(initializer != null)
			{
				initializer(target);
			}
		}
		
		protected function addedHandler(event:Event):void
		{
			var target:DisplayObject = (event.target as requiredBaseClass) as DisplayObject;
			if(!target)
			{
				return;
			}
			this.applyAllStyles(target);
		}
	}
}