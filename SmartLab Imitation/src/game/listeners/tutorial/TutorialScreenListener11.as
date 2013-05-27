package game.listeners.tutorial
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.listeners.ScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class TutorialScreenListener11 extends ScreenListener
	{
		public function TutorialScreenListener11(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 11");
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
			var tutorialScreen12:Screen = new Screen(Images.getInstance().image9, Sounds.getInstance().sound9);
			tutorialScreen12.addEventListener(Event.ADDED, new TutorialScreenListener12(tutorialScreen12, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen12);
		}
	}
}