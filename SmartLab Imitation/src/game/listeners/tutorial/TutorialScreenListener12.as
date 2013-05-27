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

	public class TutorialScreenListener12 extends ScreenListener
	{
		public function TutorialScreenListener12(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen, videoType);
			Main.appendMessage("Tutorial Screen Listener 12");
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
			//10.wav and game_emotion_question.wav are the same
			var tutorialScreen13:Screen; 
			if (this.videoType == Video.TYPE_SONG)
				tutorialScreen13 = new Screen(Images.getInstance().image10B, Sounds.getInstance().sound10);
			else
				tutorialScreen13 = new Screen(Images.getInstance().image10, Sounds.getInstance().sound10);
			tutorialScreen13.addEventListener(Event.ADDED, new TutorialScreenListener13(tutorialScreen13, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen13);
		}
	}
}