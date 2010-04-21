package dynimage 
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.getQualifiedClassName;

	internal class ImageLoader extends EventDispatcher 
	{

		private var _waitingStack : Array = new Array( );
		private var _loadingStack : Array = new Array( );
		private var _loaderCount : uint;

		public function ImageLoader(inLoaderCount : Number = Number.NaN) 
		{
			_loaderCount = isNaN( inLoaderCount ) ? Image.LOADER_COUNT : inLoaderCount;
		}

		public function loadAsset(inUrl : String, inName : String = "") : void 
		{
			if ((inUrl == null) || (inUrl.length == 0)) 
			{
				var evt : ImageLoaderEvent = new ImageLoaderEvent( ImageLoaderEvent.ERROR, inName );
				evt.error = "invalid url";
				dispatchEvent( evt );
				
				return;
			}

			_waitingStack.push( new ImageData( inUrl, inName ) );
			loadNext( );
		}

		public function stopLoadingAll() : void 
		{
			for each (var fd : ImageData in _loadingStack) stopLoadingAsset( fd.name );
			
			_loadingStack = new Array( );
			_waitingStack = new Array( );
		}

		public function stopLoadingAsset(inName : String) : void 
		{
			for each (var fd : ImageData in _loadingStack) 
			{
				if (fd.name == inName)
				{
					if (fd.loader.contentLoaderInfo) 
						try { fd.loader.close( ); }catch(e:Error){}

					_loadingStack.splice( _loadingStack.indexOf( fd ), 1 );
				}
			}
		}

		public function removeAsset(inName : String) : void
		{
			stopLoadingAsset( inName );
			
			for each (var fd : ImageData in _waitingStack) 
			{
				if (fd.name == inName)
				{
					_waitingStack.splice( _waitingStack.indexOf( fd ), 1 );
				}
			}
		}

		public function getTotalBytesLoaded() : uint 
		{
			return getTotalCount( "bytesLoaded" );
		}

		public function getTotalBytesCount() : uint 
		{
			return getTotalCount( "bytesTotal" );
		}

		private function getTotalCount(inProperty : String) : uint 
		{
			var count : uint = 0;
			for each (var fd : ImageData in _loadingStack) 
			{
				var info : LoaderInfo = fd.loader.contentLoaderInfo;
				count += info[inProperty];
			}
			
			return count;
		}

		private function loadNext() : void 
		{
			if (_loadingStack.length == _loaderCount) return;
			if (_waitingStack.length == 0 && _loadingStack.length == 0) 
			{
				dispatchEvent( new ImageLoaderEvent( ImageLoaderEvent.ALL_LOADED ) );
				return;
			}
			
			var fd : ImageData = _waitingStack.shift( ) as ImageData;
			
			var loader : Loader = new Loader( );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleLoaderEvent );
			loader.contentLoaderInfo.addEventListener( Event.OPEN, handleLoadStarted );
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, handleLoaderProgressEvent );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleLoaderEvent );
			loader.contentLoaderInfo.addEventListener( SecurityErrorEvent.SECURITY_ERROR, handleLoaderEvent );

			fd.loader = loader;
			_loadingStack.push( fd );
			
			loader.load( new URLRequest( fd.url ), new LoaderContext( true ) );
		}

		private function handleLoadStarted(e : Event) : void 
		{
			var info : LoaderInfo = e.target as LoaderInfo;
			var fd : ImageData = getDataForLoaderInfo( info );
			var evt : ImageLoaderEvent;
			
			if (fd == null) 
			{
				evt = new ImageLoaderEvent( ImageLoaderEvent.ERROR, fd.name );
				evt.loader = fd.loader;
				evt.error = "ImageLoader.handleLoadStarted() Data for loader not found";
				dispatchEvent( evt );
				
				return;
			}

			evt = new ImageLoaderEvent( ImageLoaderEvent.START, fd.name );
			evt.loader = fd.loader;
			evt.loadedBytesCount = 0;
			evt.totalBytesCount = 0;
			dispatchEvent( evt );
		}

		private function handleLoaderEvent(e : Event) : void 
		{
			var info : LoaderInfo = e.target as LoaderInfo;
			var fd : ImageData = getDataForLoaderInfo( info );
			
			var evt : ImageLoaderEvent;
			if (fd == null) return;

			if (e is ErrorEvent) 
			{
				evt = new ImageLoaderEvent( ImageLoaderEvent.ERROR, fd.name );
				evt.error = ErrorEvent( e ).text;
			} else {
				evt = new ImageLoaderEvent( ImageLoaderEvent.COMPLETE, fd.name );
				evt.loader = fd.loader;
				evt.loaderInfo = info;
				evt.url = fd.url;

				var reSWF : RegExp = /^.*\.swf$/i;
				evt.asset = reSWF.test( evt.url ) ? fd.loader.content : fd.loader;
			}
			
			dispatchEvent( evt );
			
			_loadingStack.splice( _loadingStack.indexOf( fd ), 1 );
			removeAsset( fd.name );
			
			loadNext( );
		}

		private function handleLoaderProgressEvent(e : ProgressEvent) : void 
		{
			var info : LoaderInfo = e.target as LoaderInfo;
			var fd : ImageData = getDataForLoaderInfo( info );
			
			var evt : ImageLoaderEvent;
			
			if (fd == null) 
			{
				evt = new ImageLoaderEvent( ImageLoaderEvent.ERROR, fd.name );
				evt.loader = fd.loader;
				evt.error = "ImageLoader.handleLoaderProgressEvent() Data for loader not found";
			} else {
				evt = new ImageLoaderEvent( ImageLoaderEvent.PROGRESS, fd.name );
				evt.loader = fd.loader;
				evt.loadedBytesCount = e.bytesLoaded;
				evt.totalBytesCount = e.bytesTotal;
			}
			
			dispatchEvent( evt );
		}

		private function getDataForLoaderInfo(inInfo : LoaderInfo) : ImageData 
		{
			for each (var fd : ImageData in _loadingStack) 
			{
				if (fd.loader.contentLoaderInfo == inInfo) return fd;
			}
			
			return null;
		}

		override public function toString() : String 
		{
			return getQualifiedClassName( this ) + " :: loaderCount[" + _loaderCount + "] loadingStack[" + _loadingStack .length + "] waitingStack[" + _waitingStack.length + "]";
		}
	}
}

import flash.display.Loader;

internal class ImageData 
{

	public var loader : Loader;
	public var url : String;
	public var name : String;
	public var bytesTotal : Number;
	public var bytesLoaded : Number;

	public function ImageData(inURL : String, inName : String) 
	{
		url = inURL;
		name = inName;
	}
}