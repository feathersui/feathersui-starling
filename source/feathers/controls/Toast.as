package feathers.controls
{
import feathers.core.FeathersControl;
import feathers.core.PopUpManager;

import flash.events.TimerEvent;
import flash.utils.Timer;

import starling.display.DisplayObject;
import starling.events.Event;

public class Toast extends FeathersControl
  {
    protected static const DEFAULT_DELAY:int = 3000;

    //instantiation
		protected static var _instance:Toast;

		protected static var _allowInstantiation:Boolean = false;
	
		public static function get instance():Toast
		{
			if (!_instance)
			{
				_allowInstantiation = true;
				_instance = new Toast();
				_allowInstantiation = false;
			}
			return _instance;
		}

		public function Toast()
		{
			super();

			if (!_allowInstantiation)
				throw new Error("Error on creating Toast");

            this._timer = new Timer(DEFAULT_DELAY,1);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayComplete);

            this.addEventListener(Event.ADDED_TO_STAGE, toast_addedToStageHandler);
		}
		//instantiation

		//styles
		protected var _backgroundSkin:DisplayObject;
		
		public function get backgroundSkin():DisplayObject
		{
			return this._backgroundSkin;
		}

		public function set backgroundSkin(value:DisplayObject):void
		{
			if(this._backgroundSkin == value) return;
			if(this._backgroundSkin)
            {
                this._backgroundSkin.removeFromParent(true);
            }
			this._backgroundSkin = value;
			addChildAt(this._backgroundSkin,0);
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingTop:Number;

		public function get paddingTop():Number
		{
			return this._paddingTop;
		}

		public function set paddingTop(value:Number):void
		{
			if(this._paddingTop == value)
            {
                return;
            }
			this._paddingTop = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingLeft:Number;

		public function get paddingLeft():Number
		{
			return this._paddingLeft;
		}

		public function set paddingLeft(value:Number):void
		{
			if(this._paddingLeft == value)
            {
                return;
            }
			this._paddingLeft = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}

		protected var _paddingRight:Number;

		public function get paddingRight():Number
		{
			return this._paddingRight;
		}

		public function set paddingRight(value:Number):void
		{
			if(this._paddingRight == value)
            {
                return;
            }
			this._paddingRight = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}


		protected var _paddingBottom:Number;

		public function get paddingBottom():Number
		{
			return this._paddingBottom;
		}

		public function set paddingBottom(value:Number):void
		{
			if(this._paddingBottom == value)
            {
                return;
            }
			this._paddingBottom = value;
			invalidate(INVALIDATION_FLAG_STYLES);
		}
		//styles

		protected var _text:String;

		public function get text():String
		{
			return this._text;
		}

		public function set text(value:String):void
		{
			if(this._text==value)
            {
                return;
            }
			this._text = value;
			invalidate(INVALIDATION_FLAG_DATA);
		}


		//controls
		protected var _label:Label;
		//controls

		protected var _timer:Timer;

		public function set delay(value:Number):void
		{
            if(!this._timer || this._timer.delay == value)
            {
                return;
            }
			this._timer.delay = value;
		}

		public function startTimer():void
		{
			if(this._timer)
            {
                this._timer.start();
            }
		}

		override public function dispose():void
		{
			if(this._label)
            {
                this._label.removeFromParent(true);
            }
			if(this._backgroundSkin)
            {
                this._backgroundSkin.removeFromParent(true);
            }
			if(this._timer)
			{
				this._timer.stop();
				this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,onDelayComplete);
				this._timer = null;
			}
            super.dispose();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._label = new Label();
            this._label.text = this._text;
            addChild(this._label);

		}

		override protected function draw():void
		{
			super.draw();
			const stylesInvalid:Boolean = isInvalid(INVALIDATION_FLAG_STYLES);
			const textContentInvalid:Boolean = isInvalid(INVALIDATION_FLAG_DATA);
			if(textContentInvalid && this._label)
            {
                this._label.text = this._text;
            }
			if(this._label && (textContentInvalid || stylesInvalid))
			{
                this._label.x = this.paddingLeft;
                this._label.y = this.paddingTop;
                this._label.validate();
                this.height = this._label.height + this.paddingTop + this.paddingBottom;
                this.width =  this._label.width + this.paddingLeft + this.paddingRight;
                if(this._backgroundSkin)
                {
                    this._backgroundSkin.width = this.actualWidth;
                    this._backgroundSkin.height = this.actualHeight;
                }
                this.x = (this.stage.stageWidth - width)/2;
                this.y = (this.stage.stageHeight - height)*0.9;
			}
		}		

		protected function onDelayComplete(event:TimerEvent):void
		{
  	   PopUpManager.removePopUp(this,true);
			 _instance = null;
		}


		public static function show(text:String,delay:Number = DEFAULT_DELAY):void
		{
      instance.text = text;
      instance.delay = delay;
      PopUpManager.addPopUp(instance,false,false);
		}

    protected function toast_addedToStageHandler():void
    {
       startTimer();
    }
	}
}
