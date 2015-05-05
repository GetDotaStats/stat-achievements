package achievements 
{
	
	/**
	 * ...
	 * @author ractis
	 */
	public interface IAchievementGroupView 
	{
		function updateLayout():void;
		function addAchievement( info:AchievementInfo ):void;
		function removeAchievement( info:AchievementInfo ):void;
		function removeAllAchievements():void;
	}
	
}