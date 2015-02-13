package ui 
{
	import flash.display.Graphics;
	/**
	 * ...
	 * @author ractis
	 */
	public class ProgressBar extends BaseView 
	{
		// Range
		private var _min:int = 0;
		private var _max:int = 100;
		private var _value:int = 0;
		
		private var _progressColor:uint = 0x00FF33;
		private var _progressAlpha:Number = 1.0;
		
		public function ProgressBar() 
		{
			super();
			
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
			// Bar
			var per:Number = Math.min( Math.max( ( value - min ) / ( max - min ), 0.0 ), 1.0 );
			updateProgressBar( viewWidth * per );
		}
		
		protected function updateProgressBar( progressWidth:Number ):void
		{
			var g:Graphics = graphics;
			g.beginFill( progressColor, progressAlpha );
			g.drawRect( 0, 0, progressWidth, viewHeight );
			g.endFill();
		}
		
		public function get min():int 
		{
			return _min;
		}
		
		public function set min(value:int):void 
		{
			if ( _min == value ) return;
			_min = value;
			setDirty();
		}
		
		public function get max():int 
		{
			return _max;
		}
		
		public function set max(value:int):void 
		{
			if ( _max == value ) return;
			_max = value;
			setDirty();
		}
		
		public function get value():int 
		{
			return _value;
		}
		
		public function set value(value:int):void 
		{
			if ( _value == value ) return;
			_value = value;
			setDirty();
		}
		
		public function get progressColor():uint 
		{
			return _progressColor;
		}
		
		public function set progressColor(value:uint):void 
		{
			_progressColor = value;
			setDirty();
		}
		
		public function get progressAlpha():Number 
		{
			return _progressAlpha;
		}
		
		public function set progressAlpha(value:Number):void 
		{
			_progressAlpha = value;
			setDirty();
		}
		
	}

}