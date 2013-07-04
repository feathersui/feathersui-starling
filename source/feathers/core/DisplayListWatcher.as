/*
Feathers
Copyright 2012-2013 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	/**
	 * Watches a container on the display list. As new display objects are
	 * added, and if they match a specific type, they will be passed to initializer
	 * functions to set properties, call methods, or otherwise modify them.
	 * Useful for initializing skins and styles on UI controls.
	 *
	 * <p>In the example below, the <code>buttonInitializer()</code> function
	 * will be called when a <code>Button</code> is added to the display list:</p>
	 *
	 * <listing version="3.0">
	 * setInitializerForClass(Button, buttonInitializer);</listing>
	 *
	 * <p>However, initializers are not called for subclasses. If a
	 * <code>Check</code> is added to the display list (<code>Check</code>
	 * extends <code>Button</code>), the <code>buttonInitializer()</code>
	 * function will not be called. This important restriction allows subclasses
	 * to have different skins, for instance.</p>
	 *
	 * <p>You can target a specific subclass with the same initializer function
	 * without adding it for all subclasses:</p>
	 *
	 * <listing version="3.0">
	 * setInitializerForClass(Button, buttonInitializer);
	 * setInitializerForClass(Check, buttonInitializer);</listing>
	 *
	 * <p>In this case, <code>Button</code> and <code>Check</code> will trigger
	 * the <code>buttonInitializer()</code> function, but <code>Radio</code>
	 * (another subclass of <code>Button</code>) will not.</p>
	 *
	 * <p>You can target a class and all of its subclasses, using a different
	 * function. This is recommended only when you are absolutely sure that
	 * no subclasses will need a separate initializer.</p>
	 *
	 * <listing version="3.0">
	 * setInitializerForClassAndSubclasses(Button, buttonInitializer);</listing>
	 *
	 * <p>In this case, <code>Button</code>, <code>Check</code>, <code>Radio</code>
	 * and every other subclass of <code>Button</code> (including any subclasses
	 * that you create yourself) will trigger the <code>buttonInitializer()</code>
	 * function.</p>
	 */
	public class DisplayListWatcher
	{
		/**
		 * Constructor.
		 *
		 * @param topLevelContainer		The root display object to watch (not necessarily Starling's root object)
		 */
		public function DisplayListWatcher(topLevelContainer:DisplayObjectContainer)
		{
			this.root = topLevelContainer;
			this.root.addEventListener(Event.ADDED, addedHandler);
		}
		
		/**
		 * The minimum base class required before the AddedWatcher will check
		 * to see if a particular display object has any initializers.
		 *
		 * @default feathers.core.IFeathersControl
		 */
		public var requiredBaseClass:Class = IFeathersControl;

		/**
		 * Determines if only the object added should be processed or if its
		 * children should be processed recursively.
		 *
		 * @default true
		 */
		public var processRecursively:Boolean = true;

		/**
		 * @private
		 * Tracks the objects that have been initialized. Uses weak keys so that
		 * the tracked objects can be garbage collected.
		 */
		protected var initializedObjects:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _initializeOnce:Boolean = true;

		/**
		 * Determines if objects added to the display list are initialized only
		 * once or every time that they are re-added.
		 *
		 * @default true
		 */
		public function get initializeOnce():Boolean
		{
			return this._initializeOnce;
		}

		/**
		 * @private
		 */
		public function set initializeOnce(value:Boolean):void
		{
			if(this._initializeOnce == value)
			{
				return;
			}
			this._initializeOnce = value;
			if(value)
			{
				this.initializedObjects = new Dictionary(true);
			}
			else
			{
				this.initializedObjects = null
			}
		}

		/**
		 * The root of the display list that is watched for added children.
		 */
		protected var root:DisplayObjectContainer;

		/**
		 * @private
		 */
		protected var _initializerNoNameTypeMap:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _initializerNameTypeMap:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _initializerSuperTypeMap:Dictionary = new Dictionary(true);

		/**
		 * @private
		 */
		protected var _initializerSuperTypes:Vector.<Class> = new <Class>[];

		/**
		 * @private
		 */
		protected var _excludedObjects:Vector.<DisplayObject>;

		/**
		 * Stops listening to the root and cleans up anything else that needs to
		 * be disposed. If a <code>DisplayListWatcher</code> is extended for a
		 * theme, it should also dispose textures and other assets.
		 */
		public function dispose():void
		{
			if(this.root)
			{
				this.root.removeEventListener(Event.ADDED, addedHandler);
				this.root = null;
			}
			if(this._excludedObjects)
			{
				this._excludedObjects.length = 0;
				this._excludedObjects = null;
			}
			for(var key:Object in this.initializedObjects)
			{
				delete this.initializedObjects[key];
			}
			for(key in this._initializerNameTypeMap)
			{
				delete this._initializerNameTypeMap[key];
			}
			for(key in this._initializerNoNameTypeMap)
			{
				delete this._initializerNoNameTypeMap[key];
			}
			for(key in this._initializerSuperTypeMap)
			{
				delete this._initializerSuperTypeMap[key];
			}
			this._initializerSuperTypes.length = 0;
		}

		/**
		 * Excludes a display object, and all if its children (if any) from
		 * being watched.
		 */
		public function exclude(target:DisplayObject):void
		{
			if(!this._excludedObjects)
			{
				this._excludedObjects = new <DisplayObject>[];
			}
			this._excludedObjects.push(target);
		}

		/**
		 * Determines if an object is excluded from being watched.
		 */
		public function isExcluded(target:DisplayObject):Boolean
		{
			if(!this._excludedObjects)
			{
				return false;
			}

			const objectCount:int = this._excludedObjects.length;
			for(var i:int = 0; i < objectCount; i++)
			{
				var object:DisplayObject = this._excludedObjects[i];
				if(object is DisplayObjectContainer)
				{
					if(DisplayObjectContainer(object).contains(target))
					{
						return true;
					}
				}
				else if(object == target)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Sets the initializer for a specific class.
		 */
		public function setInitializerForClass(type:Class, initializer:Function, withName:String = null):void
		{
			if(!withName)
			{
				this._initializerNoNameTypeMap[type] = initializer;
				return;
			}
			var nameTable:Object = this._initializerNameTypeMap[type];
			if(!nameTable)
			{
				this._initializerNameTypeMap[type] = nameTable = {};
			}
			nameTable[withName] = initializer;
		}

		/**
		 * Sets an initializer for a specific class and any subclasses. This
		 * option can potentially hurt performance, so use sparingly.
		 */
		public function setInitializerForClassAndSubclasses(type:Class, initializer:Function):void
		{
			const index:int = this._initializerSuperTypes.indexOf(type);
			if(index < 0)
			{
				this._initializerSuperTypes.push(type);
			}
			this._initializerSuperTypeMap[type] = initializer;
		}
		
		/**
		 * If an initializer exists for a specific class, it will be returned.
		 */
		public function getInitializerForClass(type:Class, withName:String = null):Function
		{
			if(!withName)
			{
				return this._initializerNoNameTypeMap[type] as Function;
			}
			const nameTable:Object = this._initializerNameTypeMap[type];
			if(!nameTable)
			{
				return null;
			}
			return nameTable[withName] as Function;
		}

		/**
		 * If an initializer exists for a specific class and its subclasses, the initializer will be returned.
		 */
		public function getInitializerForClassAndSubclasses(type:Class):Function
		{
			return this._initializerSuperTypeMap[type];
		}
		
		/**
		 * If an initializer exists for a specific class, it will be removed
		 * completely.
		 */
		public function clearInitializerForClass(type:Class, withName:String = null):void
		{
			if(!withName)
			{
				delete this._initializerNoNameTypeMap[type];
				return;
			}

			const nameTable:Object = this._initializerNameTypeMap[type];
			if(!nameTable)
			{
				return;
			}
			delete nameTable[withName];
			return;
		}

		/**
		 * If an initializer exists for a specific class and its subclasses, the
		 * initializer will be removed completely.
		 */
		public function clearInitializerForClassAndSubclasses(type:Class):void
		{
			delete this._initializerSuperTypeMap[type];
			const index:int = this._initializerSuperTypes.indexOf(type);
			if(index >= 0)
			{
				this._initializerSuperTypes.splice(index, 1);
			}
		}
		
		/**
		 * @private
		 */
		protected function processAllInitializers(target:DisplayObject):void
		{
			const superTypeCount:int = this._initializerSuperTypes.length;
			for(var i:int = 0; i < superTypeCount; i++)
			{
				var type:Class = this._initializerSuperTypes[i];
				if(target is type)
				{
					this.applyAllStylesForTypeFromMaps(target, type, this._initializerSuperTypeMap);
				}
			}
			type = Class(Object(target).constructor);
			this.applyAllStylesForTypeFromMaps(target, type, this._initializerNoNameTypeMap, this._initializerNameTypeMap);
		}

		/**
		 * @private
		 */
		protected function applyAllStylesForTypeFromMaps(target:DisplayObject, type:Class, map:Dictionary, nameMap:Dictionary = null):void
		{
			var initializer:Function;
			if(nameMap)
			{
				const nameTable:Object = nameMap[type];
				if(nameTable)
				{
					if(target is IFeathersControl)
					{
						const uiControl:IFeathersControl = IFeathersControl(target);
						for(var name:String in nameTable)
						{
							if(uiControl.nameList.contains(name))
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
			}

			initializer = map[type] as Function;
			if(initializer != null)
			{
				initializer(target);
			}
		}

		/**
		 * @private
		 */
		protected function addObject(target:DisplayObject):void
		{
			const targetAsRequiredBaseClass:DisplayObject = DisplayObject(target as requiredBaseClass);
			if(targetAsRequiredBaseClass)
			{
				const isInitialized:Boolean = this._initializeOnce && this.initializedObjects[targetAsRequiredBaseClass];
				if(!isInitialized)
				{
					if(this.isExcluded(target))
					{
						return;
					}

					this.initializedObjects[targetAsRequiredBaseClass] = true;
					this.processAllInitializers(target);
				}
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