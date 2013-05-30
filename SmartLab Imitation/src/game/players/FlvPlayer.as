package game.players
{
		import flash.display.Sprite;
		import flash.events.AsyncErrorEvent;
		import flash.events.Event;
		import flash.events.NetStatusEvent;
		import flash.events.ProgressEvent;
		import flash.events.TimerEvent;
		import flash.media.Video;
		import flash.net.NetConnection;
		import flash.net.NetStream;
		import flash.utils.Timer;
		
		public class FlvPlayer extends Sprite
		{
			private var video		:Video;
			private var stream		:NetStream;
			private var connection	:NetConnection;
			private var timer		:Timer;
			private var duration	:Number;
			private var flvUrl		:String;
			private var isAutoPlay	:Boolean;
			private var isPlay		:Boolean; //used to check whether the movie is playing (in VideoController)
			private var isInitialized:Boolean;
			
			public static const END_OF_VIDEO_EVENT:String = "endOfVideo";
			
			
			public function FlvPlayer(url:String, auto:Boolean=false):void
			{
				isAutoPlay	= auto;
				isPlay		= auto;	// init with default value. has nothing to do with autoPlay
				duration	= 0;
				flvUrl		= url;
				isInitialized = false;
				connection	= new NetConnection;
				connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
				connection.connect(null);
			}
			
			private function connectStream():void
			{
				stream = new NetStream(connection);
				//if (!stream.hasEventListener(NetStatusEvent.NET_STATUS, onNetStatus)
				stream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
				stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
				
				var client:Object	= new Object;
				client.onMetaData	= onMetaData;
				stream.client		= client;
				
				
				video = new Video;
				video.attachNetStream(stream);
				
				addChild(video);			
				stream.bufferTime = 3;
				
				//this.playFlv();
				//isPlay = true;
			}
			
			private function onTimer(event:TimerEvent):void
			{
				Main.appendMessage("Video Loaded: "+stream.bytesLoaded/stream.bytesTotal);
				var pEvent:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS)
				pEvent.bytesLoaded = stream.bytesLoaded;
				pEvent.bytesTotal = stream.bytesTotal;
				this.dispatchEvent(pEvent);
				if(stream.bytesLoaded == stream.bytesTotal)
					timer.stop();
			}
			
			public function getBufferLength():Number
			{
				return stream.bufferLength;
			}
			
			public function getBufferTime():Number
			{
				return stream.bufferTime;
			}
			
			private function onNetStatus(event:NetStatusEvent):void
			{
				switch (event.info.code)
				{
					case "NetConnection.Connect.Success" :
						//stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						connectStream();
						connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						
						
						this.dispatchEvent(new Event("videoLoaded"));
						//stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
						break;
					case "NetStream.Play.StreamNotFound" :	// this needs to be handled with an event listener
						Main.appendMessage("Unable to locate video: " + flvUrl);
						this.dispatchEvent(new Event("stream.notFound"));
						break;
					case "NetStream.Play.Start" :
						//stream.play(flvUrl);
						//stream.seek(0);					
						event.target.seek(0);
						// if (!isAutoPlay){ stream.pause(); }
						break;
					case "NetStream.Play.Stop" :
						//stream.dispatchEvent(new Event("end of video"));
						//event.target.dispatchEvent(new Event("end of video"));
					//	event.target.seek(0);
						event.target.pause();					
						this.dispatchEvent(new Event(END_OF_VIDEO_EVENT));
						//stream.seek(0);
						//stream.pause();					
						break;
					case "NetStream.Buffer.Empty" :
						this.dispatchEvent(new Event("buffer.empty"));
						break;
					case "NetStream.Buffer.Full" :
						this.dispatchEvent(new Event("buffer.full"));
						break;
				}
			}
			
			private function onMetaData(data:Object):void
			{
				duration = data.duration;
				this.dispatchEvent(new Event("videoLoaded"));
			}	
			/*		
			private function playFlv():void
			{
			stream.play(flvUrl);
			isPlay = true;
			}
			*/
			public function togglePlay():void	// it's never called anywhere, why public ??
			{
				stream.togglePause();
				isPlay =! isPlay;
			}		
			
			public function pause():void
			{
				stream.pause();
				isPlay = false;
			}
			
			public function resume():void
			{
				if (!isInitialized)
				{
					timer = new Timer(100);
					timer.addEventListener(TimerEvent.TIMER, onTimer);	
					timer.start();
					stream.play(flvUrl);
					isInitialized = true;
				}
				else
				{
					stream.resume();
				}
				isPlay = true;
			}
			
			public function seek(time:Number):void
			{
				stream.seek(time);
				//isPlay = true;	// why was it false???
			}
			
			public function getTime():Number
			{
				return stream.time;
			}
			
			public function getDuration():Number
			{
				return duration;
			}
			
			public function isPlaying():Boolean
			{
				return isPlay;
			}
			
			private function asyncErrorHandler(event:AsyncErrorEvent):void 
			{
				// ignore AsyncErrorEvent events.
				Main.appendMessage("AsyncError!" + event.error.message);
				connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				stream.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
				stream.close();
			}
			
		}
	}