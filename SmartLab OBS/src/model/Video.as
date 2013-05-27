package model
{
	public class Video
	{
		public static const TYPE_SPEECH:String = "Speech";  
		public static const TYPE_SONG:String = "Song";
		
		public static const EMOTION_TYPE_HAPPY:String = "Happy";
		public static const EMOTION_TYPE_SAD:String = "Sad";
		public static const EMOTION_TYPE_CALM:String = "Calm";
		public static const EMOTION_TYPE_FEARFUL:String = "Fearful";
		public static const EMOTION_TYPE_ANGRY:String = "Angry";
		public static const EMOTION_TYPE_SURPRISED:String = "Surprised";
		public static const EMOTION_TYPE_DISGUSTED:String = "Disgusted";
		public static const EMOTION_TYPE_NO_EMOTION:String = "Neutral";
		
		
		private var _url:String;
		private var _numberOfTries:Number;
		private var _emotionType:String;
		private var _type:String;
		private var _intensity:Number;
		
		private static const scoreTable:Array = new Array(5, 3, 1, 0);
		
		public function Video(url:String, numberOfTries:Number, emotionType:String, type:String)
		{
			this.url = url;
			this.numberOfTries = numberOfTries;
			this.emotionType = emotionType;
			this.type = type;
		}

		public function get intensity():Number
		{
			return _intensity;
		}

		public function set intensity(value:Number):void
		{
			_intensity = value;
		}

		public function getVideoScore():Number
		{
			return scoreTable[numberOfTries];
		}
		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get emotionType():String
		{
			return _emotionType;
		}

		public function set emotionType(value:String):void
		{
			_emotionType = value;
		}

		public function get numberOfTries():Number
		{
			return _numberOfTries;
		}

		public function set numberOfTries(value:Number):void
		{
			_numberOfTries = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

	}
}