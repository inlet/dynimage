/*
 *	DynImage for ActionScript 3.0
 *	Copyright © 2010 Inlet.nl
 *	All rights reserved.
 *	
 *	http://github.com/inlet/dynimage
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Log Meister nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	DynImage is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	DynImage is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with DynImage.  If not, see <http://www.gnu.org/licenses/>.
 *	
 *	Version 1.0
 *	
 */
package dynimage 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	[Event(name="ImageEvent.STARTED", type="dynimage.ImageEvent")]
	[Event(name="ImageEvent.PROGRESS", type="dynimage.ImageEvent")]
	[Event(name="ImageEvent.ERROR", type="dynimage.ImageEvent")]
	[Event(name="ImageEvent.COMPLETE", type="dynimage.ImageEvent")]

	public class Image extends AbstractAsset 
	{
		
		private var _modifier : Function;
		private var _modifierParams : Object;

		/**
		 * Image
		 * 
		 * TODO: validate image type
		 * @param url:String path to image
		 * @param modifier:Function (optional) apply bitmap manipulation before it is rendered on display list
		 * @param modifierParams:Object (optional) modifier arguments
		 * @param preloader:DisplayObject (optional) show a preloader while image is loading?
		 * @param autoStart:Boolean (optional) directly start with loading?
		 */
		public function Image(url : String, modifier : Function = null, modifierParams : Object = null, preloader : DisplayObject = null, autoStart : Boolean = true) 
		{
			_modifier = modifier;
			_modifierParams = modifierParams;
			
			super( url, preloader, autoStart );
		}

		/**
		 * Place the preloader on stage.
		 * Center preloader if possible.
		 */
		override protected function placePreloader() : void 
		{
			super.placePreloader( );
			
			if (_modifierParams) 
			{
				if (!_modifierParams.hasOwnProperty("width") || !_modifierParams.hasOwnProperty("height")) return;
				_preloader.x = _modifierParams['width'] / 2;
				_preloader.y = _modifierParams['height'] / 2;
			}
		}

		/**
		 * Apply custom modifier on image is modifier is specified.
		 * 
		 * @param asset:DisplayObject
		 * @return DisplayObject
		 */
		override protected function getModifiedAsset(asset : DisplayObject) : DisplayObject 
		{
			if (_modifier is Function && _modifierParams is Object) return _modifier( asset, _modifierParams );
			return getCopyAsBitmap( asset );
		}

		/**
		 * Forced the returned width
		 * 
		 * @return Number
		 */
		override public function get width() : Number 
		{
			if (_modifierParams)
			{
				if (_modifierParams.hasOwnProperty("width")) 
					return _modifierParams['width'];
			}
				
			return super.width;
		}

		/**
		 * Force the returned height.
		 * 
		 * @return Number
		 */
		override public function get height() : Number 
		{
			if (_modifierParams)
			{
				if (_modifierParams.hasOwnProperty("height")) 
					return _modifierParams['height'];
			}
			
			return super.height;
		}

		/**
		 * Return display object as Bitmap
		 * 
		 * TODO: Make proportional scale when width or height succeed max
		 * @param inDisplayObject:DisplayObject
		 * @return Bitmap
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
		
		/**
		 * Throttle setting.
		 * The amount of loaders to use.
		 */
		public static function set LOADER_COUNT(inLoaderCount : uint) : void
		{
			ImageLoader.loaderCount = inLoaderCount;
		}

		public static function get LOADER_COUNT() : uint
		{
			return ImageLoader.loaderCount;
		}
	}
}
