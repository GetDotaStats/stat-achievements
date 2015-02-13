package achievements.events 
{
	import achievements.AchievementInfo;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementEvent extends Event 
	{
		static public const LOADED:String = "loaded";
		static public const CHANGED_VALUE:String = "changedValue";
		static public const ACHIEVED:String = "achieved";
		
		public var info:AchievementInfo;
		
		public function AchievementEvent(type:String, $info:AchievementInfo = null) 
		{
			super(type);
			
			info = $info;
		}
		
	}

}