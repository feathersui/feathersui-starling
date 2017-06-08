package feathers.utils.touch
{
    import feathers.controls.LayoutGroup;
    import feathers.events.ExclusiveTouch;

    import flash.geom.Point;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.utils.Pool;

    /**
     * A modified version of TouchSheet for Feathers.
     */
    public class TouchSheet extends LayoutGroup
    {
        public static const MOVE:String = "move";
        public static const ZOOM:String = "zoom";
        public static const ROTATE:String = "rotate";

        public function TouchSheet(contents:DisplayObject=null)
        {
            addEventListener(TouchEvent.TOUCH, onTouch);
            useHandCursor = true;
            
            if (contents)
            {
                contents.x = int(contents.width / -2);
                contents.y = int(contents.height / -2);
                addChild(contents);
            }
        }

        public var moveEnabled:Boolean = true;
        public var rotateEnabled:Boolean = true;
        public var zoomEnabled:Boolean = true;
        public var bringToFrontEnabled:Boolean = true;
        protected var touchAID:int = -1;
        protected var touchBID:int = -1;
        
        private function onTouch(event:TouchEvent):void
        {
            var exclusiveTouch:ExclusiveTouch = ExclusiveTouch.forStage(this.stage);

            //first check if the existing touches ended
            if(touchBID !== -1)
            {
                var touchB:Touch = event.getTouch(this, null, touchBID);
                if(touchB !== null)
                {
                    if(touchB.phase === TouchPhase.ENDED)
                    {
                        touchBID = -1;
                    }
                    else
                    {
                        //if the touch has been claimed since we first started
                        //watching it, we can no longer use it
                        var claim:DisplayObject = exclusiveTouch.getClaim(touchBID);
                        if(claim !== null && claim !== this)
                        {
                            touchBID = -1;
                        }
                    }
                }
            }
            //we checeked touch b first because a might be replaced by b
            if(touchAID !== -1)
            {
                var touchA:Touch = event.getTouch(this, null, touchAID);
                if(touchA !== null)
                {
                    if(touchA.phase === TouchPhase.ENDED)
                    {
                        touchAID = touchBID;
                        touchBID = -1;
                    }
                    else
                    {
                        claim = exclusiveTouch.getClaim(touchAID);
                        if(claim !== null && claim !== this)
                        {
                            touchAID = touchBID;
                            touchBID = -1;
                        }
                    }
                }
            }
            //then, check for new touches, if necessary
            if(touchAID === -1 || touchBID === -1)
            {
                var touches:Vector.<Touch> = event.getTouches(this, TouchPhase.BEGAN);
                var touchCount:int = touches.length;
                for(var i:int = 0; i < touchCount; i++)
                {
                    var touch:Touch = touches[i];
                    claim = exclusiveTouch.getClaim(touch.id);
                    if(claim !== null)
                    {
                        //this touch is claimed, so we can't use it
                        continue;
                    }
                    if(touchAID === -1)
                    {
                        touchAID = touch.id;
                        if(this.moveEnabled)
                        {
                            exclusiveTouch.claimTouch(touchAID, this);
                        }
                    }
                    else if(touchBID === -1)
                    {
                        touchBID = touch.id;
                        //if we've found both touches, claim them to stop containers
                        //from scrolling
                        exclusiveTouch.claimTouch(touchAID, this);
                        exclusiveTouch.claimTouch(touchBID, this);
                    }
                }
            }
            //do a multi-touch gesture if we have enough touches
            if(touchAID !== -1 && touchBID !== -1)
            {
                // two fingers touching -> rotate and scale
                touchA = event.getTouch(this, null, touchAID);
                touchB = event.getTouch(this, null, touchBID);
                if(touchA.phase !== TouchPhase.MOVED && touchB.phase !== TouchPhase.MOVED)
                {
                    //neither touch moved, so nothing has changed
                    return;
                }
                
                // updated to use stage instead of parent because the
                // parent might move, but the stage never will. -JT
                var currentPosA:Point  = touchA.getLocation(stage, Pool.getPoint());
                var previousPosA:Point = touchA.getPreviousLocation(stage, Pool.getPoint());
                var currentPosB:Point  = touchB.getLocation(stage, Pool.getPoint());
                var previousPosB:Point = touchB.getPreviousLocation(stage, Pool.getPoint());
                
                var currentVector:Point  = currentPosA.subtract(currentPosB);
                var previousVector:Point = previousPosA.subtract(previousPosB);
                
                var currentAngle:Number  = Math.atan2(currentVector.y, currentVector.x);
                var previousAngle:Number = Math.atan2(previousVector.y, previousVector.x);
                var deltaAngle:Number = currentAngle - previousAngle;

                // update pivot point based on previous center
                var point:Point = Pool.getPoint(
                    (previousPosA.x + previousPosB.x) * 0.5,
                    (previousPosA.y + previousPosB.y) * 0.5);
                globalToLocal(point, point);
                pivotX = point.x;
                pivotY = point.y;

                // update location based on the current center
                point.setTo(
                    (currentPosA.x + currentPosB.x) * 0.5,
                    (currentPosA.y + currentPosB.y) * 0.5);
                parent.globalToLocal(point, point);
                x = point.x;
                y = point.y;

                Pool.putPoint(point);
                Pool.putPoint(currentPosA);
                Pool.putPoint(previousPosA);
                Pool.putPoint(currentPosB);
                Pool.putPoint(previousPosB);

                if (rotateEnabled && deltaAngle !== 0)
                {
                    rotation += deltaAngle;
                    dispatchEventWith(ROTATE);
                }

                var sizeDiff:Number = currentVector.length / previousVector.length;
                if (zoomEnabled && sizeDiff !== 1)
                {
                    var zoomed:Boolean = false;
                    var newScaleX:Number = scaleX * sizeDiff;
                    if(scaleX !== newScaleX)
                    {
                        scaleX = newScaleX;
                        zoomed = true;
                    }
                    var newScaleY:Number = scaleY * sizeDiff;
                    if(scaleY !== newScaleY)
                    {
                        scaleY = newScaleY;
                        zoomed = true;
                    }
                    if(zoomed)
                    {
                        dispatchEventWith(ZOOM);
                    }
                }
            }
            else if(touchAID !== -1) //single touch gesture
            {
                touchA = event.getTouch(this, null, touchAID);
                if (moveEnabled)
                {
                    // one finger touching -> move

                    // updated to use stage instead of parent because the
                    // parent might move, but the stage won't -JT
                    var delta:Point = touchA.getMovement(stage, Pool.getPoint());
                    if(delta.length !== 0)
                    {
                        x += delta.x;
                        y += delta.y;

                        dispatchEventWith(MOVE);
                    }
                    Pool.putPoint(delta);
                }
            }
            
            var touchEnded:Touch = event.getTouch(this, TouchPhase.ENDED);
            if (touchEnded)
            {
                if (bringToFrontEnabled && touchEnded.tapCount == 2)
                {
                    parent.addChild(this); // bring self to front
                }
            }
        }
    }
}