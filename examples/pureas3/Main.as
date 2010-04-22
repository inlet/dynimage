package  
{
	import dynimage.Image;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Image.LOADER_COUNT = 1;
			var image : FadeImage;
			
			var leni : uint = 2;
			for (var i:uint = 0; i < leni*leni; ++i) 
			{
				image = new FadeImage("mario.jpg", ImageModifiers.fill, {width: stage.stageWidth/leni, height:stage.stageHeight/leni}, new PreloaderAnimation());
				image.x = int(i % leni) * stage.stageWidth/leni;
				image.y = int(i / leni) * stage.stageHeight/leni;
				image.addEventListener(ImageEvent.STARTED, imageEvents);
				image.addEventListener(ImageEvent.PROGRESS, imageEvents);
				image.addEventListener(ImageEvent.ERROR, imageEvents);
				image.addEventListener(ImageEvent.COMPLETE, imageEvents);
				addChild(image);
			}

		}

		private function imageEvents(event : ImageEvent) : void 
		{
			trace( event );
		}
	}
}
