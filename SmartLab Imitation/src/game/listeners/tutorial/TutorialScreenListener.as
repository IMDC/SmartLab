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

	public class TutorialScreenListener extends ScreenListener
	{
		public function TutorialScreenListener(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 1");

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
			var tutorialScreen2:Screen;
			if (this.videoType == Video.TYPE_SONG)
				tutorialScreen2= new Screen(Images.getInstance().image2B, Sounds.getInstance().sound2B);
			else
				tutorialScreen2= new Screen(Images.getInstance().image2, Sounds.getInstance().sound2);
			tutorialScreen2.addEventListener(Event.ADDED, new TutorialScreenListener2(tutorialScreen2, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen2);
		}
	}
}