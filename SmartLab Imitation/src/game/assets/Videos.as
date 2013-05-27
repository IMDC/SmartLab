package game.assets
{
	import flash.media.Sound;

	public class Videos
	{
		//Tutorial Videos
		
	public static const VIDEO_TUTORIAL_B:String = "resources/video/song/tutorialB.mp4";
	public static const VIDEO_TUTORIAL_A:String = "resources/video/speech/tutorial.mp4";

	private static const secret:Number = Math.random();
	private static var instance:Videos;
	
	public static function getInstance():Videos
	{
		if (instance==null)
			instance = new Videos(secret);
		return instance;
	}
	
	public function Videos(enforcer:Number)
	{
		if (enforcer != secret)
		{
			throw new Error("Error: use Singleton.instance instead");
		}
	}
	
	}
}