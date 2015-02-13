package ui 
{
	/**
	 * ...
	 * @author ractis
	 */
	public class TableContentView extends BaseView 
	{
		private var _headerHeight:int = 0;
		private var _rowHeight:int = 50;
		
		public function TableContentView() 
		{
			super();
			
		}
		
		override public function updateLayout():void 
		{
			var currentY:int = _headerHeight;
			for each ( var cell:BaseView in subviews )
			{
				cell.viewSize = new Vec2i( viewWidth, _rowHeight > 0 ? _rowHeight : cell.viewHeight );
				
				cell.y = currentY;
				currentY += cell.viewHeight;
			}
			
			viewHeight = currentY;
			
			super.updateLayout();
		}
		
		public function get rowHeight():int 
		{
			return _rowHeight;
		}
		
		public function set rowHeight(value:int):void 
		{
			if ( _rowHeight == value ) return;
			
			_rowHeight = value;
			setDirty();
		}
		
		public function get headerHeight():int 
		{
			return _headerHeight;
		}
		
		public function set headerHeight(value:int):void 
		{
			if ( _headerHeight == value ) return;
			
			_headerHeight = value;
			setDirty();
		}
		
	}

}