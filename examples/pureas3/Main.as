package  
{
	import dynimage.Img;
	import dynimage.ImgAlign;
	import dynimage.ImgEvent;
	import dynimage.ImgModifiers;

	import logmeister.LogMeister;
	import logmeister.connectors.TrazzleConnector;

	import flash.display.Sprite;

	/**
	 * @author Patrick.Brouwer (patrick at inlet dot nl)
	 */
	public class Main extends Sprite 
	{
		public function Main()
		{
			LogMeister.addLogger(new TrazzleConnector(stage, "DynImage", false, false));
			
			var preloader : Sprite = new Sprite();
			preloader.graphics.beginFill(0xff0000);
			preloader.graphics.drawRect(-150, -150, 300, 300);
			preloader.graphics.endFill();
			
			var img : Img = new FadeImg("mario.jpg", ImgModifiers.fill, {width: 500, height: 300, align: ImgAlign.CENTER}, preloader);
			img.y = 20;
			img.addEventListener(ImgEvent.COMPLETE, imgEvents);
			img.addEventListener(ImgEvent.PROGRESS, imgEvents);
			img.addEventListener(ImgEvent.ERROR, imgEvents);
			img.addEventListener(ImgEvent.STARTED, imgEvents);
			
			addChild(img);
		}

		private function imgEvents(event : ImgEvent) : void 
		{
			info(event);
		}
	}
}
