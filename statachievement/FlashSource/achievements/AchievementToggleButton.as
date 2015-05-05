package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementToggleButton extends Sprite 
	{
		private var _toggleButton:SimpleButton;
		private var _toggleBadgeButton:SimpleButton;
		
		private var _badgeLabel:TextField;
		
		private var _target:AchievementListPanel;
		
		private var _currentBadgeCount:int;
		
		public function AchievementToggleButton( target:AchievementListPanel ) 
		{
			super();
			
			_target = target;
			
			x = 0;
			y = 38;
			
			// Create components
			addChild( _toggleButton = new SimpleButton( new ToggleClass(), new ToggleOverClass(), new ToggleOverClass(), new ToggleClass() ) );
			addChild( _toggleBadgeButton = new SimpleButton( new ToggleCountClass(), new ToggleCountOverClass(), new ToggleCountOverClass(), new ToggleCountClass() ) );
			
			_badgeLabel = Utils.CreateLabel( "0", FontType.TextFontBold, function ( format:TextFormat ):void
			{
				format.size = 9;
				format.color = 0xFFFFFF;
				format.align = TextFormatAlign.CENTER;
			} );
			_badgeLabel.alpha = 0.9;
			addChild( _badgeLabel );
			_badgeLabel.x = 28;
			_badgeLabel.y = 7;
			_badgeLabel.width = 21;
			_badgeLabel.height = _badgeLabel.textHeight + 4;
			
			filters = [ new DropShadowFilter( 0 ) ];
			
			// Hide the target panel
			target.visible = false;
			
			// Badge
			_updateBadge( 0 );
			
			// Event listener
			addEventListener( MouseEvent.CLICK, function ( e:MouseEvent ):void
			{
				target.visible = !target.visible;
				
				if ( target.visible )
				{
					_updateBadge( 0 );
				}
			} );
			
			AchievementDatabase.instance.addEventListener( AchievementEvent.ACHIEVED, function ( e:AchievementEvent ):void
			{
				_updateBadge( target.visible ? 0 : _currentBadgeCount + 1 );
			} );
		}
		
		private function _updateBadge( nCount:int ):void
		{
			_currentBadgeCount = nCount;
			
			var bShowBadge:Boolean = nCount > 0 && !_target.visible;
			
			_toggleButton.visible = !bShowBadge;
			_toggleBadgeButton.visible = bShowBadge;
			_badgeLabel.visible = bShowBadge;
			
			if ( bShowBadge )
			{
				// Update the label
				_badgeLabel.text = nCount.toString();
			}
		}
		
		[Embed(source = "assets/Toggle.png")]				static private const ToggleClass:Class;
		[Embed(source = "assets/Toggle_over.png")]			static private const ToggleOverClass:Class;
		[Embed(source = "assets/Toggle_Count.png")]			static private const ToggleCountClass:Class;
		[Embed(source = "assets/Toggle_Count_over.png")]	static private const ToggleCountOverClass:Class;
	}

}