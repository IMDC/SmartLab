package game.listeners.game
{
	import flash.events.Event;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.assets.Videos;
	import game.gui.SpriteButton;
	import game.gui.screens.EmotionRateScreen;
	import game.gui.screens.Screen;
	import game.gui.screens.VideoPlaybackScreen;
	import game.listeners.VideoPlaybackScreenListener;
	import game.players.FlvPlayer;
	
	import model.Video;
	
	import recorder.events.ButtonEvent;
	import recorder.events.RecordingEvent;

	public class GameVideoRecordListener1 extends VideoPlaybackScreenListener
	{
		public function GameVideoRecordListener1(screen:Screen)
		{
			super(screen);
			Main.appendMessage("Game Video Record Listener 1");
			(screen as VideoPlaybackScreen).videoPlayer.addEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			Main.instance.setScoreVisible(false);
			connected();
		
			//(screen as VideoPlaybackScreen).videoPlayer.resume();
			
			//TODO record the video here!
		}
		
		private function connected(event:Event = null):void
		{
			Main.instance.removeEventListener(Main.EVENT_CONNECTED, connected);
			Main.instance.cameraControlsListener.addEventListener(RecordingEvent.EVENT_RECORDING_STARTED, recordingStarted);
			Main.instance.cameraControlsListener.addEventListener(RecordingEvent.EVENT_RECORDING_STOPPED, recordingStopped);
			Main.instance.cameraControlsListener.addEventListener(RecordingEvent.EVENT_TRANSCODING_FINISHED, transcodingFinished);
			Main.instance.cameraControlsListener.record();		
//			(screen as VideoPlaybackScreen).videoPlayer.resume();
		}
		
		public function recordingStarted(event:RecordingEvent):void
		{
			Main.instance.cameraControlsListener.removeEventListener(RecordingEvent.EVENT_RECORDING_STARTED, recordingStarted);
			(screen as VideoPlaybackScreen).videoPlayer.resume();
		}
		
		public function recordingStopped(event:RecordingEvent):void
		{
			Main.instance.cameraControlsListener.removeEventListener(RecordingEvent.EVENT_RECORDING_STOPPED, recordingStopped);
			Main.instance.cameraControlsListener.transcode(Main.instance.participantID,Main.instance.day, Main.instance.videoNumber, screen.video1.numberOfTries);
		}
		
		public function transcodingFinished(event:RecordingEvent):void
		{
			//Go to the next screen and pick the appropriate video type - Speech or Song
			Main.instance.cameraControlsListener.removeEventListener(RecordingEvent.EVENT_TRANSCODING_FINISHED, transcodingFinished);
			Main.instance.setLoadingLabelVisible(false, "Done");

			var rateEmotionScreen:EmotionRateScreen = new EmotionRateScreen(screen.video1);
			rateEmotionScreen.video2 = Main.instance.cameraControlsListener.resultingVideoFile;
			rateEmotionScreen.addEventListener(Event.ADDED, new EmotionRateListener1(rateEmotionScreen).loaded);
			Main.instance.disconnect();
			Main.instance.replaceScreen(rateEmotionScreen);
		}
		
		override public function videoEnded(event:Event):void
		{
			(screen as VideoPlaybackScreen).videoPlayer.removeEventListener(FlvPlayer.END_OF_VIDEO_EVENT, videoEnded);
			//TODO Stop recording here! get the recorded video url and save it as video2.
			Main.instance.cameraControlsListener.stopRecording();	
			Main.instance.setLoadingLabelVisible(true, "Uploading video...");
			
		}
		
	}
}