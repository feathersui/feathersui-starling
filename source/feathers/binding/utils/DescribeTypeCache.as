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
	import feathers.binding.*;

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]

	/**
	 *  @private
	 *  DescribeTypeCache is a convenience class that is used to
	 *  cache the return values of <code>flash.utils.describeType()</code>
	 *  so that calls made subsequent times return faster.
	 *
	 *  This class also lets you set handler functions for specific value types.
	 *  These will get called when the user tries to access these values on
	 *  the <code>DescribeTypeCacheRecord</code> class.
	 *
	 *  @see mx.utils.DescribeTypeCacheRecord
	 */
	public class DescribeTypeCache
	{
		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------

		registerCacheHandler("bindabilityInfo", bindabilityInfoHandler);

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private static var typeCache:Object = {};

		/**
		 *  @private
		 */
		private static var cacheHandlers:Object = {};

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Calls <code>flash.utils.describeType()</code> for the first time and caches
		 *  the return value so that subsequent calls return faster.
		 *
		 *  @param o Can be either a string describing a fully qualified class name or any
		 *  ActionScript value, including all available ActionScript types, object instances,
		 *  primitive types (such as <code>uint</code>), and class objects.
		 *
		 *  @return Returns the cached record.
		 *
		 *  @see flash.utils#describeType()
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function describeType(o:*):DescribeTypeCacheRecord
		{
			var className:String;
			var cacheKey:String;

			if (o is String)
				cacheKey = className = o;
			else
				cacheKey = className = getQualifiedClassName(o);

			//Need separate entries for describeType(Foo) and describeType(myFoo)
			if (o is Class)
				cacheKey += "$";

			if (cacheKey in typeCache)
			{
				return typeCache[cacheKey];
			}
			else
			{
				if (o is String)
				{
					try
					{
						o = getDefinitionByName(o);
					}
					catch (error:ReferenceError)
					{
						// The o parameter doesn't refer to an ActionScript 
						// definition, it's just a string value.
					}
				}
				var typeDescription:XML = flash.utils.describeType(o);
				var record:DescribeTypeCacheRecord = new DescribeTypeCacheRecord();
				record.typeDescription = typeDescription;
				record.typeName = className;
				typeCache[cacheKey] = record;

				return record;
			}
		}

		/**
		 *  registerCacheHandler lets you add function handler for specific strings.
		 *  These functions get called when the user refers to these values on a
		 *  instance of <code>DescribeTypeCacheRecord</code>.
		 *
		 *  @param valueName String that specifies the value for which the handler must be set.
		 *  @param handler Function that should be called when user references valueName.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static function registerCacheHandler(valueName:String, handler:Function):void
		{
			cacheHandlers[valueName] = handler;
		}

		/**
		 *  @private
		 */
		internal static function extractValue(valueName:String, record:DescribeTypeCacheRecord):*
		{
			if (valueName in cacheHandlers)
				return cacheHandlers[valueName](record);

			return undefined;
		}

		/**
		 *  @private
		 */
		private static function bindabilityInfoHandler(record:DescribeTypeCacheRecord):*
		{
			return new BindabilityInfo(record.typeDescription);
		}
	}
}
