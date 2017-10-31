---
title: Feathers SDK Features  
author: Josh Tynjala

---
# Features of the Feathers SDK

The [Feathers SDK](http://feathersui.com/sdk/) offers everything you need to build [Feathers](http://feathersui.com/) applications using MXML and ActionScript 3, including compilers and user interface components, in one open source package.

## Overview

-   Use [MXML](mxml.html) instead of ActionScript to create user interfaces and layouts faster with Feathers components.

-   Compatible with popular IDEs, including [Adobe Flash Builder](flash-builder.html), [IntelliJ IDEA](intellij-idea.html), and [Visual Studio Code](https://github.com/BowlerHatLLC/vscode-nextgenas/wiki/Create-a-new-ActionScript-project-in-Visual-Studio-Code-that-targets-the-Feathers-SDK).

-   Built on top of [Feathers](http://feathersui.com/), [Starling Framework](http://gamua.com/starling), and a fork of the [Apache Flex SDK](http://flex.apache.org/). Targets Adobe AIR and Flash Player.

-   Open source under the terms of the [Apache license, version 2.0](http://www.apache.org/licenses/LICENSE-2.0).

-   Funded by the community. Special thanks to [YETi CGI](http://yeticgi.com/).

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
			trace("slider value changed! " + this.slider.value);
		}

	]]></fx:Script>
	```

-   Bind components to properties with simple curly brace syntax.

	``` xml
	<f:Slider id="slider"/>
	<f:Label text="{slider.value}"/>
	```