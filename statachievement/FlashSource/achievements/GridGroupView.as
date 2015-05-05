package achievements 
{
	import flash.utils.Dictionary;
	import ui.GridContentView;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class GridGroupView extends GridContentView implements IAchievementGroupView
	{
		private var _header:GroupViewHeader;
		
		private var _achievementInfoToCell:Dictionary = new Dictionary();
		
		public function GridGroupView( groupName:String ) 
		{
			super();
			
			headerHeight = 40;
			
			backgroundAlpha = 0;
			
			// Label
			_header = new GroupViewHeader( groupName );
			_header.viewHeight = headerHeight;
			addChild( _header );
		}
		
		public function addAchievement( info:AchievementInfo ):void
		{
			var cell:AchievementGridCell = new AchievementGridCell( info );
			addSubview( cell );
			_achievementInfoToCell[info] = cell;
		}
		
		public function removeAchievement( info:AchievementInfo ):void
		{
			var cell:AchievementGridCell = _achievementInfoToCell[info];
			if ( cell )
			{
				removeSubview( cell );
				delete _achievementInfoToCell[info];
			}
			else
			{
				Utils.Log( "[Achievement/GroupView] Achievement not found." );
			}
		}
		
		public function removeAllAchievements():void
		{
			removeAllSubviews();
			_achievementInfoToCell = new Dictionary();
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			if ( subviews.length == 0 )
			{
				// hide
				_header.visible = false;
				viewHeight = 0;
			}
			else
			{
				_header.visible = true;
			}
			
			_header.viewWidth = viewWidth;
		}
		
		public function get header():GroupViewHeader 
		{
			return _header;
		}
		
	}

}