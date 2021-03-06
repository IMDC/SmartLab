package recorder.model
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	
	import recorder.events.CameraReadyEvent;
	import recorder.events.MicrophoneReadyEvent;
	import recorder.gui.CameraViewer;

	public class CameraMicSource extends EventDispatcher // IEventDispatcher
	{
		private static const secret:Number = Math.random();
		
		private var _camera:Camera;
		private var _microphone:Microphone;
		private static var instance:CameraMicSource;
		private var _cameraAccess:Boolean = false;
		private var _microphoneAccess:Boolean = false;
		private var _microphonePresent:Boolean = false;
		private var _cameraPresent:Boolean = false;
		private var cameraStream:NetStream;
		private var audioStream:NetStream;
		private var _cameraVideo:Video;
		private var videoCleared:Boolean = true;
		private var cameraStreamCleared:Boolean = true;
		private var audioStreamCleared:Boolean = true;
		
		public static const CAMERA_READY_STRING:String = "camera ready";
		public static const MICROPHONE_READY_STRING:String = "microphone ready";
		
		
		public static function getInstance():CameraMicSource
		{
			if (instance==null)
				instance = new CameraMicSource(secret);
			return instance;
		}
		
		public function CameraMicSource(enforcer:Number)
		{
			Main.appendMessage("Initializing camera!");
			if (enforcer != secret)
			{
				throw new Error("Error: use Singleton.instance instead");
			}
			if (getNumberOfCameras()>1 || getNumberOfMicrophones()>1)
			{
				//Security.showSettings(SecurityPanel.PRIVACY);
			}
			if (getNumberOfCameras()>0)
				setupCamera();
			if (getNumberOfMicrophones()>0)
				setupMicrophone();
		}
		
		public function selectCamera():void
		{
			if (cameraPresent)
			{
				Security.showSettings(SecurityPanel.CAMERA);
				setupCamera();
				CameraViewer.getInstance().showCameraPreview();
				
			}
		}
		
		public function selectMicrophone():void
		{
			if (microphonePresent)
			{
				Security.showSettings(SecurityPanel.MICROPHONE);
				setupMicrophone();
			}
		}
		
		public function destroyCameraStream():void
		{
			if (cameraStream != null)
			{
				cameraStream.attachCamera(null);
				cameraStream.close();
				cameraStream = null;
				cameraStreamCleared = true;
			}
		}
		
		public function destroyAudioStream():void
		{
			if (audioStream != null)
			{
				audioStream.attachAudio(null);
				audioStream.close();
				audioStream = null;
				audioStreamCleared = true;
			}
		}
		
		public function destroyCamera():void
		{
			if (camera != null)
			{
				Main.appendMessage("Destroying camera:"+camera.name);
				if (_cameraVideo != null)
				{
					_cameraVideo.attachCamera(null);
				}
				if (cameraStream != null)
				{
					
					cameraStream.attachCamera(null);
				}
				videoCleared = true;
				cameraStreamCleared = true;
				camera.removeEventListener(StatusEvent.STATUS, cameraStatusHandler); 
				camera = null;
			}
		}
		
		public function destroyMicrophone():void
		{
			if (microphone != null)
			{
				if (audioStream != null)
				{
					audioStream.attachAudio(null);
				}
				cameraStreamCleared = true;
				microphone.removeEventListener(StatusEvent.STATUS, microphoneStatusHandler); 
				microphone = null;
			}
		}
		public function setupCamera():void
		{
			if (camera != null)
			{
				destroyCamera();
			}
//			if (cameraExists() > 1)
//			{
//				//Display the camera Dialog to select a camera
//				Security.showSettings(SecurityPanel.CAMERA);
//			}
			camera = Camera.getCamera();
			//	WebcamRecorderClient.appendMessage(camera.name);
			if (camera==null)
			{
				Main.appendMessage("Camera is in use in another application");
				Main.displayPopup("Camera is in use in another application");
				return;
			}
			Main.appendMessage("Setting up camera:"+camera.name);
			camera.addEventListener(StatusEvent.STATUS, cameraStatusHandler); 
			camera.setMode(Main.configurationVariables["videoWidth"], Main.configurationVariables["videoHeight"], 30, true);
			camera.setQuality(0, 95);
			camera.setKeyFrameInterval(5);
		}
		
		public function setupMicrophone():void
		{
//			if (microphoneExists() > 1)
//			{
//				//Display the camera Dialog to select a camera
//				Security.showSettings(SecurityPanel.CAMERA);
//			}
			if (microphone != null)
			{
				destroyMicrophone();
			}
			
			microphone = Microphone.getMicrophone();
			if (microphone==null)
			{
				Main.appendMessage("Microphone is in use in another application");
				Main.displayPopup("Microphone is in use in another application");
				return;
			}
			microphone.addEventListener(StatusEvent.STATUS, microphoneStatusHandler); 
			microphone.setUseEchoSuppression(true);
			microphone.setLoopBack(false);
			microphone.rate = 22;
			microphone.setSilenceLevel(0);
		}
		
		public function getNumberOfCameras():uint
		{
			if (Camera.names.length == 1) 
			{ 
				Main.appendMessage("User has one camera installed.");
				cameraPresent = true;
			} 
			else if (Camera.names.length == 0)
			{ 
				Main.appendMessage("No camera Found");
				Main.displayPopup("No camera Found! Plug in a camera and reload the page");
				cameraPresent = false;
			}
			else
			{
				Main.appendMessage("User has several cameras");
				cameraPresent = true;
			}
			return Camera.names.length;
		}
		
		public function getNumberOfMicrophones():uint
		{
			if (Microphone.names.length == 1)
			{ 
				Main.appendMessage("User has one microphone installed."); 
				microphonePresent = true;
			} 
			else if (Microphone.names.length == 0)
			{ 
				Main.appendMessage("No microphones Found");
				Main.displayPopup("No microphone Found! Plug in a microphone and reload the page");
				microphonePresent = false;
			}
			else
			{
				Main.appendMessage("User has several microphones");
				microphonePresent = true;
			}
			return Microphone.names.length;
		}

		public function get cameraPresent():Boolean
		{
			return _cameraPresent;
		}

		public function set cameraPresent(value:Boolean):void
		{
			_cameraPresent = value;
		}

		public function get microphonePresent():Boolean
		{
			return _microphonePresent;
		}

		public function set microphonePresent(value:Boolean):void
		{
			_microphonePresent = value;
		}

		public function get microphoneAccess():Boolean
		{
			return _microphoneAccess;
		}

		public function set microphoneAccess(value:Boolean):void
		{
			_microphoneAccess = value;
		}

		public function get cameraAccess():Boolean
		{
			return _cameraAccess;
		}

		public function set cameraAccess(value:Boolean):void
		{
			_cameraAccess = value;
		}

		public function get camera():Camera
		{
			return _camera;
		}

		public function set camera(value:Camera):void
		{
			_camera = value;
		}

		public function get microphone():Microphone
		{
			return _microphone;
		}

		public function set microphone(value:Microphone):void
		{
			_microphone = value;
		}

//		public static function get instance():CameraMicSource
//		{
//			return _instance;
//		}

		public function getCameraStream(connection:NetConnection):NetStream
		{
			if (!cameraPresent)
				return null;
			
			if (cameraStream==null)
			{
				cameraStream = new NetStream(connection)
				cameraStream.attachCamera(camera);
				cameraStream.attachAudio(microphone);
			}
			else
			{
				if (cameraStreamCleared)
				{
					cameraStreamCleared = false;
					cameraStream.attachCamera(camera);
					cameraStream.attachAudio(microphone);
				}
			}
			cameraStream.bufferTime = 60;
			if (cameraAccess)
				this.dispatchEvent(new CameraReadyEvent(CAMERA_READY_STRING, camera));
			return cameraStream;
		}

		public function getAudioStream(connection:NetConnection):NetStream
		{
			if (!microphonePresent)
				return null;
			if (audioStream == null)
			{
				audioStream = new NetStream(connection);
				audioStream.attachAudio(microphone);
			}
			else
			{
				if (audioStreamCleared)
				{
					audioStreamCleared = false;
					audioStream.attachAudio(microphone);
				}
			}
			audioStream.bufferTime = 60;
			
			if (microphoneAccess)
				this.dispatchEvent(new MicrophoneReadyEvent(MICROPHONE_READY_STRING, microphone));
			return audioStream;
		}

		public function get cameraVideo():Video
		{
			if (!cameraPresent)
				return null;
			if (_cameraVideo == null)
			{
				videoCleared = false;
				_cameraVideo = new Video();
				_cameraVideo.attachCamera(camera);
				_cameraVideo.width=640;
				_cameraVideo.height=480;
			}
			else 
			{
				if (videoCleared)
				{
					videoCleared = false;
					_cameraVideo.attachCamera(camera);
				}
			}
			if (cameraAccess || !camera.muted)
				this.dispatchEvent(new CameraReadyEvent(CAMERA_READY_STRING, camera));
			
			return _cameraVideo;
		}

		private function cameraStatusHandler(event:StatusEvent):void 
		{ 
			if (camera.muted) 
			{ 
				cameraAccess = false;
				this.dispatchEvent(new CameraReadyEvent(CAMERA_READY_STRING, camera));
				Main.appendMessage("User prevented access to camera");
				Main.displayPopup("Camera/Microphone access is required for this application, reload the page and allow camera/microphone access");
				//No camera Access
			//	selectCamera();
			} 
			else 
			{ 
				cameraAccess = true;
				Main.appendMessage("Connected to camera");
				this.dispatchEvent(new CameraReadyEvent(CAMERA_READY_STRING, camera));
//				camera.removeEventListener(StatusEvent.STATUS, cameraStatusHandler); 
			}

		}
		
		private function microphoneStatusHandler(event:StatusEvent):void
		{
			if (microphone.muted)
			{
				_microphoneAccess = false;
				Main.appendMessage("User prevented access to microphone");
			}
			else
			{
				_microphoneAccess = true;
				this.dispatchEvent(new MicrophoneReadyEvent(MICROPHONE_READY_STRING, microphone));
			}
		}
	}
}