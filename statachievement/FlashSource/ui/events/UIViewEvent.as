package ui.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class UIViewEvent extends Event 
	{
		static public const RESIZED:String = "resized";
		static public const CHANGED_VALUE:String = "changedValue";
		static public const CHANGED_SELECTED:String = "changedSelected";
		
		public function UIViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new UIViewEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ViewEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}