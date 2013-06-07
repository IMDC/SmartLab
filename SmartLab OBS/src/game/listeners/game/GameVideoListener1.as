package game.listeners.game
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.EmotionRateScreen;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.VideoPlaybackScreenListener;
	import game.players.FlvPlayer;
	
	import recorder.events.ButtonEvent;

	public class GameVideoListener1 extends VideoPlaybackScreenListener
	{
		public function GameVideoListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("GameVideoListener1");
			(screen as VideoPlaybackScreen).videoPlayer.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			(screen as VideoPlaybackScreen).videoPlayer.addEventListener("stream.notFound", streamNotFound);
		}
		
		private function streamNotFound(event:Event):void
		{
			Main.displayPopup("Cannot connect to server, please check your internet connection and reload the page");
		}
		
		override public function loaded(event:Event):void
		{
			Main.instance.setScoreVisible(false);
			screen.removeEventListener(Event.ADDED, loaded);
			(screen as VideoPlaybackScreen).videoPlayer.resume();
		}
		
		override public function videoEnded(event:Event):void
		{
			(screen as VideoPlaybackScreen).videoPlayer.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			var getReadyToPerformScreen:Screen = new Screen(Images.getInstance().imageGetReadyToPerform, Sounds.getInstance().soundGamePerform);
			getReadyToPerformScreen.video1 = screen.video1;
			getReadyToPerformScreen.addEventListener(Event.ADDED, new GetReadyToPerformListener1(getReadyToPerformScreen).loaded);
			Main.instance.replaceScreen(getReadyToPerformScreen);
		}
		
	}
}