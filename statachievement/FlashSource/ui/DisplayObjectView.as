package ui 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class DisplayObjectView extends BaseView 
	{
		private var _displayObject:DisplayObject;
		
		public function DisplayObjectView( displayObject:DisplayObject ) 
		{
			super();
			
			_displayObject = displayObject;
			addChild( _displayObject );
			
			viewWidth = displayObject.width;
			viewHeight = displayObject.height;
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			_displayObject.width = viewWidth;
			_displayObject.height = viewHeight;
		}
		
	}

}