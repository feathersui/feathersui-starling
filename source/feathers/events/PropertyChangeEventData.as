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
package feathers.events
{
	/**
	 * Data about the changed property passed with an event used by the data
	 * binding mechanism.
	 */
	public class PropertyChangeEventData
	{
		/**
		 * The value of a property has been updated.
		 */
		public static const KIND_UPDATE:String = "update";

		/**
		 * A property has been deleted.
		 */
		public static const KIND_DELETE:String = "delete";

		/**
		 * @private
		 */
		private static const POOL:Vector.<PropertyChangeEventData> = new <PropertyChangeEventData>[];

		/**
		 * @private
		 */
		public static function fromPool(kind:String, property:Object,
			newValue:Object, oldValue:Object, source:Object):PropertyChangeEventData
		{
			if(POOL.length > 0)
			{
				return POOL.pop().reset(kind, property, newValue, oldValue, source);
			}
			return new PropertyChangeEventData(kind, property, newValue, oldValue, source);
		}

		/**
		 * @private
		 */
		public static function toPool(data:PropertyChangeEventData):void
		{
			data.newValue = null;
			data.oldValue = null;
			data.source = null;
			data.kind = null;
			data.property = null;
			POOL[POOL.length] = data;
		}

		/**
		 * Constructor.
		 */
		public function PropertyChangeEventData(kind:String = KIND_UPDATE,
			property:Object = null, newValue:Object = null, oldValue:Object = null, source:Object = null)
		{
			this.reset(kind, property, newValue, oldValue, source);
		}

		/**
		 * Specifies the kind of change.
		 */
		public var kind:String;

		/**
		 * A <code>String</code>, <code>QName</code>, or <code>int</code> specifying the property that changed.
		 */
		public var property:Object;

		/**
		 * The value of the property after the change.
		 */
		public var newValue:Object;

		/**
		 * The value of the property before the change.
		 */
		public var oldValue:Object;

		/**
		 * The object that the change occured on.
		 */
		public var source:Object;

		/**
		 * @private
		 */
		public function reset(kind:String, property:Object,
			newValue:Object, oldValue:Object, source:Object):PropertyChangeEventData
		{
			this.kind = kind;
			this.property = property;
			this.newValue = newValue;
			this.oldValue = oldValue;
			this.source = source;
			return this;
		}
	}
}