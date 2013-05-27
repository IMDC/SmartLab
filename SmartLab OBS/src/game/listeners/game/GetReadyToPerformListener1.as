package game.listeners.game
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.ScreenListener;
	
	import recorder.events.ButtonEvent;

	public class GetReadyToPerformListener1 extends ScreenListener
	{
		private var countDown:Sound = Sounds.getInstance().soundCountdown;
		private var countDownChannel:SoundChannel;
		
		public function GetReadyToPerformListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("Get ready to perform Listener 1");
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			screen.soundChannel = screen.sound.play();
			Main.instance.addEventListener(Main.EVENT_CONNECTED, showNextButton);
			Main.instance.connect();
			Main.instance.setScoreVisible(true);
		}
		
		private function showNextButton(event:Event):void
		{
			Main.instance.removeEventListener(Main.EVENT_CONNECTED, showNextButton);
			screen.soundChannel.removeEventListener(Event.SOUND_COMPLETE, showNextButton);
			screen.nextButton.backgroundColor = 0x33333;
			screen.nextButton.addEventListener(ButtonEvent.CLICK, playCountdownAndGoToNextScreen);
			screen.nextButton.visible = true;
			screen.nextButton.enabled = true;
		}
		
		private function playCountdownAndGoToNextScreen(event:ButtonEvent):void
		{
			screen.nextButton.visible = false;
			screen.nextButton.enabled = false;
			countDownChannel = countDown.play();
			countDownChannel.addEventListener(Event.SOUND_COMPLETE, goToNextScreen)
		}
		
		private function goToNextScreen(event:Event):void
		{
			countDownChannel.removeEventListener(Event.SOUND_COMPLETE, goToNextScreen);
			var videoPlaybackScreen:Screen = new VideoPlaybackScreen(screen.video1);
			videoPlaybackScreen.addEventListener(Event.ADDED_TO_STAGE, new GameVideoRecordListener1(videoPlaybackScreen).loaded);
			Main.instance.replaceScreen(videoPlaybackScreen);
		}
	}
}