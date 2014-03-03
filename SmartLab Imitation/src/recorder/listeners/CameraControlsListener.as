package recorder.listeners
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.getClassByAlias;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	import mx.controls.Button;
	
	import recorder.events.ButtonEvent;
	import recorder.events.CameraReadyEvent;
	import recorder.events.MicrophoneReadyEvent;
	import recorder.events.RecordingEvent;
	import recorder.gui.CameraViewer;
	import recorder.model.CameraMicSource;
	
	public class CameraControlsListener  extends EventDispatcher
	{
//		public static const MAX_RECORDING_TIME:Number = 60000; //Maximum recording time in milliseconds
		
		private var previewing:Boolean;
		private var netConnection:NetConnection;
		private var startRecordingResponder:Responder;
		private var stopRecordingCameraResponder:Responder;
		private var stopRecordingAudioResponder:Responder;
		private var stopRecordingCombinedResponder:Responder;
		private var transcodeVideoResponder:Responder;
		private var camera:Camera;
		private var microphone:Microphone;
		private var cameraNetStream:NetStream;
		private var audioNetStream:NetStream;
		private var combinedNetStream:NetStream;
		private var streamName:String;
		private var flushTimerCamera:Timer;
		private var flushTimerAudio:Timer;
		
		private var flushTimerCombined:Timer;
		
		private var cameraRecording:Boolean;
		private var audioRecording:Boolean;
		private var streamNameResponder:Responder;
		private var recordingTimer:Timer;
		private var recordingCameraStartTime:Number;
		private var recordingAudioStartTime:Number;
		private var realFileNameVideo:String;
		private var realFileNameAudio:String;
		private var _resultingVideoFile:String;
		private var doneRecording:Boolean;
		private var urlLoader:URLLoader;
		private var totalBytesForUploading:Number;
		
		private var _audioDelay:Number = 0;
		
		private const DELETE_TIMER_DELAY:Number = 5 * 60 * 1000; //5 minutes
		private const RECORDING_CAMERA:int = 1;
		private const RECORDING_AUDIO:int = 0;
		private const RECORDING_COMBINED:int = 2;
		private const SUFFIX_AUDIO:String = "_audio";
		private const SUFFIX_CAMERA:String = "_video";
		private const SUFFIX_COMBINED:String = "_combined";
		
		public const STREAMS_DIRECTORY:String = "http://imdc.ca/~martin/smartlab/streams/";
		
		public function CameraControlsListener(nc:NetConnection)
		{
			netConnection = nc;
			startRecordingResponder = new Responder(startRecordingSuccess, startStopRecordingFailure);
			stopRecordingCameraResponder = new Responder(stopRecordingCameraSuccess, startStopRecordingFailure);
			stopRecordingAudioResponder = new Responder(stopRecordingAudioSuccess, startStopRecordingFailure);
			stopRecordingCombinedResponder = new Responder(stopRecordingCombinedSuccess, startStopRecordingFailure);
			streamNameResponder = new Responder(streamNameResult, streamNameStatus);
			transcodeVideoResponder = new Responder(transcodeVideoSuccess, transcodeVideoFailure);
			cameraRecording = false;
			previewing = false;
			doneRecording = true;
		}
		
		public function get audioDelay():Number
		{
			return _audioDelay;
		}

		public function set audioDelay(value:Number):void
		{
			_audioDelay = value;
		}

		public function get resultingVideoFile():String
		{
			return _resultingVideoFile;
		}

		public function set resultingVideoFile(value:String):void
		{
			_resultingVideoFile = value;
		}

		public function record(event:RecordingEvent=null):void
		{
			if (cameraNetStream==null)
			{
				cameraNetStream = CameraMicSource.getInstance().getCameraStream(netConnection);
			}
//			if (audioNetStream==null)
//			{
//				audioNetStream = CameraMicSource.getInstance().getAudioStream(netConnection);
//				audioNetStream.close();
//				audioNetStream = null;
//			}
			combinedNetStream = cameraNetStream;
			
//			combinedNetStream.attachAudio(CameraMicSource.getInstance().microphone);
//			netStream.bufferTime = 60;
			var h264Settings:H264VideoStreamSettings = new H264VideoStreamSettings();
			h264Settings.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_3);
			h264Settings.setQuality(0, 100);
			
			
			combinedNetStream.videoStreamSettings = h264Settings;
			combinedNetStream.addEventListener(NetStatusEvent.NET_STATUS, onCombinedRecStreamStatus);
			
//			cameraNetStream.videoStreamSettings = h264Settings;
//			
//			cameraNetStream.addEventListener(NetStatusEvent.NET_STATUS, onCameraRecStreamStatus);
//			
//			audioNetStream.addEventListener(NetStatusEvent.NET_STATUS, onAudioRecStreamStatus);
			
			netConnection.call("generateStream", streamNameResponder);
		}
		
		private function onCombinedRecStreamStatus(event:NetStatusEvent):void
		{
			trace ("VIDEO: " + event.info.code);
			if ( event.info.code == "NetStream.Publish.Start" )
			{
				cameraRecording = true;
				audioRecording = true;
				netConnection.call("record", startRecordingResponder, streamName, RECORDING_COMBINED);
				recordingCameraStartTime = new Date().time;
				//				recordingTimer = new Timer(200, 0);
				//				recordingTimer.addEventListener(TimerEvent.TIMER, updateTime);
				//				recordingTimer.start();
			}
		}
		
		
		private function onCameraRecStreamStatus(event:NetStatusEvent):void
		{
			trace ("VIDEO: " + event.info.code);
			if ( event.info.code == "NetStream.Publish.Start" )
			{
				cameraRecording = true;
				netConnection.call("record", startRecordingResponder, streamName, RECORDING_CAMERA);
				recordingCameraStartTime = new Date().time;
//				recordingTimer = new Timer(200, 0);
//				recordingTimer.addEventListener(TimerEvent.TIMER, updateTime);
//				recordingTimer.start();
			}
		}
		
		private function onAudioRecStreamStatus(event:NetStatusEvent):void
		{
			trace ("AUDIO: " + event.info.code);
			if ( event.info.code == "NetStream.Publish.Start" )
			{
				audioRecording = true;
				netConnection.call("record", startRecordingResponder, streamName, RECORDING_AUDIO);
				recordingAudioStartTime = new Date().time;
//				recordingTimer = new Timer(200, 0);
//				recordingTimer.addEventListener(TimerEvent.TIMER, updateTime);
//				recordingTimer.start();
			}
			
		}
		
		public function stopRecording(event:RecordingEvent=null):void
		{
			//recordButton = (RecordButton)(event.target);
//			uploadProgressText("Uploading...");
//			setBlur(true);
//			recordingTimer.stop();
//			recordingTimer = null;
			
//			totalBytesForUploading = cameraNetStream.bufferLength + audioNetStream.bufferLength;
			totalBytesForUploading = combinedNetStream.bufferLength;
			
			
			flushTimerCombined = new Timer(100, 0);
			flushTimerCombined.addEventListener(TimerEvent.TIMER, bufferCheckerCombined);
			flushTimerCombined.start();
			
//			flushTimerCamera = new Timer(100, 0);
//			flushTimerCamera.addEventListener(TimerEvent.TIMER, bufferCheckerCamera);
//			flushTimerCamera.start();
//			
//			flushTimerAudio = new Timer(100, 0);
//			flushTimerAudio.addEventListener(TimerEvent.TIMER, bufferCheckerAudio);
//			flushTimerAudio.start();
			
			combinedNetStream.pause();
			combinedNetStream.attachCamera(null);
			combinedNetStream.attachAudio(null);
//			cameraNetStream.pause();
//			cameraNetStream.attachCamera(null);
//			cameraNetStream.attachAudio(null);
//			
//			audioNetStream.pause();
//			audioNetStream.attachCamera(null);
//			audioNetStream.attachAudio(null);
			
			Main.appendMessage("Recording stopped. Video is uploading...");
		}
		
		private function bufferCheckerCombined(event:TimerEvent):void
		{
			if (combinedNetStream.bufferLength == 0)
			{
				trace("Buffer cleared");
				flushTimerCombined.stop();
				flushTimerCombined = null;
				
				netConnection.call("stopRecording", stopRecordingCombinedResponder, streamName, RECORDING_COMBINED);
				combinedNetStream.close();
				combinedNetStream = null;
				//See startStopRecordingSuccess for enabling buttons etc.
				
				//				(CameraControlsPanel)(event.target).setRecordingButtonEnabled(true);
				
			}
			else
			{
				var remainingBytesForUploading:Number;
				remainingBytesForUploading = combinedNetStream.bufferLength;
				uploadProgressText(""+Math.round((totalBytesForUploading - remainingBytesForUploading)/totalBytesForUploading * 100));
				
				var percentDone:Number = Math.round((totalBytesForUploading - remainingBytesForUploading)/totalBytesForUploading * 100);
			}
		}
		
		private function bufferCheckerCamera(event:TimerEvent):void
		{
			if (cameraNetStream.bufferLength == 0)
			{
				trace("Buffer cleared");
				flushTimerCamera.stop();
				flushTimerCamera = null;
				
				netConnection.call("stopRecording", stopRecordingCameraResponder, streamName, RECORDING_CAMERA);
				cameraNetStream.close();
				cameraNetStream = null;
				//See startStopRecordingSuccess for enabling buttons etc.
				
//				(CameraControlsPanel)(event.target).setRecordingButtonEnabled(true);
				
			}
			else
			{
				var remainingBytesForUploading:Number;
				if (audioNetStream!=null)
					remainingBytesForUploading = (cameraNetStream.bufferLength + audioNetStream.bufferLength);
				else
					remainingBytesForUploading = cameraNetStream.bufferLength;
				uploadProgressText(""+Math.round((totalBytesForUploading - remainingBytesForUploading)/totalBytesForUploading * 100));
				
				var percentDone:Number = Math.round((totalBytesForUploading - remainingBytesForUploading)/totalBytesForUploading * 100);
			}
		}
		
		private function bufferCheckerAudio(event:TimerEvent):void
		{
			if (audioNetStream.bufferLength == 0)
			{
				trace("Buffer cleared");
				flushTimerAudio.stop();
				flushTimerAudio = null;
				
				netConnection.call("stopRecording", stopRecordingAudioResponder, streamName, RECORDING_AUDIO);
				audioNetStream.close();
				audioNetStream = null;
				//See startStopRecordingSuccess for enabling buttons etc.
				
				//				(CameraControlsPanel)(event.target).setRecordingButtonEnabled(true);
				
				
			}
			else
			{
				var remainingBytesForUploading:Number;
				if (cameraNetStream!=null)
					remainingBytesForUploading = (cameraNetStream.bufferLength + audioNetStream.bufferLength);
				else
					remainingBytesForUploading = audioNetStream.bufferLength;
				uploadProgressText(""+Math.round((totalBytesForUploading - remainingBytesForUploading)/totalBytesForUploading * 100));
			}
		}
		
		/**
		 * This function gets called after we have received a stream name to use and can now start recording
		 */
		private function streamNameResult(obj:Object):void
		{
			//FIXME gives the same name except for the last part which is generated on the server :(
			streamName = obj.toString();
			
//			cameraNetStream.publish(streamName+SUFFIX_CAMERA, "live");
//			audioNetStream.publish(streamName+SUFFIX_AUDIO, "live");
			combinedNetStream.publish(streamName+SUFFIX_COMBINED, "live");
			//	Main.appendMessage("Recording started to file: "+obj.toString()+".flv");
//			}
			trace("Result is:"+obj);
		}
		
		private function streamNameStatus(obj:Object):void
		{
			for (var i:Object in obj)
			{
				trace("Status: " + i + " : "+obj[i]);
			}
		}
		
		private function startRecordingSuccess(obj:Object):void
		{
			if (cameraRecording && audioRecording)
			{
				
				doneRecording = false;
				Main.appendMessage("Recording started");
				//call the javascript function that recording has started
				var event:RecordingEvent = new RecordingEvent(RecordingEvent.EVENT_RECORDING_STARTED);
				dispatchEvent(event);
//				ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingStartedCallback"]);
			}
			
		}
		
		private function stopRecordingCombinedSuccess(obj:Object):void
		{
			cameraRecording = false;
			audioRecording = false;
			//recording stopped - returns filename of recording
			realFileNameVideo = obj.toString();
			trace("Recording stopped");
			//Enable the buttons
			Main.appendMessage("Video Uploading finished.");
			
			trace("StopRecordingCombined Success:"+obj);
			var event:RecordingEvent = new RecordingEvent(RecordingEvent.EVENT_RECORDING_STOPPED);
			dispatchEvent(event);
			
		}
		
		private function stopRecordingCameraSuccess(obj:Object):void
		{
				cameraRecording = false;
				//recording stopped - returns filename of recording
				realFileNameVideo = obj.toString();
				trace("Recording stopped");
				//Enable the buttons
				Main.appendMessage("Video Uploading finished.");
				
				trace("StopRecordingCamera Success:"+obj);
				if (!audioRecording)
				{
//					setBlur(false);
//					uploadProgressText("");
//					transcode();
					var event:RecordingEvent = new RecordingEvent(RecordingEvent.EVENT_RECORDING_STOPPED);
					dispatchEvent(event);
//					ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingStoppedCallback"],true);
				}

		}
		
		
		
		private function stopRecordingAudioSuccess(obj:Object):void
		{
				audioRecording = false;
				//recording stopped - returns filename of recording
				realFileNameAudio = obj.toString();
				trace("Recording stopped");
				//Enable the buttons
				Main.appendMessage("Audio Uploading finished.");
				trace("StopRecordingAudio Success:"+obj);
				if (!cameraRecording)
				{
//					transcode();
//					setBlur(false);
//					setBlurText("");
					
					var event:RecordingEvent = new RecordingEvent(RecordingEvent.EVENT_RECORDING_STOPPED);
					dispatchEvent(event);
//					ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingStoppedCallback"],true);
				}

		}
		//FIXME Make this WEBM Only due to GPL/non-redistributable restrictions
		public function transcode(participantID:Number,day:Number, videoNumber:Number, numberOfTries:Number):void
		{
			netConnection.call("cancelDeleteTimer",null, streamName);
//			uploadProgressText("Converting video...");
//			setBlur(true);
			//Only use mp4 as video codec
			var supportedVideoType:String = "mp4";
//			audioDelay = recordingCameraStartTime - recordingAudioStartTime;
			audioDelay = 0;
			netConnection.call("transcodeVideo",transcodeVideoResponder, streamName, audioDelay, supportedVideoType, ""+participantID, "" + day, ""+videoNumber,""+numberOfTries, true);	
		}
		
		private function startStopRecordingFailure(obj:Object):void
		{
			Main.appendMessage("Recording failed!");
			for (var i:Object in obj)
			{
				Main.appendMessage("Status: " + i + " : "+obj[i]);
				trace("Status: " + i + " : "+obj[i]);
			}
//			ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingStoppedCallback"], false);
//			setBlur(false);
		}
		
		private function transcodeVideoSuccess(obj:Object):void
		{
			var fileName:String = obj.toString();
			Main.appendMessage("Transcoding successfull. File: " +fileName);
			//startDeleteTimer(RECORDING_COMBINED);
			resultingVideoFile = STREAMS_DIRECTORY+Main.instance.participantID+"/"+Main.instance.day+"/"+fileName;
//			setBlur(false);
//			uploadProgressText("");
//			postData(resultingVideoFile, Main.configurationVariables["postURL"], Main.configurationVariables["isAjax"]);
//			ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingTranscodingFinishedCallback"], resultingVideoFile, true);
			
			
			var event:RecordingEvent = new RecordingEvent(RecordingEvent.EVENT_TRANSCODING_FINISHED);
			dispatchEvent(event);
			//postData(fileName);
		}
		
		private function transcodeVideoFailure(obj:Object):void
		{
			Main.appendMessage("Transcoding video failed.");
			trace("Transcoding video failed:");
			for (var i:Object in obj)
			{
				Main.appendMessage("Status: " + i + " : "+obj[i]);
				trace("Status: " + i + " : "+obj[i]);
			}
//			uploadProgressText("");
//			setBlur(false);
//			ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingTranscodingFinishedCallback"], null, false);
		}
		
		public function cameraReady(event:CameraReadyEvent):void
		{
			camera = event.camera;
			if (camera.muted)
			{
				ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["cameraReadyCallback"], false);	
				trace("Camera Not Ready");
			}
			else
			{
				ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["cameraReadyCallback"], true);	
				trace("Camera ready");
			}
		}
		
		public function microphoneReady(event:MicrophoneReadyEvent):void
		{
			microphone = event.microphone;
			if (microphone.muted)
			{
				ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["microphoneReadyCallback"], false);
				trace("Microphone Not Ready");
			}
			else
			{
				ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["microphoneReadyCallback"], true);
				trace("Microphone ready");
			}
		}
		
//		public function goToURL(url:String=null):void
//		{
//			if (url==null)
//				refreshPage();
//			else if (url.indexOf("javascript:")==0)
//			{
//				url= url.substr(11);
//				ExternalInterface.call(url); 
//			}
//			else
//			{
//				var request:URLRequest = new URLRequest(url);
//				navigateToURL(request, "_self");
//			}
//		}
		
		public function postData(fName:String, url:String=null, isAjax:Boolean = false):void 
		{
			//Possibly make this ajax based javascript call if isAjax==true
			if (url == null)
				url = ExternalInterface.call('window.location.href.toString'); 
			var request:URLRequest = new URLRequest(url);
			var variables:URLVariables = new URLVariables();
			variables.vidfile = fName;
			variables.type = 'record';
			variables.keepvideofile = "false";
			request.data = variables;
			request.method = URLRequestMethod.POST;
			
			if (isAjax)
			{
				var dataToSend:String = 'vidfile='+fName+'&type=record&keepvideofile=false';
				ExternalInterface.call("refreshPage", url, dataToSend);
			}
			else
			{
				navigateToURL(request, "_self");	
			}
			
		}
		
//		private function setBlur(flag:Boolean):void
//		{
//			ExternalInterface.call(Main.configurationVariables["blurFunction"], flag);			
//		}
		
		private function uploadProgressText(text:String):void
		{
			ExternalInterface.call(Main.configurationVariables["jsObj"]+"."+Main.configurationVariables["recordingUploadProgressCallback"], text);			
		}

		private function metaDataHandler(infoObject:Object):void
		{
			trace("metadata"+ infoObject.duration);
		}
	}
}