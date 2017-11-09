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
    /**
     *  The BindingUtils class defines utility methods
     *  for performing data binding from ActionScript.
     *  You can use the methods defined in this class to configure data bindings.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class BindingUtils
    {
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         *  Binds a public property, <code>prop</code> on the <code>site</code>
         *  Object, to a bindable property or property chain.
         *  If a ChangeWatcher instance is successfully created, <code>prop</code>
         *  is initialized to the current value of <code>chain</code>.
         *
         *  @param site The Object defining the property to be bound
         *  to <code>chain</code>.
         *
         *  @param prop The name of the public property defined in the
         *  <code>site</code> Object to be bound.
         *  The property will receive the current value of <code>chain</code>,
         *  when the value of <code>chain</code> changes.
         *
         *  @param host The object that hosts the property or property chain
         *  to be watched.
         *  The <code>host</code> maintains a list of <code>sites</code> to update
         *  when <code>prop</code> changes.
         *
         *  @param chain A value specifying the property or chain to be watched.
         *  Legal values are:
         *  <ul>
         *    <li>String containing the name of a public bindable property
         *    of the host object.</li>
         *
         *    <li>An Object in the form:
         *    <code>{ name: <i>property name</i>, getter: function(host) { return host[<i>property name</i>] } }</code>.
         *    This Object must contain the name of, and a getter function for,
         *    a public bindable property of the host object.</li>
         *
         *    <li>A non-empty Array containing a combination of the first two
         *    options that represents a chain of bindable properties accessible
         *    from the host.
         *    For example, to bind the property <code>host.a.b.c</code>,
         *    call the method as:
         *    <code>bindProperty(site, prop, host, ["a","b","c"])</code>.</li>
         *  </ul>
         *
         *  <p>Note: The property or properties named in the <code>chain</code> argument
         *  must be public, because the <code>describeType()</code> method suppresses all information
         *  about non-public properties, including the bindability metadata
         *  that ChangeWatcher scans to find the change events that are exposed
         *  for a given property.
         *  However, the getter function supplied when using the <code>{ name, getter }</code>
         *  argument form described above can be used to associate an arbitrary
         *  computed value with the named (public) property.</p>
         *
         *  @param commitOnly Set to <code>true</code> if the handler
         *  should be called only on committing change events;
         *  set to <code>false</code> if the handler should be called
         *  on both committing and non-committing change events.
         *  Note: the presence of non-committing change events for a property
         *  is indicated by the <code>[NonCommittingChangeEvent(&lt;event-name&gt;)]</code>
         *  metadata tag.
         *  Typically these tags are used to indicate fine-grained value changes,
         *  such as modifications in a text field prior to confirmation.
         *
         *  @param useWeakReference Determines whether the reference to <code>site</code>
         *  is strong or weak.
         *  A strong reference (the default) prevents <code>site</code> from being garbage-collected.
         *  A weak reference does not.
         *  Can be used with <code>flash.events.IEventDispatcher</code>, but is ignored when binding to <code>starling.events.EventDispatcher</code>.
         *
         *  @return A ChangeWatcher instance, if at least one property name has
         *  been specified to the <code>chain</code> argument; null otherwise.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function bindProperty(
            site:Object, prop:String,
            host:Object, chain:Object,
            commitOnly:Boolean = false,
            useWeakReference:Boolean = false):ChangeWatcher
        {
            var w:ChangeWatcher =
                ChangeWatcher.watch(host, chain, null, commitOnly, useWeakReference);

            if (w != null)
            {
                var assign:Function = function(event:*):void
                {
                    site[prop] = w.getValue();
                };
                w.setHandler(assign);
                assign(null);
            }

            return w;
        }

        /**
         *  Binds a setter function, <code>setter</code>, to a bindable property
         *  or property chain.
         *  If a ChangeWatcher instance is successfully created,
         *  the setter function is invoked.
         *  The setter must have the following function signature:
         *
         *  <pre>
         *  function mySetterFunction(object:Object):void {
		 *      //Do whatever you want with the value of the bound property.
		 *  }</pre>
         *
         *  <p>where <code>object</code> contains the
         *  current value of <code>chain</code>.</p>
         *
         *  @param setter Setter method to invoke with an argument of the current
         *  value of <code>chain</code> when that value changes.
         *
         *  @param host The host of the property.
         *  See the <code>bindProperty()</code> method for more information.
         *  The <code>host</code> maintains a list of <code>setters</code> to update
         *  when <code>prop</code> changes.
         *
         *  @param name The name of the property, or property chain.
         *  See the <code>bindProperty()</code> method for more information.
         *
         *  @param commitOnly Set to <code>true</code> if the handler should be
         *  called only on committing change events.
         *  See the <code>bindProperty()</code> method for more information.
         *
         *  @param useWeakReference Determines whether the reference to <code>setter</code>
         *  is strong or weak.
         *  A strong reference (the default) prevents <code>setter</code> from being garbage-collected.
         *  A weak reference does not.
         *  Added for Flex 4.
         *
         *  @return A ChangeWatcher instance, if at least one property name
         *  has been  specified to the <code>chain</code> argument; null otherwise.
         *
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function bindSetter(setter:Function, host:Object,
            chain:Object,
            commitOnly:Boolean = false,
            useWeakReference:Boolean = false):ChangeWatcher
        {
            var w:ChangeWatcher =
                ChangeWatcher.watch(host, chain, null, commitOnly, useWeakReference);

            if (w != null)
            {
                var invoke:Function = function(event:*):void
                {
                    setter(w.getValue());
                };
                w.setHandler(invoke);
                invoke(null);
            }

            return w;
        }
    }

}
