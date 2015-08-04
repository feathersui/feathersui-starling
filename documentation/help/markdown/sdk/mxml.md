---
title: The complete guide to MXML in the Feathers SDK  
author: Josh Tynjala

---
# The complete guide to MXML in the Feathers SDK

The [Feathers SDK](http://feathersui.com/sdk/) supports using MXML to declaratively layout user interfaces at compile time. MXML provides a number of features to reduce boilerplate ActionScript code and make user interface code more readable.

## Add children to containers

With only a quick glance at MXML code, we can easily recognize the relationship between a component and its parent container. Adding a child to a container is as simple as nesting an XML element inside another.

``` xml
<f:LayoutGroup>
    <f:Slider/>
</f:LayoutGroup>
```

## Set properties on components

A component's properties may be set in one of two ways. First, we can set properties using XML attributes:

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

## Include ActionScript code inside an MXML component

In the previous example, we listened for an event. Let's create the event listener function using ActionScript. We can add an `<fx:Script>` block to our MXML component to include ActionScript code:

``` xml
<fx:Script><![CDATA[

    private function button_triggeredHandler(event:Event):void
    {
        trace( "slider value changed!" );
    }

]]></fx:Script>
```

## Reference MXML components in ActionScript

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

## Create inline sub-components with `<fx:Component>`

When sub-components require a factory, we can define it in the MXML using `<fx:Component>` instead of writing the factory as a function in ActionScript code:

``` xml
<f:List>
    <f:itemRendererFactory>
        <fx:Component>
            <f:DefaultListItemRenderer labelField="text"/>
        </fx:Component>
    </f:itemRendererFactory>
    <f:dataProvider>
        <f:ListCollection>
            <fx:Object text="Milk"/>
            <fx:Object text="Eggs"/>
            <fx:Object text="Flour"/>
            <fx:Object text="Sugar"/>
        </f:ListCollection>
    </f:dataProvider>
</f:List>
```

In the MXML above, we create a `DefaultListItemRenderer` and set its `labelField` as an inline component.