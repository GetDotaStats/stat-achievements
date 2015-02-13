package achievements 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementPopup extends Sprite 
	{
		private var _container:Sprite;
		private var _nextPopup:AchievementPopup;
		
		private var _offsetNextPopup:Number = 0;
		
		public function AchievementPopup( title:String, subtitle:String, icon:DisplayObject ) 
		{
			super();
			
			_container = new Sprite();
			addChild( _container );
			
			var primaryColor:uint = 0x30bfbf;
			
			// Labels
			var lbTitle:TextField = Utils.CreateLabel( title, FontType.TextFont );
			_container.addChild( lbTitle );
			lbTitle.textColor = primaryColor;
			lbTitle.x = 87; lbTitle.y = 24;
			lbTitle.width = 145;
			
			var lbSubtitle:TextField = Utils.CreateLabel( subtitle, FontType.TextFont );
			_container.addChild( lbSubtitle );
			lbSubtitle.x = 87; lbSubtitle.y = 50;
			lbSubtitle.width = 145;
			
			// icon
			_container.addChild( icon );
			icon.x = 13; icon.y = 14;
			
			// Background
			var g:Graphics = _container.graphics;
			g.beginFill( 0x111111 );
			g.lineStyle( 1, primaryColor, 0.5 );
			g.drawRect( 0, 0, containerWidth, containerHeight );
			g.endFill();
		}
		
		public function get containerWidth():Number
		{
			return 238;
		}
		
		public function get containerHeight():Number
		{
			return 92;
		}
		
		public function set nextPopup( popup:AchievementPopup ):void
		{
			_nextPopup = popup;
			_nextPopup.y = y + _offsetNextPopup;
		}
		
		public function animate( onComplete:Function ):void
		{
			var durationToShow:Number = 2.5;
			
			TweenLite.fromTo( _container, 0.75, {
				y : -_container.height,
				alpha : 0
			}, {
				y : 0,
				alpha : 1,
				ease : Cubic.easeOut,
				onUpdate : _onUpdate
			} );
			
			TweenLite.to( _container, 0.75, {
				y : -_container.height,
				alpha : 0,
				ease : Cubic.easeIn,
				onUpdate : _onUpdate,
				onComplete : onComplete
			} ).delay( durationToShow + 0.75 );
		}
		
		override public function set y( value:Number ):void 
		{
			super.y = value;
			if ( _nextPopup )
			{
				_nextPopup.y = Math.max( y + _offsetNextPopup, 0 );
			}
		}
		
		private function _onUpdate():void
		{
			_offsetNextPopup = _container.y + containerHeight;
			if ( _nextPopup )
			{
				_nextPopup.y = Math.max( y + _offsetNextPopup, 0 );
			}
		}
		
	}

}