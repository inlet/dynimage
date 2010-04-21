# What is DynImage

Something many actionscript developers use a lot is loading external images in their application. You don't want to create the whole code each time for only showing a simple image.
With this point of view I started to create this extension which is very useful and came in handy in most every project.

So what is DynImage? A very simple image loader with extendible functionality. It's very lightweight and easy to use!
You can assign a preloader and create custom animations in a single line of code. Besides cropping/scaling an image to fulfill your needs is all included! It work's in Flex, Flash and Pure as3.

# How do I use it?

Here are some examples

### Load an image

This is the most simple form of loading an external image.

<pre>
var image : Image = new Image("path.to.image");
addChild(image);
</pre>
 

### Load image with a custom preloader

To assign a preloader to an image while loading, just give the preloader clip (Display Object) in the constructor like below:

<pre>
var image : Image = new Image("path.to.image", null, null, preloaderClip);
addChild(image);
</pre>


### Scale/crop image in the desired proportions

This is one of the things that make DynImage very useful! You can easily modify your loaded image before it is rendered on the display list.
Create your own modifiers is easy like pushing a function through the constructor with it's parameters. 

By default the ImageModifiers class provides the most primair modifier functionality like scaling and cropping:

* ImageModifiers.fit		 <code> *Make the image proportionally fit to given boundaries* </code>
* ImageModifiers.fill		 <code> *Fill the image to given boundaries* </code>


#### Examples

Let's make the image fit in a box of 300x300px and align the image in the center of it

<pre>
var image : Image = new Image("path.to.image", ImageModifiers.fit, {width:300, height:300, align:ImageAlign.CENTER});
addChild(image);
</pre>

Let's make the image fill a box of 300x300px and align the image top right

<pre>
var image : Image = new Image("path.to.image", ImageModifiers.fill, {width:300, height:300, align:ImageAlign.TR});
addChild(image);
</pre>


# Write your own Image Modifiers!

Like the included ImageModifiers class, you can easily create your own one to manipulate the image data before it is actually rendered on the display list.
All you have to do is create a function like this:

<pre>
/**
* @param original:DisplayObject the original image to modify
* @param params:Object the specified parameters
*/
public static function myModifier(original : DisplayObject, params : Object) : Bitmap
{
	// manipulate original with params
	var newImage : Bitmap = ....
	return newImage;
}
</pre>
