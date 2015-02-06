/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.events
{
	/**
	 * Data about the changed property passed with an event used by the data
	 * binding mechanism.
	 */
	public class PropertyChangeEventData
	{
		public static const KIND_UPDATE:String = "update";
		public static const KIND_DELETE:String = "delete";
		
		/**
		 * Constructor.
		 */
		public function PropertyChangeEventData(kind:String = KIND_UPDATE,
			property:Object = null, newValue:Object = null, oldValue:Object = null, source:Object = null)
		{
			this.kind = kind;
			this.property = property;
			this.newValue = newValue;
			this.oldValue = oldValue;
			this.source = source;
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
	}
}