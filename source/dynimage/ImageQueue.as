package dynimage 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	internal class ImageQueue extends EventDispatcher 
	{

		private static var _loader : ImageLoader;
		private static var _instance : ImageQueue;
		private static var _queue : Dictionary;

		public static function getInstance() : ImageQueue 
		{
			if(_instance == null) 
			{
				_instance = new ImageQueue( );
				_queue = new Dictionary( );
				
				_loader = new ImageLoader( );
				_loader.addEventListener( ImageLoaderEvent.ALL_LOADED, onImageLoaderEvent );
				_loader.addEventListener( ImageLoaderEvent.COMPLETE, onImageLoaderEvent );
				_loader.addEventListener( ImageLoaderEvent.ERROR, onImageLoaderEvent );
				_loader.addEventListener( ImageLoaderEvent.PROGRESS, onImageLoaderEvent );
				_loader.addEventListener( ImageLoaderEvent.START, onImageLoaderEvent );
			}
			
			return _instance;	
		}

		public static function loadImage(url : String, inName : String) : void 
		{
			_queue[inName] = url;
			getInstance( )._loadImage( url, inName );
		}

		private function _loadImage(url : String, name : String) : void 
		{
			_loader.loadAsset( url, name );	
		}

		private static function onImageLoaderEvent(evt : ImageLoaderEvent) : void 
		{
			if(_queue[evt.name] != null) 
			{
				if(evt.type == ImageLoaderEvent.COMPLETE) 
					delete _queue[evt.name];
			}
			
			getInstance( ).dispatchEvent( evt.clone( ) );	
		}

		public static function addEventListener(type : String,listener : Function) : void 
		{
			getInstance( ).addEventListener( type, listener, false, 0, true );			
		}
		
		public static function removeEventListener(type : String, listener : Function) : void 
		{
			getInstance( ).removeEventListener( type, listener );			
		}

		public static function get imageLoader() : ImageLoader 
		{
			return _loader;	
		}		

	}
}
