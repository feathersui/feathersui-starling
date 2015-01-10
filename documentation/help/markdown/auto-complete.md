---
title: How to use the Feathers AutoComplete component  
author: Josh Tynjala

---
# How to use the Feathers `AutoComplete` component

The [`AutoComplete`](../api-reference/feathers/controls/AutoComplete.html) class extends the [`TextInput`](text-input.html) component to add a pop-up list of suggestions as you type.

## The Basics

First, let's create a `AutoComplete` control and add it to the display list:

``` code
var input:AutoComplete = new AutoComplete();
this.addChild( input );
```

At this point, the `AutoComplete` will behave like a normal [`TextInput`](text-input.html) without suggestions. All properties available to a `TextInput` (like [`maxChars`](../api-reference/feathers/controls/TextInput.html#maxChars) or [`prompt`](../api-reference/feathers/controls/TextInput.html#prompt), for example) may be used with an `AutoComplete` too.

## Providing suggestions for completion

An [`IAutoCompleteSource`](../api-reference/feathers/data/IAutoCompleteSource.html) implementation should be passed to the [`source`](../api-reference/feathers/controls/AutoComplete.html#source) property to display suggestions for completion. Let's look at a couple of the classes that we can use to provide these suggestions.

### `LocalAutoCompleteSource`

The simplest option involves passing a [`ListCollection`](../api-reference/feathers/data/ListCollection.html) to [`LocalAutoCompleteSource`](../api-reference/feathers/data/LocalAutoCompleteSource.html). As the user types, the collection will be filtered to display appropriate suggestions. 

``` code
input.source = new LocalAutoCompleteSource( new ListCollection(new <String>
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

In some cases, you may want to request suggestions from a server instead.

## Customizing suggestion behavior

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

An `AutoComplete` provides a number of properties to customize its appearance. For full details about what skin and style properties are available, see the [`AutoComplete` API reference](../api-reference/feathers/controls/AutoComplete.html).

As mentioned above, `AutoComplete` is a subclass of `TextInput`. For more detailed information about the skinning options available to `AutoComplete`, see [How to use the Feathers `TextInput` component](text-input.html).

### Targeting an `AutoComplete` in a theme

If you are creating a [theme](themes.html), you can set a function for the default styles like this:

``` code
getStyleProviderForClass( AutoComplete ).defaultStyleFunction = setAutoCompleteStyles;
```

If you want to customize a specific `AutoComplete` to look different than the default, you may use a custom style name to call a different function:

``` code
input.styleNameList.add( "custom-auto-complete" );
```

You can set the function for the custom style name like this:

``` code
getStyleProviderForClass( AutoComplete )
    .setFunctionForStyleName( "custom-auto-complete", setCustomAutoCompleteStyles );
```

Trying to change the auto complete's styles and skins outside of the theme may result in the theme overriding the properties, if you set them before the `AutoComplete` was added to the stage and initialized. Learn to [extend an existing theme](extending-themes.html) to add custom skins.

If you aren't using a theme, then you may set any of the auto complete's properties directly.

## Related Links

-   [`feathers.controls.AutoComplete` API Documentation](../api-reference/feathers/controls/AutoComplete.html)

-   [How to Use the Feathers `TextInput` Component](text-input.html)

For more tutorials, return to the [Feathers Documentation](index.html).


