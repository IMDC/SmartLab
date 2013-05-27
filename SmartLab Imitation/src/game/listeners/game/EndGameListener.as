package game.listeners.game
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.assets.Videos;
	import game.gui.screens.EmotionRateScreen;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.ScreenListener;
	import game.listeners.VideoPlaybackScreenListener;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class EndGameListener extends ScreenListener
	{
		public function EndGameListener(screen:Screen)
		{
			super(screen);
			Main.appendMessage("End Game listener");
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			screen.soundChannel = screen.sound.play();
			//TODO display the score and save all the data and email it/store it on the server
			Main.instance.setScoreVisible(true);
			Main.instance.saveData();
		}
		
		
	}
}