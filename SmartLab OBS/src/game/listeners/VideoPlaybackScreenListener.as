package game.listeners
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.players.FlvPlayer;
	
	import recorder.events.ButtonEvent;

	public class VideoPlaybackScreenListener extends ScreenListener
	{
		public function VideoPlaybackScreenListener(screen:Screen)
		{
			super(screen);
			(screen as VideoPlaybackScreen).videoPlayer.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
		}
		
		override public function loaded(event:Event):void
		{
			(screen as VideoPlaybackScreen).videoPlayer.resume();
		}
		
		public function videoEnded(event:Event):void
		{
			(screen as VideoPlaybackScreen).videoPlayer.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
//			var tutorialScreen2:Screen = new Screen(Images.getInstance().image2B, Sounds.getInstance().sound2B);
//			tutorialScreen2.addEventListener(Event.ADDED, new TutorialScreenListener2(tutorialScreen2).loaded);
//			Main.instance.replaceScreen(tutorialScreen2);
		}
		
	}
}