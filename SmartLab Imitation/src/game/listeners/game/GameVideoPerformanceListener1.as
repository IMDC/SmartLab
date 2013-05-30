package game.listeners.game
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPerformancePlaybackScreen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.VideoPerformancePlaybackScreenListener;
	import game.listeners.VideoPlaybackScreenListener;
	import game.players.FlvPlayer;

	public class GameVideoPerformanceListener1 extends VideoPerformancePlaybackScreenListener
	{
		private var buffer1Full:Boolean = false;
		private var buffer2Full:Boolean = false;
		private var recordingTimer:Timer;
		
		public function GameVideoPerformanceListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("GameVideoPerformanceListener1");
		}
		
		override public function loaded(event:Event):void
		{
			Main.instance.setScoreVisible(false);
			Main.appendMessage("GameVideoPerformanceListener1 loaded");
			screen.removeEventListener(Event.ADDED_TO_STAGE, loaded);
			Main.instance.setLoadingLabelVisible(true, "Loading...");
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.addEventListener("buffer.empty", bufferEmpty1);
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.addEventListener("buffer.full", bufferFull1);
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.addEventListener(ProgressEvent.PROGRESS, onProgress1);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.addEventListener("buffer.empty", bufferEmpty2);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.addEventListener("buffer.full", bufferFull2);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.addEventListener("stream.notFound", streamNotFound);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.addEventListener(ProgressEvent.PROGRESS, onProgress2);
			Main.appendMessage("Registered listeners");
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.resume();
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.pause();
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.resume();
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.pause();
			
			
		}
		
		private function streamNotFound(event:Event):void
		{
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.resume();
			
		}
		
		private function onProgress1(event:ProgressEvent):void
		{
			
			if (event.bytesLoaded==event.bytesTotal)
			{
				buffer1Full = true;
				if (buffer2Full)
				{
					startPlayback();
				}
			}
			
		}
		private function startPlayback():void
		{
			Main.appendMessage("Playback Started");
			Main.instance.setLoadingLabelVisible(false);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.resume();
			recordingTimer = new Timer(300, 1);
			recordingTimer.addEventListener(TimerEvent.TIMER, updateTime);
			recordingTimer.start();
//			(screen as VideoPerformancePlaybackScreen).videoPlayer1.resume();
		}
		
		private function updateTime(event:TimerEvent):void
		{
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.resume();
		}
		
		private function onProgress2(event:ProgressEvent):void
		{
			
			if (event.bytesLoaded==event.bytesTotal)
			{
				buffer2Full = true;
				if (buffer1Full)
				{
					startPlayback();
				}
			}
			
		}
		
		private function bufferEmpty1(event:Event):void
		{
//			loadingIndicator.visible = true;
			Main.appendMessage("BufferEmpty1");
			buffer1Full = false;
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.pause();
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.pause();
		}
		
		private function bufferFull1(event:Event):void
		{
//			loadingIndicator.visible = false;
			Main.appendMessage("BufferFull1");
			buffer1Full = true;
			if (buffer2Full)
			{
				startPlayback();
			}
		}
		
		private function bufferEmpty2(event:Event):void
		{
//			loadingIndicator.visible = true;
			Main.appendMessage("BufferEmpty2");
			buffer2Full = false;
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.pause();
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.pause();
		}
		
		private function bufferFull2(event:Event):void
		{
//			loadingIndicator.visible = false;
			Main.appendMessage("BufferFull2");
			buffer2Full = true;
			if (buffer1Full)
			{
				startPlayback();
			}
		}
		
		override public function videoEnded(event:Event):void
		{
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.removeEventListener("buffer.empty", bufferEmpty1);
			(screen as VideoPerformancePlaybackScreen).videoPlayer1.removeEventListener("buffer.full", bufferFull1);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.removeEventListener("buffer.empty", bufferEmpty2);
			(screen as VideoPerformancePlaybackScreen).videoPlayer2.removeEventListener("buffer.full", bufferFull2);
			Main.appendMessage("Playback done");
			var feedBackScreenNumber:Number = Math.floor((Math.random()*6))+1;
			var feedBackScreen:Screen;
			if (feedBackScreenNumber == 1)
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback1, Sounds.getInstance().soundFeedback1);	
			}
			else if (feedBackScreenNumber == 2)
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback2, Sounds.getInstance().soundFeedback2);
			}
			else if (feedBackScreenNumber == 3)
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback3, Sounds.getInstance().soundFeedback3);
			}
			else if (feedBackScreenNumber == 4)
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback4, Sounds.getInstance().soundFeedback4);
			}
			else if (feedBackScreenNumber == 5)
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback5, Sounds.getInstance().soundFeedback5);
			}
			else 
			{
				feedBackScreen = new Screen(Images.getInstance().imageFeedback6, Sounds.getInstance().soundFeedback6);
			}
			feedBackScreen.video1 = screen.video1;
			Main.instance.setScoreVisible(true);
			feedBackScreen.addEventListener(Event.ADDED, new FeedbackListener(feedBackScreen).loaded);
			Main.instance.replaceScreen(feedBackScreen);
		}
		
	}
}