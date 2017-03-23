---
title: How to use the Feathers AutoComplete component  
author: Josh Tynjala

---
# How to use the Feathers `AutoComplete` component

The [`AutoComplete`](../api-reference/feathers/controls/AutoComplete.html) class extends the [`TextInput`](text-input.html) component to add a pop-up list of suggestions as you type.

<figure>
<img src="images/auto-complete.png" srcset="images/auto-complete@2x.png 2x" alt="Screenshot of Feathers a AutoComplete component" />
<figcaption>A `AutoComplete` component skinned with `MetalWorksMobileTheme`</figcaption>
</figure>

-   [The Basics](#the-basics)

-   [Provide completion suggestions](#provide-completion-suggestions)

-   [Customize suggestion behavior](#customize-suggestion-behavior)

-   [Skinning an `AutoComplete`](#skinning-an-autocomplete)

## The Basics

First, let's create an `AutoComplete` control and add it to the display list:

``` code
var input:AutoComplete = new AutoComplete();
this.addChild( input );
```

At this point, the `AutoComplete` will behave like a normal [`TextInput`](text-input.html) without suggestions. All properties available to a `TextInput` (like [`maxChars`](../api-reference/feathers/controls/TextInput.html#maxChars) or [`prompt`](../api-reference/feathers/controls/TextInput.html#prompt), for example) may be used with an `AutoComplete` too.

## Provide completion suggestions

An [`IAutoCompleteSource`](../api-reference/feathers/data/IAutoCompleteSource.html) implementation should be passed to the [`source`](../api-reference/feathers/controls/AutoComplete.html#source) property to display suggestions for completion. Let's look at a couple of the classes that we can use to provide these suggestions.

### `LocalAutoCompleteSource`

The simplest option involves passing a collection, such as [`VectorCollection`](../api-reference/feathers/data/VectorCollection.html), to [`LocalAutoCompleteSource`](../api-reference/feathers/data/LocalAutoCompleteSource.html). As the user types, the collection will be filtered to display appropriate suggestions. 

``` code
input.source = new LocalAutoCompleteSource( new VectorCollection(new <String>
[
	"Apple",
	"Banana",
	"Cherry",
	"Grape",
	"Lemon",
	"Orange",
	"Watermelon"
]));
```

When one types "ap" into the `AutoComplete`, the list of suggestions will include "Apple" and "Grape". By default, `LocalAutoCompleteSource` converts each item to lowercase, and it returns any item that contains the entered text. The entered text may be in the middle of an item, as we see when "ap" matches "Grape".

If the default behavior doesn't quite fit our needs, we can use a custom [`compareFunction`](../api-reference/feathers/data/LocalAutoCompleteSource.html#compareFunction) to handle the filtering. In the following example, we create a `compareFunction` where the entered text must be at the very beginning of the suggestion:

``` code
var source:LocalAutoCompleteSource = new LocalAutoCompleteSource();
source.compareFunction = function( item:Object, textToMatch:String ):Boolean
{
	return item.toString().toLowerCase().indexOf(textToMatch.toLowerCase()) == 0;
};
```

In this case, if one types "ap" using the same data provider as in the previous example, only "Apple" will be suggested. "Grape" will not be suggested because "ap" appears in the middle of the word instead of the beginning.

As you can see above, the first argument to the `compareFunction` is typed as `Object`, meaning that suggestions don't necessarily need to be strings.

<aside class="info">When using objects that aren't strings for suggestions, we must provide an implementation of the [`toString()`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/Object.html#toString()) function so that each suggestion can be converted to a string that the text input can display.</aside>

### `URLAutoCompleteSource`

In some cases, you may want to request personalized suggestions from a server instead. We can pass the text entered by the user to a backend API using [`URLAutoCompleteSource`](../api-reference/feathers/data/URLAutoCompleteSource.html).

To load suggestions from the web, we need a URL. The [`urlRequestFunction`](../api-reference/feathers/data/URLAutoCompleteSource.html#urlRequestFunction) property can be used to generate a [`URLRequest`](http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/net/URLRequest.html):

``` code
var source:URLAutoCompleteSource = new URLAutoCompleteSource();
source.urlRequestFunction = function( textToMatch:String ):URLRequest
{
	var request:URLRequest = new URLRequest( "http://example.com/search_suggestions" );
	var variables:URLVariables = new URLVariables();
	variables.query = textToMatch;
	request.data = variables;
	return request;
};
input.source = source;
```

The `urlRequestFunction` takes one argument, the text entered into the `AutoComplete`. We can pass that to the server to return relevant suggestions.

By default, `URLAutoCompleteSource` parses the result as a JSON array. If the result returned by the API looks similar to the example below, it can be parsed automatically:

``` code
[
	"adobe",
	"adobe flash",
	"adobe reader",
	"adobe creative cloud"
]
```

However, if the API returns data in a different format, we can use the [`parseResultFunction`](../api-reference/feathers/data/URLAutoCompleteSource.html#parseResultFunction) property to tell the `URLAutoCompleteSource` how to convert the result into something that the pop-up list of suggestions can display.

Let's create a `parseResultFunction` for some XML in the following format:

``` code
<search>
	<suggestion>adobe</suggestion>
	<suggestion>adobe flash</suggestion>
	<suggestion>adobe reader</suggestion>
	<suggestion>adobe creative cloud</suggestion>
</search>
```

In the custom `parseResultFunction` below, we loop through each `<suggestion>` element in the result and extract the string. We'll return an `Array` of these strings:

``` code
source.parseResultFunction = function( result:String ):Object
{
	var parsedSuggestions:Array = [];
	var xmlResult:XML = new XML( result );
	var resultCount:int = xmlResult.suggestion.length();
	for( var i:int = 0; i < resultCount; i++ )
	{
		var suggestion:XML = xmlResult.suggestion[i];
		parsedSuggestions.push( suggestion.toString() );
	}
	return parsedSuggestions;
};
```

The `parseResultFunction` may return an [`IListCollection`](../api-reference/feathers/data/IListCollection.html) implementation, such as an [`ArrayCollection`](../api-reference/feathers/data/ArrayCollection.html) or a [`VectorCollection`](../api-reference/feathers/data/VectorCollection.html).

## Customize suggestion behavior

The [`minimumAutoCompleteLength`](../api-reference/feathers/controls/AutoComplete.html#minimumAutoCompleteLength) property determines how many characters must be entered into the input before displaying suggestions:

``` code
input.minimumAutoCompleteLength = 3;
```

By default, the input will not make suggestions until at least `2` characters have been typed.

The [`autoCompleteDelay`](../api-reference/feathers/controls/AutoComplete.html#autoCompleteDelay) property determines how long to wait after the text in the input has been edited before updating the suggestions:

``` code
input.autoCompleteDelay = 0.25;
```

This value is measured in seconds, and the default value is `0.5`.

## Skinning an `AutoComplete`

As mentioned above, `AutoComplete` is a subclass of `TextInput`. For more detailed information about skins and font styles available to `AutoComplete`, see [How to use the Feathers `TextInput` component](text-input.html). All styling properties are inherited by the `AutoComplete` class.

### Skinning the pop-up list

This section only explains how to access the pop-up list sub-component. Please read [How to use the Feathers `List` component](list.html) for full details about the skinning properties that are available on `List` components.

#### With a Theme

If you're creating a [theme](themes.html), you can target the [`AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST`](../api-reference/feathers/controls/AutoComplete.html#DEFAULT_CHILD_STYLE_NAME_LIST) style name.

``` code
getStyleProviderForClass( List )
	.setFunctionForStyleName( AutoComplete.DEFAULT_CHILD_STYLE_NAME_LIST, setAutoCompleteListStyles );
```

The styling function might look like this:

``` code
private function setAutoCompleteListStyles( list:List ):void
{
	list.backgroundSkin = new Image( listBackgroundTexture );
}
```

You can override the default style name to use a different one in your theme, if you prefer:

``` code
input.customListStyleName = "custom-list";
```

You can set the styling function for the [`customListStyleName`](../api-reference/feathers/controls/AutoComplete.html#customListStyleName) like this:

``` code
getStyleProviderForClass( List )
	.setFunctionForStyleName( "custom-list", setAutoCompleteCustomListStyles );
```

#### Without a Theme

If you are not using a theme, you can use [`listFactory`](../api-reference/feathers/controls/AutoComplete.html#listFactory) to provide skins for the pop-up list

``` code
input.listFactory = function():List
{
	var list:List = new List();

	//skin the list here, if you're not using a theme
	list.backgroundSkin = new Image( listBackgroundTexture );

	return list;
}
```

## Related Links

-   [`feathers.controls.AutoComplete` API Documentation](../api-reference/feathers/controls/AutoComplete.html)

-   [How to Use the Feathers `TextInput` Component](text-input.html)