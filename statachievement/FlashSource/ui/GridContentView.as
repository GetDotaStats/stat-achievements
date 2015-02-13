package ui 
{
	/**
	 * ...
	 * @author ractis
	 */
	public class GridContentView extends BaseView 
	{
		private var _headerHeight:int = 0;
		
		public function GridContentView() 
		{
			super();
			
		}
		
		override public function updateLayout():void 
		{
			var currentX:int = 0;
			var currentY:int = _headerHeight;
			var maxHeightInLine:int = 0;
			
			var newLine:Function = function ():void
			{
				currentY += maxHeightInLine;
				currentX = 0;
				maxHeightInLine = 0;
			};
			
			for each ( var cell:BaseView in subviews )
			{
				if ( currentX != 0 && currentX + cell.viewWidth > viewWidth )
				{
					newLine();
				}
				
				cell.x = currentX;
				cell.y = currentY;
				
				currentX += cell.viewWidth;
				maxHeightInLine = Math.max( maxHeightInLine, cell.viewHeight );
			}
			
			newLine();
			viewHeight = currentY;
			
			super.updateLayout();
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