package game.gui.screens
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import game.assets.Images;
	import game.assets.Sounds;
	
	public class IntensityRateScreen extends Screen
	{
		private var intensityLabel:TextField;
		private var valueSprite:Sprite;
		private static const spriteWidth:Number = 375;
		private static const spriteHeight:Number = 25;
		private var _intensity:Number;
		
		
		
		public function IntensityRateScreen()
		{
			super(Images.getInstance().imageThermometer, Sounds.getInstance().soundGameRateIntensity);
			_intensity = 0;
			var label:TextField = new TextField();
			label.selectable = false;
			label.type = TextFieldType.DYNAMIC;
			label.mouseEnabled = false;
			label.tabEnabled = false;
		
			label.height = 80;
			label.width = 450;
			var format:TextFormat = new TextFormat();
		//	format.align = TextFormatAlign.CENTER;
			format.size = 50;
			label.defaultTextFormat = format;
			label.text = "Rate the intensity!";
			label.x = 20;
			label.y = 20;
			this.addChild(label);
			
			
			intensityLabel = new TextField();
			intensityLabel.selectable = false;
			intensityLabel.type = TextFieldType.DYNAMIC;
			intensityLabel.mouseEnabled = false;
			intensityLabel.tabEnabled = false;
			
			intensityLabel.width= 60;
			intensityLabel.height = 60;
			var format1:TextFormat = new TextFormat();
			format1.align = TextFormatAlign.CENTER;
			format1.size = 30;
			format1.color = 0xFFFFFF;
			intensityLabel.defaultTextFormat = format1;
			intensityLabel.text = ""+_intensity;
			
			intensityLabel.x = 140;
			intensityLabel.y = 220;
			this.addChild(intensityLabel);
			
			valueSprite = new Sprite();
			valueSprite.x = 240;
			valueSprite.y = 210;
			valueSprite.graphics.clear();
			valueSprite.graphics.beginFill( 0x000000);
			valueSprite.graphics.drawRect( 0, 0, spriteWidth, spriteHeight);
			valueSprite.graphics.endFill();
			valueSprite.graphics.beginFill( 0xD10000);
			valueSprite.graphics.drawRect( 0, 0, 10, spriteHeight);
			valueSprite.graphics.endFill();
			valueSprite.buttonMode = true;
			valueSprite.useHandCursor = true;
			valueSprite.addEventListener(MouseEvent.CLICK, mouseClicked);
			
			this.addChild(valueSprite);
		}
		
		public function get intensity():Number
		{
			return _intensity;
		}

		public function set intensity(value:Number):void
		{
			_intensity = value;
			intensityLabel.text = ""+_intensity;
		}

		private function mouseClicked(event:MouseEvent):void
		{
			var x:Number = event.localX;
			var value:Number = Math.round( x / (spriteWidth/9));
			if (x <10)
				x = 10;
			this.intensity = value;
			valueSprite.graphics.clear();
			valueSprite.graphics.beginFill( 0x000000);
			valueSprite.graphics.drawRect( 0, 0, spriteWidth, spriteHeight);
			valueSprite.graphics.endFill();
			valueSprite.graphics.beginFill( 0xD10000);
			valueSprite.graphics.drawRect( 0, 0, x, spriteHeight);
			valueSprite.graphics.endFill();
		}
	}
}