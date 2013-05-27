package game.listeners.tutorial
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.VideoPlaybackScreenListener;
	import game.players.FlvPlayer;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;

	public class TutorialScreenListener10 extends VideoPlaybackScreenListener
	{
		public function TutorialScreenListener10(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			super(screen);
			this.videoType = videoType;
			Main.appendMessage("Tutorial Screen Listener 10");
			(screen as VideoPlaybackScreen).videoPlayer.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			(screen as VideoPlaybackScreen).videoPlayer.resume();
		}
		
		override public function videoEnded(event:Event):void
		{
			(screen as VideoPlaybackScreen).videoPlayer.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			var tutorialScreen11:Screen = new Screen(Images.getInstance().image8, Sounds.getInstance().sound8);
			tutorialScreen11.addEventListener(Event.ADDED, new TutorialScreenListener11(tutorialScreen11, this.videoType).loaded);
			Main.instance.replaceScreen(tutorialScreen11);
		}
		
	}
}