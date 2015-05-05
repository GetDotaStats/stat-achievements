package ui 
{
	import flash.events.MouseEvent;
	import ui.events.UIViewEvent;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class SegmentedControl extends BaseView 
	{
		private var _selectedIndex:int = 0;
		private var _margin:int = 0;
		
		public function SegmentedControl() 
		{
			super();
			
		}
		
		override public function addSubview(subview:BaseView):void 
		{
			super.addSubview(subview);
			
			subview.addEventListener( MouseEvent.CLICK, _onClickButton );
			
			subview.isSelected = subviews.indexOf( subview ) == selectedIndex;
		}
		
		override public function removeSubview(subview:BaseView):void 
		{
			subview.removeEventListener( MouseEvent.CLICK, _onClickButton );
			
			super.removeSubview(subview);
		}
		
		private function _onClickButton(e:MouseEvent):void 
		{
			selectedIndex = subviews.indexOf( BaseView(e.currentTarget) );
		}
		
		public function get selectedIndex():int 
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex( value:int ):void
		{
			subviews[_selectedIndex].isSelected = false;
			_selectedIndex = value;
			subviews[_selectedIndex].isSelected = true;
			
			dispatchEvent( new UIViewEvent( UIViewEvent.CHANGED_SELECTED ) );
		}
		
		public function get margin():int 
		{
			return _margin;
		}
		
		public function set margin(value:int):void 
		{
			if ( _margin == value ) return;
			_margin = value;
			setDirty();
		}
		
		override public function updateLayout():void 
		{
			var currentX:int = 0;
			var maxHeight:int = 0;
			for each ( var segment:BaseView in subviews )
			{
				segment.x = currentX;
				currentX += segment.viewWidth + margin;
				maxHeight = Math.max( segment.viewHeight, maxHeight );
			}
			
			currentX -= margin;
			viewWidth = currentX;
			viewHeight = maxHeight;
			
			super.updateLayout();
		}
		
	}

}