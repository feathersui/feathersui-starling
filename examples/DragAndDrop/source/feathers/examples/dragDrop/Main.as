package feathers.examples.dragDrop
{
	import feathers.controls.Button;
	import feathers.controls.Label;
	import feathers.dragDrop.IDragSource;
	import feathers.dragDrop.IDropTarget;
	import feathers.themes.MetalWorksDesktopTheme;

	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite implements IDragSource, IDropTarget
	{
		private static const DRAG_FORMAT:String = "draggableQuad";

		public function Main()
		{
			//set up the theme right away!
			new MetalWorksDesktopTheme();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}

		private var _draggableQuad:Quad;
		private var _dragSource:DragSource;
		private var _dropTarget:DropTarget;
		private var _resetButton:Button;

		private function reset():void
		{
			this._draggableQuad.x = 40;
			this._draggableQuad.y = 40;
			this._dragSource.addChild(this._draggableQuad);
		}

		private function addedToStageHandler(event:Event):void
		{
			this._draggableQuad = new Quad(100, 100, 0xff8800);

			this._dragSource = new DragSource(DRAG_FORMAT);
			this._dragSource.width = 320;
			this._dragSource.height = 420;
			this._dragSource.x = 80;
			this._dragSource.y = 80;
			this.addChild(this._dragSource);

			this._dropTarget = new DropTarget(DRAG_FORMAT);
			this._dropTarget.width = 320;
			this._dropTarget.height = 420;
			this._dropTarget.x = 560;
			this._dropTarget.y = 80;
			this.addChild(this._dropTarget);

			this._resetButton = new Button();
			this._resetButton.label = "Reset";
			this._resetButton.addEventListener(Event.TRIGGERED, resetButton_triggeredHandler);
			this.addChild(this._resetButton);

			this._resetButton.validate();
			this._resetButton.x = (this.stage.stageWidth - this._resetButton.width) / 2;
			this._resetButton.y = this.stage.stageHeight - this._resetButton.height - 80;

			var instructions:Label = new Label();
			instructions.text = "Drag the square from the left container to the right container.";
			this.addChild(instructions);

			instructions.validate();
			instructions.x = (this.stage.stageWidth - instructions.width) / 2;
			instructions.y = (this._dragSource.y - instructions.height) / 2;

			this.reset();
		}

		private function resetButton_triggeredHandler(event:Event):void
		{
			this.reset();
		}
	}
}
