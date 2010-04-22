package  
{
	import dynimage.Image;

	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.DisplayObject;

	/**
	 * @author Patrick.Brouwer (patrick at inlet dot nl)
	 */
	public class FadeImage extends Image 
	{
		public function FadeImage(url : String, modifier : Function = null, modifierParams : Object = null, preloader : DisplayObject = null, autoStart : Boolean = true)
		{
			TweenPlugin.activate([ColorMatrixFilterPlugin, AutoAlphaPlugin, BlurFilterPlugin]);
			super(url, modifier, modifierParams, preloader, autoStart);
		}
		
		override protected function animatePreloaderIn(preloader : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(preloader, 0, {y: preloader.y - 50, autoAlpha:1, blurFilter:{blurY:50, quality:3}});
			TweenLite.to(preloader, 0.5, {y: preloader.y + 50, blurFilter:{blurY:0, quality:3}, ease: Back.easeOut, onComplete: onComplete});
		}

		
		override protected function animatePreloaderOut(preloader : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(preloader, 0.3, {y: preloader.y + 50, delay: 0.5, autoAlpha: 0, ease: Back.easeIn, blurFilter:{blurY:50, quality:3}, onComplete: onComplete});
		}

		override protected function animateAssetIn(asset : DisplayObject, onComplete : Function) : void 
		{
			TweenLite.to(asset, 0, {autoAlpha:1, colorMatrixFilter:{amount:3, contrast:3, brightness:3}, blurFilter:{blurX:50, blurY:50, quality:3}});
			TweenLite.to(asset, 1.5, {autoAlpha:1, colorMatrixFilter:{amount:1, contrast:1, brightness:1}, blurFilter:{blurX:0, blurY:0, quality:3}, onComplete: onComplete, ease:Strong.easeOut});
		}

	}
}
