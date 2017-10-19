package feathers.tests
{
	import feathers.controls.GroupedList;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.core.FocusManager;
	import feathers.data.HierarchicalCollection;

	import flash.events.KeyboardEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	import org.flexunit.Assert;

	import starling.display.Quad;
	import starling.events.Event;

	public class GroupedListFocusTests
	{
		private var _list:GroupedList;

		[Before]
		public function prepare():void
		{
			this._list = new GroupedList();
			this._list.dataProvider = new HierarchicalCollection(
			[
				{
					header: { label: "A" },
					children:
					[
						{label: "One"},
						{label: "Two"},
						{label: "Three"},
					]
				},
				{
					header: { label: "B" },
					children:
					[
						{label: "Four"},
						{label: "Five"},
						{label: "Six"},
					]
				},
				{
					header: { label: "C" },
					children:
					[
						{label: "Seven"},
					]
				}
			]);
			this._list.itemRendererFactory = function():DefaultGroupedListItemRenderer
			{
				var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
				itemRenderer.defaultSkin = new Quad(200, 200);
				return itemRenderer;
			};
			TestFeathers.starlingRoot.addChild(this._list);
			this._list.validate();

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, true);
		}

		[After]
		public function cleanup():void
		{
			this._list.removeFromParent(true);
			this._list = null;

			FocusManager.setEnabledForStage(TestFeathers.starlingRoot.stage, false);

			Assert.assertStrictlyEquals("Child not removed from Starling root on cleanup.", 0, TestFeathers.starlingRoot.numChildren);
			Assert.assertFalse("FocusManager not disabled on cleanup.", FocusManager.isEnabledForStage(TestFeathers.starlingRoot.stage));
		}

		[Test]
		public function testNoTriggerWhenNoSelectedItem():void
		{
			FocusManager.focus = this._list;
			var hasTriggered:Boolean = false;
			var triggeredItem:Object = null;
			this._list.addEventListener(Event.TRIGGERED, function(event:Event, item:Object):void
			{
				hasTriggered = true;
				triggeredItem = item;
			});
			this._list.stage.starling.nativeStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 32, Keyboard.SPACE, KeyLocation.STANDARD, false, false, false));
			this._list.stage.starling.nativeStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 32, Keyboard.SPACE, KeyLocation.STANDARD, false, false, false));
			Assert.assertFalse("Event.TRIGGERED incorrectly dispatched when no item is selected",
				hasTriggered);
		}

		[Test]
		public function testTriggered():void
		{
			this._list.setSelectedLocation(0, 1);
			FocusManager.focus = this._list;
			var hasTriggered:Boolean = false;
			var triggeredItem:Object = null;
			this._list.addEventListener(Event.TRIGGERED, function(event:Event, item:Object):void
			{
				hasTriggered = true;
				triggeredItem = item;
			});
			this._list.stage.starling.nativeStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 32, Keyboard.SPACE, KeyLocation.STANDARD, false, false, false));
			this._list.stage.starling.nativeStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_UP, true, false, 32, Keyboard.SPACE, KeyLocation.STANDARD, false, false, false));
			Assert.assertTrue("Event.TRIGGERED must be dispatched on KeyboardEvent.KEY_DOWN with Keyboard.SPACE key code",
				hasTriggered);
			Assert.assertStrictlyEquals("Incorrect item passed to Event.TRIGGERED listener",
				this._list.dataProvider.getItemAt(0, 1), triggeredItem);
		}
	}
}