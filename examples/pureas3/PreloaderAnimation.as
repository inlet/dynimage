package  
{
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Patrick.Brouwer (patrick at inlet dot nl)
	 * Originaly created by Bernard Visser (Debit.nl)
	 */
	public class PreloaderAnimation extends Sprite 
	{

		private var _radius : int;
		private var _thickness : int;
		private var _innerMargin : int;
		private var _degreePerTick : int = 2;
		private var _innerColor : uint;
		private var _outerColor : uint;

		public function PreloaderAnimation(innerColor : uint = 0x666666, outerColor : uint = 0x1D89E5, radius : int = 16, thickness : int = 5, innerMargin : int = 0) 
		{
			_innerColor = innerColor;
			_outerColor = outerColor;
			
			_radius = radius;
			_thickness = thickness;
			_innerMargin = innerMargin;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			addEventListener(Event.REMOVED, dispose, false, 0, true);
			
			rotation = -90;
			scaleY = -1;
		}

		private function init(evt : Event) : void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//  set the starting state which is 0% loaded 
			update(1, 5);
		}

		private function dispose(evt : Event) : void 
		{
			removeEventListener(Event.ENTER_FRAME, rotateLoader);
		}

		private function rotateLoader(evt : Event) : void 
		{
			rotation -= 8;	
		}

		public function update(bytesLoaded : int, bytesTotal : int) : void 
		{
			if(bytesLoaded == 1 && bytesTotal == 5) 
			{
				addEventListener(Event.ENTER_FRAME, rotateLoader, false, 0, true);	
			} else {
				removeEventListener(Event.ENTER_FRAME, rotateLoader);
				rotation = -90;
			}
			
			var cx : Number, cy : Number, px : Number, py : Number, tempAngle : int;
			var angle : int = Math.round((bytesLoaded / bytesTotal) * 360);
			var radMid : Number = (Math.PI / 180) * _degreePerTick;
			var distanceToControllPoint : Number = _radius / Math.cos(radMid / 2);
			
			graphics.clear();
			graphics.lineStyle(_thickness, _outerColor, 1, false);
			graphics.drawCircle(0, 0, _radius);
			
			graphics.lineStyle(_thickness - _innerMargin, _innerColor, 1, false);
			
			graphics.moveTo(_radius, 0);
			
			tempAngle = 0;
			for(var i : int = 0 ;i < Math.floor(angle / _degreePerTick);i++) 
			{
				tempAngle += _degreePerTick;
				cx = Math.cos(tempAngle * Math.PI / 180 - radMid / 2) * distanceToControllPoint;
				cy = Math.sin(tempAngle * Math.PI / 180 - radMid / 2) * distanceToControllPoint;
				
				px = Math.cos(tempAngle * Math.PI / 180) * _radius;
				py = Math.sin(tempAngle * Math.PI / 180) * _radius;
				
				graphics.curveTo(cx, cy, px, py);
			}
		}
	}
}
