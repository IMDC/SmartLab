package game.listeners.game
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import game.assets.Images;
	import game.assets.Sounds;
	import game.gui.screens.EmotionRateScreen;
	import game.gui.screens.IntensityRateScreen;
	import game.gui.screens.Screen;
	import game.listeners.EmotionRateListener;
	
	import model.Video;

	public class EmotionRateListener1 extends EmotionRateListener
	{
		private var soundForEmotionType:Dictionary = new Dictionary();
		
		private var imageForEmotionType:Dictionary = new Dictionary();;
		
		public function EmotionRateListener1(screen:EmotionRateScreen)
		{
			super(screen);	
			Main.instance.setScoreVisible(true);
			soundForEmotionType[Video.EMOTION_TYPE_ANGRY] = Sounds.getInstance().soundWrongAngry;
			soundForEmotionType[Video.EMOTION_TYPE_CALM] = Sounds.getInstance().soundWrongCalm;
			soundForEmotionType[Video.EMOTION_TYPE_DISGUSTED] = Sounds.getInstance().soundWrongDisgusted;
			soundForEmotionType[Video.EMOTION_TYPE_FEARFUL] = Sounds.getInstance().soundWrongFearful;
			soundForEmotionType[Video.EMOTION_TYPE_HAPPY] = Sounds.getInstance().soundWrongHappy;
			soundForEmotionType[Video.EMOTION_TYPE_NO_EMOTION] = Sounds.getInstance().soundWrongNoEmotion;
			soundForEmotionType[Video.EMOTION_TYPE_SAD] = Sounds.getInstance().soundWrongSad;
			soundForEmotionType[Video.EMOTION_TYPE_SURPRISED] = Sounds.getInstance().soundWrongSurprised;
			
			imageForEmotionType[Video.EMOTION_TYPE_ANGRY] = Images.getInstance().imageEmotionAngry;
			imageForEmotionType[Video.EMOTION_TYPE_CALM] = Images.getInstance().imageEmotionCalm;
			imageForEmotionType[Video.EMOTION_TYPE_DISGUSTED] = Images.getInstance().imageEmotionDisgusted;
			imageForEmotionType[Video.EMOTION_TYPE_FEARFUL] = Images.getInstance().imageEmotionFearful;
			imageForEmotionType[Video.EMOTION_TYPE_HAPPY] = Images.getInstance().imageEmotionHappy;
			imageForEmotionType[Video.EMOTION_TYPE_NO_EMOTION] = Images.getInstance().imageEmotionNoEmotion;
			imageForEmotionType[Video.EMOTION_TYPE_SAD] = Images.getInstance().imageEmotionSad;
			imageForEmotionType[Video.EMOTION_TYPE_SURPRISED] = Images.getInstance().imageEmotionSurprised;
			Main.appendMessage("Starting EmotionRateListener1");
		}
		
		override public function emotionSelected(event:Event):void
		{
			Main.instance.setScoreVisible(false);
			Main.appendMessage("Emotion selected: " + (screen as EmotionRateScreen).selectedEmotion);
			screen.soundChannel.stop();	
			//TODO check the answer with the passed correct answer
			
			if (screen.video1.emotionType==(screen as EmotionRateScreen).selectedEmotion)
			{
				//Correct answer - go to the intensity rating screen
				//TODO if no emotion, skip the intensity rating screen
				Main.instance.score+= screen.video1.getVideoScore();
				if (screen.video1.emotionType == Video.EMOTION_TYPE_NO_EMOTION)
				{
					var greatJobScreen:Screen;
					if (screen.video1.numberOfTries == 0)
					{
						greatJobScreen = new Screen(Images.getInstance().imagePoint5, Sounds.getInstance().soundPoint5);
					}
					if (screen.video1.numberOfTries == 1)
					{
						greatJobScreen = new Screen(Images.getInstance().imagePoint3, Sounds.getInstance().soundPoint3);
					}
					else if (screen.video1.numberOfTries == 2)
					{
						greatJobScreen = new Screen(Images.getInstance().imagePoint1, Sounds.getInstance().soundPoint1);
					}
					
					Main.instance.addVideoData(Main.instance.videoNumber, screen.video1.url, screen.video1.numberOfTries, screen.video2, screen.video1.emotionType, screen.video1.emotionType,0);
					
					greatJobScreen.video1 = screen.video1;
					greatJobScreen.video2 = screen.video2;
					greatJobScreen.addEventListener(Event.ADDED, new GreatJobListener1(greatJobScreen).loaded);
					Main.instance.replaceScreen(greatJobScreen);
				}
				else
				{
					var intensityRateScreen:IntensityRateScreen = new IntensityRateScreen();
					intensityRateScreen.video1 = screen.video1;
					intensityRateScreen.video2 = screen.video2;
					var intensityRateListener1:RateIntensityListener1 = new RateIntensityListener1(intensityRateScreen);
					intensityRateScreen.addEventListener(Event.ADDED, intensityRateListener1.loaded);
					Main.instance.replaceScreen(intensityRateScreen);
				}
			}
			else
			{
				//Wrong answer - deduct the number of tries and redirect to the appropriate screen
				var wrongAnwserScreen:Screen;
				Main.instance.addVideoData(Main.instance.videoNumber, screen.video1.url, screen.video1.numberOfTries, screen.video2, screen.video1.emotionType, (screen as EmotionRateScreen).selectedEmotion); 
				screen.video1.numberOfTries++;
				if (screen.video1.numberOfTries == 1)
				{
					wrongAnwserScreen = new Screen(Images.getInstance().imageTryAgain2, Sounds.getInstance().soundTriesLeft2);
					wrongAnwserScreen.addEventListener(Event.ADDED, new TryAgainListener(wrongAnwserScreen).loaded);
				}
				else if (screen.video1.numberOfTries == 2)
				{
					wrongAnwserScreen = new Screen(Images.getInstance().imageTryAgain1, Sounds.getInstance().soundTriesLeft1);	
					wrongAnwserScreen.addEventListener(Event.ADDED, new TryAgainListener(wrongAnwserScreen).loaded);
				}
				else
				{ //No more tries left
					wrongAnwserScreen = new Screen(imageForEmotionType[screen.video1.emotionType], soundForEmotionType[screen.video1.emotionType]);	
					wrongAnwserScreen.addEventListener(Event.ADDED, new ShowCorrectAnswerListener(wrongAnwserScreen).loaded);
				}
				wrongAnwserScreen.video1 = screen.video1;
				Main.instance.replaceScreen(wrongAnwserScreen);
			}
			
//			var intensityRateScreen:IntensityRateScreen = new IntensityRateScreen(screen.video1.emotionType==(screen as EmotionRateScreen).selectedEmotion);
//			intensityRateScreen.video1 = screen.video1;
//			intensityRateScreen.video2 = screen.video2;
//			var intensityRateListener1:RateIntensityListener1 = new RateIntensityListener1(intensityRateScreen);
//			intensityRateScreen.addEventListener(Event.ADDED, intensityRateListener1.loaded);
//			Main.instance.replaceScreen(intensityRateScreen);
		}
		
	}
}