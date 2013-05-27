package game.gui.screens
{
	import flash.events.Event;
	
	import game.players.FlvPlayer;
	
	import model.Video;

	public class VideoPerformancePlaybackScreen extends Screen
	{
		private var _videoPlayer1:FlvPlayer;
		private var _videoPlayer2:FlvPlayer;
		
		public function VideoPerformancePlaybackScreen(video:Video, video2:String)
		{
			video1 = video;
			_videoPlayer1 = new FlvPlayer(video1.url);
			_videoPlayer2 = new FlvPlayer(video2);
			Main.appendMessage("Video2: "+video2);
			videoPlayer1.width = Main.instance.width/2;
			videoPlayer1.scaleY = videoPlayer1.scaleX;
			videoPlayer1.y = (Main.instance.height - videoPlayer1.height)/2;
			videoPlayer2.x=Main.instance.width/2;
			videoPlayer2.width = Main.instance.width/2;
			videoPlayer2.scaleY = videoPlayer2.scaleX;
			videoPlayer2.y = (Main.instance.height - videoPlayer2.height)/2;
			addChild(videoPlayer1);
			addChild(videoPlayer2);
		}

		public function get videoPlayer1():FlvPlayer
		{
			return _videoPlayer1;
		}
		
		public function get videoPlayer2():FlvPlayer
		{
			return _videoPlayer2;
		}
		
		
	}
}