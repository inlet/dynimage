package dynimage 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;

	public class ImageModifiers 
	{

		private static function getBitmap(displayObject : DisplayObject, matrix : Matrix, width : Number, height : Number) : Bitmap
		{
			var bmd : BitmapData = new BitmapData( width, height, true, 0x000000 );
			bmd.draw( displayObject, matrix, null, null, null, true );
			
			var bmp : Bitmap = new Bitmap( bmd );
			bmp.pixelSnapping = PixelSnapping.AUTO;
			bmp.smoothing = true;
			return bmp;
		}

		private static function getMatrix(originalWidth : Number, originalHeight : Number, newWidth : Number, newHeight : Number, scale : Number, align : String) : Matrix
		{
			var matrix : Matrix = new Matrix( );
			matrix.createBox( scale, scale );

			switch (align.toUpperCase( )) 
			{
				case "L":
					matrix.tx = 0;
					matrix.ty = newHeight / 2 - (originalHeight * scale) / 2;
					break;
				case "TL":
					matrix.tx = 0;
					matrix.ty = 0;
					break;
				case "BL":
					matrix.tx = 0;
					matrix.ty = newHeight - originalHeight * scale;
					break;
				case "R":
					matrix.tx = newWidth - originalWidth * scale;
					matrix.ty = newHeight / 2 - (originalHeight * scale) / 2;
					break;
				case "TR":
					matrix.tx = newWidth - originalWidth * scale;
					matrix.ty = 0;
					break;
				case "BR":
					matrix.tx = newWidth - originalWidth * scale;
					matrix.ty = newHeight - originalHeight * scale;
					break;
				case "B":
					matrix.tx = newWidth / 2 - (originalWidth * scale) / 2;
					matrix.ty = newHeight - originalHeight * scale;
					break;
				case "T":
					matrix.tx = newWidth / 2 - (originalWidth * scale) / 2;
					matrix.ty = 0;
					break;
				default: 
					// center
					matrix.tx = newWidth / 2 - (originalWidth * scale) / 2;
					matrix.ty = newHeight / 2 - (originalHeight * scale) / 2;
					break;
			}	
			
			return matrix;
		}

		public static function fit(displayObject : DisplayObject, params : Object) : Bitmap
		{
			var w : Number = params.width;
			var h : Number = params.height;
			var align : String = params.align ? params.align : "center";
			
			var fx : Number = w / displayObject.width;
			var fy : Number = h / displayObject.height;
			
			var scale : Number = (w == 0) ? fy : h == 0 ? fx : Math.min( fx, fy );
			var matrix : Matrix = getMatrix( displayObject.width, displayObject.height, w, h, scale, align );
			
			w = (w > 0) ? w : displayObject.width * scale;
			h = (h > 0) ? h : displayObject.height * scale;

			var bmp : Bitmap = getCopyAsBitmap( displayObject );
			return ImageModifiers.getBitmap( bmp, matrix, w, h );
		}

		public static function fill(displayObject : DisplayObject, params : Object) : Bitmap 
		{
			var w : Number = params.width;
			var h : Number = params.height;
			var align : String = params.align ? params.align : "center";
			
			var fx : Number = w / displayObject.width;
			var fy : Number = h / displayObject.height;
			
			var scale : Number = (w == 0) ? fy : h == 0 ? fx : Math.max( fx, fy );
			var matrix : Matrix = getMatrix( displayObject.width, displayObject.height, w, h, scale, align );
			
			w = (w > 0) ? w : displayObject.width * scale;
			h = (h > 0) ? h : displayObject.height * scale;

			var bmp : Bitmap = getCopyAsBitmap( displayObject );
			return ImageModifiers.getBitmap( bmp, matrix, w, h );
		}
		
		private static function getCopyAsBitmap(inDisplayObject : DisplayObject) : Bitmap 
		{
			var width : Number = Math.min( Math.max( 1, inDisplayObject.width ), 2880 );
			var height : Number = Math.min( Math.max( 1, inDisplayObject.height ), 2880 );
			
			try 
			{
				var bmpData : BitmapData = new BitmapData( width, height, true, 0x00000000 );
				bmpData.draw( inDisplayObject );
			} catch (e : Error) 
			{
				throw Error( "error creating bitmap: " + e.message );
			}
			
			var bmp : Bitmap = new Bitmap( bmpData );
			bmp.smoothing = true;
			
			return bmp;
		}
	}
}
