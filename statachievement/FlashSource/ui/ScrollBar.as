package ui 
{
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import ui.events.UIViewEvent;
	/**
	 * ...
	 * @author ractis
	 */
	public class ScrollBar extends BaseView 
	{
		private var _knob:InteractiveObject;
		
		// Bounded range
		private var _min:int = 0;
		private var _max:int = 100;
		private var _value:int = 0;
		private var _extent:int = 10;
		
		// Arrow
		private var _arrowLength:int = 12;
		
		// Dragging states
		private var _bDragging:Boolean = false;
		private var _draggingKnobStartMouseLocalY:int;
		private var _draggingKnobStartY:int;
		
		public function ScrollBar() 
		{
			super();
			
			viewWidth = 12;
			
			knob = new Sprite();
		}
		
		private function _onMouseDownKnob(e:MouseEvent):void 
		{
			if ( _bDragging ) return;
			
			// start dragging
			_bDragging = true;
			_draggingKnobStartMouseLocalY = globalToLocal( new Point( 0, e.stageY ) ).y;
			_draggingKnobStartY = _knob.y;
			
			stage.addEventListener( MouseEvent.MOUSE_UP, _onMouseUpStage );
			stage.addEventListener( MouseEvent.MOUSE_MOVE, _onMouseMoveStage );
		}
		
		private function _onMouseUpStage(e:MouseEvent):void 
		{
			if ( !_bDragging ) return;
			
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, _onMouseMoveStage );
			stage.removeEventListener( MouseEvent.MOUSE_UP, _onMouseUpStage );
			
			// Stop dragging
			_bDragging = false;
		}
		
		private function _onMouseMoveStage(e:MouseEvent):void 
		{
			var knobY:Number = globalToLocal( new Point( 0, e.stageY ) ).y - _draggingKnobStartMouseLocalY + _draggingKnobStartY;
			value = knobY / viewHeight * ( max - min ) + min;
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			var trackL:int = trackLength;
			
			// Update the knob
			var knobY:Number = ( value - min ) / ( max - min ) * trackL + _arrowLength;
			var knobHeight:Number = Math.min( extent / ( max - min ), 1.0 ) * trackL;
			
			updateKnob( knobY, knobHeight );
		}
		
		protected function updateKnob( knobY:Number, knobHeight:Number ):void
		{
			var knobAsSprite:Sprite = _knob as Sprite;
			if ( knobAsSprite )
			{
				var g:Graphics = knobAsSprite.graphics;
				g.clear();
				g.beginFill( 0x3333FF );
				g.drawRect( 0, 0, viewWidth, knobHeight );
				g.endFill();
			}
			
			_knob.y = knobY;
			_knob.height = knobHeight;
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
			value = Math.min( value, max - extent );	// First!!!
			value = Math.max( value, 0 );
			
			if ( _value == value ) return;
			
			_value = value;
			dispatchEvent( new UIViewEvent( UIViewEvent.CHANGED_VALUE ) );
			setDirty();
		}
		
		public function get extent():int 
		{
			return _extent;
		}
		
		public function set extent(value:int):void 
		{
			if ( _extent == value ) return;
			_extent = value;
			setDirty();
		}
		
		public function get trackLength():int
		{
			return viewHeight - _arrowLength * 2;
		}
		
		public function get arrowLength():int 
		{
			return _arrowLength;
		}
		
		public function set arrowLength(value:int):void 
		{
			_arrowLength = value;
			setDirty();
		}
		
		public function get knob():InteractiveObject 
		{
			return _knob;
		}
		
		public function set knob(value:InteractiveObject):void 
		{
			if ( _knob )
			{
				_knob.removeEventListener( MouseEvent.MOUSE_DOWN, _onMouseDownKnob );
				removeChild( _knob );
			}
			
			_knob = value;
			
			addChild( _knob );
			_knob.addEventListener( MouseEvent.MOUSE_DOWN, _onMouseDownKnob );
		}
		
	}

}