---
title: Using MXML with Feathers  
author: Josh Tynjala

---
# Using MXML with Feathers

The Feathers SDK supports using MXML to declaratively layout user interfaces at compile time. With only a quick glance at MXML code, developers can easily recognize the relationship between a components and their parent containers. Adding a child to a container is as simple as nesting an XML element inside another.

Data binding saves developers time by skipping the boilerplate code for setting up event listeners.

## The Basics

Let's create an MXML class that extends the [`LayoutGroup`](../layout-group.html) component:

``` code
<f:LayoutGroup xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:f="library://ns.feathersui.com/mxml">
</f:LayoutGroup>
```

The Feathers namespace must be included in your MXML document to add Feathers components. This identifier for this namespace is `library://ns.feathersui.com/mxml`. To reference a Feathers component, you must use the `f:` prefix before the name of the class. We're using the `LayoutGroup` component, so the XML element should be `<f:LayoutGroup/>`.

Let's add a [`Button`](../button.html) as a child of the `LayoutGroup`:

``` code
<f:LayoutGroup xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:f="library://ns.feathersui.com/mxml">
 
    <f:Button label="Click Me"/>
</f:LayoutGroup>
```

It's as simple as adding a `<f:Button/>` element as a child of the `<f:LayoutGroup/>` element. As you can see, we've set the `label` property of the `Button` using an XML attribute.

Now, let's add an event listener to the button:

``` code
<f:Button label="Click Me" triggered="button_triggeredHandler(event)"/>
 
<fx:Script><![CDATA[
 
    private function button_triggeredHandler(event:Event):void
    {
    }
 
]]></fx:Script>
```

Similar to setting a property, we can add an event listener using an attribute with the string value of the event's type. The value of `Event.TRIGGERED` constant is `"triggered"`, so that's what we use in the MXML.

We need to define the listener in ActionScript. To add ActionScript code to an MXML class, we need to create a `<fx:Script/>` element. Inside this element, we can add properties and methods just like we would in an ActionScript class.

<aside class="info">Because ActionScript code may contain characters that are not valid XML, we must add `<![CDATA[` at the beginning of a script block and `]]>` at the end.</aside>

Let's adjust the layout a bit to put the button in the center of the screen:

``` code
<f:layout>
    <f:AnchorLayout/>
</f:layout>
 
<f:Button label="Click Me" triggered="button_triggeredHandler(event)">
    <f:layoutData>
        <f:AnchorLayoutData horizontalCenter="0" verticalCenter="0"/>
    </f:layoutData>
</f:Button>
```

Previously, we learned that there are two ways to set a property of a component. The first way to set a property was to add an attribute. We've set the `horizontalCenter` and `verticalCenter` properties on an `AnchorLayoutData` instance in the same way.

Sometimes, it may be easier to set properties by adding child element with the property's name (prefixed by the namespace). In the code above, we set the `layout` property of the `LayoutGroup` to an [`AnchorLayout`](../anchor-layout.html) instance, and we set the `layoutData` property of the `Button` to an `AnchorLayoutData` instance.