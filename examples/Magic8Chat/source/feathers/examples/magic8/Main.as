package feathers.examples.magic8
{
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.TextInput;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import feathers.data.ArrayCollection;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.examples.magic8.data.ChatMessage;
	import feathers.examples.magic8.themes.Magic8ChatTheme;
	import feathers.examples.magic8.themes.StyleNames;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.HorizontalLayoutData;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;

	import starling.events.Event;

	public class Main extends PanelScreen
	{
		private static const MESSAGES:Vector.<String> = new <String>
		[
			"It is certain",
			"It is decidedly so",
			"Without a doubt",
			"Yes, definitely",
			"You may rely on it",
			"As I see it, yes",
			"Most likely",
			"Outlook good",
			"Yes",
			"Signs point to yes",
			"Reply hazy try again",
			"Ask again later",
			"Better not tell you now",
			"Cannot predict now",
			"Concentrate and ask again",
			"Don't count on it",
			"My reply is no",
			"My sources say no",
			"Outlook not so good",
			"Very doubtful",
		];

		private static const USER_ITEM:String = "user";
		private static const EIGHT_BALL_ITEM:String = "8ball";

		public function Main()
		{
			new Magic8ChatTheme();
			super();
			this.title = "Magic 8-Ball";
		}

		private var _list:List;
		private var _input:TextInput;
		private var _sendButton:Button;

		override protected function initialize():void
		{
			super.initialize();

			this.layout = new AnchorLayout();

			this._list = new List();
			this._list.dataProvider = new ArrayCollection();
			this._list.isSelectable = false;
			this._list.setItemRendererFactoryWithID(USER_ITEM, function():IListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.styleNameList.add(StyleNames.USER_MESSAGE_ITEM_RENDERER);
				itemRenderer.labelField = "message";
				itemRenderer.wordWrap = true;
				return itemRenderer;
			});
			this._list.setItemRendererFactoryWithID(EIGHT_BALL_ITEM, function():IListItemRenderer
			{
				var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				itemRenderer.styleNameList.add(StyleNames.EIGHT_BALL_MESSAGE_ITEM_RENDERER);
				itemRenderer.labelField = "message";
				itemRenderer.wordWrap = true;
				return itemRenderer;
			});
			this._list.factoryIDFunction = function(item:ChatMessage):String
			{
				if(item.type === ChatMessage.TYPE_MAGIC_8BALL)
				{
					return EIGHT_BALL_ITEM;
				}
				return USER_ITEM;
			};
			var listLayout:VerticalLayout = new VerticalLayout();
			listLayout.hasVariableItemDimensions = true;
			listLayout.horizontalAlign = HorizontalAlign.JUSTIFY;
			listLayout.verticalAlign = VerticalAlign.BOTTOM;
			this._list.layout = listLayout;
			this.addChild(this._list);

			var controls:LayoutGroup = new LayoutGroup();
			controls.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			this.addChild(controls);

			this._input = new TextInput();
			this._input.prompt = "Ask a yes or no question...";
			this._input.layoutData = new HorizontalLayoutData(100);
			this._input.textEditorFactory = function():ITextEditor
			{
				var textEditor:StageTextTextEditor = new StageTextTextEditor();
				textEditor.maintainTouchFocus = true;
				//flash.text.ReturnKeyLabel doesn't exist in Flash Player, so
				//we can't use the constant here.
				//we use ReturnKeyLabel.GO because the default label doesn't
				//dispatch an event for Keyboard.ENTER on all platforms.
				textEditor.returnKeyLabel = "go";
				return textEditor;
			};
			this._input.addEventListener(FeathersEventType.ENTER, input_enterHandler);
			this._input.addEventListener(Event.CHANGE, input_changeHandler);
			controls.addChild(this._input);

			this._sendButton = new Button();
			this._sendButton.label = "Send";
			this._sendButton.addEventListener(Event.TRIGGERED, sendButton_triggeredHandler);
			controls.addChild(this._sendButton);

			controls.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			var listLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			listLayoutData.bottomAnchorDisplayObject = controls;
			this._list.layoutData = listLayoutData;
		}

		private function sendMessage():void
		{
			var message:String = this._input.text;
			if(message.length === 0)
			{
				this._input.errorString = "Please ask a question!";
				return;
			}
			this._input.text = "";
			this._list.dataProvider.addItem(new ChatMessage(ChatMessage.TYPE_USER, message));

			var index:int = Math.floor(Math.random() * MESSAGES.length);
			var response:String = MESSAGES[index];
			this._list.dataProvider.addItem(new ChatMessage(ChatMessage.TYPE_MAGIC_8BALL, response));

			this._list.validate();
			this._list.scrollToPosition(0, this._list.maxVerticalScrollPosition, 0.5);
		}

		private function input_changeHandler(event:Event):void
		{
			if(this._input.text.length > 0)
			{
				this._input.errorString = null;
			}
		}

		private function input_enterHandler(event:Event):void
		{
			this.sendMessage();
		}

		private function sendButton_triggeredHandler(event:Event):void
		{
			this.sendMessage();
		}
	}
}
