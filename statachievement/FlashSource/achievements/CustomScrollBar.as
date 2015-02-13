package achievements 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import ui.ScrollBar;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class CustomScrollBar extends ScrollBar 
	{
		private var _bg:Bitmap;
		private var _incementButton:DisplayObjectContainer;
		private var _decrementButton:DisplayObjectContainer;
		
		private var _knobLayers:Array;
		
		public function CustomScrollBar() 
		{
			super();
			
			viewWidth = 15;
			arrowLength = 17;
			
			addChildAt( _bg = new ScrollBarBgClass(), 0 );
			
			//
			// Knob
			//
			_knobLayers = [ new ScrollKnobClass(), new ScrollKnobOverClass(), new ScrollKnobOverClass(), new ScrollKnobClass() ];
			knob = new SimpleButton( _knobLayers[0], _knobLayers[1], _knobLayers[2], _knobLayers[3] );
			
			//
			// Arrow button
			//
			var createArrowImpl:Function = function ( disabledClass:Class, upClass:Class, overClass:Class, increment:int ):DisplayObjectContainer
			{
				var cont:Sprite = new Sprite();
				
				cont.addChild( new disabledClass() );
				cont.addChild( new SimpleButton( new upClass(), new overClass(), new overClass(), new upClass() ) );
				
				cont.addEventListener( MouseEvent.CLICK, function ( e:MouseEvent ):void
				{
					value += increment;
				} );
				
				return cont;
			}
			
			var incrementStep:int = 100;
			addChild( _decrementButton = createArrowImpl( ScrollArrowUpDisabledClass, ScrollArrowUpUpClass, ScrollArrowUpOverClass, -incrementStep ) );
			addChild( _incementButton = createArrowImpl( ScrollArrowDownDisabledClass, ScrollArrowDownUpClass, ScrollArrowDownOverClass, incrementStep ) );
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			_decrementButton.y = 1;
			_incementButton.y = viewHeight - arrowLength;
		}
		
		override protected function updateKnob(knobY:Number, knobHeight:Number):void 
		{
			//super.updateKnob(knobY, knobHeight);
			
			knob.y = knobY;
		//	knob.height = knobHeight;
			for each ( var layer:DisplayObject in _knobLayers )
			{
				layer.height = knobHeight;
			}
		}
		
		override protected function updateBackground():void 
		{
		//	super.updateBackground();
			graphics.clear();
			
			_bg.height = viewHeight;
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
			var bDisabledDecr:Boolean = value <= min;
			_decrementButton.getChildAt(0).visible = bDisabledDecr;
			_decrementButton.getChildAt(1).visible = !bDisabledDecr;
			
			var bDisabledIncr:Boolean = value + extent >= max;
			_incementButton.getChildAt(0).visible = bDisabledIncr;
			_incementButton.getChildAt(1).visible = !bDisabledIncr;
		}
		
		[Embed(source = "assets/ScrollBar_Bg.png")]
		static private const ScrollBarBgClass:Class;
		
		[Embed(source = "assets/ScrollBar_Knob.png", scaleGridTop="4", scaleGridBottom="16", scaleGridLeft="2", scaleGridRight="13")]
		static private const ScrollKnobClass:Class;
		
		[Embed(source = "assets/ScrollBar_Knob_over.png", scaleGridTop="4", scaleGridBottom="16", scaleGridLeft="2", scaleGridRight="13")]
		static private const ScrollKnobOverClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Up_Disabled.png")]
		static private const ScrollArrowUpDisabledClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Up_up.png")]
		static private const ScrollArrowUpUpClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Up_over.png")]
		static private const ScrollArrowUpOverClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Down_Disabled.png")]
		static private const ScrollArrowDownDisabledClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Down_up.png")]
		static private const ScrollArrowDownUpClass:Class;
		
		[Embed(source = "assets/ScrollBar_Arrow_Down_over.png")]
		static private const ScrollArrowDownOverClass:Class;
	}

}