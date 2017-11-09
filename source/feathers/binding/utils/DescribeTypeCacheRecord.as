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
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;

	use namespace flash_proxy;

	[ExcludeClass]

	/**
	 *  @private
	 *  This class represents a single cache entry, this gets created
	 *  as part of the <code>describeType</code> method call on the
	 *  <code>DescribeTypeCache</code>  class.
	 */

	public dynamic class DescribeTypeCacheRecord extends Proxy
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		private var cache:Object = {};

		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  typeDescription
		//----------------------------------

		/**
		 *  @private
		 */
		public var typeDescription:XML;

		//----------------------------------
		//  typeName
		//----------------------------------

		/**
		 *  @private
		 */
		public var typeName:String;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		public function DescribeTypeCacheRecord()
		{
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 */
		override flash_proxy function getProperty(name:*):*
		{
			var result:* = cache[name];

			if (result === undefined)
			{
				result = DescribeTypeCache.extractValue(name, this);
				cache[name] = result;
			}

			return result;
		}

		/**
		 *  @private
		 */
		override flash_proxy function hasProperty(name:*):Boolean
		{
			if (name in cache)
				return true;

			var value:* = DescribeTypeCache.extractValue(name, this);

			if (value === undefined)
				return false;

			cache[name] = value;

			return true;
		}
	}
}
