---
title: Feathers SDK Features  
author: Josh Tynjala

---
# Features of the Feathers SDK

The Feathers SDK is an open source SDK for developing applications with [Feathers](http://feathersui.com/) user interface components and [Starling Framework](http://gamua.com/starling/) with the ActionScript 3 and MXML languages.

## Overview

-   Open source under the terms of the Apache license, version 2.0.

-   Use MXML to layout user interfaces.

-   Compatible with IDEs that support the Flex SDK, including [Flash Builder](flash-builder.html) and [IntelliJ IDEA](intellij-idea.html).

-   Built on top of Feathers, Starling Framework, Apache Flex, Adobe AIR and Adobe Flash Player.

-   Funded by the community.

## MXML

-   Add children and describe layouts with intuitive XML nesting.

	``` xml
	<f:LayoutGroup>
		<f:layout>
			<f:HorizontalLayout/>
		</f:layout>

		<f:Slider/>
		<f:Label/>
	</f:LayoutGroup>
	```

-   Set properties and listen to events as XML attributes.

	``` xml
	<f:Slider minimum="0" maximum="100" change="slider_changeHandler(event)"/>
	```

-   Reference MXML components in embedded ActionScript by giving them an ID.
	``` xml
	<f:Slider id="slider" change="slider_changeHandler(event)"/>
	<fx:Script><![CDATA[

		private function slider_changeHandler(event:Event):void
		{
			trace( slider.value );
		}

	]]></fx:Script>
	```

-   Bind components to properties with simple curly brace syntax.

	``` xml
	<f:Slider id="slider"/>
	<f:Label text="{slider.value}"/>
	```