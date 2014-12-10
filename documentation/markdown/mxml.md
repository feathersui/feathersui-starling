# Feathers MXML Support

Feathers has partial support for MXML, with some limitations. You can instantiate components, containers, layouts, and collections in XML. You can also listen for events. However, binding and setting a component's id are not supported with Feathers in MXML due to incompatibilities between the native `EventDispatcher` and the Starling Framework `EventDispatcher`.

MXML is not supported in the official Feathers builds because they are built with ASC 2.0, which doesn't compile MXML. However, if you build with the Flex SDK, you can include MXML support. See [Feathers issue \#186 on Github](https://github.com/joshtynjala/feathers/issues/186) for instructions about how to use the Feathers build script to compile your own custom Feathers SWC that includes MXML support.

The Feathers MXML namespace is `library://ns.feathersui.com/mxml`.

Let's create an MXML document for a `PanelScreen`:

``` code
<feathers:PanelScreen xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:feathers="library://ns.feathersui.com/mxml">
</feathers:PanelScreen>
```

Just like with Flex, you can add children as child elements of a container in the MXML. For instance, you might add a `Button`:

``` code
<feathers:PanelScreen xmlns:fx="http://ns.adobe.com/mxml/2009"
    xmlns:feathers="library://ns.feathersui.com/mxml">
 
    <feathers:Button label="Click Me"/>
</feathers:PanelScreen>
```

Let's add an event listener to the button:

``` code
<feathers:Button label="Click Me" triggered="button_triggeredHandler(event)"/>
 
<fx:Script><![CDATA[
 
    import starling.events.Event;
 
    private function button_triggeredHandler(event:starling.events.Event):void
    {
    }
 
]]></fx:Script>
```

Notice that we need to use the fully qualified class name `starling.events.Event` due to the fact that MXML implicitly imports `flash.events.Event`.

Let's adjust the layout a bit to put the button in the center of the screen:

``` code
<feathers:layout>
    <feathers:AnchorLayout/>
</feathers:layout>
 
<feathers:Button label="Click Me" triggered="button_triggeredHandler(event)">
    <feathers:layoutData>
        <feathers:AnchorLayoutData horizontalCenter="0" verticalCenter="0"/>
    </feathers:layoutData>
</feathers:Button>
```

That's the basics. For more detailed sample code, take a look at the [MXML Example on Github](https://github.com/joshtynjala/feathers/blob/master/examples/MXML).

For more tutorials, return to the [Feathers Documentation](index.html).


