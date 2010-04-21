package  
{
	import dynimage.Image;

	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;

	/**
	 * @author Patrick.Brouwer (patrick at inlet dot nl)
	 */
	public class FadeImage extends Image 
	{
		public function FadeImage(url : String, modifier : Function = null, modifierParams : Object = null, preloader : DisplayObject = null, autoStart : Boolean = true)
		{
			super(url, modifier, modifierParams, preloader, autoStart);
			TweenPlugin.activate([AutoAlphaPlugin]);
		}
		
		override protected function animatePreloaderIn(preloader : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(preloader, 0.3, {autoAlpha: 1, onComplete: onComplete});
		}

		
		override protected function animatePreloaderOut(preloader : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(preloader, 0.3, {autoAlpha: 0, onComplete: onComplete});
		}

		override protected function animateAssetIn(asset : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(asset, 0.3, {autoAlpha:1, onComplete: onComplete});
		}

	}
}
