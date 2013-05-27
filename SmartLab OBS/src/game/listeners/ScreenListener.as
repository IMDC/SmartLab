package game.listeners
{
	import flash.events.Event;
	
	import game.gui.screens.Screen;
	
	import model.Video;

	public class ScreenListener
	{
		private var _screen:Screen;
		private var _videoType:String;
		
		public function ScreenListener(screen:Screen, videoType:String = Video.TYPE_SONG)
		{
			this.screen = screen;	
			this.videoType = videoType;
		}
		
		public function get videoType():String
		{
			return _videoType;
		}

		public function set videoType(value:String):void
		{
			_videoType = value;
		}

		public function get screen():Screen
		{
			return _screen;
		}

		public function set screen(value:Screen):void
		{
			_screen = value;
		}

		public function loaded(event:Event):void
		{
			
		}
	}
}