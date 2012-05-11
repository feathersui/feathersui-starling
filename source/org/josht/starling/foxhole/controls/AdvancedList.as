package org.josht.starling.foxhole.controls
{

	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.IListItemRenderer;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.Scroller;
	import org.josht.starling.foxhole.controls.SimpleItemRenderer;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * Supports pull down to action and slide item to action.
	 * @author g.konnov
	 */
	public class AdvancedList extends List implements IMovableList
	{
		protected static const INVALIDATION_FLAG_PULL_DOWN_CONTROL:String = "pullDownControl";
		protected static const SCROLLER_BOUNDARY_POSITION:Number=-1;

		public static const CONTROL_STATE_BASE:String="base";		
		public static const CONTROL_STATE_DRAGGING:String="dragging";		
		public static const CONTROL_STATE_READY:String="ready";
		public static const CONTROL_STATE_RELEASED:String="released";		

		protected var _onLeftAction:Signal = new Signal(Object,IListItemRenderer);

		/**
		 *  Dispatched when touch is ended and itemRenderer is in left zone.
		 *  Parameters: data:Object, renderer:IListItemRenderer
		 */
		public function get onLeftAction():ISignal
		{
			return _onLeftAction;
		}

		protected var _onRightAction:Signal = new Signal(Object,IListItemRenderer);


		public function get onRightAction():ISignal
		{
			return _onRightAction;
		}

		protected var _onCenterAction:Signal = new Signal(Object,IListItemRenderer);

		public function get onCenterAction():ISignal
		{
			return _onCenterAction;
		}


		/**
		 * @private
		 */
		protected var _onPullDownAction:Signal = new Signal(AdvancedList);

		/**
		 * Dispatched when the user ends touch when pullDownControl is in ready state.
		 */
		public function get onPullDownAction():ISignal
		{
			return this._onPullDownAction;
		}


		protected var _pullDownControl:IPullDownControl;

		public function get pullDownControl():IPullDownControl
		{
			return _pullDownControl;
		}

		/** @private */
		public function set pullDownControl(value:IPullDownControl):void
		{
			if (_pullDownControl)
			{				
				if (_dataContainer)
					_dataContainer.removeChild(_pullDownControl as DisplayObject);	
				if (_scroller)
					_scroller.onVerticalTween.remove(scroller_onVerticalTween);
			}
			_pullDownControl = value;
			if (_pullDownControl && _dataContainer)
			{		
				if (_dataContainer)
					_dataContainer.addChild(_pullDownControl as DisplayObject);	
				if (_scroller)
					_scroller.onVerticalTween.add(scroller_onVerticalTween);
			}
			invalidate(INVALIDATION_FLAG_PULL_DOWN_CONTROL);
		}


		public function AdvancedList()
		{
			super();
		}

		override public function dispose():void
		{
			_onLeftAction.removeAll();
			_onRightAction.removeAll();
			_onCenterAction.removeAll();
			super.dispose();
		}

		protected function updatePullDownControlState():void
		{
			var pullDownControl:DisplayObject = _pullDownControl as DisplayObject;				
			if(verticalScrollPosition<SCROLLER_BOUNDARY_POSITION){
				pullDownControl.width=width;

				pullDownControl.y = _dataContainer.y - pullDownControl.height;				

				if (verticalScrollPosition<(-1.3*pullDownControl.height))
				{
					_pullDownControl.currentState=CONTROL_STATE_READY;
				}
				else
				{
					if (_pullDownControl.currentState!=CONTROL_STATE_RELEASED)
						_pullDownControl.currentState=CONTROL_STATE_DRAGGING;
				}
			}
			else								
				if (_pullDownControl.currentState!=CONTROL_STATE_BASE)
				{
					_pullDownControl.currentState=CONTROL_STATE_BASE;							
					resetPullDownControl();
				}			
		}

		override protected function draw():void
		{
			if (this.isInvalid(INVALIDATION_FLAG_PULL_DOWN_CONTROL) && _pullDownControl)
				resetPullDownControl();
			super.draw();
		}

		protected function resetPullDownControl():void
		{
			var pullDownControl:DisplayObject = _pullDownControl as DisplayObject;	
			pullDownControl.y=-40-pullDownControl.height;			
		}

		override protected function initialize():void
		{
			super.initialize();

			if (_pullDownControl)			
				pullDownControl = _pullDownControl;	

		}

		/**
		 * @private
		 */
		protected override function scroller_onScroll(scroller:Scroller):void
		{
			super.scroller_onScroll(scroller);		
			if (_pullDownControl)			
				updatePullDownControlState();			
		}	

		protected function scroller_onVerticalTween(scroller:Scroller,targetVerticalScrollPosition:Number):void
		{				
			if (_pullDownControl.currentState==CONTROL_STATE_READY)
			{
				_pullDownControl.currentState=CONTROL_STATE_RELEASED;
				_onPullDownAction.dispatch(this);
			}
		}
	}
}

