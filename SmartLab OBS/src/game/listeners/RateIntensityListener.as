package game.listeners
{
	import flash.events.Event;
	
	import game.gui.screens.Screen;

	public class RateIntensityListener extends ScreenListener
	{
		public function RateIntensityListener(screen:Screen)
		{
			super(screen);
		}
		
		override public function loaded(event:Event):void
		{
			screen.removeEventListener(Event.ADDED, loaded);
			screen.soundChannel = screen.sound.play();
			screen.soundChannel.addEventListener(Event.SOUND_COMPLETE, showNextButton);
		}
		
		public function showNextButton(event:Event):void
		{
			
		}
	}
}