package game.listeners.game
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Timer;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPerformancePlaybackScreen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.VideoPerformancePlaybackScreenListener;
	import game.listeners.VideoPlaybackScreenListener;
	import game.players.FlvPlayer;

	public class GameVideoPerformanceListener1 extends VideoPlaybackScreenListener
	{
		
		public function GameVideoPerformanceListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("GameVideoPerformanceListener1");
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
			Main.appendMessage("Playback done");
			(screen as VideoPlaybackScreen).videoPlayer.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			var feedBackScreen:Screen;
			feedBackScreen = new Screen(Images.getInstance().imageFeedback6, Sounds.getInstance().soundFeedback6);
			feedBackScreen.video1 = screen.video1;
			feedBackScreen.addEventListener(Event.ADDED, new FeedbackListener(feedBackScreen).loaded);
			Main.instance.replaceScreen(feedBackScreen);
		}
		
	}
}