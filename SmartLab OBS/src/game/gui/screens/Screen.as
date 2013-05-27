package game.gui.screens
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import game.gui.SpriteButton;
	
	import model.Video;

	public class Screen extends Sprite
	{
		private var _image:Bitmap;
		private var _sound:Sound;
		private var _soundChannel:SoundChannel;
		private var _video1:Video;
		private var _video2:String;
		private var _nextButton:SpriteButton = new SpriteButton(80,50,"Next");
		private static const offset:Number = 20;
		
		public function Screen(image:Bitmap=null, sound:Sound=null)
		{
			this.image = image;
			this.sound = sound;
			if (this.image!=null)
				this.addChild(this.image);
			nextButton.x = width - nextButton.width - offset;
			nextButton.y = height - nextButton.height - offset;
			nextButton.backgroundColor = 0x00FF00;
			nextButton.visible = false;
			nextButton.enabled = false;
			
			this.addChild(nextButton);
		}
		
		public function get video2():String
		{
			return _video2;
		}

		public function set video2(value:String):void
		{
			_video2 = value;
		}

		public function get soundChannel():SoundChannel
		{
			return _soundChannel;
		}

		public function set soundChannel(value:SoundChannel):void
		{
			_soundChannel = value;
		}


		public function get video1():Video
		{
			return _video1;
		}

		public function set video1(value:Video):void
		{
			_video1 = value;
		}

		public function get image():Bitmap
		{
			return _image;
		}

		public function set image(value:Bitmap):void
		{
			_image = value;
		}

		public function get sound():Sound
		{
			return _sound;
		}

		public function set sound(value:Sound):void
		{
			_sound = value;
		}

		public function get nextButton():SpriteButton
		{
			return _nextButton;
		}

	}
}