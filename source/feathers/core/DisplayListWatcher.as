/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.core
{
	import flash.utils.Dictionary;

	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	import starling.events.EventDispatcher;

	/**
	 * Watches a container on the display list. As new display objects are
	 * added, and if they match a specific type, they will be passed to
	 * initializer functions to set properties, call methods, or otherwise
	 * modify them. Useful for initializing skins and styles on UI controls.
	 *
	 * <p><strong>Note:</strong> This class is no longer recommended as a base
	 * class for themes. See <a href="../../../help/custom-themes.html">Custom
	 * Feathers themes</a> for complete details.</p>
	 *
	 * <p>In the example below, the <code>buttonInitializer()</code> function
	 * will be called when a <code>Button</code> is added to the display list,
	 * and no values are specified in its <code>styleNameList</code> that match
	 * other initializers:</p>
	 *
	 * <listing version="3.0">
	 * setInitializerForClass(Button, buttonInitializer);</listing>
	 *
	 * <p>You can specify a value in the button's <code>styleNameList</code> to
	 * call a different initializer for a button. You might do this to apply
	 * different skins for some buttons:</p>
	 *
	 * <listing version="3.0">
	 * var button:Button = new Button();
	 * button.label = "Click Me";
	 * button.styleNameList.add( Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION );
	 * this.addChild( button );</listing>
	 *
	 * <p>The <code>callToActionButtonInitializer()</code> function will be called
	 * when a <code>Button</code> with the <code>Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION</code>
	 * value is added to its <code>styleNameList</code>:</p>
	 *
	 * <listing version="3.0">
	 * setInitializerForClass( Button, callToActionButtonInitializer, Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION );</listing>
	 *
	 * <p>Initializers are not called for subclasses. If a <code>Check</code> is
	 * added to the display list (<code>Check</code> extends
	 * <code>Button</code>), the <code>buttonInitializer()</code> function will
	 * not be called. This important restriction allows subclasses to have
	 * different skins.</p>
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
	public class DisplayListWatcher extends EventDispatcher
	{
		/**
		 * Constructor.
		 *
		 * @param topLevelContainer		The root display object to watch (not necessarily Starling's stage or root object)
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
		 * <p>In the following example, the required base class is changed:</p>
		 *
		 * <listing version="3.0">
		 * watcher.requiredBaseClass = Sprite;</listing>
		 *
		 * @default feathers.core.IFeathersControl
		 */
		public var requiredBaseClass:Class = IFeathersControl;

		/**
		 * Determines if only the object added should be processed or if its
		 * children should be processed recursively. Disabling this property
		 * may improve performance slightly, but it limits the capabilities of
		 * <code>DisplayListWatcher</code>.
		 *
		 * <p>In the following example, children are not processed recursively:</p>
		 *
		 * <listing version="3.0">
		 * watcher.processRecursively = false;</listing>
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
		 * once or every time that they are re-added. Disabling this property
		 * will allow you to reinitialize a component when it is removed and
		 * added to the display list. However, this may also unnecessarily
		 * reinitialize components that have not changed, which will affect
		 * performance.
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
				this.initializedObjects = null;
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
		 *
		 * <p>In the following example, we check if a display object is excluded:</p>
		 *
		 * <listing version="3.0">
		 * if( watcher.isExcluded( image ) )
		 * {
		 *     // this display object won't be processed by the watcher
		 * }</listing>
		 */
		public function isExcluded(target:DisplayObject):Boolean
		{
			if(!this._excludedObjects)
			{
				return false;
			}

			var objectCount:int = this._excludedObjects.length;
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
			var index:int = this._initializerSuperTypes.indexOf(type);
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
			var nameTable:Object = this._initializerNameTypeMap[type];
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

			var nameTable:Object = this._initializerNameTypeMap[type];
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
			var index:int = this._initializerSuperTypes.indexOf(type);
			if(index >= 0)
			{
				this._initializerSuperTypes.splice(index, 1);
			}
		}

		/**
		 * Immediately initialize an object. Useful for initializing components
		 * that are already on stage when this <code>DisplayListWatcher</code>
		 * is created.
		 *
		 * <p>If the object has already been initialized, it won't be
		 * initialized again. However, it's children may be initialized, if they
		 * haven't been initialized yet.</p>
		 */
		public function initializeObject(target:DisplayObject):void
		{
			var targetAsRequiredBaseClass:DisplayObject = DisplayObject(target as requiredBaseClass);
			if(targetAsRequiredBaseClass)
			{
				var isInitialized:Boolean = this._initializeOnce && this.initializedObjects[targetAsRequiredBaseClass];
				if(!isInitialized)
				{
					if(this.isExcluded(target))
					{
						return;
					}

					if(this._initializeOnce)
					{
						this.initializedObjects[targetAsRequiredBaseClass] = true;
					}
					this.processAllInitializers(target);
				}
			}

			if(this.processRecursively)
			{
				var targetAsContainer:DisplayObjectContainer = target as DisplayObjectContainer;
				if(targetAsContainer)
				{
					var childCount:int = targetAsContainer.numChildren;
					for(var i:int = 0; i < childCount; i++)
					{
						var child:DisplayObject = targetAsContainer.getChildAt(i);
						this.initializeObject(child);
					}
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function processAllInitializers(target:DisplayObject):void
		{
			var superTypeCount:int = this._initializerSuperTypes.length;
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
			var hasNameInitializer:Boolean = false;
			if(target is IFeathersControl && nameMap)
			{
				var nameTable:Object = nameMap[type];
				if(nameTable)
				{
					var uiControl:IFeathersControl = IFeathersControl(target);
					var styleNameList:TokenList = uiControl.styleNameList;
					var nameCount:int = styleNameList.length;
					for(var i:int = 0; i < nameCount; i++)
					{
						var name:String = styleNameList.item(i);
						initializer = nameTable[name] as Function;
						if(initializer != null)
						{
							hasNameInitializer = true;
							initializer(target);
						}
					}
				}
			}
			if(hasNameInitializer)
			{
				return;
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
		protected function addedHandler(event:Event):void
		{
			this.initializeObject(event.target as DisplayObject);
		}
	}
}