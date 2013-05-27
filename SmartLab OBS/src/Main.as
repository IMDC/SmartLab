package
{
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.external.ExternalInterface;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.ContextMenu;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.assets.Videos;
	import game.gui.SpriteButton;
	import game.gui.screens.Screen;
	import game.gui.screens.WelcomeScreen;
	
	import model.Video;
	
	import recorder.gui.CameraViewer;
	import recorder.listeners.CameraControlsListener;
	import recorder.model.CameraMicSource;
	
	
	[SWF(width=720)]
	[SWF(height=480)]
	[SWF(backgroundColor="#FFFFFF")]
	
	public class Main extends Sprite
	{
		private var _netConnection:NetConnection;
		private var _cameraControlsListener:CameraControlsListener 
		private static var _configurationVariables:Array;
		private var cameraViewer:CameraViewer;
		private var currentScreen:Screen;
		
		private var scoreField:TextField;
		private var _score:Number = 0;
		
		private static var _instance:Main;
		
		private var _participantID:Number = -1;
		private var _day:Number = -1;
		
		private var _songVideosArray:Array;
		private var _speechVideosArray:Array;
		
		private var currentVideoArray:Array;
		private var currentVideoIndex:Number = 0;
		private var _videoNumber:Number = 0;
		
		public static const EVENT_CONNECTED:String = "Connected to server";
		
		private var finalData:String = "";
		
		private var saveDataResponder:Responder;
		public static const EVENT_VIDEOS_LOADED:String = "Videos for day loaded";
		
		private var loadingLabel:TextField;
		
		public function Main()
		{
			
			_instance = this;
			
			saveDataResponder = new Responder(saveDataSuccess, saveDataFailure);
			
			configurationVariables = new Array();
			songVideosArray = new Array();
			speechVideosArray = new Array();
			
			
			configurationVariables["width"] = 720;
			configurationVariables["height"] = 480;
			configurationVariables["debug"] = true;
			configurationVariables["backgroundColor"] = 0xFFFFFF;
			configurationVariables["contentPadding"] = 0;
			configurationVariables["videoWidth"] = 640;
			configurationVariables["videoHeight"] = 480;
			configurationVariables["sliderBackgroundColor"] = 0xCCCCCC;
			configurationVariables["sliderHighlightedColor"] = 0x666666;
			configurationVariables["buttonsBackgroundColor"] = 0xFF0000;
			configurationVariables["postURL"] = null;
			configurationVariables["cancelURL"] = "javascript:history.go(-1)";
			configurationVariables["isAjax"] = false;
			configurationVariables["elementID"] = "playerContent";
			configurationVariables["jsObj"] = "controls";
			configurationVariables["day"] = -1;
			configurationVariables["email"] = "mgerdzhe@ryerson.ca";
			//			configurationVariables["blurFunction"] = "setBlur";
			//			configurationVariables["blurFunctionText"] = "setBlurText";
			
			configurationVariables["maxRecordingTime"] = 60000; //1 minute
			configurationVariables["minRecordingTime"] = 1000; //1 second
			
			configurationVariables["recordingStartedCallback"] = "recording_recordingStarted";
			configurationVariables["recordingStoppedCallback"] = "recording_recordingStopped";
			configurationVariables["recordingUploadProgressCallback"] = "recording_recordingUploadProgress";
			configurationVariables["recordingTranscodingFinishedCallback"] = "recording_recordingTranscodingFinished";
			configurationVariables["cameraReadyCallback"] = "recording_cameraReady";
			configurationVariables["microphoneReadyCallback"] = "recording_microphoneReady";
			
			
			this.loaderInfo.addEventListener(Event.COMPLETE, stageLoaded);//wait for this swf to be loaded and have flashVars ready
		}
		
		public function get speechVideosArray():Array
		{
			return _speechVideosArray;
		}

		public function set speechVideosArray(value:Array):void
		{
			_speechVideosArray = value;
		}

		public function get songVideosArray():Array
		{
			return _songVideosArray;
		}

		public function set songVideosArray(value:Array):void
		{
			_songVideosArray = value;
		}

		public function addVideoData(videoNumber:Number, originalVideoURL:String, trialNumber:Number, responseVideoURL:String, videoEmotion:String, responseEmotion:String, responseEmotionIntensity:Number = -1):void
		{
			finalData+=""+videoNumber+"\t"+originalVideoURL+"\t" +trialNumber+"\t" +responseVideoURL+"\t"+videoEmotion+"\t"+responseEmotion+"\t" +responseEmotionIntensity +"\n";
		}
		
		public function saveData():void
		{
			finalData = "Video #\tOriginal Video name\tTrial #\tResponse Video url:\tEmotion:\tResponse Emotion:\tIntensity:\n\n"+finalData;
			finalData+="Score: "+ score +"\n";
			this.addEventListener(EVENT_CONNECTED, connectedToSave);
			this.connect();
		}
		
		private function connectedToSave(event:Event):void
		{
			appendMessage("Saving Data");
			Main.instance.netConnection.call("saveDayData",saveDataResponder, ""+participantID, ""+day, ""+finalData, configurationVariables["email"]);
		}
		
		public function saveDataSuccess(obj:Object):void
		{
			appendMessage("Data saved successfully");
			this.disconnect();
		}
		
		public function saveDataFailure(obj:Object):void
		{
			appendMessage("Data not saved");	
		}
		
		public function get videoNumber():Number
		{
			return _videoNumber;
		}

		public function set videoNumber(value:Number):void
		{
			_videoNumber = value;
		}

		public function get day():Number
		{
			return _day;
		}

		public function set day(value:Number):void
		{
			_day = value;
			initializeVideosForDay(_day);
		}
		
		

		public function get participantID():Number
		{
			return _participantID;
		}

		public function set participantID(value:Number):void
		{
			_participantID = value;
		}

		public function get score():Number
		{
			return _score;
		}

		public function set score(value:Number):void
		{
			_score = value;
			scoreField.text = "Score: " + _score;
		}
		
		public function setScoreVisible(flag:Boolean):void
		{
			scoreField.visible = flag;
		}
		
		public function isScoreVisible():Boolean
		{
			return scoreField.visible;
		}

		public static function get instance():Main
		{
			return _instance;
		}
		
		public function initializeVideosForDay(day:Number):void
		{
			parseXMLToSongAndSpeech("http://imdc.ca/~martin/smartlab/resources/input/day"+day+".xml");
		}
		
		private function parseXMLToSongAndSpeech(url:String):void
		{
			
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(new URLRequest(url));
			myLoader.addEventListener(Event.COMPLETE, processXML);
		}
		
		private function processXML(e:Event):void 
		{
			var myXML:XML = new XML(e.target.data);
			
			if (myXML.song!=null)
			{
				var len:uint = myXML.song.children().length();	
				for(var i:uint = 0; i < len; i++)
				{
					var videoElement:XML = myXML.song.children()[i];
					Main.appendMessage(videoElement.toString());
					var emotion:String = videoElement.child("emotion");
					var videoFile:String = videoElement.child("file");
					var video:Video = new Video("http://imdc.ca/~martin/smartlab/resources/video/"+videoFile, 0, emotion, Video.TYPE_SONG);
					songVideosArray[i] = video;
				}
				songVideosArray = randomizeArray(songVideosArray);
				currentVideoArray = songVideosArray;
			}
			
			if (myXML.speech!=null)
			{
				var len:uint = myXML.speech.children().length();	
				for(var i:uint = 0; i < len; i++)
				{
					var videoElement:XML = myXML.speech.children()[i];
					Main.appendMessage(videoElement.toString())
					var emotion:String = videoElement.child("emotion");
					var videoFile:String = videoElement.child("file");
					var video:Video = new Video("http://imdc.ca/~martin/smartlab/resources/video/"+videoFile, 0, emotion, Video.TYPE_SPEECH);
					speechVideosArray[i] = video;
				}
				speechVideosArray = randomizeArray(speechVideosArray);
				if (myXML.song==null)
					currentVideoArray = speechVideosArray;
				
			}
			this.dispatchEvent(new Event(EVENT_VIDEOS_LOADED));
		}
		
		public static function randomizeArray(array:Array):Array
		{
			
			var newArray:Array = new Array();
			
			while(array.length > 0)
			{
				newArray.push(array.splice(Math.floor(Math.random()*array.length), 1)[0]);
			}
			return newArray;
			
		}
		
		
		public function connect():void
		{
			//new NetConnection
			if (Main.instance.netConnection!=null)
			{
				this.dispatchEvent(new Event(EVENT_CONNECTED));
				return;
			}	
			appendMessage("Connect() method called");
			netConnection = new NetConnection();
			netConnection.client = this;
			
			//set encoding to old amf;
			netConnection.objectEncoding = ObjectEncoding.AMF0;
			
			//netstatus event listening
			netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			
			//connect to red5
			netConnection.connect("rtmp://imdc.ca//smartLabProject", true);
		}

		public function setup():void
		{
			cameraViewer = CameraViewer.getInstance();
			cameraViewer.x = configurationVariables["contentPadding"];
			cameraViewer.y = configurationVariables["contentPadding"];
//			addChild(cameraViewer);
			
			var welcomeScreen:WelcomeScreen = new WelcomeScreen(); 
			addChild(welcomeScreen);
			currentScreen = welcomeScreen;
			
			scoreField = new TextField();
			scoreField.selectable = false;
			scoreField.type = TextFieldType.DYNAMIC;
			scoreField.mouseEnabled = false;
			scoreField.tabEnabled = false;
			
			scoreField.width= 200;
			scoreField.height = 60;
			var format1:TextFormat = new TextFormat();
			format1.size = 30;
			format1.color = 0x000000;
			scoreField.defaultTextFormat = format1;
			scoreField.text = "Score: 0";
			scoreField.visible = false;
			
			scoreField.x = 10;
			scoreField.y = configurationVariables["height"] - scoreField.height-10;
			this.addChild(scoreField);
			
			
			loadingLabel = new TextField();
			loadingLabel.selectable = false;
			loadingLabel.type = TextFieldType.DYNAMIC;
			loadingLabel.background = true;
			loadingLabel.backgroundColor = 0x666666;
			loadingLabel.border = true;
			loadingLabel.borderColor = 0x000000;
			loadingLabel.mouseEnabled = false;
			
			loadingLabel.tabEnabled = false;
			
			loadingLabel.width= 200;
			loadingLabel.height = 60;
			
			
			var format4:TextFormat = new TextFormat();
			format4.align = TextFormatAlign.CENTER;
			format4.size = 20;
			format4.color = 0xFFFFFF;
			loadingLabel.defaultTextFormat = format4;
			loadingLabel.text = "Loading...";
			loadingLabel.visible = false;
			loadingLabel.autoSize = TextFieldAutoSize.CENTER;
			
			loadingLabel.x = (this.width-loadingLabel.width)/2;
			loadingLabel.y = (this.height - loadingLabel.height)/2;
			this.addChild(loadingLabel);
		}
		
		public function setLoadingLabelVisible(flag:Boolean, text:String="Loading..."):void
		{
			loadingLabel.text = text;
//			loadingLabel.x = (this.width-loadingLabel.width)/2;
//			loadingLabel.y = (this.height - loadingLabel.height)/2;
			loadingLabel.visible = flag;
		}
		
		public function pickNextVideo():Video
		{
			//TODO pick the next video from the list of videos to watch
			var nextVideo:Video;
			if (currentVideoArray==songVideosArray)
			{
				Main.appendMessage("Current array is SongVideos with length="+currentVideoArray.length);
				if (currentVideoIndex == currentVideoArray.length) //no more songs videos, go to speech
				{
					currentVideoIndex = 0;
					currentVideoArray = speechVideosArray;
					return pickNextVideo();
				}
				
			}
			else
			{
				Main.appendMessage("Current array is SpeechVideos with length="+currentVideoArray.length);
				if (currentVideoIndex == currentVideoArray.length) //no more speech videos, done
				{
					currentVideoIndex = -1;
					currentVideoArray = null;
					return null;
				}
			}
			Main.appendMessage("Current array index is "+currentVideoIndex);
			Main.appendMessage("Array contains: "+ currentVideoArray.toString());
			nextVideo = currentVideoArray[currentVideoIndex];
			currentVideoIndex++;
			videoNumber++
			Main.appendMessage("Current Video is "+nextVideo);
			
			return nextVideo;
		}
		
		public function switchToSpeechVideos():void
		{
			currentVideoIndex = 0;
			currentVideoArray = speechVideosArray;
			videoNumber = songVideosArray.length;
		}
		
		public function replaceScreen(newScreen:Screen):void
		{
			var index:Number = this.getChildIndex(currentScreen);
			this.removeChild(currentScreen);
			this.currentScreen = newScreen;
			this.addChildAt(newScreen, index);
		}
		
		public function stageLoaded(event:Event):void
		{
			initFlashVars();
			var my_menu:ContextMenu = new ContextMenu();
			my_menu.hideBuiltInItems();
			contextMenu = my_menu;
			this.stage.addEventListener(Event.RESIZE, handleResize);
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			graphics.beginFill( configurationVariables["backgroundColor"], 1.0 );
			graphics.drawRect( 0, 0, configurationVariables["width"], configurationVariables["height"] );
			graphics.endFill();
			appendMessage("Creating a new instance");
			
			setup();
			
			connect();
			
		}
		
		private function netStatus(event:NetStatusEvent):void
		{
			appendMessage(event.info.code);
			if (event.info.code=="NetConnection.Connect.Failed")
			{
				//trace reject message
				appendMessage("Connected Failed. Reason:" +event.info.application);
				return;
			}
			if (event.info.code=="NetConnection.Connect.Rejected")
			{
				//trace reject message
				appendMessage("Connection Rejected. Reason:" +event.info.application);
				return;
			}
			if (event.info.code=="NetConnection.Connect.Success")
			{
				appendMessage("Connected to server");
				onConnection();
			}
			if (event.info.code=="NetConnection.Connect.Closed")
			{
				appendMessage("Disconnected from server");
				netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatus);
				netConnection = null;
				CameraMicSource.getInstance().removeEventListener(CameraMicSource.CAMERA_READY_STRING,cameraControlsListener.cameraReady);
				CameraMicSource.getInstance().removeEventListener(CameraMicSource.MICROPHONE_READY_STRING,cameraControlsListener.microphoneReady);
				CameraMicSource.getInstance().destroyAudioStream();
				CameraMicSource.getInstance().destroyCameraStream();
				cameraControlsListener = null;
			}
		}
		
		private function onConnection():void
		{
			//Setup the controls listener first so that it will get the event when the camera is ready
			appendMessage("On Connection called");
			cameraControlsListener = new CameraControlsListener(netConnection);
			CameraMicSource.getInstance().addEventListener(CameraMicSource.CAMERA_READY_STRING,cameraControlsListener.cameraReady);
			CameraMicSource.getInstance().addEventListener(CameraMicSource.MICROPHONE_READY_STRING,cameraControlsListener.microphoneReady);
			this.dispatchEvent(new Event(EVENT_CONNECTED));
			
		}
		
		public function disconnect():void
		{
			appendMessage("Disconnect called");
			if (netConnection!=null)
			{
				appendMessage("cleaning up the netConnection");
				netConnection.close();
			}
		}
		
		public static function appendMessage(message:String):void
		{
			if (configurationVariables["debug"])
			{	
				ExternalInterface.call("console.log","FLASH MESSAGE:"+message);
			}
		}
		
		public function initFlashVars():void
		{
			var key:String; // This will contain the name of the parameter
			var val:String; // This will contain the value of the parameter
			var flashVars:Object = LoaderInfo(this.root.loaderInfo).parameters;
			var rExp:RegExp=new RegExp(/#/g);
			for (key in flashVars) 
			{
				if (key.indexOf("Color")!=-1)
				{
					//Convert HTML colors to Flash colors
					configurationVariables[key] = uint(String(flashVars[key]).replace(rExp,"0x"));
				}
				else
				{
					configurationVariables[key] = flashVars[key];
				}
			}
		}
		
		public function handleResize(e:Event):void
		{
			//The resize code goes here
			graphics.beginFill( configurationVariables["backgroundColor"], 1.0 );
			graphics.drawRect( 0, 0, configurationVariables["width"], configurationVariables["height"] );
			graphics.endFill();
			this.x = (stage.stageWidth-this.width)/2 
			this.y = (stage.stageHeight-this.height)/2
		}
		
		public function get netConnection():NetConnection
		{
			return _netConnection;
		}
		
		public function set netConnection(value:NetConnection):void
		{
			_netConnection = value;
		}
		
		public static function get configurationVariables():Array
		{
			return _configurationVariables;
		}
		
		public static function set configurationVariables(value:Array):void
		{
			_configurationVariables = value;
		}
		
		public function get cameraControlsListener():CameraControlsListener
		{
			return _cameraControlsListener;
		}
		
		public function set cameraControlsListener(value:CameraControlsListener):void
		{
			_cameraControlsListener = value;
		}
		
		public function onBWCheck(... rest):Number
		{
			return 0;
		}
		
		public function onBWDone(... rest):void
		{
			
		}

	}
}