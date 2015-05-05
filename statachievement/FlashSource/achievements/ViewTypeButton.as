package achievements 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import ui.BaseView;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class ViewTypeButton extends BaseView 
	{
		static public const VIEW_TYPE_GRID:String	= "grid";
		static public const VIEW_TYPE_LIST:String	= "list";
		
		private var _activeButton:SimpleButton;
		private var _inactiveButton:SimpleButton;
		
		public function ViewTypeButton( type:String ) 
		{
			super();
			
			viewWidth = 24;
			viewHeight = 24;
			
			var createHitbox:Function = function ():Shape
			{
				var shape:Shape = new Shape();
				var g:Graphics = shape.graphics;
				g.beginFill( 0xFFFFFF );
				g.drawRect( 0, 0, viewWidth, viewHeight );
				g.endFill();
				return shape;
			};
			
			var createButtonImpl:Function = function ( up:Class, over:Class, down:Class ):void
			{
				_activeButton = new SimpleButton( new up(), new up(), new up(), createHitbox() );
				
				var upDisp:DisplayObject = new up();
				upDisp.alpha = 0.5;
				_inactiveButton = new SimpleButton( upDisp, new over(), new down(), createHitbox() );
			//	_inactiveButton.upState.alpha = 0.5;	// in scaleform, we can't access the display object of the state through this.
				
				addChild( _activeButton );
				addChild( _inactiveButton );
			};
			
			switch ( type )
			{
			case VIEW_TYPE_GRID: createButtonImpl( viewGridUpClass, viewGridOverClass, viewGridDownClass ); break;
			case VIEW_TYPE_LIST: createButtonImpl( viewListUpClass, viewListOverClass, viewListDownClass ); break;
			}
		}
		
		override protected function updateBackground():void 
		{
			//super.updateBackground();
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
			_activeButton.visible = isSelected;
			_inactiveButton.visible = !isSelected;
		}
		
		[Embed(source = "assets/View_Grid_up.png")]
		static public const viewGridUpClass:Class;
		
		[Embed(source = "assets/View_Grid_over.png")]
		static public const viewGridOverClass:Class;
		
		[Embed(source = "assets/View_Grid_down.png")]
		static public const viewGridDownClass:Class;
		
		[Embed(source = "assets/View_List_up.png")]
		static public const viewListUpClass:Class;
		
		[Embed(source = "assets/View_List_over.png")]
		static public const viewListOverClass:Class;
		
		[Embed(source = "assets/View_List_down.png")]
		static public const viewListDownClass:Class;
		
	}

}