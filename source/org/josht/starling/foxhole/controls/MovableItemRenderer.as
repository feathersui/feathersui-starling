package org.josht.starling.foxhole.controls
{
	import com.gskinner.motion.easing.Quintic;

	import flash.system.Capabilities;

	import org.josht.starling.foxhole.controls.SimpleItemRenderer;
	import org.josht.starling.motion.GTween;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * The default movable item renderer for AdvancedList.
	 * Supports slide to action.
	 *
	 * @see AdvancedList
	 */
	public class MovableItemRenderer extends SimpleItemRenderer
	{
		/**
		 * @private
		 * The minimum physical distance (in inches) that a touch must move
		 * before the scroller starts scrolling.
		 */
		private static const MINIMUM_DRAG_DISTANCE:Number = 0.04;

		/** @private */
		protected static const STATE_LEFT:String = "left";
		/** @private */
		protected static const STATE_RIGHT:String = "right";
		/** @private */
		protected static const STATE_SELECTED_LEFT:String = "selectedLeft";

		/** @private */
		protected static const STATE_SELECTED_RIGHT:String = "selectedRight";

		protected static const MOVING_STATES:Array=[STATE_LEFT,STATE_RIGHT,STATE_SELECTED_LEFT,STATE_SELECTED_RIGHT,STATE_DOWN];


		protected override function set currentState(value:String):void
		{			
			if (_isMoving && (MOVING_STATES.indexOf(value)==-1) )
				return;			
			super.currentState=value;		
		}

		/**
		 * @private
		 */
		protected override function get stateNames():Vector.<String>
		{
			var resVector:Vector.<String> = super.stateNames;
			resVector.push(STATE_LEFT,STATE_RIGHT,STATE_SELECTED_LEFT,STATE_SELECTED_RIGHT);
			return resVector;
		}

		/** @private */
		protected var _leftSkin:DisplayObject;

		public function get leftSkin():DisplayObject
		{
			return _leftSkin;
		}

		/** @private */
		public function set leftSkin(value:DisplayObject):void
		{
			if(_leftSkin == value)			
				return;			

			if(_leftSkin && _leftSkin != _defaultSkin && _leftSkin != _defaultSelectedSkin)
			{
				removeChild(_leftSkin);
			}
			_leftSkin = value;
			if(_leftSkin && _leftSkin.parent != this)
			{
				_leftSkin.visible = false;
				addChildAt(_leftSkin, 0);
			}
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		/** @private */
		protected var _rightSkin:DisplayObject;

		public function get rightSkin():DisplayObject
		{
			return _rightSkin;
		}

		/** @private */
		public function set rightSkin(value:DisplayObject):void
		{
			if(_rightSkin == value)			
				return;			

			if(_rightSkin && _rightSkin != _defaultSkin && _rightSkin != _defaultSelectedSkin)
			{
				removeChild(_rightSkin);
			}
			_rightSkin = value;
			if(_rightSkin && _rightSkin.parent != this)
			{
				_rightSkin.visible = false;
				addChildAt(_rightSkin, 0);
			}
			invalidate(INVALIDATION_FLAG_STYLES);
		}		

		/** Moving was prevented. (List is scrolling) */
		protected var _isMovingStopped:Boolean=false;
		/** Renderer is Moving */
		protected var _isMoving:Boolean=false;
		/** Base renderer position */
		protected var _baseRendererX:Number=0;
		/** Previous touch X position */
		protected var _previousTouchX:Number;					
		/** Start touch Y position */
		protected var _startTouchY:Number;					

		protected var _horizontalMovingTween:GTween;

		/** Renderer is in center zone */
		protected const STATUS_DEFAULT:String="default";
		/** Renderer is in left zone */
		protected const STATUS_LEFT:String="left";
		/** Renderer is in right zone */
		protected const STATUS_RIGHT:String="right";

		protected var _status:String=STATUS_DEFAULT;

		/** Rendrerer status. In center, in left or in right zone */
		public function get status():String
		{
			return _status;
		}

		/**
		 * @private
		 */
		public function set status(value:String):void
		{			
			_status = value;
			switch(_status)
			{
				case STATUS_DEFAULT:
				{
					if (isSelected)
					{
						currentState = STATE_DOWN;
					}
					else
						currentState = STATE_UP;
					break;
				}
				case STATUS_LEFT:
				{					
					currentState = STATE_LEFT;	
					break;
				}
				case STATUS_RIGHT:
				{
					currentState = STATE_RIGHT;	
					break;
				}				
			}			
		}



		public function MovableItemRenderer()
		{
			super();
			_useStateDelayTimer=false;
			addEventListener(TouchEvent.TOUCH, touchHandler);			
		}


		public function reset():void
		{
			status=STATUS_DEFAULT;
			moveTo(_baseRendererX,true);
			_isMovingStopped=false;
			_isMoving=false;
			_touchPointID=-1;	
		}		

		/**
		 * Moves rendrer to the specified position.
		 * @param targetX target X value
		 * @param instantlyMove Instanly change X. Otherwise GTween will be created
		 * @param duration
		 */
		public function moveTo(targetX:Number, instantlyMove:Boolean=false,  duration:Number = 0.2):void
		{
			if(!isNaN(targetX))
			{
				if(_horizontalMovingTween)
				{
					_horizontalMovingTween.paused = true;
					_horizontalMovingTween = null;
				}

				if (instantlyMove)
				{
					x=targetX;
				}
				else					
					if(x != targetX)
					{
						_horizontalMovingTween = new GTween(this, duration,
							{
								x: targetX
							},
							{
								ease: Quintic.easeOut,
								onComplete: horizontalMovingTween_onComplete
							});
					}
					else
					{
						finishMovingHorizontally();
					}
			}
		}

		/** Commits data changes */		
		protected override function commitDataChanges():void
		{
			super.commitDataChanges();
			reset();
		}


		/**
		 * @private
		 */
		protected function finishMovingHorizontally():void
		{
			_isMovingStopped=false;
			_isMoving=false;
			_touchPointID=-1;	
			if (owner is IMovableList)
				switch(status)
				{
					case STATUS_DEFAULT:
					{
						IMovableList(owner).onCenterAction.dispatch(data,this);
						break;
					}
					case STATUS_LEFT:
					{
						IMovableList(owner).onLeftAction.dispatch(data,this);				
						break;
					}
					case STATUS_RIGHT:
					{
						IMovableList(owner).onRightAction.dispatch(data,this);					
						break;
					}					
				}
			status=STATUS_DEFAULT;
		}

		protected override function updateSkinStates():void
		{
			if(this._currentState == STATE_LEFT || _currentState == STATE_SELECTED_LEFT)
			{
				this.currentSkin = this._leftSkin;
			}
			else if(this._leftSkin)
			{
				this._leftSkin.visible = false;
			}

			if(_currentState == STATE_RIGHT || _currentState == STATE_SELECTED_RIGHT)
			{
				this.currentSkin = this._rightSkin;
			}
			else if(this._rightSkin)
			{
				this._rightSkin.visible = false;
			}
			super.updateSkinStates();
		}

		//handlers

		protected function touchHandler(event:TouchEvent):void
		{			
			const touch:Touch = event.getTouch(this);
			if(!touch || (_touchPointID >= 0 && _touchPointID != touch.id))			
				return;

			var currentTouchX:Number = touch.globalX;
			var currentTouchY:Number = touch.globalY;

			if(touch.phase == TouchPhase.BEGAN)
			{
				//_baseRendererX=x;
				_previousTouchX=currentTouchX;				
				_startTouchY=currentTouchY;	
				_isMovingStopped=false;
			}
			else if(touch.phase == TouchPhase.MOVED)
			{
				if (_isMovingStopped)
					return;

				var deltaX:Number = currentTouchX-_previousTouchX;				
				var deltaXInches:Number = Math.abs(deltaX)/Capabilities.screenDPI;

				if (!_isMoving)
				{
					var deltaYInches:Number = Math.abs(currentTouchY-_startTouchY)/Capabilities.screenDPI;

					if (deltaYInches>MINIMUM_DRAG_DISTANCE)
					{
						_isMovingStopped=true;
						return;
					}					
					if (deltaXInches>MINIMUM_DRAG_DISTANCE)
					{
						_isMoving=true;						
						owner.stopScrolling();
					}
					else
						return;
				}

				//moving renderer
				moveTo(x + deltaX,true);				

				var rendererXshift:Number =  Math.abs(x-_baseRendererX);				

				var centerRegionWidth:Number=0.2*width;

				if (rendererXshift>centerRegionWidth)
				{					
					if (x<_baseRendererX)
						status=STATUS_LEFT;						
					else
						status=STATUS_RIGHT;
				}
				else
				{			
					status=STATUS_DEFAULT;
				}				

				_previousTouchX=currentTouchX;
			}
			else if(touch.phase == TouchPhase.ENDED)
			{				
				if (_isMoving)				
					switch(status)
					{
						case STATUS_LEFT:
						{
							moveTo(-width);
							break;
						}
						case STATUS_RIGHT:
						{
							moveTo(+width);						
							break;
						}

						default:
						{
							moveTo(_baseRendererX);						
							break;
						}
					}
			}
		}


		/**
		 * @private
		 */
		protected function horizontalMovingTween_onComplete(tween:GTween):void
		{
			_horizontalMovingTween = null;
			finishMovingHorizontally();
		}

	}
}

