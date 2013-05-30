package game.listeners.game
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.IntensityRateScreen;
	import game.gui.screens.Screen;
	import game.listeners.RateIntensityListener;
	import game.listeners.ScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;
	
	public class RateIntensityListener1 extends RateIntensityListener
	{
		
		
		
		public function RateIntensityListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("Starting RateIntensityListener1");
			
		}
		
		override public function showNextButton(event:Event):void
		{
			screen.soundChannel.removeEventListener(Event.SOUND_COMPLETE, showNextButton);
			screen.nextButton.backgroundColor = 0x33333;
			screen.nextButton.addEventListener(ButtonEvent.CLICK, goToNextScreen);
			screen.nextButton.visible = true;
			screen.nextButton.enabled = true;
		}
		
		private function goToNextScreen(event:ButtonEvent):void
		{
			screen.video1.intensity = (screen as IntensityRateScreen).intensity;
			var greatJobScreen:Screen;
			if (screen.video1.numberOfTries == 0)
			{
				greatJobScreen = new Screen(Images.getInstance().imagePoint5, Sounds.getInstance().soundPoint5);
			}
			else if (screen.video1.numberOfTries == 1)
			{
				greatJobScreen = new Screen(Images.getInstance().imagePoint3, Sounds.getInstance().soundPoint3);
			}
			else if (screen.video1.numberOfTries == 2)
			{
				greatJobScreen = new Screen(Images.getInstance().imagePoint1, Sounds.getInstance().soundPoint1);
			}
			
			Main.instance.addVideoData(Main.instance.videoNumber, screen.video1.url, screen.video1.numberOfTries, screen.video2, screen.video1.emotionType, screen.video1.emotionType,screen.video1.intensity);
			
			greatJobScreen.video1 = screen.video1;
			greatJobScreen.video2 = screen.video2;
			greatJobScreen.addEventListener(Event.ADDED, new GreatJobListener1(greatJobScreen).loaded);
			Main.instance.replaceScreen(greatJobScreen);
			
		}
	}
	
}