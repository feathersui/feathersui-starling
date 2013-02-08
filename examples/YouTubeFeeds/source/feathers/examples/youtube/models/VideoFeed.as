package feathers.examples.youtube.models
{
	public class VideoFeed
	{
		public function VideoFeed(name:String = null, url:String = null)
		{
			this.name = name;
			this.url = url;
		}

		public var name:String;
		public var url:String;
	}
}
