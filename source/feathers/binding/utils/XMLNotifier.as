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
package feathers.binding.utils
{

	import flash.utils.Dictionary;

	import mx.core.mx_internal;

	use namespace mx_internal;

	[ExcludeClass]
	/**
	 *  @private
	 *  Used for watching changes to XML and XMLList objects.
	 *  Those objects are not EventDispatchers, so if multiple elements
	 *  want to watch for changes they need to go through this mechanism.
	 *  Call <code>watchXML()</code>, passing in the same notification
	 *  function that you would pass to XML.notification.
	 *  Use <code>unwatchXML()</code> to remove that notification.
	 *
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class XMLNotifier
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  XMLNotifier is a singleton.
		 */
		private static var instance:XMLNotifier;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Get the singleton instance of the XMLNotifier.
		 *
		 *  @return The XMLNotifier object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function getInstance():XMLNotifier
		{
			if (!instance)
				instance = new XMLNotifier(new XMLNotifierSingleton());

			return instance;
		}

		/**
		 *  @private
		 *  Decorates an XML node with a notification function
		 *  that can fan out to multiple targets.
		 */
		mx_internal static function initializeXMLForNotification():Function
		{
			var notificationFunction:Function = function(currentTarget:Object,
				ty:String,
				tar:Object,
				value:Object,
				detail:Object):void
			{
				var xmlWatchers:Dictionary = arguments.callee.watched;
				if (xmlWatchers != null)
				{
					for (var notifiable:Object in xmlWatchers)
					{
						IXMLNotifiable(notifiable).xmlNotification(currentTarget, ty, tar, value, detail);
					}
				}
			}

			return notificationFunction;
		}

		//--------------------------------------------------------------------------
		//
		// Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *
		 *  XMLNotifier is a singleton class, so you do not use
		 *  the <code>new</code> operator to create multiple instances of it.
		 *  Instead, call the static method <code>XMLNotifider.getInstance()</code>
		 *  to get the sole instance of this class.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function XMLNotifier(x:XMLNotifierSingleton)
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		// Methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Given an XML or XMLList, add the notification function
		 *  to watch for changes.
		 *
		 *  @param xml XML/XMLList object to watch.
		 *  @param notification Function that needs to be called.
		 *  @param optional UID for object
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function watchXML(xml:Object, notifiable:IXMLNotifiable, uid:String = null):void
		{
			if ((xml is XMLList) && xml.length() > 1)
			{
				for each(var item:Object in xml)
				{
					watchXML(item, notifiable, uid);
				}
			}
			else
			{
				// An XMLList object behaves like XML when it contains one
				// XML object.  Casting to an XML object is necessary to
				// access the notification() function.
				var xmlItem:XML = XML(xml);

				// First make sure the xml node has a notification function.
				var watcherFunction:Object = xmlItem.notification();

				if (!(watcherFunction is Function))
				{
					watcherFunction = initializeXMLForNotification();
					xmlItem.setNotification(watcherFunction as Function);
					if (uid && watcherFunction["uid"] == null)
						watcherFunction["uid"] = uid;
				}

				// Watch lists are maintained on the notification function.
				var xmlWatchers:Dictionary;
				if (watcherFunction["watched"] == undefined)
					watcherFunction["watched"] = xmlWatchers = new Dictionary(true);
				else
					xmlWatchers = watcherFunction["watched"];

				xmlWatchers[notifiable] = true;
			}
		}

		/**
		 *  Given an XML or XMLList, remove the specified notification function.
		 *
		 *  @param xml XML/XMLList object to un-watch.
		 *  @param notification Function notification function.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function unwatchXML(xml:Object, notifiable:IXMLNotifiable):void
		{
			if ((xml is XMLList) && xml.length() > 1)
			{
				for each(var item:Object in xml)
				{
					unwatchXML(item, notifiable);
				}
			}
			else
			{
				// An XMLList object behaves like XML when it contains one
				// XML object.  Casting to an XML object is necessary to
				// access the notification() function.
				var xmlItem:XML = XML(xml);

				var watcherFunction:Object = xmlItem.notification();

				if (!(watcherFunction is Function))
					return;

				var xmlWatchers:Dictionary;

				if (watcherFunction["watched"] != undefined)
				{
					xmlWatchers = watcherFunction["watched"];
					delete xmlWatchers[notifiable];
				}
			}
		}
	}

}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: XMLNotifierSingleton
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class XMLNotifierSingleton
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
	public function XMLNotifierSingleton()
	{
		super();
	}
}
