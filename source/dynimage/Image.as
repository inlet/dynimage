package dynimage 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class Image extends AbstractAsset 
	{
		public static var LOADER_COUNT : int = 3;

		private var _modifier : Function;
		private var _modifierParams : Object;

		public function Image(url : String, modifier : Function = null, modifierParams : Object = null, preloader : DisplayObject = null, autoStart : Boolean = true) 
		{
			_modifier = modifier;
			_modifierParams = modifierParams;

			if (modifierParams == null)	modifierParams = new Object( );
			if (modifierParams.width == null) modifierParams.width = 0;
			if (modifierParams.height == null) modifierParams.height = 0;
			
			if (!preloader) preloader = new Sprite( );
			
			super( url, preloader, autoStart );
		}

		override protected function placePreloader() : void 
		{
			super.placePreloader( );
			
			if (_modifierParams != null) 
			{
				if (_modifierParams.width == 0 || _modifierParams.height == 0) return;
				if (_modifierParams.originalWidth == 0 || _modifierParams.originalHeight == 0) return;
				
				_preloader.x = _modifierParams.width / 2;
				_preloader.y = _modifierParams.height / 2;
			}
		}

		override protected function getModifiedAsset(asset : DisplayObject) : DisplayObject 
		{
			if (_modifier != null && _modifierParams != null) return _modifier( asset, _modifierParams );
			return getCopyAsBitmap( asset );
		}

		override public function get width() : Number 
		{
			if (_modifierParams)
				if (_modifierParams.width > 0) return _modifierParams.width;
				
			return super.width;
		}

		override public function get height() : Number 
		{
			if (_modifierParams)
				if (_modifierParams.height > 0) return _modifierParams.height;
			
			return super.height;
		}

		/**
		 * TODO: Make proportional scale when width or height succeed max
		 */
		private function getCopyAsBitmap(inDisplayObject : DisplayObject) : Bitmap 
		{
			var width : Number = Math.min( Math.max( 1, inDisplayObject.width ), 2880 );
			var height : Number = Math.min( Math.max( 1, inDisplayObject.height ), 2880 );
			
			var bmpData : BitmapData;
			try 
			{
				bmpData = new BitmapData( width, height, true, 0x00000000 );
				bmpData.draw( inDisplayObject );
			} catch (e : Error) 
			{
				var evt : ImageEvent = new ImageEvent(ImageEvent.ERROR);
				evt.errorMessage = "Image.getCopyAsBitmap() Can't create bitmap data from " + inDisplayObject + ", width[" + inDisplayObject .width + "] height[" + inDisplayObject.height + "]";
				dispatchEvent(evt);
				
				bmpData = new BitmapData(0, 0);
			}
			
			var bmp : Bitmap = new Bitmap( bmpData );
			bmp.smoothing = true;
			
			return bmp;
		}
	}
}
