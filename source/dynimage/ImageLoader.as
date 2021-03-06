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

	/**
	 * Internal Loader.
	 */
	internal class ImageLoader extends EventDispatcher 
	{
		
		private var _waitingStack : Array = new Array( );
		private var _loadingStack : Array = new Array( );
		internal static var loaderCount : uint = 3;

		public function ImageLoader() 
		{
		}

		/**
		 * Load image by url.
		 * 
		 * @param inUrl:String path to image
		 * @param inName:String unique id for the image.
		 */
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

		/**
		 * Stop loading all assets in queue and clear the waiting stack
		 */
		public function stopLoadingAll() : void 
		{
			for each (var fd : ImageData in _loadingStack) stopLoadingAsset( fd.name );
			
			_loadingStack = new Array( );
			_waitingStack = new Array( );
		}

		/**
		 * Stop loading image by name (identifier)
		 * 
		 * @param inName:String
		 */
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

		/**
		 * Remove asset by name (identifier)
		 * 
		 * @param inName:String
		 */
		public function removeAsset(inName : String) : void
		{
			stopLoadingAsset( inName );
			
			for each (var fd : ImageData in _waitingStack) 
			{
				if (fd.name == inName)
					_waitingStack.splice( _waitingStack.indexOf( fd ), 1 );
			}
		}

		/**
		 * Get the total bytes loaded
		 * 
		 * @param uint
		 */
		public function getTotalBytesLoaded() : uint 
		{
			return getTotalCount( "bytesLoaded" );
		}

		/**
		 * Get the total bytes count
		 * 
		 * @param uint
		 */
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
			if (_loadingStack.length == loaderCount) return;
			if (_waitingStack.length == 0) 
			{
				if (_loadingStack.length == 0)
				{
					dispatchEvent( new ImageLoaderEvent( ImageLoaderEvent.ALL_LOADED ) );
				}
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
			return getQualifiedClassName( this ) + " :: loaderCount[" + loaderCount + "] loadingStack[" + _loadingStack .length + "] waitingStack[" + _waitingStack.length + "]";
		}
	}
}

import flash.display.Loader;

/**
 * ImageData (vo).
 * Part of the loading stacks, provides information data of one single image.
 */
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
	
	public function toString() : String
	{
		return "[ImageData : " + name + "]";
	}
}