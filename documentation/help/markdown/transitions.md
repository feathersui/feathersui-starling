---
title: Transitions for Feathers screen navigators  
author: Josh Tynjala

---
# Transitions for Feathers screen navigators

A *transition* provides animation when a [`StackScreenNavigator`](stack-screen-navigator.html) or a [`ScreenNavigator`](screen-navigator.html) component navigates from one screen to another. Transitions help establish a relationship between two screens, providing extra context to improve the user experience.

Feathers offers a number of classes to quickly create common transitions. Screen navigators support custom transitions too, but first, we'll look at the built-in transitions.

## ColorFade

With a [`ColorFade`](../api-reference/feathers/motion/ColorFade.html) transition, the old screen is hidden as a solid color fades in over it. Then, the solid color fades back out to show that the new screen has replaced the old screen.

``` code
var color:uint = 0xff851b;
ColorFade.createColorFadeTransition( color );
```

The `ColorFade` class offers two convienence functions, one for black and one for white:

``` code
ColorFade.createBlackFadeTransition();
ColorFade.createWhiteFadeTransition();
```

## Cover

A [`Cover`](../api-reference/feathers/motion/Cover.html) transition slides the new screen into view, animating the `x` or `y` property, to cover up the old screen. The new screen may slide up, right, down, or left. The old screen remains stationary.

``` code
Cover.createCoverLeftTransition();
Cover.createCoverRightTransition();
Cover.createCoverUpTransition();
Cover.createCoverownTransition();
```

## Cube

A [`Cube`](../api-reference/feathers/motion/Cube.html) transition positions the screens in 3D space as if they are on two adjacent sides of a cube. The cube may rotate up or down around the x-axis, or it may rotate left or right around the y-axis.

``` code
Cube.createCubeLeftTransition();
Cube.createCubeRightTransition();
Cube.createCubeUpTransition();
Cube.createCubeDownTransition();
```

## Fade

The [`Fade`](../api-reference/feathers/motion/Fade.html) transition animates the opacity of one or both screens.

### Fade in

The new screen may fade in, animating the `alpha` property from `0` to `1`, while the old screen remains fully opaque at a lower depth.

``` code
Fade.createFadeInTransition();
```

### Fade out

Alternatively, the old screen may fade out, animating the `alpha` property from `1` to `0`, while the new screen remains fully opaque at a lower depth. 

``` code
Fade.createFadeOutTransition();
```

### Crossfade

A third option is to crossfade the screens. In other words, the old screen fades out, animating the `alpha` property from `1` to `0`. Simulataneously, the new screen fades in, animating its `alpha` property from `0` to `1`.

``` code
Fade.createCrossfadeTransition();
```

Since both screens are semi-transparent during a crossfade, the background behind the screens may be slightly visible during this transition.

## Flip

The [`Flip`](../api-reference/feathers/motion/Flip.html) transition positions the screens in 3D space is if they are printed on opposite sides of a postcard. The old screen appears on the front, and the card rotates around its center to show the new screen on the back side. The screens may rotate up or down around the x-axis, or they may rotate left or right around the y-axis.

``` code
Flip.createFlipLeftTransition();
Flip.createFlipRightTransition();
Flip.createFlipUpTransition();
Flip.createFlipDownTransition();
```

## Reveal

A [`Reveal`](../api-reference/feathers/motion/Reveal.html) transition slides the old screen out of view, animating the `x` or `y` property, to reveal the new screen under it. The old screen may slide up, right, down, or left. The new screen remains stationary.

``` code
Reveal.createRevealLeftTransition();
Reveal.createRevealRightTransition();
Reveal.createRevealUpTransition();
Reveal.createRevealDownTransition();
```

## Slide

With a [`Slide`](../api-reference/feathers/motion/Slide.html) transition, the new screen slides in from off-stage, pushing the old screen in the same direction. The screens may slide up, right, down, or left.

``` code
Slide.createSlideLeftTransition();
Slide.createSlideRightTransition();
Slide.createSlideUpTransition();
Slide.createSlideDownTransition();
```

## Custom transitions

 The `pushTransition` and `popTransition` properties on `StackScreenNavigator` (or the `transition` property on `ScreenNavigator`) are simply typed as `Function`. Let's take a look at the required function signature:

``` code
function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
```

A transition function should accept three arguments. The first argument is the old screen that is transitioning out. The second argument is the new screen that is transitioning in. Finally, a callback is passed in as the third argument. The transition uses this callback to tell the screen navigator that the animation has finished.

To better understand custom transitions, we'll look at a couple of examples. Let's start with the simplest possible transition: a transition that does nothing.

### An empty transition

This transition simply calls the `completeCallback` to say that it has finished:

``` code
navigator.transition = function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
{
    completeCallback();
};
```

There's no animation, so it's pretty boring, but this basic example illustrates the minimum requirements of a transition function. It accepts three arguments, and it uses the callback to notify the screen navigator that it has finished.

For our next example, let's animate something!

### A custom transition using `starling.animation.Tween`

Let's create a transition that's kind of a combination between `Cover` and `Fade`. The new screen will move from right to left to cover the old screen, animating the `x` property. In parallel, it will fade in, animating the `alpha` property from `0` to `1`.

Let's start with a simple function that sets the initial conditions before the animation starts:

``` code
function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
{
	newScreen.x = newScreen.width;
	newScreen.alpha = 0;
}
```

The new screen will start on the right side, so we should update its `x` property to position it. We want this screen to fade in too, so we'll set its `alpha` property to `0`.

Next, we'll create a `Tween` that animates properties on the new screen:

``` code
var tween:Tween = new Tween( newScreen, 1.0, Transitions.EASE_IN_OUT );
tween.animate( "x", 0 );
tween.animate( "alpha", 1 );
```

As you can see, we animate the `x` and `alpha` properties for a duration of one second, and we specify an easing function. Try not to get confused about the name of the `Transitions` class used above. That's simply what Starling calls an easing function. A transition for a Feathers screen navigator is something different, of course.

For more information about Starling's `Tween` class, see [Animation](http://wiki.starling-framework.org/manual/animation#tween) in the Starling Manual.

Now, we need to use the callback to notify the screen navigator when the animation is complete. If there isn't anything to clean up after the animation is complete, then we can simply pass to callback to its `onComplete` property:

``` code
tween.onComplete = completeCallback;
```

If some kind of cleanup is needed after the tween completes, we can create a closure that uses the callback when it is done:

``` code
tween.onComplete = function():void
{
	// clean up here

	completeCallback();
}
```

In this case, there is nothing to clean up. More advanced transitions might need to reset some properties on the old screen or the new screen, after the animation completes.

Finally, add the `Tween` to the Starling juggler to start the animation:

``` code
Starling.juggler.add( tween );
```

That's all that we need in most cases, but there's one more thing that we may need to consider.

It's possible that either the old screen or the new screen passed to a transition function will be `null`. For instance, when the very first screen is shown by the screen navigator, the old screen will be `null` because no other screen has been shown previously. Similarly, if `clearScreen()` is called on a `ScreenNavigator`, the new screen will be `null` because the current screen is being removed, and it won't be replaced by a new screen. There will never be a case where both screens are `null`.

For completeness, since were are animating properties on the new screen, we should handle the case where it is `null`. We don't want to get this dreaded runtime error:

	TypeError: Error #1009: Cannot access a property or method of a null object reference

At the start of the function, we'll simply check if the new screen is `null`:

``` code
function(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void
{
	if(!newScreen)
	{
		completeCallback();
		return;
	}
```

In this case, since there is no screen to animate, we can notify the screen navigator that the transition is complete by immediately calling `completeCallback` function before returning.

Since we aren't animating the old screen, we don't need to worry about it being `null`. A more advanced transition might need to account for that case, though.

Truly, our custom transition is now complete. Let's combine all of the source code snippets from above to see the final result.

### Full custom transition source code

``` code
function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
{
	if(!newScreen)
	{
		completeCallback();
		return;
	}

	newScreen.x = newScreen.width;
	newScreen.alpha = 0;
	var tween:Tween = new Tween( newScreen, 1.0, Transitions.EASE_IN_OUT );
	tween.animate( "x", 0 );
	tween.animate( "alpha", 1 );
	tween.onComplete = completeCallback;
	Starling.juggler.add( tween );
}
```

### Canceling transitions

In most cases, the callback passed to a transition function should be called without arguments. However, it's worth noting that this function has one optional argument.

The callback passed to a transition function has the following signature:

``` code
function completeCallback( cancelTransition:Boolean = false ):void
```

The callback accepts one optional argument that indicates if the transition was canceled or not. If you pass `true` to cancel the transition, the screen navigator will keep the old screen active instead of making the new screen active. If you pass `false` (which is the default behavior), the transition will complete normally and the new screen will become active.

Most transitions cannot be canceled. With that in mind, you should usually call the complete callback with no arguments when the animation is complete:

``` code
completeCallback();
```

If you need to cancel a transition to return to the old screen, you can pass `true` to the callback:

``` code
completeCallback( true );
```

The screen navigator will not make the new screen its active screen. The old screen will remain visible.

## Optimizing transitions

Transition animations between screens help give the user more context. However, the creation of a new screen can be expensive enough to make the runtime skip a transition completely due to dropped frames. Often, by strategically choreographing a screen's initialization code to spread it out over time, you can improve the performance of screen creation to preserve the transition animation.

If possible, try to limit the number of new objects you create in `initialize()`, and take out any code that does things that aren't immediately needed when the screen is first displayed. Keep the code in `initialize()` limited to what must be displayed during the transition. You can listen for `FeathersEventType.TRANSITION_COMPLETE` on the screen's `owner` (the `ScreenNavigator`) to know when the transition has completed so that you can finish your initialization.

Some examples of things to avoid in `initialize()`:

* Don't `flatten()` anything yet. Starling won't actually handle the request to flatten a `Sprite` until the next time that its `render()` function is called. The transition starts before that, so the expensive processing of flattening will happen in the middle of the transition, which will affect the frame rate. Wait until after the transition to flatten things.
* Don't upload any new textures to the GPU. Ideally, you'll be using a texture atlas, and your `SubTexture` objects needed by the screen will already be created with calls to `atlas.getTexture()` before the screen is initialized.
* Don't create display objects that don't need to be visible immediately during the transition. If something isn't vitally important, you should consider creating it after the transition. For instance, you may have all sorts of powerups, enemies, and terrain in your game's level, but if some of them are not on screen during the transition, consider creating those objects later.
* Any long-running code that generates data or does some non-visual calculations can wait too, if its results don't matter during the transition.
* Don't access the file system during initialization of a screen. If you're using shared objects or files to store settings and stuff, load those values when the app first starts up or at some other time before you need the screen to transition in.
* Avoid creating many temporary objects that will be quickly garbage collected. Many functions like `push()`, `unshift()`, and `splice()` from the `Array` class have `rest` arguments. Every time one of these functions is called, a new temporary `Array` will be allocated and quickly deallocated. Garbage collection running during a transition can result in lost frames, especially on slower devices.

Chances are that all the initialization will still take just as long to complete, but you'll be spreading it out to strategic times when the user won't notice that all that work is happening. Some animations in between help make the app look more responsive and they naturally make the user pause for a moment as their brain switches context from watching the content transition in to interacting with it.

For more tutorials, return to the [Feathers Documentation](index.html).


