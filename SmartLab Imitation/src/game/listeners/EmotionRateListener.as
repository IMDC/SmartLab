package game.listeners
{
	import flash.events.Event;
	
	import game.gui.screens.EmotionRateScreen;

	public class EmotionRateListener extends ScreenListener
	{
		
		public function EmotionRateListener(screen:EmotionRateScreen)
		{
			super(screen);	
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			screen.soundChannel = screen.sound.play();
			(screen as EmotionRateScreen).addEventListener(EmotionRateScreen.SELECTED_EMOTION_EVENT, emotionSelected);
		}
		
		public function emotionSelected(event:Event):void
		{
			Main.appendMessage("Emotion selected: " + (screen as EmotionRateScreen).selectedEmotion);
		}
		
	}
}