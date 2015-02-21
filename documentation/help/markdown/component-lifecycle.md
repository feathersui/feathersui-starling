---
title: The Feathers user interface component lifecycle  
author: Josh Tynjala

---
# The Feathers user interface component lifecycle

To develop custom components for Feathers, one should understand the basics of the Feathers component lifecycle. A component goes through a number of distinct stages between when it is created and when it is destroyed.

## Instantiation

The component instance is created with the `new` keyword. It has not yet been added to the display list. Properties may be changed, and the new values will be saved, but the component will not react to those changes until after it has been added to the display list. This ensures that the Feathers component doesn't run its drawing code too often.

## Initialization

The component is added to the display list and its `initialize()` function is called. It will then validate for the first time, doing a complete redraw as if every single property has been invalidated (see *Invalidation* below).

## Validation

The component's `draw()` function is called. The component should handle any changes that have been made to its properties. Then, if the component's dimensions have not be specified, it should automatically calculate ideal width and height values. These should be passed to `setSizeInternal()` where other values such as minimum width and height will come into play. After the final dimensions are determined, the component should position and size its children.

Read [Anatomy of a Feathers Component](component-properties-methods.html) for more detailed information about the various "width" and "height" properties and variables that are available on a Feathers component.

## Render

The component automatically validates immediately before Starling renders its display list. Feathers components typically don't override Starling's `render()` function.

## Invalidation

Any time a property changes, the component should call `invalidate()` while passing in a flag (or multiple flags) to specify the type of invalidation. Examples of invalidation types include size, layout, and selection. Each component may have its own internal categorization of properties as invalidation flags, but a number of useful generic flags are defined on `FeathersControl` as `protected` constants. How these flags are used is not enforced in any way. Feel free call `invalidate()` without flags and use private `Boolean` variables to track state, if you prefer.

After being invalidated, the component will wait to validate until immediately before the next time that Starling asks it to render.

The process of 1) invalidation, 2) validation, 3) rendering will repeat indefinitely until the component is removed from the display list. It will start again if the component is removed and re-added.

## Removal

The component is removed from the display list. Unless it is added to the display list again, it will not validate. Property changes will be saved, but they will not be handled while the component is not attached to the stage.

## Disposal

Like all Starling display objects, Feathers components have a `dispose()` function that may be used to do things like remove event listeners and dispose of children. In general, the core Feathers components are designed to ensure that disposal isn't strictly required, but disposal is recommended for safety in most cases.

## Garbage Collection

After all references to the component have been removed, it becomes eligible for garbage collection to be handled by the runtime. The component's short life has ended.

## Related Links

-   [Anatomy of a Feathers Component](component-properties-methods.html)

-   [Feathers Component Validation with `draw()`](component-validation.html)