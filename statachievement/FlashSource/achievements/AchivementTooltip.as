package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import ui.BaseView;
	import ui.ProgressBar;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class AchivementTooltip extends BaseView 
	{
		private var _owner:BaseView;
		private var _info:AchievementInfo;
		private var _progressBar:ProgressBar;
		private var _progressLabel:TextField;
		
		public function AchivementTooltip( achievementInfo:AchievementInfo, owner:BaseView ) 
		{
			super();
			
			_owner = owner;
			_info = achievementInfo;
			
			mouseEnabled = false;
			mouseChildren = false;
			
		//	filters = [ new DropShadowFilter( 0, 45, 0, 1, 3, 3, 3 ) ];
			
			viewWidth = 300;
			viewHeight = 80;
			
			var margin:Number = 10;
			
			//
			// Name Label
			//
			var nameLabel:TextField = Utils.CreateLabel( _info.name, FontType.TitleFont, function ( format:TextFormat ):void
			{
				format.size = 14;
			} );
			nameLabel.width = viewWidth - margin*2;
			nameLabel.x = margin;
			nameLabel.y = margin;
			nameLabel.textColor = 0xFFFFFF;
			nameLabel.alpha = 0.95;
			addChild( nameLabel );
			
			//
			// Description label
			//
			var descLabel:TextField = Utils.CreateLabel( _info.description, FontType.TextFontBold, function ( format:TextFormat ):void
			{
				format.size = 10;
			} );
			with ( descLabel )
			{
				width = viewWidth - margin*2;
				x = margin + 1;
				y = 45;
				textColor = 0xFFFFFF;
				alpha = 0.75;
				multiline = true;
				wordWrap = true;
				height = textHeight + 4;
			}
			addChild( descLabel );
			
			//
			// Update viewheight
			//
			viewHeight = descLabel.y + descLabel.height + margin + 2;
			
			//
			// (Optional) Progress bar
			//
			if ( _info.hasProgressBar )
			{
				viewHeight += 20;
				
				_progressBar = new ProgressBar();
				_progressBar.viewWidth = (viewWidth - 20) * 0.7;
				_progressBar.viewHeight = 4;
				_progressBar.max = _info.maxValue;
				_progressBar.value = _info.currentValue;
				_progressBar.x = margin + 1;
				_progressBar.y = viewHeight - 20 + 0.5;
				_progressBar.backgroundColor = 0xFFFFFF;
				_progressBar.backgroundAlpha = 0.25;
				_progressBar.progressColor = 0x33AAFF;
				_progressBar.progressAlpha = 0.75;
				
				addChild( _progressBar );
				
				_progressLabel = Utils.CreateLabel( _info.progressText, FontType.TextFontBold, function ( format:TextFormat ):void
				{
					format.size = 12;
					format.align = TextFormatAlign.LEFT;
				} );
				_progressLabel.textColor = 0x33AAFF;
				_progressLabel.x = _progressBar.viewWidth + 20;
				_progressLabel.y = viewHeight - 26;
				_progressLabel.alpha = 0.9;
				addChild( _progressLabel );
			}
			
			// Add event listeners
			addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
			addEventListener( Event.REMOVED_FROM_STAGE, _onRemovedFromStage );
		}
		
		private function _onAddedToStage(e:Event):void 
		{
			_info.addEventListener( AchievementEvent.CHANGED_VALUE, _onChangedValue );
			_onChangedValue();
		}
		
		private function _onRemovedFromStage(e:Event):void 
		{
			_info.removeEventListener( AchievementEvent.CHANGED_VALUE, _onChangedValue );
		}
		
		private function _onChangedValue(e:AchievementEvent = null):void 
		{
			if ( _info.hasProgressBar )
			{
				_progressBar.value = _info.currentValue;
				_progressLabel.text = _info.progressText;
			}
		}
		
		public function show():void 
		{
			if ( stage ) return;
			
			_updatePosition();
			
			_owner.stage.addChild( this );
			
			addEventListener( Event.ENTER_FRAME, _onEnterFrame );
		}
		
		public function hide():void 
		{
			if ( stage == null ) return;
			
			removeEventListener( Event.ENTER_FRAME, _onEnterFrame );
			
			stage.removeChild( this );
		}
		
		private function _onEnterFrame( e:Event ):void 
		{
			_updatePosition();
		}
		
		private function _updatePosition():void 
		{
			var offsetX:Number = 40;
			var offsetY:Number = -35;
		//	var mousePos:Point = _owner.localToGlobal( new Point( _owner.mouseX, _owner.mouseY ) );
			var mousePos:Point = _owner.localToGlobal( new Point( _owner.halfViewWidth, _owner.halfViewHeight ) );
			this.x = mousePos.x + offsetX;
			this.y = mousePos.y + offsetY;
		}
		
		override protected function updateBackground():void 
		{
			//super.updateBackground();
			var g:Graphics = graphics;
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox( viewWidth, viewHeight, Math.PI / 2 );
			
			g.clear();
			g.beginGradientFill( GradientType.LINEAR, [ 0x303030, 0x101010 ], [ 1, 1 ], [ 0, 255 ], matrix );
			g.lineStyle( 1, 0xFFFFFF, 0.25 );
			g.drawRoundRect( 0, 0, viewWidth, viewHeight, 8 );
			g.endFill();
		}
		
		override protected function updateForeground():void 
		{
			super.updateForeground();
			
			var g:Graphics = graphics;
			
			g.lineStyle( 1, 0xFFFFFF, 0.15 );
			g.moveTo( 7, 36 );
			g.lineTo( viewWidth - 7, 36 );
		}
		
	}

}