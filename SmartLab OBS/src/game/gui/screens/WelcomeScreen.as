package game.gui.screens
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.listeners.WelcomeScreenListener;
	
	import model.Video;

	public class WelcomeScreen extends Screen
	{
		public static const loginState:Number = 0;  
		public static const chooseInitialState:Number = 1;
		private var _videoType:String;
		private var _videoTypeLabel:TextField;
		private var _dayLabel:TextField;
		private var welcomeLabel:TextField;
		
		
		private var _currentState:Number = 0;
		public function WelcomeScreen(state:Number=loginState, videoType:String = Video.TYPE_SONG)
		{
			Main.appendMessage("Initializing welcome screen");
			super(Images.getInstance().imageBalloons);
			this.videoType = videoType;
			currentState = state;
			this.addEventListener(Event.ADDED, new WelcomeScreenListener(this).loaded);
			
			videoTypeLabel = new TextField();
			videoTypeLabel.type = TextFieldType.DYNAMIC;
			var format:TextFormat = new TextFormat();
			videoTypeLabel.multiline = true;
			videoTypeLabel.wordWrap= true;
			videoTypeLabel.visible =false;
			format.align = TextFormatAlign.LEFT;
			format.color = 0x000000;
			format.size = 18;
			format.font = "Arial"
			videoTypeLabel.defaultTextFormat = format;
			videoTypeLabel.text = ""+videoType +" videos";
			videoTypeLabel.mouseEnabled = false;
			videoTypeLabel.width = 100;//-20;
			videoTypeLabel.height = 100;
			videoTypeLabel.y = 10;
			videoTypeLabel.x = 10;
			
						
			dayLabel = new TextField();
			dayLabel.type = TextFieldType.DYNAMIC;
			var format1:TextFormat = new TextFormat();
			dayLabel.multiline = true;
			dayLabel.wordWrap= true;
			dayLabel.visible =false;
			format1.align = TextFormatAlign.LEFT;
			format1.color = 0x000000;
			format1.size = 18;
			format1.font = "Arial"
			dayLabel.defaultTextFormat = format1;
//			dayLabel.text = "Day "+Main.instance.day;
			dayLabel.mouseEnabled = false;
			dayLabel.width = 100;//-20;
			dayLabel.height = 100;
			dayLabel.y = 10;
			dayLabel.x = Main.instance.width - dayLabel.width -10;
			
			welcomeLabel = new TextField();
			welcomeLabel.type = TextFieldType.DYNAMIC;
			var format3:TextFormat = new TextFormat();
			welcomeLabel.multiline = true;
			welcomeLabel.wordWrap= true;
			format3.align = TextFormatAlign.CENTER;
			format3.color = 0x000000;
			format3.size = 24;
			format3.font = "Arial"
			welcomeLabel.defaultTextFormat = format3;
			welcomeLabel.text = "Welcome to the Emotion game";
			welcomeLabel.mouseEnabled = false;
			welcomeLabel.width = 180;//-20;
			welcomeLabel.height = 100;
			welcomeLabel.y = 10;
			welcomeLabel.x = (Main.instance.width - welcomeLabel.width)/2;
			
			this.addChild(dayLabel);
			
			this.addChild(videoTypeLabel);

			this.addChild(welcomeLabel);
		}

		public function get dayLabel():TextField
		{
			return _dayLabel;
		}

		public function set dayLabel(value:TextField):void
		{
			_dayLabel = value;
		}

		public function get videoTypeLabel():TextField
		{
			return _videoTypeLabel;
		}

		public function set videoTypeLabel(value:TextField):void
		{
			_videoTypeLabel = value;
		}

		public function get videoType():String
		{
			return _videoType;
		}

		public function set videoType(value:String):void
		{
			_videoType = value;
		}

		public function get currentState():Number
		{
			return _currentState;
		}

		public function set currentState(value:Number):void
		{
			_currentState = value;
		}

	}
}