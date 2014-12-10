# Feathers ScreenNavigator Transitions

Let's look at some advanced tips for using transitions with the `ScreenNavigator` class. We'll look at transitions from a low-level perspective to see how transition managers communicate with a screen navigator and how they abstract it. We'll also spend some time on optimization.

For an introduction to transition managers, and transition events, see the [ScreenNavigator tutorial](screen-navigator.html).

## Transitions without Managers

The `transition` property on `ScreenNavigator` is simply typed as `Function`. Transition managers may do extra things like keep track of state, and manage tweens, and other things like, but ultimately, a manager passes a transition function to the `ScreenNavigator`. Let's take a look at the function signature and what the arguments do:

``` code
function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
```

The transition function will receive the old screen that is transitioning out, the new screen that is transitioning in, and a function that needs to be called when the transition finishes.

There will always be at least one screen in the transition. However, the other screen may be null. For instance, when the first screen is shown by the screen navigator, the old screen will be `null` because no other screen has been shown. Similarly, if `clearScreen()` is called on the screen navigator, the new screen will be `null` because there will be no new screen. There will never be a case where both screens are `null`.

The `completeCallback` references a function that should be called when your animation and other actions in the transition are finished. It may be saved in a variable somewhere if your transition takes time and won't be finished by the time the transition function returns. The `completeCallback` has the following signature:

``` code
function completeCallback():void
```

### An Empty Transition

The simplest transition function is one that does nothing except call the `completeCallback` to say that the transition has finished immediately:

``` code
navigator.transition = function( oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function ):void
{
    completeCallback();
};
```

## A Simple Transition Manager

Transition *managers* aren't based on a strict interface. Consider their design a useful suggestion for abstracting away details of how a transition works.

Let's create a class that always slides in new screens from the right side of the screen navigator with a tween. It doesn't track history or anything fancy or allow the animation to slide in screens from other directions. It's just a simple example that shows how to use a tween or other timed action and correctly report back to the screen navigator when it finishes.

``` code
package
{
    import feathers.controls.ScreenNavigator;
 
    import starling.animation.Transitions;
    import starling.animation.Tween;
    import starling.core.Starling;
    import starling.display.DisplayObject;
 
    public class SimpleTransitionManager
    {
        public function ScreenSlidingStackTransitionManager(navigator:ScreenNavigator)
        {
            //we'll need its dimensions later
            this.navigator = navigator;
 
            //our onTransition function is what the navigator calls
            //to start the transition
            this.navigator.transition = this.onTransition;
        }
 
        protected var navigator:ScreenNavigator;
        protected var tween:Tween;
        protected var savedOldScreen:DisplayObject;
        protected var savedCompleteCallback:Function;
 
        protected function onTransition(oldScreen:DisplayObject, newScreen:DisplayObject, completeCallback:Function):void
        {
            //if we're already transitioning, stop immediately
            if(this.tween)
            {
                this.savedOldScreen = null;
                this.savedCompleteCallback = null;
                Starling.juggler.remove(this.tween);
                this.tween = null;
            }
 
            //no need to animate if one of the screens is missing
            if(!oldScreen || !newScreen)
            {
                //make sure the screen that exists is at the right position
                if(newScreen)
                {
                    newScreen.x = 0;
                }
                if(oldScreen)
                {
                    oldScreen.x = 0;
                }
 
                //no animation, so let's finish immediately
                completeCallback();
                return;
            }
 
            //save this until the tween finishes
            this.savedCompleteCallback = completeCallback;
 
            //save this so that we can use it in the onUpdate callback
            this.savedOldScreen = oldScreen;
 
            //the old screen is on the left
            oldScreen.x = 0;
            //the new screen is on the right
            newScreen.x = this.navigator.width;
 
            //animate the new screen to x == 0
            this.tween = new Tween(newScreen, 0.25, Transitions.EASE_OUT);
            this.tween.animate("x", 0);
            this.tween.onUpdate = tween_onUpdate;
            this.tween.onComplete = tween_onComplete;
            Starling.juggler.add(this.tween);
        }
 
        protected function tween_onUpdate():void
        {
            //position the old screen relative to the new screen
            var newScreen:DisplayObject = DisplayObject(this.tween.target);
            this.savedOldScreen.x = newScreen.x - this.navigator.width;
        }
 
        protected function tween_onComplete():void
        {
            //we don't need to save these
            this.tween = null;
            this.savedOldScreen = null;
 
            var completeCallback:Function = this.savedCompleteCallback;
            this.savedCompleteCallback = null;
 
            //done!
            completeCallback();
        }
    }
}
```

See the inline comments in the code above for complete details.

## Optimizing Transitions

Transition animations between screens help give the user more context. However, the creation of a new screen can be expensive enough to make the runtime skip a transition completely due to dropped frames. Often, by strategically choreographing a screen's initialization code to spread it out over time, you can improve the performance of screen creation to preserve the transition animation.

If possible, try to limit the number of new objects you create in `initialize()`, and take out any code that does things that aren't immediately needed when the screen is first displayed. Keep the code in `initialize()` limited to what must be displayed during the transition. You can listen for `FeathersEventType.TRANSITION_COMPLETE` on the screen's `owner` (the `ScreenNavigator`) to know when the transition has completed so that you can finish your initialization.

Some examples of things to avoid in `initialize()`:

-   Don't `flatten()` anything yet. Starling won't actually handle the request to flatten a `Sprite` until the next time that its `render()` function is called. The transition starts before that, so the expensive processing of flattening will happen in the middle of the transition, which will affect the frame rate. Wait until after the transition to flatten things.

<!-- -->

-   Don't upload any new textures to the GPU. Ideally, you'll be using a texture atlas, and your `SubTexture` objects needed by the screen will already be created with calls to `atlas.getTexture()` before the screen is initialized.

<!-- -->

-   Don't create display objects that don't need to be visible immediately during the transition. If something isn't vitally important, you should consider creating it after the transition. For instance, you may have all sorts of powerups, enemies, and terrain in your game's level, but if some of them are not on screen during the transition, consider creating those objects later.

<!-- -->

-   Any long-running code that generates data or does some non-visual calculations can wait too, if its results don't matter during the transition.

<!-- -->

-   Don't access the file system during initialization of a screen. If you're using shared objects or files to store settings and stuff, load those values when the app first starts up or at some other time before you need the screen to transition in.

<!-- -->

-   Avoid creating many temporary objects that will be quickly garbage collected. Many functions like `push()`, `unshift()`, and `splice()` from the `Array` class have `rest` arguments. Every time one of these functions is called, a new temporary `Array` will be allocated and quickly deallocated. Garbage collection running during a transition can result in lost frames, especially on slower devices.

Chances are that all the initialization will still take just as long to complete, but you'll be spreading it out to strategic times when the user won't notice that all that work is happening. Some animations in between help make the app look more responsive and they naturally make the user pause for a moment as their brain switches context from watching the content transition in to interacting with it.

For more tutorials, return to the [Feathers Documentation](index.html).


