package game.gui.screens
{
	import flash.events.Event;
	
	import game.players.FlvPlayer;
	
	import model.Video;

	public class VideoPlaybackScreen extends Screen
	{
		private var _videoPlayer:FlvPlayer;
		public function VideoPlaybackScreen(video:Video)
		{
			video1 = video;
			_videoPlayer = new FlvPlayer(video1.url);
			videoPlayer.width = Main.instance.width;
			videoPlayer.height = Main.instance.height;
			addChild(videoPlayer);
		}

		public function get videoPlayer():FlvPlayer
		{
			return _videoPlayer;
		}
		
		
	}
}