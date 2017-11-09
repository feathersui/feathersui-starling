/*
Feathers SDK
Copyright 2012-2017 Bowler Hat LLC

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
package feathers.core
{
	/**
	 *  The ContainerCreationPolicy class defines the constant values
	 *  for the <code>creationPolicy</code> property of the Container class.
	 *
	 *  @see mx.core.Container#creationPolicy
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public final class ContainerCreationPolicy
	{
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		/**
		 *  Delay creating some or all descendants until they are needed.
		 *
		 *  <p>For example, if a navigator container such as a TabNavigator
		 *  has this <code>creationPolicy</code>, it will immediately create
		 *  all of its children, plus the descendants of the initially
		 *  selected child.
		 *  However, it will wait to create the descendants of the other children
		 *  until the user navigates to them.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const AUTO:String = "auto";
		
		/**
		 *  Immediately create all descendants.
		 *
		 *  <p>Avoid using this <code>creationPolicy</code> because
		 *  it increases the startup time of your application.
		 *  There is usually no good reason to create components at startup
		 *  which the user cannot see.
		 *  If you are using this policy so that you can "push" data into
		 *  hidden components at startup, you should instead design your
		 *  application so that the data is stored in data variables
		 *  and components which are created later "pull" in this data,
		 *  via databinding or an <code>initialize</code> handler.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const ALL:String = "all";
		
		/**
		 *  Add the container to a creation queue.
		 *  Deprecated since Flex 4.0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const QUEUED:String = "queued";
		
		/**
		 *  Do not create any children.
		 *
		 *  <p>With this <code>creationPolicy</code>, it is the developer's
		 *  responsibility to programmatically create the children 
		 *  from the UIComponentDescriptors by calling
		 *  <code>createComponentsFromDescriptors()</code>
		 *  on the parent container.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public static const NONE:String = "none";
	}
}