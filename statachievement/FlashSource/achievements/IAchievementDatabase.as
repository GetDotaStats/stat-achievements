package achievements 
{
	
	/**
	 * ...
	 * @author ractis
	 */
	public interface IAchievementDatabase 
	{
		function get isLoading():Boolean;
		function set isLoading( value:Boolean ):void;
		function setValue( achievementID:int, achievementValue:int ):void;
		
		function getChangeList( bClearChangeList:Boolean = true ):Array;
	}
	
}