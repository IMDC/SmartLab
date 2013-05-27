package game.listeners.tutorial
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.assets.Videos;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.ScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class TutorialScreenListener5 extends ScreenListener
	{
		public function TutorialScreenListener5(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 5");
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
			screen.nextButton.backgroundColor = 0x33333;
			screen.nextButton.addEventListener(ButtonEvent.CLICK, goToNextScreen);
			screen.nextButton.visible = true;
			screen.nextButton.enabled = true;
		}
		
		private function goToNextScreen(event:ButtonEvent):void
		{
			var video:Video;
			if (this.videoType == Video.TYPE_SONG)
				video= new Video(Videos.VIDEO_TUTORIAL_B, 0, Video.EMOTION_TYPE_HAPPY,Video.TYPE_SONG);
			else
				video= new Video(Videos.VIDEO_TUTORIAL_A, 0, Video.EMOTION_TYPE_HAPPY,Video.TYPE_SPEECH);
			var tutorialScreen6:VideoPlaybackScreen = new VideoPlaybackScreen(video);
			tutorialScreen6.addEventListener(Event.ADDED, new TutorialScreenListener6(tutorialScreen6, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen6);
		}
	}
}