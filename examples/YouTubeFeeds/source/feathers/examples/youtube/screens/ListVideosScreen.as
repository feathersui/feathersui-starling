package feathers.examples.youtube.screens
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.data.ListCollection;
	import feathers.examples.youtube.models.VideoDetails;
	import feathers.examples.youtube.models.YouTubeModel;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	import starling.display.DisplayObject;
	import starling.events.Event;

	[Event(name="complete",type="starling.events.Event")]

	[Event(name="showVideoDetails",type="starling.events.Event")]

	public class ListVideosScreen extends Screen
	{
		public static const SHOW_VIDEO_DETAILS:String = "showVideoDetails";

		public function ListVideosScreen()
		{
			this.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}

		private var _header:Header;
		private var _backButton:Button;
		private var _list:List;
		private var _message:Label;

		private var _model:YouTubeModel;

		public function get model():YouTubeModel
		{
			return this._model;
		}

		public function set model(value:YouTubeModel):void
		{
			if(this._model == value)
			{
				return;
			}
			this._model = value;
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		private var _loader:URLLoader;
		private var _transitionTimer:Timer;
		private var _savedLoaderData:*;

		override protected function initialize():void
		{
			this._backButton = new Button();
			this._backButton.label = "Back";
			this._backButton.addEventListener(starling.events.Event.TRIGGERED, onBackButton);

			this._header = new Header();
			this.addChild(this._header);
			this._header.leftItems = new <DisplayObject>
			[
				this._backButton
			];

			this._list = new List();
			this._list.itemRendererProperties.labelField = "title";
			this._list.itemRendererProperties.accessoryLabelField = "author";
			this._list.addEventListener(starling.events.Event.CHANGE, list_changeHandler);
			this.addChild(this._list);

			this._message = new Label();
			this._message.text = "Loading...";
			this.addChild(this._message);

			this.backButtonHandler = onBackButton;

			this._transitionTimer = new Timer(400, 1);
			this._transitionTimer.addEventListener(TimerEvent.TIMER_COMPLETE, transitionTimer_timerCompleteHandler);
			this._transitionTimer.start();
		}

		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);

			this._header.width = this.actualWidth;
			this._header.validate();

			this._list.y = this._header.height;
			this._list.width = this.actualWidth;
			this._list.height = this.actualHeight - this._list.y;

			this._message.maxWidth = this.actualWidth - this._header.paddingLeft - this._header.paddingRight;
			this._message.validate();
			this._message.x = (this.actualWidth - this._message.width) / 2;
			this._message.y = this._list.y + this._message.x;

			if(dataInvalid)
			{
				this._list.dataProvider = null;
				if(this._model && this._model.selectedList)
				{
					this._header.title = this._model.selectedList.name;
					if(this._loader)
					{
						this.cleanUpLoader();
					}
					if(this._model.cachedLists.hasOwnProperty(this._model.selectedList.url))
					{
						this._message.visible = false;
						this._list.dataProvider = ListCollection(this._model.cachedLists[this._model.selectedList.url]);
					}
					else
					{
						this._loader = new URLLoader();
						this._loader.addEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
						this._loader.addEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
						this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
						this._loader.load(new URLRequest(this._model.selectedList.url));
					}
				}
			}
		}

		private function cleanUpLoader():void
		{
			if(!this._loader)
			{
				return;
			}
			this._loader.removeEventListener(flash.events.Event.COMPLETE, loader_completeHandler);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, loader_errorHandler);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_errorHandler);
			this._loader = null;
		}

		private function parseFeed(feed:XML):void
		{
			this._message.visible = false;

			const atom:Namespace = feed.namespace();
			const media:Namespace = feed.namespace("media");

			const items:Vector.<VideoDetails> = new <VideoDetails>[];
			const entries:XMLList = feed.atom::entry;
			const entryCount:int = entries.length();
			for(var i:int = 0; i < entryCount; i++)
			{
				var entry:XML = entries[i];
				var item:VideoDetails = new VideoDetails();
				item.title = entry.atom::title[0].toString();
				item.author = entry.atom::author[0].atom::name[0].toString();
				item.url = entry.media::group[0].media::player[0].@url.toString();
				item.description = entry.media::group[0].media::description[0].toString();
				items.push(item);
			}
			const collection:ListCollection = new ListCollection(items);
			this._model.cachedLists[this._model.selectedList.url] = collection;
			this._list.dataProvider = collection;
		}

		private function onBackButton(event:starling.events.Event = null):void
		{
			this.dispatchEventWith(starling.events.Event.COMPLETE);
		}

		private function list_changeHandler(event:starling.events.Event):void
		{
			if(this._list.selectedIndex < 0)
			{
				return;
			}
			this.dispatchEventWith(SHOW_VIDEO_DETAILS, false, VideoDetails(this._list.selectedItem));
		}

		private function removedFromStageHandler(event:starling.events.Event):void
		{
			this.cleanUpLoader();
		}

		private function loader_completeHandler(event:flash.events.Event):void
		{
			const loaderData:* = this._loader.data;
			this.cleanUpLoader();
			if(this._transitionTimer)
			{
				//if this screen is still transitioning in, the we'll save the
				//feed until later to ensure that the animation isn't affected.
				this._savedLoaderData = loaderData;
				return;
			}
			this.parseFeed(new XML(loaderData));
		}

		private function loader_errorHandler(event:ErrorEvent):void
		{
			this.cleanUpLoader();
			this._message.text = "Unable to load data. Please try again later.";
			this._message.visible = true;
			this.invalidate(INVALIDATION_FLAG_STYLES);
			trace(event.toString());
		}

		private function transitionTimer_timerCompleteHandler(event:TimerEvent):void
		{
			this._transitionTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, transitionTimer_timerCompleteHandler);
			this._transitionTimer = null;

			if(this._savedLoaderData)
			{
				this.parseFeed(new XML(this._savedLoaderData));
				this._savedLoaderData = null;
			}
		}
	}
}
