---
title: Creating a draw() function to validate a custom Feathers component  
author: Josh Tynjala

---
# Creating a draw() function to validate a custom Feathers component

`FeathersControl` provides a single, simple `draw()` function for validation. In general, though, a little extra structure can go a long way to help organize a component's validation code. The core components in Feathers typically break up validation into three phases. If you're familiar with the component internals [Apache Flex](http://flex.apache.org/) (formerly Adobe Flex), you should recognize that this is a similar, but also slightly simpler, approach.

## Phase 1: Commit

The first phase passes properties to children. If a property change requires creating or destroying a child dynamically (such as item renderers in a list), it should happen here.

## Phase 2: Measurement

The second phase calculates the ideal dimensions of the component. In general, all children should be created by now, and they may need to be validated so that their own dimensions are known in case they affect the dimensions of their parent.

## Phase 3: Layout

The third phase is for layout. Children are positioned and resized, using the `actualWidth` and `actualHeight` properties as the final dimensions of the component.

These three phases are not a core part of `FeathersControl`. They are not required, but they provide a useful structure for organizing validation code. A class that provides a stricter, required structure may be introduced in a future version of Feathers, but it will likely live alongside the current `FeathersControl` rather than replace it.

## Related Links

-   [Anatomy of a Feathers Component](component-properties-methods.html)

-   [Feathers Component Lifecycle](component-lifecycle.html)

For more tutorials, return to the [Feathers Documentation](index.html).


