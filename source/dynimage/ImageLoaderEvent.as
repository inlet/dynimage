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