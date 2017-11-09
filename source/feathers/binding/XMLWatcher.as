/*
Feathers SDK
Copyright 2012-2015 Bowler Hat LLC

See the NOTICE file distributed with this work for additional information
regarding copyright ownership. The author licenses this file to You under the
Apache License, Version 2.0 (the "License"); you may not use this file except in
compliance with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.
*/
package feathers.binding
{
	import feathers.binding.utils.IXMLNotifiable;
	import feathers.binding.utils.XMLNotifier;

	import mx.core.mx_internal;

	use namespace mx_internal;

	[ExcludeClass]

	/**
	 *  @private
	 */
	public class XMLWatcher extends Watcher implements IXMLNotifiable
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function XMLWatcher(propertyName:String, listeners:Array)
		{
			super(listeners);

			_propertyName = propertyName;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  The parent object of this property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var parentObj:Object;

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  propertyName
		//----------------------------------

		/**
		 *  Storage for the propertyName property.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private var _propertyName:String;

		/**
		 *  The name of the property this Watcher is watching.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get propertyName():String
		{
			return _propertyName;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods: Watcher
		//
		//--------------------------------------------------------------------------

		/**
		 *  If the parent has changed we need to update ourselves
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override public function updateParent(parent:Object):void
		{
			if (parentObj && (parentObj is XML || parentObj is XMLList))
				XMLNotifier.getInstance().unwatchXML(parentObj, this);

			if (parent is Watcher)
				parentObj = parent.value;
			else
				parentObj = parent;

			if (parentObj && (parentObj is XML || parentObj is XMLList))
				XMLNotifier.getInstance().watchXML(parentObj, this);

			// Now get our property.
			wrapUpdate(updateProperty);
		}

		/**
		 *  @private
		 */
		override protected function shallowClone():Watcher
		{
			return new XMLWatcher(_propertyName, listeners);
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Gets the actual property then updates
		 *  the Watcher's children appropriately.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private function updateProperty():void
		{
			if (parentObj)
			{
				if (_propertyName == "this")
					value = parentObj;
				else
					value = parentObj[_propertyName];
			}
			else
			{
				value = null;
			}

			updateChildren();
		}

		/**
		 *  @private
		 */
		public function xmlNotification(currentTarget:Object, type:String,
			target:Object, value:Object, detail:Object):void
		{
			updateProperty();

			notifyListeners(true);
		}
	}

}