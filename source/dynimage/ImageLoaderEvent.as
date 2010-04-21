package dynimage 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	internal class ImageLoaderEvent extends Event 
	{

		public static const START : String = "ImageLoaderEvent.START";
		public static const PROGRESS : String = "ImageLoaderEvent.PROGRESS";
		public static const COMPLETE : String = "ImageLoaderEvent.COMPLETE";
		public static const ALL_LOADED : String = "ImageLoaderEvent.ALL_LOADED";
		public static const ERROR : String = "ImageLoaderEvent.ERROR";

		public var name : String;
		public var totalBytesCount : uint;
		public var loadedBytesCount : uint;
		public var error : String;
		public var loader : Loader;
		public var loaderInfo : LoaderInfo;

		public var asset : DisplayObject;
		public var url : String;

		public function ImageLoaderEvent(inType : String, inName : String = "") 
		{
			super( inType );
			
			name = inName;
		}

		public override function clone() : Event
		{
			var evt : ImageLoaderEvent = new ImageLoaderEvent( type, name );
			evt.totalBytesCount = totalBytesCount;
			evt.loadedBytesCount = loadedBytesCount;
			evt.error = error;
			evt.loader = loader;
			evt.loaderInfo = loaderInfo;
			evt.asset = asset;
			evt.url = url;
			
			return evt;
		} 
		
		public override function toString() : String 
		{
			return getQualifiedClassName( this ) + " name[" + name + "] error[" + error + "] totalBytesCount[" + totalBytesCount + "] loadedBytesCount[" + loadedBytesCount + "]";
		}
	}
}