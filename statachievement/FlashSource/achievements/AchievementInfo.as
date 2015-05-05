package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import ui.BaseView;
	import ui.DisplayObjectView;
	import ui.ImageLoader;
	
	/**
	 * https://github.com/GetDotaStats/stat-achievements#achievementinfo
	 * @author ractis
	 */
	public class AchievementInfo extends EventDispatcher
	{
		private var _id:int;
		private var _name:String;
		private var _description:String;
		private var _maxValue:int = 1;
		private var _currentValue:int = 0;
		private var _isRecentlyAchieved:Boolean = false;
		
		private var _isDummy:Boolean;
		
		public function AchievementInfo( achievementID:int, isDummy:Boolean = false ) 
		{
			_isDummy = isDummy;
			if ( !isDummy )
			{
				_id = achievementID;
				_name = "#ACHIEVEMENT_" + achievementID + "_NAME";
				_description = "#ACHIEVEMENT_" + achievementID + "_DESCRIPTION";
			}
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get description():String 
		{
			return _description;
		}
		
		public function get icon():BaseView 
		{
			if ( !_isDummy )
			{
				var suffix:String = isAchieved ? "on" : "off";
				return new ImageLoader( "images/achievements/" + id + "_" + suffix + ".png" );
			}
			else
			{
				return new DisplayObjectView( new DummyAchievementImg() );
			}
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function get maxValue():int 
		{
			return _maxValue;
		}
		
		public function set maxValue(value:int):void 
		{
			_maxValue = value;
		}
		
		public function get currentValue():int 
		{
			return _currentValue;
		}
		
		public function set currentValue(value:int):void
		{
			if ( _currentValue == value ) return;
			
			var isLastAchieved:Boolean = isAchieved;
			
			_currentValue = value;
			dispatchEvent( new AchievementEvent( AchievementEvent.CHANGED_VALUE, this ) );
			
			// Check wheather the achievement has been achieved.
			if ( !isLastAchieved )
			{
				if ( currentValue >= maxValue )
				{
					// Achieved!
					if ( !AchievementDatabase.instance.isLoading )
					{
						// Achievement earned in this session.
						_isRecentlyAchieved = true;
					}
					
					dispatchEvent( new AchievementEvent( AchievementEvent.ACHIEVED, this ) );
				}
			}
		}
		
		public function get progressText():String 
		{
		//	return "<bold>" + _countCurrent + "</bold> / " + _countMax;
			return _currentValue + " / " + _maxValue;
		}
		
		public function get hasProgressBar():Boolean
		{
			return maxValue > 1;
		}
		
		public function get isAchieved():Boolean
		{
			return currentValue >= maxValue;
		}
		
		public function get isRecentlyAchieved():Boolean
		{
			return _isRecentlyAchieved;
		}
		
		public function set isRecentlyAchieved(value:Boolean):void
		{
			_isRecentlyAchieved = value;
		}
		
		//
		// Dummy
		//
		[Embed(source = "assets/achievement.jpg")]
		static private const DummyAchievementImg:Class;
		
		static public function createDummyAchievementInfo( bCounting:Boolean ):AchievementInfo
		{
			var dummy:AchievementInfo = new AchievementInfo( -999999, true );
			
			if ( !bCounting )
			{
				dummy._name = "F in Chemistry";
				dummy._description = "On day 1 of the Rat job, blow up the lab.";
			}
			else
			{
				dummy._name = "License to Kill";
				dummy._description = "Kill 378 enemies using the Gruber Kurz handgun.";
				dummy._currentValue = Math.random() * 378;
				dummy._maxValue = 378;
			}
			
			return dummy;
		}
		
	}

}