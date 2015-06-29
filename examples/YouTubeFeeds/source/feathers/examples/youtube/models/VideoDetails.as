package feathers.examples.youtube.models
{
	public class VideoDetails
	{
		public function VideoDetails(title:String = null, author:String = null,
			url:String = null, description:String = null, thumbnailURL:String = null)
		{
			this.title = title;
			this.author = author;
			this.url = url;
			this.description = description;
			this.thumbnailURL = thumbnailURL;
		}

		public var title:String;
		public var author:String;
		public var url:String;
		public var description:String;
		public var thumbnailURL:String;
	}
}
