package dynimage 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	internal class ImgQueue extends EventDispatcher 
	{

		private static var _loader : ImgLoader;
		private static var _instance : ImgQueue;
		private static var _queue : Dictionary;

		public static function getInstance() : ImgQueue 
		{
			if(_instance == null) 
			{
				_instance = new ImgQueue( );
				_queue = new Dictionary( );
				
				_loader = new ImgLoader( );
				_loader.addEventListener( ImgLoaderEvent.ALL_LOADED, onImageLoaderEvent );
				_loader.addEventListener( ImgLoaderEvent.COMPLETE, onImageLoaderEvent );
				_loader.addEventListener( ImgLoaderEvent.ERROR, onImageLoaderEvent );
				_loader.addEventListener( ImgLoaderEvent.PROGRESS, onImageLoaderEvent );
				_loader.addEventListener( ImgLoaderEvent.START, onImageLoaderEvent );
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

		private static function onImageLoaderEvent(evt : ImgLoaderEvent) : void 
		{
			if(_queue[evt.name] != null) 
			{
				if(evt.type == ImgLoaderEvent.COMPLETE) 
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

		public static function get imageLoader() : ImgLoader 
		{
			return _loader;	
		}		

	}
}
