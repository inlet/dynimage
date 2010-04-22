package  
{
	import dynimage.Image;
	import dynimage.ImageAlign;
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
			
			var img : Image = new FadeImage("mario.jpg", ImageModifiers.fill, {width: 500, height: 300, align: ImageAlign.CENTER}, new PreloaderAnimation());
			img.addEventListener(ImageEvent.COMPLETE, imgEvents);
			img.addEventListener(ImageEvent.PROGRESS, imgEvents);
			img.addEventListener(ImageEvent.ERROR, imgEvents);
			img.addEventListener(ImageEvent.STARTED, imgEvents);
			addChild(img);

			var img2 : Image = new FadeImage("mario.jpg", ImageModifiers.fill, {width: 500, height: 300, align: ImageAlign.CENTER}, new PreloaderAnimation());
			img2.y = 100;
			img2.addEventListener(ImageEvent.COMPLETE, imgEvents);
			img2.addEventListener(ImageEvent.PROGRESS, imgEvents);
			img2.addEventListener(ImageEvent.ERROR, imgEvents);
			img2.addEventListener(ImageEvent.STARTED, imgEvents);
			addChild(img2);
			
			
		}
		

		private function imgEvents(event : ImageEvent) : void 
		{
			trace(event);
		}
	}
}
