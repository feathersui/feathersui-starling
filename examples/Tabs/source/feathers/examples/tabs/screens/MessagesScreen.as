package feathers.examples.tabs.screens
{
	import feathers.controls.ImageLoader;
	import feathers.controls.List;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.examples.tabs.themes.StyleNames;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.utils.textures.TextureCache;

	public class MessagesScreen extends PanelScreen
	{
		public function MessagesScreen()
		{
			this.title = "Messages";
		}

		private var _list:List;
		private var _cache:TextureCache;

		override public function dispose():void
		{
			if(this._cache !== null)
			{
				this._cache.dispose();
				this._cache = null;
			}
			super.dispose();
		}

		override protected function initialize():void
		{
			super.initialize();

			this._cache = new TextureCache(10);

			this.layout = new AnchorLayout();

			this._list = new List();
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.customItemRendererStyleName = StyleNames.MESSAGE_LIST_ITEM_RENDERER;
			this._list.itemRendererFactory = this.createMessageItemRenderer;
			this.addChild(this._list);

			this._list.dataProvider = new ListCollection(
			[
				{
					name: "Patsy Brewer",
					message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
					photo: "https://randomuser.me/api/portraits/women/79.jpg"
				},
				{
					name: "Wayne Adams",
					message: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
					photo: "https://randomuser.me/api/portraits/men/36.jpg"
				},
				{
					name: "Andy Johnston",
					message: "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
					photo: "https://randomuser.me/api/portraits/men/92.jpg"
				},
				{
					name: "Pearl Boyd",
					message: "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
					photo: "https://randomuser.me/api/portraits/women/69.jpg"
				},
			]);
		}

		private function createMessageItemRenderer():IListItemRenderer
		{
			var itemRenderer:DefaultListItemRenderer = new DefaultListItemRenderer();
			itemRenderer.labelField = "name";
			itemRenderer.accessoryLabelField = "message";
			itemRenderer.iconSourceField = "photo";
			itemRenderer.iconLoaderFactory = this.createPhotoLoader;
			return itemRenderer;
		}

		private function createPhotoLoader():ImageLoader
		{
			var loader:ImageLoader = new ImageLoader();
			loader.textureCache = this._cache;
			return loader;
		}
	}
}
