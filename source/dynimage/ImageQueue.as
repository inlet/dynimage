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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * Internal image queue'ing class.
	 * @see ImageLoader
	 */
	internal class ImageQueue extends EventDispatcher 
	{

		private static var _loader : ImageLoader;
		private static var _instance : ImageQueue;
		private static var _queue : Dictionary;

		/**
		 * Singleton
		 * Creates a reference to ImageLoader
		 * 
		 * @return ImageQueue
		 */
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

		/**
		 * Load an image
		 * 
		 * @param url:String path to image
		 * @param inName:String unique identifier
		 */
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

		/**
		 * Weak listener wrapper.
		 * 
		 * @param type:String
		 * @param listener:Function
		 */
		public static function addEventListener(type : String,listener : Function) : void 
		{
			getInstance( ).addEventListener( type, listener, false, 0, true );			
		}
		
		/**
		 * Weak listener wrapper.
		 * 
		 * @param type:String
		 * @param listener:Function
		 */
		public static function removeEventListener(type : String, listener : Function) : void 
		{
			getInstance( ).removeEventListener( type, listener );			
		}

		/**
		 * Get the image loader.
		 * @return ImageLoader
		 */
		public static function get imageLoader() : ImageLoader 
		{
			return _loader;	
		}		

	}
}
