package recorder.gui
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.text.TextField;
	
	import recorder.events.CameraReadyEvent;
	import recorder.model.CameraMicSource;
	
//	import mx.controls.Label;

	public class CameraViewer extends Sprite implements IEventDispatcher
	{
		private var camera:Camera;
		private var video:Video;
		private var hasVideo:Boolean;
		private var microphone:Microphone;
		private var cameraPreview:Boolean;
		private var cmSource:CameraMicSource;
		private static var instance:CameraViewer;
		
		private static const secret:Number = Math.random();
		
//		public static const CAMERA_READY_STRING:String = "camera ready";
//		public static const MICROPHONE_READY_STRING:String = "microphone ready";
		
		public static function getInstance():CameraViewer
		{
			if (instance==null)
				instance = new CameraViewer(secret);
			return instance;
		}
		public function CameraViewer(enforcer:Number)
		{
			if (enforcer != secret)
			{
				throw new Error("Error: use Singleton.instance instead");
			}
			graphics.beginFill( 0xffffff, 1.0 );
			graphics.drawRect( 0, 0, Main.configurationVariables["videoWidth"], Main.configurationVariables["videoHeight"] );
			graphics.endFill();
			cmSource = CameraMicSource.getInstance();
			video = cmSource.cameraVideo;
			video.width = Main.configurationVariables["videoWidth"];
			video.height = Main.configurationVariables["videoHeight"]
			Main.appendMessage("cameraViewer constructor with Video:"+video);
			if (video != null)
			{
				Main.appendMessage("cameraViewer Video not null");
				this.addChild(video);
			}
			else
			{
				Main.appendMessage("cameraViewer Video null");
				var noCamera:TextField = new TextField();
				noCamera.text = "No Camera Detected";
				this.addChild(noCamera);
			}
			cameraPreview = true;
		}
		
		public function showCameraPreview():void
		{
		//	if (video==cmSource.cameraVideo)
				Main.appendMessage("showCameraPreview in cameraViewer: "+cameraPreview);
			
//			if (cameraPreview)
//				return;
			video.clear();
			this.removeChild(video);
			video = cmSource.cameraVideo;
			this.addChild(video);
//////			trace(cmSource.camera.muted);
////			video.attachCamera(cmSource.camera);
//			cameraPreview = true;
		}
		
		public function showRemoteRecordingPreview(stream:NetStream):void
		{
			if (!cameraPreview)
				return;
			video.attachCamera(null);
			video.clear();
			video.attachNetStream(stream);
			cameraPreview = false;
		}
		
	}
}