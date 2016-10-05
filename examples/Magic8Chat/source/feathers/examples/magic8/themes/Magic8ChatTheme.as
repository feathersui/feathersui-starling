package feathers.examples.magic8.themes
{
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.RelativePosition;
	import feathers.themes.MetalWorksMobileTheme;

	import starling.display.Image;
	import starling.textures.Texture;

	public class Magic8ChatTheme extends MetalWorksMobileTheme
	{
		[Embed(source="/../assets/images/8ball@2x.png")]
		private static const EIGHT_BALL_ICON:Class;

		[Embed(source="/../assets/images/question@2x.png")]
		private static const QUESTION_ICON:Class;

		private static const THEME_STYLE_NAME_MESSAGE_ITEM_RENDERER_LABEL:String = "magic8Ball-message-item-renderer-label";

		public function Magic8ChatTheme()
		{
			super();
		}

		private var eightBallTexture:Texture;
		private var questionTexture:Texture;

		override protected function initializeTextures():void
		{
			super.initializeTextures();
			this.eightBallTexture = Texture.fromEmbeddedAsset(EIGHT_BALL_ICON, false, false, 2);
			this.questionTexture = Texture.fromEmbeddedAsset(QUESTION_ICON, false, false, 2);
		}

		override protected function initializeStyleProviders():void
		{
			super.initializeStyleProviders();
			this.getStyleProviderForClass(DefaultListItemRenderer)
				.setFunctionForStyleName(StyleNames.USER_MESSAGE_ITEM_RENDERER, this.setUserMessageItemRendererStyles);
			this.getStyleProviderForClass(DefaultListItemRenderer)
				.setFunctionForStyleName(StyleNames.EIGHT_BALL_MESSAGE_ITEM_RENDERER, this.setEightBallMessageItemRendererStyles);
			this.getStyleProviderForClass(TextBlockTextRenderer)
				.setFunctionForStyleName(THEME_STYLE_NAME_MESSAGE_ITEM_RENDERER_LABEL, this.setMessageItemRendererLabelStyles);
		}

		private function setUserMessageItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.customLabelStyleName = THEME_STYLE_NAME_MESSAGE_ITEM_RENDERER_LABEL;

			itemRenderer.horizontalAlign = HorizontalAlign.RIGHT;
			itemRenderer.iconPosition = RelativePosition.RIGHT;

			itemRenderer.itemHasIcon = false;
			itemRenderer.defaultIcon = new Image(this.questionTexture);
		}

		private function setEightBallMessageItemRendererStyles(itemRenderer:DefaultListItemRenderer):void
		{
			this.setItemRendererStyles(itemRenderer);

			itemRenderer.customLabelStyleName = THEME_STYLE_NAME_MESSAGE_ITEM_RENDERER_LABEL;

			itemRenderer.itemHasIcon = false;
			itemRenderer.defaultIcon = new Image(this.eightBallTexture);
		}

		private function setMessageItemRendererLabelStyles(text:TextBlockTextRenderer):void
		{
			text.wordWrap = true;
		}
	}
}
