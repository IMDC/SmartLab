package game.listeners.game
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPerformancePlaybackScreen;
	import game.listeners.ScreenListener;
	
	import recorder.events.ButtonEvent;

	public class GreatJobListener1 extends ScreenListener
	{
		public function GreatJobListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("GreatJobListener1");
		}
		
		override public function loaded(event:Event):void
		{
			Main.instance.setScoreVisible(true);
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
			var videoPerformancePlaybackScreen:VideoPerformancePlaybackScreen = new VideoPerformancePlaybackScreen(screen.video1, screen.video2);
			videoPerformancePlaybackScreen.addEventListener(Event.ADDED, new GameVideoPerformanceListener1(videoPerformancePlaybackScreen).loaded);
			Main.instance.replaceScreen(videoPerformancePlaybackScreen);
		}
	}
}