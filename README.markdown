# What is DynImage

Something many actionscript developers use a lot is loading external images in their application. You don't want to create the whole code each time for only showing a simple image.
With this point of view I started to create this extension which is very useful and came in handy in most every project.

So what is DynImage? A very simple image loader with extendible functionality. It's very lightweight and easy to use!
You can assign a preloader and create custom animations in a single line of code. It work's in Flex, Flash and Pure as3.

# How do I use it?

Here are some examples

### Load an image

This is the most simple form of loading an external image.

<pre>
var image : Image = new Image("url.to.image");
addChild(image);
</pre>
 

### Load image with a custom preloader

To assign a preloader to an image while loading, just give the preloader clip (Display Object) in the constructor like below:

<pre>
var image : Image = new Image("url.to.image", null, null, preloaderClip);
addChild(image);
</pre>


### Scale/crop image in the desired proportions

This is one of the things that make DynImage very useful! You can easily modify your loaded image before it is rendered on the display list.
Create your own modifiers is easy like pushing a function through the constructor with it's parameters. 

By default the ImageModifiers class provides the most primair modifier functionality like scaling and cropping:

* ImageModifiers.fit <code>*Make the image proportionally fit to given boundaries*</code>
* ImageModifiers.fill *Fill the image to given boundaries*

<pre>
var image : Image = new Image("url.to.image", null, null, preloaderClip);
addChild(image);
</pre>