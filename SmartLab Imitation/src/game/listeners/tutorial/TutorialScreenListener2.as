package game.listeners.tutorial
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.Screen;
	import game.listeners.ScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class TutorialScreenListener2 extends ScreenListener
	{
		public function TutorialScreenListener2(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 2");
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
			var tutorialScreen3:Screen;
			if (this.videoType == Video.TYPE_SONG)
				tutorialScreen3 = new Screen(Images.getInstance().image3B, Sounds.getInstance().sound3B);	
			else
				tutorialScreen3 = new Screen(Images.getInstance().image3, Sounds.getInstance().sound3);
			tutorialScreen3.addEventListener(Event.ADDED, new TutorialScreenListener3(tutorialScreen3, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen3);
		}
	}
}