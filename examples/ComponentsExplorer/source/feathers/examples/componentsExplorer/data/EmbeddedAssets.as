package feathers.examples.componentsExplorer.data
{
	import starling.textures.Texture;

	public class EmbeddedAssets
	{
		[Embed(source="/../assets/images/skull.png")]
		private static const SKULL_ICON_DARK_EMBEDDED:Class;

		[Embed(source="/../assets/images/skull-white.png")]
		private static const SKULL_ICON_LIGHT_EMBEDDED:Class;

		public static const SKULL_ICON_DARK:Texture = Texture.fromBitmap(new SKULL_ICON_DARK_EMBEDDED());

		public static const SKULL_ICON_LIGHT:Texture = Texture.fromBitmap(new SKULL_ICON_LIGHT_EMBEDDED());
	}
}
