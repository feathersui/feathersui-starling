---
title: Effects and animations for Feathers components  
author: Josh Tynjala

---
# Effects and animations for Feathers components

A Feathers component supports playing animations triggered by certain moments in its lifecycle, such as adding it to the display list, changing its size or position, or even changing its data. These are called *effects*. A number of built-in effects are available to quickly add a bit of life to your project.

Let's start by looking at a quick example of how to use an effect:

``` actionscript
component.addedEffect = Fade.createFadeInEffect();
```

In the example above, we're using one of the built-in effects on the [`feathers.motion.Fade`](../api-reference/feathers/motion/Fade.html) class. When the component is added to the stage, the [`addedEffect`](../api-reference/feathers/core/FeathersControl.html#addedEffect) will play, and the component's `alpha` value will fade in from `0.0` to `1.0`.

Now, let's explore all of the built-in effects. Components support custom effects too, and we'll look at that later.

## Fade

The [`Fade`](../api-reference/feathers/motion/Fade.html) effect animates the opacity of the target component. Several different types of fade effects are available for maximum flexibility.

### Fade in

The component may fade in, animating the `alpha` property from `0.0` to `1.0`.

``` actionscript
Fade.createFadeInEffect();
```

### Fade out

Alternatively, the component may fade out, animating the `alpha` property from `1.0` to `0.0`.

``` actionscript
Fade.createFadeOutEffect();
```

### Fade to

A third option is to fade to a specific `alpha` value starting from the component's current `alpha` value.

``` actionscript
Fade.createFadeToEffect(0.5);
```

### Fade from

Similarly, we can start from a custom `alpha` value and fade to the component's current `alpha` value.

``` actionscript
Fade.createFadeFromEffect(0.0);
```

### Fade between

The final option is to fade between a custom starting `alpha` value and a custom ending `alpha` value.

``` actionscript
Fade.createFadeBetweenEffect(1.0, 0.5);
```

## Iris

The [`Iris`](../api-reference/feathers/motion/Iris.html) effect adds a circular mask to the target component, and animates its radius to either reveal or hide the component.

``` actionscript
Iris.createIrisOpenEffect();
Iris.createIrisCloseEffect();
```

## Move

The [`Move`](../api-reference/feathers/motion/Move.html) effect animates the `x` and `y` position of the target component.

### Move to

You may animate the component to a new position, starting from its current position:

``` actionscript
Move.createMoveToEffect();
Move.createMoveXToEffect();
Move.createMoveYToEffect();
```

### Move from

You may animate the component from a specific position to its current position:

``` actionscript
Move.createMoveFromEffect();
Move.createMoveXFromEffect();
Move.createMoveYFromEffect();
```

### Move by

You may animate the component's position by a specific offset, starting from its current position:

``` actionscript
Move.createMoveByffect();
Move.createMoveXByEffect();
Move.createMoveYByEffect();
```

### Move on `x` or `y` property change

To animate a component's size any time that the `x` or `y` setters are called, pass the result of [`Move.createMoveEffect()`](../api-reference/feathers/motion/Move.html#createMoveEffect()) to the [`moveEffect`](../api-reference/feathers/core/FeathersControl.html#moveEffect) property:

``` actionscript
component.moveEffect = Move.createMoveEffect();
```

## Parallel

A [`Parallel`](../api-reference/feathers/motion/Parallel.html) effect can play multiple effects simulataeously, ending when all of them have completed.

``` actionscript
Parallel.createParallelEffect(
	Fade.createFadeInEffect(),
	Iris.createIrisOpenEffect()
);
```

## Resize

The [`Resize`](../api-reference/feathers/motion/Resize.html) effect animates the `width` and `height` values of the target component.

### Resize to

You may animate the component's size to new dimensions, starting from its current dimensions:

``` actionscript
Resize.createResizeToEffect();
Resize.createResizeWidthToEffect();
Resize.createResizeHeightToEffect();
```

### Resize from

You may animate the component's size from custom dimensions to its current dimensions:

``` actionscript
Resize.createResizeFromEffect();
Resize.createResizeWidthFromEffect();
Resize.createResizeHeightFromEffect();
```

### Resize by

You may animate the component's size by a specific offset, starting from its current dimensions:

``` actionscript
Resize.createResizeByEffect();
Resize.createResizeWidthByEffect();
Resize.createResizeHeightByEffect();
```

### Resize on `width` or `height` property change

To animate a component's size any time that the `width` or `height` setters are called, pass the result of [`Resize.createResizeEffect()`](../api-reference/feathers/motion/Resize.html#createResizeEffect()) to the [`resizeEffect`](../api-reference/feathers/core/FeathersControl.html#resizeEffect) property:

``` actionscript
component.resizeEffect = Resize.createResizeEffect();
```

## Sequence

A [`Sequence`](../api-reference/feathers/motion/Sequence.html) effect plays multiple effects one at a time, moving on to the next as each one completes.

``` actionscript
Sequence.createSequenceEffect(
	Fade.createFadeInEffect(),
	Move.createMoveToEffect(100, 50)
);
```

## Wipe

With a [`Wipe`](../api-reference/feathers/motion/Wipe.html) effect, the target component is given a rectangular mask that is resized over time. The mask may be resized in one of four directions: up, down, right, or left.
 
 A *wipe in* effect can show the target component:


``` actionscript
Wipe.createWipeInLeftEffect();
Wipe.createWipeInRightEffect();
Wipe.createWipeInUpEffect();
Wipe.createWipeInDownEffect();
```

A *wipe out* effect can hide the target component:

``` actionscript
Wipe.createWipeOutLeftEffect();
Wipe.createWipeOutRightEffect();
Wipe.createWipeOutUpEffect();
Wipe.createWipeOutDownEffect();
```

## Custom effects

Effect properties on Feathers components are simply typed as `Function`. Let's start by taking a look at the required function signature:

``` actionscript
function( target:DisplayObject ):IEffectContext
```

An effect function should accept a single argument, the target of the effect. It should return an implementation of [`feathers.motion.effectClasses.IEffectContext`](../api-reference/feathers/motion/effectClasses/IEffectContext.html). The component uses this context to start, pause, and stop the effect, as needed. Typically, you'll want to animate something using [`starling.animation.Tween`](http://doc.starling-framework.org/current/starling/animation/Tween.html), so the return value is often an instance of [`feathers.motion.effectClasses.TweenEffectContext`](../api-reference/feathers/motion/effectClasses/TweenEffectContext.html). Let's take a look at an example that uses `Tween` and `TweenEffectContext` to create our first custom effect.

### A custom transition using `starling.animation.Tween`

Let's create a custom effect that's a simplified version of the built-in [`Fade.createFadeInEffect()`](../api-reference/feathers/motion/Fade.html#createFadeInEffect()). The target component's `alpha` property will fade in from `0.0` to `1.0`.

Let's start with a simple function that sets the initial conditions before the animation starts:

``` actionscript
function( target:DisplayObject ):IEffectContext
{
	target.alpha = 0.0;
	//more code will go here
}
```

The target component will start completely hidden, so we should set its `alpha` property to `0.0`.

Next, we'll create a `Tween` that animates the `alpha` property on the target component:

``` actionscript
var tween:Tween = new Tween( target, 1.0, Transitions.EASE_OUT );
tween.animate( "alpha", 1.0 );
```

As you can see, we animate the `alpha` property for a duration of one second, and we specify an easing function.

<aside class="info">For more information about Starling's `Tween` class, see [Animations](http://manual.starling-framework.org/en/#_animations) in the Starling Manual.</aside>

Finally, we need to pass our `Tween` instance to a `TweenEffectContext` to return from our function.

``` actionscript
return new TweenEffectContext(target, tween);
```

That's it! When this effect is triggered, the component's alpha property will fade in.

### Full custom transition source code

``` actionscript
function( target:DisplayObject ):IEffectContext
{
	target.alpha = 0.0;
	var tween:Tween = new Tween( target, 1.0, Transitions.EASE_OUT );
	tween.fadeTo( 1.0 );
	return new TweenEffectContext(target, tween);
}
```


## Related Links

-   [Transitions for Feathers screen navigators](transitions.html)