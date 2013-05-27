package game.listeners
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPerformancePlaybackScreen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.players.FlvPlayer;
	
	import recorder.events.ButtonEvent;

	public class VideoPerformancePlaybackScreenListener extends ScreenListener
	{
		public function VideoPerformancePlaybackScreenListener(screen:Screen)
		{
			super(screen);
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
		}
		
		override public function loaded(event:Event):void
		{
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.resume();
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.resume();
		}
		
		public function videoEnded(event:Event):void
		{
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
		}
		
	}
}