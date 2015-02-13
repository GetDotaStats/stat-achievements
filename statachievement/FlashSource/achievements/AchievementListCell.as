package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import ui.BaseView;
	import ui.ProgressBar;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchievementListCell extends BaseView 
	{
		private var _info:AchievementInfo;
		
		// Required components
		private var _nameLabel:TextField;
		private var _descriptionLabel:TextField;
		
		// Optional components
		private var _progressLabel:TextField;
		private var _progressBar:ProgressBar;
		
		public function AchievementListCell( achievementInfo:AchievementInfo ) 
		{
			super();
			
			_info = achievementInfo;
			
			// BG
			addChild( new BgClass() );
			
			// Icon
			var iconBG:Shape = new Shape();
			addChild( iconBG );
			with ( iconBG )
			{
				x = 12;
				y = 8;
			}
			
			var g:Graphics = iconBG.graphics;
			g.beginFill( 0x000, 1 );
			g.drawRoundRect( 0, 0, viewWidth-2, viewHeight-2, 6, 6 );
			g.endFill();
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( viewWidth, viewHeight, Math.PI / 2 );
			var colors:Array = _info.isAchieved ? [ 0xcba900, 0x665814 ] : [ 0x999999, 0x444444 ];
			g.beginGradientFill( GradientType.LINEAR, colors, [ 1, 1 ], [ 0, 255 ], matrix );
			g.drawRoundRect( 1, 1, viewWidth - 4, viewHeight - 4, 5, 5 );
			g.endFill();
			
			var icon:BaseView = _info.icon;
			addChild( icon );
			icon.x = 16;
			icon.y = 12;
			icon.viewWidth = 40;
			icon.viewHeight = 40;
			
			// Labels
			_nameLabel = Utils.CreateLabel( _info.name, FontType.TextFontBold );
			_nameLabel.textColor = 0xFFFFFF;
			addChild( _nameLabel );
			_nameLabel.x = 70;
			_nameLabel.y = 16;
			
			_descriptionLabel = Utils.CreateLabel( _info.description, FontType.TextFont, function ( format:TextFormat ):void
			{
				format.size = 9;
			} );
			_descriptionLabel.textColor = 0xFFFFFF;
			_descriptionLabel.alpha = 0.5;
			addChild( _descriptionLabel );
			_descriptionLabel.x = 70;
			_descriptionLabel.y = 31;
			
			if ( achievementInfo.hasProgressBar )
			{
				_progressBar = new ProgressBar();
				_progressBar.viewHeight = 4;
				_progressBar.max = _info.maxValue;
				_progressBar.value = _info.currentValue;
				addChild( _progressBar );
				_progressBar.x = 70 + 2;
				_progressBar.backgroundColor = 0xFFFFFF;
				_progressBar.backgroundAlpha = 0.25;
				_progressBar.progressColor = 0x33AAFF;
				_progressBar.progressAlpha = 0.75;
				
				_progressLabel = Utils.CreateLabel( _info.progressText, FontType.TextFontBold, function ( format:TextFormat ):void
				{
					format.size = 10;
					format.align = TextFormatAlign.LEFT;
				} );
				_progressLabel.textColor = 0x33AAFF;
				addChild( _progressLabel );
			}
			
			// Add event listeners
			addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemovedFromStage );
		}
		
		private function _onAddedToStage(e:Event):void 
		{
			_info.addEventListener( AchievementEvent.CHANGED_VALUE, _onChangedValue );
		}
		
		private function _onRemovedFromStage(e:Event):void 
		{
			_info.removeEventListener( AchievementEvent.CHANGED_VALUE, _onChangedValue );
		}
		
		private function _onChangedValue(e:AchievementEvent):void 
		{
			if ( _info.hasProgressBar )
			{
				_progressBar.value = _info.currentValue;
				_progressLabel.text = _info.progressText;
			}
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			// Height
			var marginTopProgress:Number = 1;
			var sumHeight:Number = 0;
			sumHeight += _nameLabel.textHeight;
			sumHeight += _descriptionLabel.textHeight;
			if ( _progressLabel ) sumHeight += _progressLabel.textHeight + marginTopProgress - 5;
			
			var y:Number = ( viewHeight - sumHeight ) / 2;
			y += -1;	// Offset
			
			_nameLabel.y = y;
			y += _nameLabel.textHeight;
			_descriptionLabel.y = y;
			y += _descriptionLabel.textHeight;
			
			if ( _progressLabel )
			{
				y += marginTopProgress;
				_progressLabel.y = y - 1;
				_progressBar.y = ( _progressLabel.textHeight - _progressBar.viewHeight ) / 2 + y + 1;
			}
			
			// Width
			_nameLabel.width = viewWidth - _nameLabel.x - 8;
			_descriptionLabel.width = viewWidth - _descriptionLabel.x - 8;
			if ( _progressLabel )
			{
				_progressBar.viewWidth = viewWidth - 180;
				_progressLabel.x = _progressBar.x + _progressBar.viewWidth + 8;
			}
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
		/*	var g:Graphics = graphics;
			g.beginFill( 0x666666 );
			g.drawRect( 0, 0, viewWidth, viewHeight );
			g.endFill();
			g.beginFill( 0x222222 );
			g.drawRect( 2, 2, viewWidth - 4, viewHeight - 4 );
			g.endFill();*/
		}
		
		[Embed(source = "assets/ListCellBackground.png")]
		static private const BgClass:Class;
		
	}

}