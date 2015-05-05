package ui 
{
	/**
	 * ...
	 * @author ractis
	 */
	public class TabView extends BaseView 
	{
		private var _currentIndex:int = 0;
		
		public function TabView() 
		{
			super();
			
		}
		
		override public function addSubview(subview:BaseView):void 
		{
			super.addSubview(subview);
			
			var index:int = subviews.indexOf( subview );
			if ( index != _currentIndex )
			{
				subview.visible = false;
			}
			
			setDirty();
		}
		
		public function get currentIndex():int 
		{
			return _currentIndex;
		}
		
		public function set currentIndex(value:int):void 
		{
			subviews[_currentIndex].visible = false;
			
			_currentIndex = value;
			
			subviews[value].visible = true;
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			for each ( var subview:BaseView in subviews )
			{
				subview.viewWidth = viewWidth;
				subview.viewHeight = viewHeight;
			}
		}
		
	}

}