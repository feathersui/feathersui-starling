---
title: The complete guide to MXML in the Feathers SDK  
author: Josh Tynjala

---
# The complete guide to MXML in the Feathers SDK

The [Feathers SDK](http://feathersui.com/sdk/) supports using MXML to declaratively layout user interfaces at compile time. MXML provides a number of features to reduce boilerplate ActionScript code and make user interface code more readable.

-   [Add children to containers](#add-children-to-containers)
-   [Set properties on objects](#set-properties-on-objects)
-   [Add event listeners](#add-event-listeners)
-   [Include ActionScript code inside an MXML class](#include-actionscript-code-inside-an-mxml-class)
-   [Reference MXML objects in ActionScript](#reference-mxml-objects-in-actionscript)
-   [Bind data to properties](#bind-data-to-properties)
-   [Built-in primitive types](#built-in-primitive-types)
-   [Define properties on an MXML class](#define-properties-on-an-mxml-class)
-   [Define metadata on an MXML class](#define-metadata-on-an-mxml-class)
-   [Define view states on an MXML class](#define-view-states-on-an-mxml-class)
-   [Create inline sub-component factories](#create-inline-sub-component-factories)

## Add children to containers

With only a quick glance at MXML code, we can easily recognize the relationship between a component and its parent container. Adding a child to a container is as simple as nesting an XML element inside another.

``` xml
<f:LayoutGroup>
    <f:Slider/>
</f:LayoutGroup>
```

## Set properties on objects

The properties of an object created in MXML may be set in one of two ways. First, we can set properties using XML attributes:

``` xml
<f:Slider minimum="0" maximum="100" value="10"/>
```

Simple types like `Number`, `int`, `uint`,  `String`, and `Boolean` can be set this way.

Alternatively, we can pass more complex values to a property by referencing it using a child XML element:

``` xml
<f:LayoutGroup>
    <f:layout>
        <f:HorizontalLayout padding="10"/>
    </f:layout>

    <f:Slider minimum="0" maximum="100" value="10"/>
</f:LayoutGroup>
```

Here, we create a new instance of `HorizontalLayout`, set one of its properties, and then we pass it to the `layout` property.

## Add event listeners

Similar to setting properties, we can listen for events by referencing the event type as an XML attribute:

``` xml
<f:Slider minimum="0" maximum="100" value="10"
    change="slider_changeHandler(event)"/>
```

We've added an event listener for `Event.CHANGE` to the `Slider`. In the next section, we'll learn how to write the ActionScript code for this event listener.

## Include ActionScript code inside an MXML class

In the previous example, we listened for an event. Let's create the event listener function using ActionScript. We can add an `<fx:Script>` block to our MXML component to include ActionScript code:

``` xml
<fx:Script><![CDATA[

    private function button_triggeredHandler(event:Event):void
    {
        trace( "slider value changed!" );
    }

]]></fx:Script>
```

## Reference MXML objects in ActionScript

If we want to access the `value` property of the `Slider` in our event listener, we can give the `Slider` an id.

``` xml
<f:Slider id="slider"
    minimum="0" maximum="100" value="10"
    change="slider_changeHandler(event)"/>
```

Now, we can reference the `Slider` that we created in MXML like a member variable on an ActionScript class:

``` code
private function button_triggeredHandler(event:Event):void
{
    trace( "slider value changed! " + this.slider.value );
}
```

## Bind data to properties

Data binding can save us time by skipping the boilerplate code for setting up event listeners and setting properties.

``` xml
<f:LayoutGroup>
    <f:layout>
        <f:HorizontalLayout/>
    </f:layout>

    <f:Slider id="slider" minimum="0" maximum="100" value="10"/>
    <f:Label text="{slider.value}"/>
</f:LayoutGroup>
```

Now, when the slider's `value` property changes, we display the value in a label.

## Built-in primitive types

A number of primitive data types that we use frequently in ActionScript may also be used to create objects in MXML. For instance, the `Number`, `int`, and `uint` classes may define numeric values.

``` xml
<fx:Number>32</fx:Number>
<fx:Number>123.45</fx:Number>
<fx:int>-650</fx:int>
<fx:uint>17925</fx:uint>
```

The `Boolean` class may be true or false:

``` xml
<fx:Boolean>true</fx:Boolean>
<fx:Boolean>false</fx:Boolean>
```

The `String` class represents text, including support for `<![CDATA[ ]>` to allow unescaped text:

``` xml
<fx:String>Hello World</fx:String>
<fx:String><![CDATA[Complex strings using <XML> & more!]]></fx:Boolean>
```

The `Object` class may define sets of key-value pairs using both attributes and child elements:

``` xml
<fx:Object numeric="35">
    <fx:text>
        <fx:String>Message for you, friend!</fx:String>
    </fx:text>
</fx:Object>
```

Additionally, `Array` objects can be populated by adding multiple children:

``` xml
<fx:Array>
    <fx:Number>1</fx:Number>
    <fx:Number>2</fx:Number>
    <fx:Number>3</fx:Number>
</fx:Array>
```

Similarly, the `Vector` class defines a typed array:

``` xml
<fx:Vector type="starling.display.DisplayObject">
    <fx:Button label="Back"/>
    <fx:Button label="Settings"/>
</fx:Vector>
```

## Define properties on an MXML class

An `<fx:Declarations>` element may be used in an MXML class to create MXML objects that aren't user interface components.

``` xml
<fx:Declarations>
    <fx:Array id="items">
        <fx:Object label="Bread"/>
        <fx:Object label="Eggs"/>
        <fx:Object label="Milk"/>
    </fx:Array>
</fx:Declarations>
```

Give the object an `id`, and it may be referenced in MXML for things like binding, and inside an ActionScript `<fx:Script>` element.

## Define metadata on an MXML class

Metadata may be added to an MXML class using a `<fx:Metadata>` element. For instance, you might define a component's with metadata:

``` xml
<fx:Metadata>
    [Event(name="change",type="starling.events.Event")]
</fx:Metadata>
```

## Define view states on an MXML class

An MXML component that is based on a container class, such as `LayoutGroup`, `ScrollContainer`, or `Panel`, may define multiple view states with overrides that change an aspect of the component's default state. For example, changing between states may modify properties or event listeners, or child components may be added or removed.

The `states` property may contain two or more `feathers.states.State` objects. The first state defines the default state when the component is instantiated.

``` xml
<f:states>
    <f:State name="default"/>
    <f:State name="submittedForm"/>
</f:states>
```

To switch between view states, set the `currentState` property to the name of the new state:

``` code
private function submitButton_onTriggered(event:Event):void
{
    this.currentState = "submittedForm";
}
```

The same property may be defined more than once in MXML by appending the name of the state where the value should be modified:

``` xml
<f:Button label="Submit" triggered="submitButton_onTriggered(event)"
    isEnabled="true" isEnabled.submittedForm="false"/>
```

In the example above, the button is enabled until the component enters the `"submittedForm"` state.

Event listeners may be modified when the view state changes:

``` xml
<f:Button label="Submit"
    triggered="submitButton_onTriggered(event)"
    triggered.submittedForm="showAlreadySubmittedError()"
```

A component may be added in a specific view state only using the `includeIn` attribute:

``` xml
<f:ProgressBar minimum="0" maximum="100" includeIn="submittedForm"/>
```

This progress bar will only be added to its parent in the `"submittedForm"` state, and it will be removed in all other view states.

Similarly, you may use the `excludeFrom` attribute to remove a component from its parent in a specific view state:

``` xml
<f:Label text="Don't forget to click Submit!" excludeFrom="submittedForm"/>
```

This label will be removed once the form is submitted, but it will be visible in all other view states.

### State Groups

Consider the following set of states that might allow you to customize a view based on different types of user accounts:

``` xml
<f:states>
    <f:State name="default"/>
    <f:State name="moderator"/>
    <f:State name="administrator"/>
</f:states>
```

Let's say that we want certain functionality to be enabled only for moderators and administrators, but disabled for everyone else. We could do it like this:

``` xml
<f:Check isEnabled="false" isEnabled.administrator="true" isEnabled.moderator="true"/>
```

However, we can also add both the "moderator" and "administrator" states to a *state group*:

``` xml
<f:states>
    <f:State name="default"/>
    <f:State name="moderator" stateGroups="privileged"/>
    <f:State name="administrator" stateGroups="privileged"/>
</f:states>
```

Using our new "privileged" state group, we can simply our code to make the same override apply to multiple states:

``` xml
<f:Check isEnabled="false" isEnabled.privileged="true"/>
```

## Create inline sub-component factories

When sub-components require a factory, we can define it in the MXML using `<fx:Component>` instead of writing the factory as a function in ActionScript code:

``` xml
<f:List>
    <f:itemRendererFactory>
        <fx:Component>
            <f:DefaultListItemRenderer labelField="text"/>
        </fx:Component>
    </f:itemRendererFactory>
    <f:dataProvider>
        <f:ArrayCollection>
            <fx:Object text="Milk"/>
            <fx:Object text="Eggs"/>
            <fx:Object text="Flour"/>
            <fx:Object text="Sugar"/>
        </f:ArrayCollection>
    </f:dataProvider>
</f:List>
```

In the MXML above, we create a `DefaultListItemRenderer` and set its `labelField` as an inline component.

### `<fx:Component>` versus `factoryFromInstance()`

When using `<fx:Component>`, we may need to call functions defined in the main `<fx:Script>` element in the MXML file. Because `<fx:Component>` is considered a different class, we need to use the implicit `outerDocument` property to access the main scope of the MXML file.

In the following example, we have a `PanelScreen` with a `Button` in its header. When the button is triggered, we want to call a function defined outside of the `<fx:Component>` element. This requires `outerDocument`:

``` xml
<f:PanelScreen xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:f="library://ns.feathersui.com/mxml">
    <f:headerFactory>
        <fx:Component>
            <f:Header>
                <f:leftItems>
                    <fx:Vector type="starling.display.DisplayObject">
                        <f:Button label="Back"
                            triggered="outerDocument.goBack()"/>
                    </fx:Vector>
                </f:leftItems>
            </f:Header>
        </fx:Component>
    </f:headerFactory>
    <fx:Script>
    <![CDATA[
        public function goBack():void
        {
            this.dispatchEventWith( Event.COMPLETE );
        }
    ]]>
    </fx:Script>
</f:PanelScreen>
```

When using `outerDocument`, we only have access to `public` APIs. Trying to call a `private` or `protected` function will result in an error.

Perhaps we'd prefer to make that `goBack()` function `private`. We can do that by using `factoryFromInstance()` instead of `<fx:Component>`.

``` xml
<f:PanelScreen xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:f="library://ns.feathersui.com/mxml"
    headerFactory="{factoryFromInstance(customHeader)}">
    <fx:Declarations>
        <f:Header id="customHeader">
            <f:leftItems>
                <fx:Vector type="starling.display.DisplayObject">
                    <f:Button label="Back"
                        triggered="goBack()"/>
                </fx:Vector>
            </f:leftItems>
        </f:Header>
    </fx:Declarations>
    <fx:Script>
    <![CDATA[
        private function goBack():void
        {
            this.dispatchEventWith( Event.COMPLETE );
        }
    ]]>
    </fx:Script>
</f:PanelScreen>
```

We can instantiate the `Header` component inside an `<fx:Declarations>` element. This will create the instance, but it will not be added to the display list. We give it an `id` so that it is assigned to a variable.

Then, when we set the `headerFactory` property, we pass `customHeader` to `factoryFromInstance()`, and it will automatically create a factory that returns the `Header` instance that we created in `<fx:Declarations>`.

Since the `Header` is defined inside the scope of our MXML file, we don't need to use `outerDocument`. We can call a `private` function directly.

<aside class="info">Passing a component to `factoryFromInstance()` only works when one instance is needed. In this case, a `PanelScreen` has only one header. If multiple instances are needed, such as how a `List` displays more than one item renderer, then `<fx:Component>` must be used.</aside>