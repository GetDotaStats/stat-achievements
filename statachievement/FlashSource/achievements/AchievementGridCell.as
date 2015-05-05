package achievements 
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import ui.BaseView;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementGridCell extends BaseView 
	{
		private var _info:AchievementInfo;
		private var _tooltipPanel:AchivementTooltip;
		
		public function AchievementGridCell( achievementInfo:AchievementInfo ) 
		{
			super();
			
			viewWidth = 64;
			viewHeight = 64;
			backgroundAlpha = 0;
			
			_info = achievementInfo;
			
			var margin:int = 5;
			
			// Icon
			var icon:BaseView = _info.icon;
			addChild( icon );
			icon.x = margin;
			icon.y = margin;
			icon.viewWidth = viewWidth - margin*2;
			icon.viewHeight = viewHeight - margin * 2;
			
			// Make rounded
		//	var maskShape:Shape = new Shape();
		//	var g:Graphics = maskShape.graphics;
		//	g.beginFill( 0xFFFFFF );
		//	g.drawRoundRect( icon.x, icon.y, icon.viewWidth, icon.viewHeight, 2, 2 );
		//	g.endFill();
		//	icon.mask = maskShape;
		//	addChild( maskShape );
		
			// Register event listeners
			addEventListener( MouseEvent.ROLL_OVER,		_onMouseRollOver );
			addEventListener( MouseEvent.ROLL_OUT,		_onMouseRollOut );
		}
		
		private function _onMouseRollOut( e:MouseEvent ):void 
		{
			if ( _tooltipPanel == null ) return;
			
			_tooltipPanel.hide();
		}
		
		private function _onMouseRollOver( e:MouseEvent ):void 
		{
			if ( _tooltipPanel == null ) {
				_tooltipPanel = new AchivementTooltip( _info, this );
			}
			
			_tooltipPanel.show();
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
			var g:Graphics = graphics;
			g.beginFill( 0x000, 1 );
			g.drawRoundRect( 1, 1, viewWidth-2, viewHeight-2, 6, 6 );
			g.endFill();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( viewWidth, viewHeight, Math.PI / 2 );
			var colors:Array = _info.isAchieved ? [ 0xcba900, 0x665814 ] : [ 0x999999, 0x444444 ];
			g.beginGradientFill( GradientType.LINEAR, colors, [ 1, 1 ], [ 0, 255 ], matrix );
			g.drawRoundRect( 2, 2, viewWidth - 4, viewHeight - 4, 5, 5 );
			g.endFill();
		}
		
	}

}