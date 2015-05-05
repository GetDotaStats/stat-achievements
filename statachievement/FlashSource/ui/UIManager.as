package ui 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class UIManager extends Sprite
	{
		static private var _instance:UIManager;
		
		private var _viewsSetDirty:Dictionary = new Dictionary();
		
		public function UIManager() 
		{
			addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		static public function createUIManager( stage:Stage ):void
		{
			if ( _instance ) return;
			
			_instance = new UIManager();
			stage.addChild( _instance );
		}
		
		static public function setDirty( view:BaseView ):void
		{
			_instance._viewsSetDirty[view] = view;
		}
		
		private function _onEnterFrame( e:Event ):void 
		{
			var viewsSetDirtyCurrentFrame:Dictionary = _viewsSetDirty;
			_viewsSetDirty = new Dictionary();
			
			for each ( var view:BaseView in viewsSetDirtyCurrentFrame )
			{
				view.updateView();
			}
		}
		
	}

}