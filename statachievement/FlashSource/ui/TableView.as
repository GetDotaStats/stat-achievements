package ui 
{
	/**
	 * ...
	 * @author ractis
	 */
	public class TableView extends GridView 
	{
		
		public function TableView() 
		{
			super();
			
		}
		
		override protected function createContentView():BaseView 
		{
			return new TableContentView();
		}
		
		public function get rowHeight():int
		{
			return tableContentView.rowHeight;
		}
		
		public function set rowHeight(value:int):void
		{
			tableContentView.rowHeight = value;
		}
		
		public function get tableContentView():TableContentView
		{
			return TableContentView(contentView);
		}
		
	}

}