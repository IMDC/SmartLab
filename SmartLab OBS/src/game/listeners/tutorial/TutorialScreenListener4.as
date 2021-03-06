package game.listeners.tutorial
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.Screen;
	import game.listeners.ScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class TutorialScreenListener4 extends ScreenListener
	{
		public function TutorialScreenListener4(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 4");
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
			var tutorialScreen5:Screen;
			if (this.videoType == Video.TYPE_SONG)
				tutorialScreen5= new Screen(Images.getInstance().image5B, Sounds.getInstance().sound5B);
			else
				tutorialScreen5= new Screen(Images.getInstance().image5, Sounds.getInstance().sound5);
			tutorialScreen5.addEventListener(Event.ADDED, new TutorialScreenListener5(tutorialScreen5, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen5);
		}
	}
}