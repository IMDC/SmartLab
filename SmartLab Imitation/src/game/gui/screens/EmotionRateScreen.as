package game.gui.screens
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class EmotionRateScreen extends Screen
	{
		
		public static const SELECTED_EMOTION_EVENT:String = "SELECTED EMOTION";
		
		private var _selectedEmotion:String;
		private var buttonsArray:Array;
		
		public function EmotionRateScreen(video:Video=null)
		{
			Main.appendMessage("Initializing EmotionRate screen");
			this.video1 = video;
			this.sound = Sounds.getInstance().soundGameEmotionQuestion;
			
			var buttonHeight:Number = 40;
			var buttonWidth:Number = 200;
			
			buttonsArray = new Array();
			var label:TextField = new TextField();
			label.selectable = false;
			label.type = TextFieldType.DYNAMIC;
			label.mouseEnabled = false;
			label.tabEnabled = false;
			
			label.height = 80;
			label.width = 650;
			var format:TextFormat = new TextFormat();
			//	format.align = TextFormatAlign.CENTER;
			format.size = 40;
			label.defaultTextFormat = format;
			label.text = "Which emotion was the person feeling?";
			label.x = 20;
			label.y = 20;
			this.addChild(label);
			
			var yCoordinate:Number = 80;
			
			var happyButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Happy");
			happyButton.backgroundColor = 0xFFFF00;
			happyButton.x = (this.width-happyButton.width)/2;
			happyButton.addEventListener(ButtonEvent.CLICK, happyButtonClicked);
			buttonsArray.push(happyButton);
			
			var sadButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Sad");
			sadButton.backgroundColor = 0xD58E55;
			sadButton.x = (this.width-sadButton.width)/2;
			sadButton.addEventListener(ButtonEvent.CLICK, sadButtonClicked);
			buttonsArray.push(sadButton);
			
			var calmButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Calm");
			calmButton.backgroundColor = 0xCCFFCC;
			calmButton.x = (this.width-calmButton.width)/2;
			calmButton.addEventListener(ButtonEvent.CLICK, calmButtonClicked);
			buttonsArray.push(calmButton);
			
			var fearfulButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Fearful");
			fearfulButton.backgroundColor = 0x3C9377;
			fearfulButton.x = (this.width-fearfulButton.width)/2;
			fearfulButton.addEventListener(ButtonEvent.CLICK, fearfulButtonClicked);
			buttonsArray.push(fearfulButton);
			
			var angryButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Angry");
			angryButton.backgroundColor = 0xFF0000;
			angryButton.x = (this.width-angryButton.width)/2;
			angryButton.addEventListener(ButtonEvent.CLICK, angryButtonClicked);
			buttonsArray.push(angryButton);
			
			var surprisedButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Surprised");
			surprisedButton.backgroundColor = 0xC7A2B3;
			surprisedButton.x = (this.width-surprisedButton.width)/2;
			surprisedButton.addEventListener(ButtonEvent.CLICK, surprisedButtonClicked);
			if (video.type==Video.TYPE_SPEECH)
				buttonsArray.push(surprisedButton);
			
			var disgustedButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"Disgusted");
			disgustedButton.backgroundColor = 0x548A94;
			disgustedButton.x = (this.width-disgustedButton.width)/2;
			disgustedButton.addEventListener(ButtonEvent.CLICK, disgustedButtonClicked);
			if (video.type==Video.TYPE_SPEECH)
				buttonsArray.push(disgustedButton);
			
			var noEmotionButton:SpriteButton = new SpriteButton(buttonWidth,buttonHeight,"No Emotion");
			noEmotionButton.backgroundColor = 0xA6A6A6;
			noEmotionButton.x = (this.width-noEmotionButton.width)/2;
			noEmotionButton.addEventListener(ButtonEvent.CLICK, noEmotionButtonClicked);
			buttonsArray.push(noEmotionButton);
			
			for (var i:Number=0;i<buttonsArray.length; i++)
			{
				(buttonsArray[i] as SpriteButton).y = yCoordinate;
				yCoordinate+= (buttonsArray[i] as SpriteButton).height;
				this.addChild((buttonsArray[i] as SpriteButton));
			}
			
			this.graphics.clear();
			this.graphics.beginFill( 0xFFFFFF, 1);
			this.graphics.drawRect( 0, 0, Main.configurationVariables["width"], Main.configurationVariables["height"]);
			this.graphics.endFill();
		}

		public function get selectedEmotion():String
		{
			return _selectedEmotion;
		}

		private function happyButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_HAPPY;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function sadButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_SAD;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function calmButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_CALM;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function fearfulButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_FEARFUL;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function angryButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_ANGRY;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function surprisedButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_SURPRISED;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function disgustedButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_DISGUSTED;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		
		private function noEmotionButtonClicked(event:ButtonEvent):void
		{
			_selectedEmotion = Video.EMOTION_TYPE_NO_EMOTION;
			dispatchEvent(new Event(SELECTED_EMOTION_EVENT));
		}
		

	}
}