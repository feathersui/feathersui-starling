---
title: Creating custom Feathers themes  
author: Josh Tynjala

---
# Creating custom Feathers themes

Let's learn a bit about how Feathers [themes](themes.html) work behind the scenes. You may want to download one of the example themes that are available as part of the [feathers-examples project on Github](https://github.com/joshtynjala/feathers-examples) to see how the code for a theme might look.

If you simply want to use a theme rather than create a new one from scratch, please take a look at [Introduction to Feathers Themes](themes.html). You'll probably also be interested in [Extending Feathers Themes](extending-themes.html) to learn how to use an existing theme and add some custom alternate component styles.

This tutorial covers the old theme architecture in Feathers 1.0. It has not yet been updated for Feathers 2.0. However, [Extending Feathers Themes](extending-themes.html) should provide enough information to create a custom theme.

## The Basics of Themes

A theme should extend the `DisplayListWatcher` class. `DisplayListWatcher` is a class provided by Feathers that can listen for display list events and take action based on them. `Event.ADDED`, in particular, is a useful bubbling event that the `DisplayListWatcher` can use to know when absolutely anything is added to the display list. When the `DisplayListWatcher` encounters a Feathers component datatype that it recognizes (such as `Button`, `Slider` or `ToggleSwitch`), it can apply an appropriate skin to the component.

`DisplayListWatcher` provides a method named `setInitializerForClass()` that lets you call an *initializer* function when a display object of that type is added to the stage. This function is where you apply your skins to the component. Below, we register an initializer function for `Button` controls:

``` code
setInitializerForClass( Button, buttonInitializer );
```

Then here's the initializer function itself:

``` code
function buttonInitializer( button:Button ):void
{
    // apply skins to the button here
    // skins, icons, text formats, etc.
}
```

Simply add a new initializer for every type of component that you need in your application.

Next, let's look at how you can skin sub-components. Child components may have different skins than the more standard version of the same component. For instance, Button is used as a sub-component for many other components, including `ToggleSwitch`, `Slider`, and many others.

## Component Names

Every component has a *name list* that provides extra metadata about the component. By default, most components don't have any names, but sub-components and components that need special skins that are different from the default are given names to help differentiate them for skinning (and, possibly, other add-on capabilities). A component can have many names, and many components can share the same name. This feature is strongly inspired by CSS classes.

If Feathers themes had a CSS-like dialect, we might create a declaration like this to skin the thumb child component in a `ToggleSwitch`:

``` code
Button.feathers-toggle-switch-thumb {}
```

In ActionScript, we can pass in a component *name* to `setInitializerForClass()` as the third argument to make the initializer target any component with the specified class **and** the specified name. We'll pass in the name `“feathers-toggle-switch-thumb”`, which is defined in the constant `ToggleSwitch.DEFAULT_CHILD_NAME_THUMB`:

``` code
setInitializerForClass( Button, buttonInitializer );
setInitializerForClass( Button, toggleSwitchThumbInitializer, ToggleSwitch.DEFAULT_CHILD_NAME_THUMB );
```

Here are our two initializer functions:

``` code
function buttonInitializer( button:Button ):void
{
    // apply skins to a regular button here
}
 
function toggleSwitchThumbInitializer( button:Button ):void
{
    // apply skins to a toggle switch thumb here
}
```

Separate initializer functions can be defined for different component names. The theme will pick the first name that is matched and no others. It's possible to use multiple names, as we'll see later, but a theme will pass a component to a single initializer only. As you can see in the code above, you can create an initializer that doesn't target any name. If a new component is added, and it doesn't have a name associated with another initializer, then it will default to using the initializer that targets no name.

Usually, names are declared for sub-components (such as the `ToggleSwitch` or `Slider` thumbs), but a theme may offer some names as static constants to offer different styles of the same component. For instance, you might want to display some buttons with a realistic 3Dish style and others in a more simplified flat style. Or maybe you want back buttons to have an arrow-like shape to literally point backwards. If variations are available, you can simply add those names to any component in your application and the theme will take care of the rest.

Names only work when added to a component *before* it is added to the stage for the first time. You **cannot** change names later to give a component a different skin.

### Multiple Component Names

In most cases, a component will have only a single name. `setInitializerForClass()` accepts only one name, and the theme will only pass a component to a single initializer. However, that doesn't mean that it's impossible to have components with multiple names. Inside that single initializer, you can check for additional names by calling `nameList.contains()`:

``` code
private function buttonInitializer( button ):void
{
    // size 
    if( button.nameList.contains( "my-small-button" ) )
    {
         // set styles for a small button
    }
    else
    {
         // set styles for a normally sized button
    }
 
    // style
    if( button.nameList.contains( Button.ALTERNATE_NAME_CALL_TO_ACTION_BUTTON ) )
    {
        // set skins for a call to action button
    }
    else
    {
        // set skins for a normally styled button
    }
}
```

## Alternate Skins

Some components may define more than one skin in the core framework. These are variations of the same component that are expected to exist across any Feathers theme. Theme authors should provide these alternate skins for maximum flexibility. An alternate skin is defined as a public static constant on a related class, and it is expected to be passed to a component's `nameList`, much like a name is added to a sub-component.

To apply an alternate skin in your theme, simply create an initializer for that name:

``` code
setInitializerForClass( GroupedList, buttonInitializer, GroupedList.ALTERNATE_NAME_INSET_GROUPED_LIST );
```

In the code above, an initializer is defined for an alternate “inset” skin supported by [GroupedList](grouped-list.html). As you can see, it's exactly the same as if you were providing a skin for a sub-component like a slider thumb or something like that.

If you choose not to provide an alternate skin, the regular skin will be applied to any component that would prefer to use the alternate skin. This will happen automatically, and you do not need any extra code to ensure that your theme falls back to the regular skin.

## Standard Icons

You should provide textures for the `StandardIcons` class. This class may be used by Feathers developers for commonly-used UI icons. For example, `StandardIcons.listDrillDownAccessoryTexture` typically provides an arrow pointing to the right to indicate that you can select a list item to drill down into more detailed data. This icon may be used with a list item's `accessoryTextureField` or `accessoryTextureFunction`.

``` code
StandardIcons.listDrillDownAccessoryTexture = atlas.getTexture("list-drill-down-accessory");
```

## Related Links

-   [Introduction to Feathers Themes](themes.html)

-   [Extending Feathers Themes](extending-themes.html)

For more tutorials, return to the [Feathers Documentation](index.html).


