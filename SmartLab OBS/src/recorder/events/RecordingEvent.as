package recorder.events
{
	import flash.events.Event;

	public class RecordingEvent extends Event
	{
		public static const EVENT_RECORDING_STARTED:String="Recording Started";
		public static const EVENT_RECORDING_STOPPED:String="Recording Stopped";
		public static const EVENT_TRANSCODING_FINISHED:String="Transcoding Finished";
		
		public function RecordingEvent(type:String)
		{
			super(type);
		}


	}
}