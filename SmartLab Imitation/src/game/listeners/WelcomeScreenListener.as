package game.listeners
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.WelcomeScreen;
	import game.listeners.game.StartGameListener;
	import game.listeners.tutorial.TutorialScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class WelcomeScreenListener extends ScreenListener
	{
		private var loginSprite:Sprite;
		private var loginPrompt:TextField;
		private var loginField:TextField;
//		private var loginPasswordPrompt:TextField;
//		private var loginPassword:Sprite;
		private var loginButton:SpriteButton;
		
		private var getDayResponder:Responder;
		
		public function WelcomeScreenListener(screen:WelcomeScreen)
		{
			super(screen);	
			getDayResponder = new Responder(getDaySuccess, getDayFailure);
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			if ((screen as WelcomeScreen).currentState == WelcomeScreen.loginState)
			{
				//play sound and present the login
				Main.appendMessage("Loading login state");
				loadLoginState();
			}
			else
			{
				Main.appendMessage("Loading options state");
				loadChooseOptionsState();
			}
		}
		
		private function loadLoginState():void
		{
			Main.appendMessage("LoginState loading...");
			screen.sound.play();
			loginSprite = new Sprite();
			var width:Number = 300;
			var height:Number = 150;
			loginSprite.graphics.clear();
			loginSprite.graphics.beginFill( 0xA190BC, 1 );
			loginSprite.graphics.drawRect( 0, 0, width, height );
			loginSprite.graphics.endFill();
			
			loginSprite.x = (Main.instance.width-width)/2;
			loginSprite.y = Main.instance.height-height-50;
			
			loginPrompt = new TextField();
			loginPrompt.type = TextFieldType.DYNAMIC;
			loginPrompt.multiline = true;
			loginPrompt.wordWrap= true;
			//tf.autoSize = TextFieldAutoSize.LEFT
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.color = 0xFFFFFF;
			format.size = 24;
			format.font = "Arial"
			loginPrompt.defaultTextFormat = format;
			loginPrompt.text = "Please enter your subject number";
			loginPrompt.mouseEnabled = false;
			loginPrompt.width = width-20;
			loginPrompt.height = 100;
			loginPrompt.y = 10;
			loginPrompt.x = 10;
			loginSprite.addChild(loginPrompt);
			
			
			
			loginField = new TextField();
			loginField.type = TextFieldType.INPUT;
			loginField.background = true;
			loginField.backgroundColor = 0xffffff;
			var format2:TextFormat = new TextFormat();
			format2.align = TextFormatAlign.CENTER;
			format2.size = 32;
			format2.font = "Arial"
			loginField.defaultTextFormat = format2;
			loginField.text = "";
			loginSprite.addChild(loginField);
			loginField.width = 150;
			loginField.height = 50;
			loginField.y = height - loginField.height - 22;
			loginField.x = 40;
			
			loginButton = new SpriteButton(50, 50, "OK");
			var format3:TextFormat = loginButton.label.defaultTextFormat;
			format3.color= 0xFFFFFF;
			loginButton.label.setTextFormat(format3);
			loginButton.backgroundColor=0x3C79CC;
			loginButton.x = width - loginButton.width - 40;
			loginButton.y = height - loginButton.height - 10;
			loginButton.addEventListener(ButtonEvent.CLICK, loginButtonClicked);
			loginSprite.addChild(loginButton);
//			loginPasswordPrompt = new TextField();
//			loginPasswordPrompt.multiline = true;
//			var format1:TextFormat = new TextFormat();
//			format1.align = TextFormatAlign.LEFT;
//			format1.size = 30;
//			format1.font = "Arial"
//			loginPasswordPrompt.defaultTextFormat = format1;
//			loginPasswordPrompt.text = "Please enter your password";
//			loginPasswordPrompt.mouseEnabled = false;
//			loginSprite.addChild(loginPasswordPrompt);
//			loginPasswordPrompt.width = 250;
//			loginPasswordPrompt.height = 70;
//			loginPasswordPrompt.y = 115;
//			loginPasswordPrompt.x = 5;
			
//			screen.nextButton.visible = true;
//			screen.nextButton.enabled = true;
//			screen.nextButton.addEventListener(ButtonEvent.CLICK, login);
			Main.instance.addEventListener(Main.EVENT_VIDEOS_LOADED, displayThings);
			this.screen.addChild(loginSprite);
		}
		
		private function displayThings(event:Event):void
		{
			Main.appendMessage("Song Videos: "+Main.instance.songVideosArray.length);
			if (Main.instance.songVideosArray.length==0)
			{
				(screen as WelcomeScreen).videoType = Video.TYPE_SPEECH;
				(screen as WelcomeScreen).videoTypeLabel.text = Video.TYPE_SPEECH +" videos";
			}
			loadChooseOptionsState();
		}
		
		private function loginButtonClicked(event:ButtonEvent):void
		{
			Main.appendMessage(loginField.text);
			if (loginField.text.length>0 && Number(loginField.text)!=NaN)
			{
				Main.instance.participantID = Number(loginField.text);
				if (Main.instance.netConnection!=null)
				{
					Main.appendMessage("Get DAY");
					if (Main.configurationVariables["day"]==-1)
						Main.instance.netConnection.call("getDay",getDayResponder, ""+Main.instance.participantID);
					else
					{
						Main.instance.day = Number(Main.configurationVariables["day"]);	
						Main.appendMessage("Else Current day for participant " + Main.instance.participantID+ " is " + Number(Main.configurationVariables["day"]));
						this.screen.removeChild(loginSprite);
						if (Main.configurationVariables["type"] == "speech")
						{
							Main.appendMessage("Starting speech videos");
							(this.screen as WelcomeScreen).videoType = Video.TYPE_SPEECH;
							(this.screen as WelcomeScreen).videoTypeLabel.text = ""+Video.TYPE_SPEECH +" videos";
						}
//						loadChooseOptionsState();
					}
				}
				else
				{
					Main.appendMessage("Could not connect!!!");
					Main.displayPopup("Could not connect to the server. Please check your internet connection and reload the page");
				}
			}
			else
			{
				Main.appendMessage("Not con printing stuff because flash is stupid");
			}
		}
		
		private function getDaySuccess(obj:Object):void
		{
			Main.instance.day = Number(obj);	
			Main.appendMessage("Current day for participant " + Main.instance.participantID+ " is " + Number(obj));
			this.screen.removeChild(loginSprite);
			Main.instance.disconnect();
//			loadChooseOptionsState();
		}
		
		private function getDayFailure(obj:Object):void
		{
			Main.appendMessage("Could not get the day. Error is:" + obj);
			Main.instance.day = -1;	
			Main.instance.disconnect();
		}
		
		private function login(event:ButtonEvent):void
		{
			//TODO Check for login credentials
			
			//loadChooseOptionsState
			loadChooseOptionsState();
			screen.nextButton.removeEventListener(ButtonEvent.CLICK, login);
		}
		
		private function loadChooseOptionsState():void
		{
			screen.nextButton.enabled = false;
			screen.nextButton.visible = false;
			
			(screen as WelcomeScreen).dayLabel.text = "Day " +Main.instance.day;
			(screen as WelcomeScreen).videoTypeLabel.visible = true;
			(screen as WelcomeScreen).dayLabel.visible = true;
			var tutorialButton:SpriteButton = new SpriteButton(200,60,"Tutorial");
			tutorialButton.backgroundColor = 0xFFFF00;
			tutorialButton.x = (screen.width-tutorialButton.width)/2;
			tutorialButton.y = screen.height/2- tutorialButton.height*0.6;
				
			var startButton:SpriteButton = new SpriteButton(200,60,"Start");
			startButton.backgroundColor = 0x6699FF;
			startButton.x = (screen.width-startButton.width)/2;
			startButton.y = (screen.height/2 + startButton.height*0.5);
			
			if ((screen as WelcomeScreen).videoType==Video.TYPE_SPEECH)
			{
				Main.instance.switchToSpeechVideos();
				tutorialButton.addEventListener(ButtonEvent.CLICK, tutorialButtonSpeechClicked);
			}
			else
			{
				tutorialButton.addEventListener(ButtonEvent.CLICK, tutorialButtonClicked)
			}
			startButton.addEventListener(ButtonEvent.CLICK, startButtonClicked)
			screen.addChild(tutorialButton);
			screen.addChild(startButton);
		}
		
		private function tutorialButtonSpeechClicked(event:ButtonEvent):void
		{
			var tutorialScreen:Screen = new Screen(Images.getInstance().image1, Sounds.getInstance().sound1);
			tutorialScreen.addEventListener(Event.ADDED, new TutorialScreenListener(tutorialScreen, Video.TYPE_SPEECH).loaded);
			Main.instance.replaceScreen(tutorialScreen);
		}
		
		private function tutorialButtonClicked(event:ButtonEvent):void
		{
			var tutorialScreen:Screen = new Screen(Images.getInstance().image1, Sounds.getInstance().sound1);
			tutorialScreen.addEventListener(Event.ADDED, new TutorialScreenListener(tutorialScreen).loaded);
			Main.instance.replaceScreen(tutorialScreen);
		}
		
		private function startButtonClicked(event:ButtonEvent):void
		{
			var video:Video = Main.instance.pickNextVideo();
			var startScreen:Screen = new Screen(Images.getInstance().imageGetReadyToWatch, Sounds.getInstance().soundGameWatch);
			startScreen.video1 = video;
			startScreen.addEventListener(Event.ADDED, new StartGameListener(startScreen).loaded);
			Main.instance.replaceScreen(startScreen);
			
//			var welcomeScreen:WelcomeScreen = new WelcomeScreen(WelcomeScreen.chooseInitialState, this.videoType); 
//			Main.instance.replaceScreen(welcomeScreen);
//			var startScreen:EmotionRateScreen = new EmotionRateScreen(EmotionRateScreen.RATE_TYPE_SPEECH);
//			startScreen.addEventListener(Event.ADDED, new EmotionRateListener(startScreen).loaded);
//			Main.instance.replaceScreen(startScreen);
		}
		
	}
}