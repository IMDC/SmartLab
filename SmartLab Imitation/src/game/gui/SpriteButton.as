package game.gui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import recorder.events.ButtonEvent;
	
	public class SpriteButton extends Sprite implements IEventDispatcher
	{
		private var _state:int;
		private var _enabled:Boolean = true;
		private var border:Boolean = false;
		private var _label:TextField;
		private var _isToggle:Boolean = false;
		private var enabledOverlayChild:Sprite;
		private var _backgroundColor:Number = 0xFFFFFF;
		
		public static const UP_STATE:int = 0;
		public static const DOWN_STATE:int = 1;
		
		
		
		public function SpriteButton(w:Number=0, h:Number=0, label:String="", upState:DisplayObject=null, downState:DisplayObject=null)
		{
			_label = new TextField();
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.CENTER;
			format.size = h/2;
			format.font = "Arial"
			this.label.defaultTextFormat = format;
			this.label.text = label;
			if(label == "")
				this.label.visible = false;
			this.label.mouseEnabled = false;
			this.addChild(this.label);
			this.label.width = w;
			this.label.height = h;
			this.label.y += Math.round((this.label.height - this.label.textHeight) / 2);
			if (upState!=null)
			{
				upState.width = w;
				upState.height = h;
				this.addChild(upState);
			}
			if (downState!=null)
			{
				downState.width = w;
				downState.height = h;
				downState.visible = false;
				this.addChild(downState);
				isToggle = true;
			}
			enabledOverlayChild = new Sprite();
			this.addChild(enabledOverlayChild);
			enabledOverlayChild.visible = false;
			drawBackground(_backgroundColor, 1);
			state= UP_STATE;
			this.buttonMode = true;
			this.setBorder(false);
			this.addEventListener(MouseEvent.CLICK, toggleButton);
			this.addEventListener(MouseEvent.MOUSE_OVER, highLightButton);
			this.addEventListener(MouseEvent.MOUSE_OUT, clearButton);
			width = w;
			height = h;
		}
		
		public function get label():TextField
		{
			return _label;
		}

		public function get backgroundColor():Number
		{
			return _backgroundColor;
		}

		public function set backgroundColor(value:Number):void
		{
			_backgroundColor = value;
			drawBackground(_backgroundColor, 1);
		}

		public function highLightButton(event:MouseEvent=null):void
		{
			this.drawBackground(this.backgroundColor,0.7);			
		}
		
		public function clearButton(event:MouseEvent=null):void
		{
			this.drawBackground(this.backgroundColor,1);			
		}
		
		public function toggleButton(event:MouseEvent=null):void
		{
			if (isToggle)
			{
				if (state == UP_STATE)
					state = DOWN_STATE;
				else if (state == DOWN_STATE)
					state = UP_STATE;
			}
			this.dispatchEvent(new ButtonEvent(ButtonEvent.CLICK));
		}
		public function toggleUp():void
		{
			if (!isToggle)
				return;
			_state = UP_STATE;
			if (this.getChildAt(1)!=null && this.getChildAt(2)!=null)
			{
				this.getChildAt(1).visible = true;
				this.getChildAt(2).visible = false;
			}
		}
		
		public function toggleDown():void
		{
			if (!isToggle)
				return;
			_state = DOWN_STATE;
			if (this.getChildAt(1)!=null && this.getChildAt(2)!=null)
			{
				this.getChildAt(2).visible = true;
				this.getChildAt(1).visible = false;
			}
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function set state(state:int):void
		{
			if (state==UP_STATE)
				toggleUp();
			else if (state==DOWN_STATE)
				toggleDown();
			_state = state;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			if (!enabled)
				return false;
			else
				return super.dispatchEvent(event);
		}
		
		/**
		 * Enables or disables the component
		 * A disabled component does not trigger mouseEvents
		 * 
		 */
		public function set enabled(value:Boolean):void
		{
			if (_enabled == value)
				return;
			_enabled = value;
			this.buttonMode=value;
			//			this.getChildAt(state).visible = value;
			this.mouseChildren = value;
			this.mouseEnabled = value;
			this.label.mouseEnabled = false;
			enabledOverlayChild.visible = !value;
			if (value)
			{
				
				//				drawBackground(WebcamRecorderClient.configurationVariables["buttonsBackgroundColor"], 1);
				//				drawBorder();
			}
			else
			{
				drawBackground( 0x666666, 0.7 , enabledOverlayChild);
			}
		}
		
		private function drawBackground(color:Number, opacity:Number, sprite:Sprite = null):void
		{
			if (sprite == null)
				sprite = this;
			var maxWidth:Number = -1;
			var maxHeight:Number = -1;
			for (var i:int=0;i<this.numChildren;i++)
			{
				maxWidth = Math.max(maxWidth, this.getChildAt(i).width);
				maxHeight = Math.max(maxHeight, this.getChildAt(i).height);
			}
			sprite.graphics.clear();
			sprite.graphics.beginFill( color, opacity );
			sprite.graphics.drawRect( 0, 0, maxWidth, maxHeight );
			sprite.graphics.endFill();
			if (border)
					drawBorder();
		}
		
		/**
		 * Enables or disables the border for the component
		 */
		public function setBorder(value:Boolean):void
		{
			border = value;
			drawBorder();
		}
		
		/**
		 *Draws border around the component if enabled 
		 * 
		 */		
		private function drawBorder():void
		{
			var maxWidth:Number = -1;
			var maxHeight:Number = -1;
			for (var i:int=0;i<this.numChildren;i++)
			{
				maxWidth = Math.max(maxWidth, this.getChildAt(i).width);
				maxHeight = Math.max(maxHeight, this.getChildAt(i).height);
			}
			if (border)
			{
				this.graphics.lineStyle(1, 0x000000);
				this.graphics.drawRect(0, 0, maxWidth-1, maxHeight-1);
			}
			else
			{
				this.graphics.clear();
			}
		}
		
		public function get isToggle():Boolean
		{
			return _isToggle;
		}
		
		public function set isToggle(value:Boolean):void
		{
			_isToggle = value;
		}
		
	}
}