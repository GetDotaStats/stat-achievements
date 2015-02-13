package achievements 
{
	import flash.events.MouseEvent;
	import ui.LabelButton;
	import ui.TableContentView;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementDebugButtonsPanel extends TableContentView 
	{
		
		public function AchievementDebugButtonsPanel() 
		{
			super();
			
			//
			// Layout
			//
			x = 0;
			y = 500;
			
			rowHeight = 24;
			viewWidth = 200;
			
			//
			// Helper func
			//
			var createDebugButton:Function = function ( text:String, callback:Function ):void
			{
				var label:LabelButton = new LabelButton( text );
				addSubview( label );
				label.addEventListener( MouseEvent.CLICK, function ( e:MouseEvent ):void
				{
					callback();
				} );
			}
			
			//
			// Create buttons
			//
			createDebugButton( "Earn a random achievement", _earnRandomAchievement );
			createDebugButton( "Increase a progress by 35%", _increaseProgressBy35 );
		}
		
		private function get _allAchievements():Array
		{
			return AchievementDatabase.instance.achievementAry;
		}
		
		private function _earnRandomAchievement():void 
		{
			var achievementToEarn:AchievementInfo = _pickRandomAchievementFrom( _allAchievements.filter( _isAvailable ) );
			
			if ( !achievementToEarn ) return;
			
			achievementToEarn.currentValue = achievementToEarn.maxValue;
		}
		
		private function _increaseProgressBy35():void 
		{
			var ach:AchievementInfo = _pickRandomAchievementFrom( _allAchievements.filter( _isAvailable ).filter( _hasProgressBar ) );
			
			if ( !ach ) return;
			
			ach.currentValue += ach.maxValue * 0.35;
		}
		
		private function _pickRandomAchievementFrom( array:Array ):AchievementInfo
		{
			if ( array.length == 0 )
			{
				Utils.Log( "[Achievement/Debug] Earnable achievement not found." );
				return null;
			}
			
			var index:int = Math.random() * array.length;
			return array[index];
		}
		
		private function _isAvailable( item:*, index:int, array:Array ):Boolean
		{
			return !AchievementInfo( item ).isAchieved;
		}
		
		private function _hasProgressBar( item:*, index:int, array:Array ):Boolean
		{
			return AchievementInfo( item ).hasProgressBar;
		}
		
	}

}