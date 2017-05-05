package feathers.examples.componentsExplorer.screens
{
	import feathers.controls.Button;
	import feathers.controls.Tree;
	import feathers.controls.Header;
	import feathers.controls.PanelScreen;
	import feathers.data.ArrayHierarchicalCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.system.DeviceCapabilities;

	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import feathers.controls.renderers.ITreeItemRenderer;
	import feathers.controls.renderers.DefaultTreeItemRenderer;

	[Event(name="complete",type="starling.events.Event")]

	public class TreeScreen extends PanelScreen
	{
		public function TreeScreen()
		{
			super();
		}

		private var _tree:Tree;

		override protected function initialize():void
		{
			//never forget to call super.initialize()
			super.initialize();

			this.title = "Tree";

			this.layout = new AnchorLayout();

			var data:Array =
			[
				{
					text: "Node 1",
					children:
					[
						{
							text: "Node 1A",
							children:
							[
								{ text: "Node 1A-I" },
								{ text: "Node 1A-II" },
								{ text: "Node 1A-III" },
								{ text: "Node 1A-IV" },
							]
						},
						{ text: "Node 1B" },
						{ text: "Node 1C" },
					]
				},
				{
					text: "Node 2",
					children:
					[
						{ text: "Node 2A" },
						{ text: "Node 2B" },
						{ text: "Node 2C" },
					]
				},
				{
					text: "Node 3"
				},
				{
					text: "Node 4",
					children:
					[
						{ text: "Node 4A" },
						{ text: "Node 4B" },
						{ text: "Node 4C" },
						{ text: "Node 4D" },
						{ text: "Node 4E" },
					]
				}
			];
			
			this._tree = new Tree();
			this._tree.dataProvider = new ArrayHierarchicalCollection(data);
			this._tree.typicalItem = { text: "Item 1000" };
			//optimization: since this tree fills the entire screen, there's no
			//need for clipping. clipping should not be disabled if there's a
			//chance that item renderers could be visible if they appear outside
			//the tree's bounds
			this._tree.clipContent = false;
			//optimization: when the background is covered by all item
			//renderers, don't render it
			this._tree.autoHideBackground = true;
			this._tree.itemRendererFactory = function():ITreeItemRenderer
			{
				var renderer:DefaultTreeItemRenderer = new DefaultTreeItemRenderer();
				renderer.labelField = "text";
				return renderer;
			};
			this._tree.addEventListener(Event.CHANGE, tree_changeHandler);
			this._tree.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this.addChildAt(this._tree, 0);

			this.headerFactory = this.customHeaderFactory;

			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				this.backButtonHandler = this.onBackButton;
			}

			this.addEventListener(FeathersEventType.TRANSITION_IN_COMPLETE, transitionInCompleteHandler);
		}

		private function customHeaderFactory():Header
		{
			var header:Header = new Header();
			//this screen doesn't use a back button on tablets because the main
			//app's uses a split layout
			if(!DeviceCapabilities.isTablet(Starling.current.nativeStage))
			{
				var backButton:Button = new Button();
				backButton.styleNameList.add(Button.ALTERNATE_STYLE_NAME_BACK_BUTTON);
				backButton.label = "Back";
				backButton.addEventListener(Event.TRIGGERED, backButton_triggeredHandler);
				header.leftItems = new <DisplayObject>
				[
					backButton
				];
			}
			return header;
		}
		
		private function onBackButton():void
		{
			this.dispatchEventWith(Event.COMPLETE);
		}

		private function transitionInCompleteHandler(event:Event):void
		{
			this._tree.revealScrollBars();
		}
		
		private function backButton_triggeredHandler(event:Event):void
		{
			this.onBackButton();
		}

		private function tree_changeHandler(event:Event):void
		{
			trace("Tree change:", this._tree.dataProvider.getItemLocation(this._tree.selectedItem));
		}
	}
}