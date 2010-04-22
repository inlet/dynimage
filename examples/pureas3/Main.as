package  
{
	import dynimage.ImageEvent;
	import dynimage.ImageModifiers;

	import flash.display.Sprite;

	/**
	 * @author Patrick.Brouwer (patrick at inlet dot nl)
	 */
	public class Main extends Sprite 
	{
		public function Main()
		{
			var image : FadeImage = new FadeImage("mario.jpg", ImageModifiers.fill, {width: stage.stageWidth , height:stage.stageHeight}, new PreloaderAnimation());
			image.addEventListener(ImageEvent.STARTED, imageEvents);
			image.addEventListener(ImageEvent.PROGRESS, imageEvents);
			image.addEventListener(ImageEvent.ERROR, imageEvents);
			image.addEventListener(ImageEvent.COMPLETE, imageEvents);

			addChild(image);
		}

		private function imageEvents(event : ImageEvent) : void 
		{
			trace(event);
		}
	}
}
