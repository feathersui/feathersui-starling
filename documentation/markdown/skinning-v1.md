# Skinning Feathers 1.0 Components Without a Theme

[Feathers themes](themes.html) are highly recommended for the convenience that they provide. A theme class can keep all of your project's skinning code in one place. A theme can automatically skin any component added to the display list, including providing separate skins for different variations of the same type of component. However, not all Feathers developers will want to use themes, and Feathers provides APIs to skin all components and their sub-components without using a monolithic theme class.

See the documentation for the [individual Feathers components](index.html#feathers_components) for complete details on how that specific component may be skinned. Below, we'll outline skinning idioms that are common to all Feathers components.

## Sub-Component Factories

Sub-components may be skinned using a *factory*. This is a function that is called when a component needs to create one of its sub-components. It receives no arguments and returns an instance of the sub-component. Below, we see a factory for a `Slider` component's thumb sub-component:

``` code
slider.thumbFactory = function():Button
{
    var thumb:Button = new Button();
    thumb.defaultSkin = new Scale9Image( upTextures );
    thumb.downSkin = new Scale9Image( downTextures );
    return thumb;
};
```

As you can see, this function creates a new `Button` instance and provides it with some skins before returning it.

### Sub-Components with Sub-Components

If a sub-component is complex enough to have sub-components of its own, you can provide separate factories for those as well. Simply pass a reference to a function. In the example below, we'll skin the scroll bar on a `List` component:

``` code
function simpleScrollBarThumbFactory():Button
{
    var thumb:Button = new Button();
    thumb.defaultSkin = new Scale3Image( thumbTextures );
    return thumb;
}
 
function simpleScrollBarFactory():SimpleScrollBar
{
    var scrollBar:SimpleScrollBar = new SimpleScrollBar();
    scrollBar.thumbFactory = simpleScrollBarThumbFactory;
    return scrollBar;
}
 
list.verticalScrollBarFactory = simpleScrollBarFactory;
```

If you prefer you could use closures to place the entire body of `simpleScrollBarThumbFactory` inside `simpleScrollBarFactory`. However, many levels of factory nesting may make your code more difficult to read, so it's not recommended, in most cases.

### Multiple Factories

Does your component already have a factory for skinning, and you want to set additional properties on the sub-component? It's easy to reuse the existing factory in your new factory. Below, we've already skinned a `Panel` component's header in a factory, but we also want to set its title:

``` code
var headerWithSkinsFactory:Function = panel.headerFactory;
panel.headerFactory = function():Button
{
    var header:Header = headerWithSkinsFactory();
    header.title = "Tools";
    return header;
};
```

You could certainly provide all of the code for skinning and setting other properties in a single factory. However, if you would like to make your skinning code reusable across many `Header` components that may have different titles (or different `leftItems` or `rightItems`, for that matter), this approach is essential.

## Sub-Component Properties

Instead of using factories to change properties, you can pass those properties into the parent component, which will set them on its child when it redraws. This is slightly worse for performance, so factories are recommended in most cases. However, this can be useful for adjusting properties and skins long after a sub-component has been created.

Reusing the slider example from the beginning, we'll pass in the skins without a factory:

``` code
slider.thumbProperties.defaultSkin = new Scale9Image( upTextures );
slider.thumbProperties.downSkin = new Scale9Image( downTextures );
```

Passing in properties this way will **not** set them directly on the sub-component right away. They will be passed on before the next frame is rendered. In general, you should not use this method to *get* the value of a property. You should only use it to *set* the value of a property. The `thumbProperties` object does not know anything about the actual `Button` instance that it's storing data for. The following code will result in an error, unless you've actually set `isSelected` yourself:

``` code
var isSelected:Boolean = slider.thumbProperties.isSelected;
```

### Nesting Sub-Component Properties

You can nest sub-component properties objects too. It's a little messy, though. In general, it's better to provide factories, but the option is here, if needed.

Let's use the scroll bar skinning example again, but this time use sub-component properties instead of factories::

``` code
list.verticalScrollBarProperties.@thumbProperties.defaultSkin = new Scale3Image( thumbTextures );
```

Notice the use of the *attribute* operator (`@`) here. The attribute operator tells the system to create a sub-component properties object inside another sub-component properties object, but only if it doesn't already exist. It should not be used for regular properties, though, so that's why `defaultSkin` doesn't start with `@`. Again, its only for sub-component properties objects that are inside other sub-component properties objects.

A benefit of this syntax is that it helps you avoid overwriting objects that may already exist. If you set the `thumbProperties` with a whole new object, like we're about to do below, it would replace any values inside `thumbProperties` that may have been set elsewhere in your application:

``` code
//WARNING: this may overwrite things!
list.verticalScrollBarProperties.thumbProperties =
{
   defaultSkin: new Scale3Image( thumbTextures )
};
```

Instead, you should use `@thumbProperties` and pass in properties individually so that anything that was already in `thumbProperties` isn't removed.

## Related Links

-   [Introduction to Feathers Themes](themes.html)

For more tutorials, return to the [Feathers Documentation](index.html).


