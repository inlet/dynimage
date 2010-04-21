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
			var preloader : Sprite = new Sprite();
			preloader.graphics.beginFill(0xff0000);
			preloader.graphics.drawRect(-150, -150, 300, 300);
			preloader.graphics.endFill();
			
			var img : Image = new FadeImage("mario.jpg", ImageModifiers.fill, {width: 500, height: 300, align: ImageAlign.CENTER}, preloader);
			img.addEventListener(ImageEvent.COMPLETE, imgEvents);
			img.addEventListener(ImageEvent.PROGRESS, imgEvents);
			img.addEventListener(ImageEvent.ERROR, imgEvents);
			img.addEventListener(ImageEvent.STARTED, imgEvents);
			
			
			var image : Image = new Image("url.to.image", );
			addChild(image);
			
			addChild(img);
		}
		

		private function imgEvents(event : ImageEvent) : void 
		{
			trace(event);
		}
	}
}
