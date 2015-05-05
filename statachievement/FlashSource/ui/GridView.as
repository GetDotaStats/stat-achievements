package ui 
{
	/**
	 * ...
	 * @author ractis
	 */
	public class GridView extends ScrollView 
	{
		
		public function GridView() 
		{
			super();
			
			contentView = createContentView();
		}
		
		protected function createContentView():BaseView
		{
			return new GridContentView();
		}
		
		public function addCell( cell:BaseView ):void
		{
			contentView.addSubview( cell );
		}
		
		public function removeAllCells():void
		{
			contentView.removeAllSubviews();
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			contentView.viewWidth = viewWidth;
		}
		
	}

}