package game.listeners.game
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.assets.Videos;
	import game.gui.screens.EmotionRateScreen;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.ScreenListener;
	import game.listeners.VideoPlaybackScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class ShowCorrectAnswerListener extends ScreenListener
	{
		public function ShowCorrectAnswerListener(screen:Screen)
		{
			super(screen);
			Main.appendMessage("Starting ShowCorrectAnswer listener");

		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			screen.soundChannel = screen.sound.play();
			screen.soundChannel.addEventListener(Event.SOUND_COMPLETE, showNextButton)
		}
		
		private function showNextButton(event:Event):void
		{
			screen.soundChannel.removeEventListener(Event.SOUND_COMPLETE, showNextButton);
			screen.nextButton.backgroundColor = 0x333333;//0x261C27;
			screen.nextButton.addEventListener(ButtonEvent.CLICK, goToNextScreen);
			screen.nextButton.visible = true;
			screen.nextButton.enabled = true;
		}
		
		private function goToNextScreen(event:ButtonEvent):void
		{
			var video:Video = Main.instance.pickNextVideo();
			var nextScreen:Screen;
			if (video!=null)
			{
				nextScreen = new Screen(Images.getInstance().imageGetReadyToWatch, Sounds.getInstance().soundGameWatch);
				nextScreen.addEventListener(Event.ADDED, new StartGameListener(nextScreen).loaded);
				nextScreen.video1 = video;
			}
			else
			{
				nextScreen = new Screen(Images.getInstance().imageEnd, Sounds.getInstance().soundGameEnd);
				nextScreen.addEventListener(Event.ADDED, new EndGameListener(nextScreen).loaded);
			}
			
			Main.instance.replaceScreen(nextScreen);
		}
	}
}