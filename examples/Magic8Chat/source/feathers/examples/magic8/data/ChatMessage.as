package feathers.examples.magic8.data
{
	public class ChatMessage
	{
		public static const TYPE_USER:String = "user";
		public static const TYPE_MAGIC_8BALL:String = "magic8Ball";

		public function ChatMessage(type:String, message:String)
		{
			this.type = type;
			this.message = message;
		}

		public var type:String;
		public var message:String;
	}
}
