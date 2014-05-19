package feathers.controls
{
	import feathers.controls.popups.VerticalBottomedPopUpContentManager;
	
	import feathers.controls.ButtonGroup;
	import feathers.controls.popups.IPopUpContentManager;
	import feathers.core.FeathersControl;
	
	import starling.events.Event;
	
	public class PopupButtonGroup extends ButtonGroup
	{
		public function PopupButtonGroup()
		{
			super();
		}
		
		/**
		 * Quickly sets all margin properties to the same value. The
		 * <code>margin</code> getter always returns the value of
		 * <code>marginTop</code>, but the other padding values may be
		 * different.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on all sides:</p>
		 *
		 * <listing version="3.0">
		 * manager.margin = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #marginTop
		 * @see #marginRight
		 * @see #marginBottom
		 * @see #marginLeft
		 */
		public function get margin():Number
		{
			return this.marginTop;
		}
		
		/**
		 * @private
		 */
		public function set margin(value:Number):void
		{
			this.marginTop = value;
			this.marginRight = value;
			this.marginBottom = value;
			this.marginLeft = value;
		}
		
		protected var _marginTop:Number = 0;

		/**
		 * The minimum space, in pixels, between the top edge of the content and
		 * the top edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the top:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginTop = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public function get marginTop():Number
		{
			return this.popUpContentManager.marginTop;
		}

		/**
		 * @private
		 */
		public function set marginTop(value:Number):void
		{
			this.popUpContentManager.marginTop = value;
		}

		
		protected var _marginRight:Number = 0;

		/**
		 * The minimum space, in pixels, between the right edge of the content
		 * and the right edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the right:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginRight = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public function get marginRight():Number
		{
			return this.popUpContentManager.marginRight;
		}

		/**
		 * @private
		 */
		public function set marginRight(value:Number):void
		{
			this.popUpContentManager.marginRight = value;
		}

		
		protected var _marginBottom:Number = 0;

		/**
		 * The minimum space, in pixels, between the bottom edge of the content
		 * and the bottom edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the bottom:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginBottom = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public function get marginBottom():Number
		{
			return this.popUpContentManager.marginBottom;
		}

		/**
		 * @private
		 */
		public function set marginBottom(value:Number):void
		{
			this.popUpContentManager.marginBottom = value;
		}

		
		protected var _marginLeft:Number = 0;

		/**
		 * The minimum space, in pixels, between the left edge of the content
		 * and the left edge of the stage.
		 *
		 * <p>The following example gives the pop-up a minimum of 20 pixels of
		 * margin on the left:</p>
		 *
		 * <listing version="3.0">
		 * manager.marginLeft = 20;</listing>
		 *
		 * @default 0
		 *
		 * @see #margin
		 */
		public function get marginLeft():Number
		{
			return this.popUpContentManager.marginLeft;
		}

		/**
		 * @private
		 */
		public function set marginLeft(value:Number):void
		{
			this.popUpContentManager.marginLeft = value;
		}

		
		/**
		 * @private
		 */
		protected var _popUpContentManager:VerticalBottomedPopUpContentManager;
		
		/**
		 * A manager that handles the details of how to display the pop-up list.
		 *
		 * <p>In the following example, a pop-up content manager is provided:</p>
		 *
		 * <listing version="3.0">
		 * list.popUpContentManager = new CalloutPopUpContentManager();</listing>
		 *
		 * @default null
		 */
		public function get popUpContentManager():VerticalBottomedPopUpContentManager
		{
			if (!this._popUpContentManager){
				this._popUpContentManager = new VerticalBottomedPopUpContentManager(); 
			}
			return this._popUpContentManager;
		}
		
		/**
		 * @private
		 */
		public function set popUpContentManager(value:VerticalBottomedPopUpContentManager):void
		{
			if(this._popUpContentManager == value)
			{
				return;
			}
			this._popUpContentManager = value;
			this.invalidate(INVALIDATION_FLAG_STYLES);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.popUpContentManager.addEventListener(Event.CLOSE, popUpContentManager_closeHandler);
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function dispose():void
		{
			if(this._popUpContentManager)
			{
				this._popUpContentManager.removeEventListener(Event.CLOSE, popUpContentManager_closeHandler);
				this._popUpContentManager.dispose();
				this._popUpContentManager = null;
			}
			super.dispose();
		}
		
		/**
		 * close the popup bottons
		 * 
		 */		
		public function close():void
		{
			this.popUpContentManager.close();
		}
		
		/**
		 * opened the popup buttons 
		 * 
		 */		
		public function open():void
		{
			this.popUpContentManager.open(this, this);
		}
		
		private function popUpContentManager_closeHandler(e:Event):void
		{
			this.dispatchEventWith(Event.CLOSE);
		}
	}
}