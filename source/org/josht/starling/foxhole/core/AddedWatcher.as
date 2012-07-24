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

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * Watches a container on the display list. As new display objects are
	 * added, if they match a specific type, they will be passed to initializer
	 * functions to set properties, call methods, or otherwise modify them.
	 * Useful for initializing skins and styles on UI controls.
	 * 
	 * <p>If a display object matches multiple types that have initializers, and
	 * <code>exactTypeMatching</code> is disabled, the initializers will be
	 * executed in order following the inheritance chain.</p>
	 */
	public class AddedWatcher
	{
		/**
		 * Constructor.
		 */
		public function AddedWatcher(root:DisplayObject)
		{
			this._root = root;
			this._root.addEventListener(Event.ADDED, addedHandler);
		}
		
		/**
		 * The minimum base class required before the AddedWatcher will check
		 * to see if a particular display object has any initializers.
		 */
		public var requiredBaseClass:Class = FoxholeControl;
		
		/**
		 * If disabled, initializers for all classes in a target's inheritance
		 * chain will be run. This setting has a performance impact on mobile.
		 */
		public var exactTypeMatching:Boolean = true;

		/**
		 * Determines if only the object added should be processed or if its
		 * children should be processed recursively.
		 */
		public var processRecursively:Boolean = true;

		private var _root:DisplayObject;
		private var _noNameTypeMap:Dictionary = new Dictionary(true);
		private var _nameTypeMap:Dictionary = new Dictionary(true);
		
		/**
		 * Sets the initializer for a specific class.
		 */
		public function setInitializerForClass(type:Class, initializer:Function, withName:String = null):void
		{
			if(!withName)
			{
				this._noNameTypeMap[type] = initializer;
			}
			var nameTable:Object = this._nameTypeMap[type];
			if(!nameTable)
			{
				this._nameTypeMap[type] = nameTable = {};
			}
			nameTable[withName] = initializer;
		}
		
		/**
		 * If an initializer exists for a specific class, it will be returned.
		 */
		public function getInitializerForClass(type:Class, withName:String = null):Function
		{
			if(!withName)
			{
				return this._noNameTypeMap[type] as Function;
			}
			const nameTable:Object = this._nameTypeMap[type];
			if(!nameTable)
			{
				return null;
			}
			return nameTable[withName] as Function;
		}
		
		/**
		 * If an initializer exists for a specific class, it will be removed
		 * completely.
		 */
		public function clearInitializerForClass(type:Class, withName:String = null):void
		{
			if(!withName)
			{
				delete this._noNameTypeMap[type];
				return;
			}

			const nameTable:Object = this._nameTypeMap[type];
			if(!nameTable)
			{
				return;
			}
			delete nameTable[withName];
			return;
		}
		
		/**
		 * @private
		 */
		protected function applyAllStyles(target:DisplayObject):void
		{
			if(!this.exactTypeMatching)
			{
				const description:XML = describeType(target);
				const extendedClasses:XMLList = description.extendsClass;
				for(var i:int = extendedClasses.length() - 1; i >= 0; i--)
				{
					var extendedClass:XML = extendedClasses[i];
					var typeName:String = extendedClass.attribute("type").toString();
					var type:Class = Class(getDefinitionByName(typeName));
					this.applyAllStylesForType(target, type);
				}
			}
			type = Object(target).constructor;
			this.applyAllStylesForType(target, type);
		}

		protected function applyAllStylesForType(target:DisplayObject, type:Class):void
		{
			var initializer:Function;
			const nameTable:Object = this._nameTypeMap[type];
			if(nameTable)
			{
				if(target is FoxholeControl)
				{
					const foxholeControl:FoxholeControl = FoxholeControl(target);
					for(var name:String in nameTable)
					{
						if(foxholeControl.nameList.contains(name))
						{
							initializer = nameTable[name] as Function;
							if(initializer != null)
							{
								initializer(target);
								return;
							}
						}
					}
				}
			}

			initializer = this._noNameTypeMap[type] as Function;
			if(initializer != null)
			{
				initializer(target);
			}
		}

		protected function addObject(target:DisplayObject):void
		{
			const targetAsRequiredBaseClass:DisplayObject = DisplayObject(target as requiredBaseClass);
			if(targetAsRequiredBaseClass)
			{
				this.applyAllStyles(target);
			}

			if(this.processRecursively)
			{
				const targetAsContainer:DisplayObjectContainer = target as DisplayObjectContainer;
				if(targetAsContainer)
				{
					const childCount:int = targetAsContainer.numChildren;
					for(var i:int = 0; i < childCount; i++)
					{
						var child:DisplayObject = targetAsContainer.getChildAt(i);
						this.addObject(child);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function addedHandler(event:Event):void
		{
			this.addObject(event.target as DisplayObject);
		}
	}
}