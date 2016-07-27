package feathers.examples.tabs.screens
{
	import feathers.controls.GroupedList;
	import feathers.controls.ImageLoader;
	import feathers.controls.PanelScreen;
	import feathers.controls.renderers.DefaultGroupedListItemRenderer;
	import feathers.controls.renderers.IGroupedListItemRenderer;
	import feathers.data.HierarchicalCollection;
	import feathers.examples.tabs.themes.StyleNames;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.utils.textures.TextureCache;

	import flash.display3D.textures.Texture;

	public class ContactsScreen extends PanelScreen
	{
		public function ContactsScreen()
		{
			this.title = "Contacts";
		}

		private var _list:GroupedList;
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

			this._list = new GroupedList();
			this._list.layoutData = new AnchorLayoutData(0, 0, 0, 0);
			this._list.customItemRendererStyleName = StyleNames.MESSAGE_LIST_ITEM_RENDERER;
			this._list.itemRendererFactory = this.createContactItemRenderer;
			this.addChild(this._list);

			this._list.dataProvider = new HierarchicalCollection(
			[
				{
					header: "A",
					children:
					[
						{
							name: "Andy Johnston",
							email: "itsandy1981@example.com",
							photo: "https://randomuser.me/api/portraits/men/92.jpg"
						},
					]
				},
				{
					header: "D",
					children:
					[
						{
							name: "Denise Kim",
							email: "kim.denise@example.com",
							photo: "https://randomuser.me/api/portraits/women/83.jpg"
						},
						{
							name: "Dylan Curtis",
							email: "curtis1987@example.com",
							photo: "https://randomuser.me/api/portraits/men/87.jpg"
						},
					]
				},
				{
					header: "P",
					children: 
					[
						{
							name: "Pat Brewer",
							email: "pbrewer19@example.com",
							photo: "https://randomuser.me/api/portraits/women/79.jpg"
						},
						{
							name: "Pearl Boyd",
							email: "pearl.boyd@example.com",
							photo: "https://randomuser.me/api/portraits/women/69.jpg"
						},
					]
				},
				{
					header: "R",
					children:
					[
						{
							name: "Robin Taylor",
							email: "robintaylor@example.com",
							photo: "https://randomuser.me/api/portraits/women/89.jpg"
						},
					]
				},
				{
					header: "S",
					children:
					[
						{
							name: "Savannah Flores",
							email: "saflo79@example.com",
							photo: "https://randomuser.me/api/portraits/women/53.jpg"
						},
					]
				},
				{
					header: "W",
					children:
					[
						{
							name: "Wayne Adams",
							email: "superwayne@example.com",
							photo: "https://randomuser.me/api/portraits/men/36.jpg"
						},
					]
				},
			]);
		}

		private function createContactItemRenderer():IGroupedListItemRenderer
		{
			var itemRenderer:DefaultGroupedListItemRenderer = new DefaultGroupedListItemRenderer();
			itemRenderer.labelField = "name";
			itemRenderer.accessoryLabelField = "email";
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
