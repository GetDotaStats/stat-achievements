package achievements 
{
	import achievements.events.AchievementEvent;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import ui.ProgressBar;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class OverallProgressBar extends ProgressBar
	{
		private const LABEL_MARGIN:int = 10;
		
		private var _fgMask:Shape;
		private var _labelText:TextField;
		private var _labelNumber:TextField;
		
		public function OverallProgressBar() 
		{
			super();
			
			viewWidth = 283;
			viewHeight = 12;
			
			backgroundAlpha = 0;
			progressAlpha = 0;
			
			//
			// Background
			//
			addChild( new OverallBgClass() );
			
			//
			// Foreground
			//
			addChild( _fgMask = new Shape() );
			
			var fg:Bitmap = new OverallFgClass();
			fg.mask = _fgMask;
			addChild( fg );
			
			//
			// Label
			//
			_labelText = Utils.CreateLabel( "#Ach_OverallProgressBar", FontType.TextFont, function ( format:TextFormat ):void
			{
				format.size = 9;
				format.color = 0x82d9d9;
			} );
			_labelText.autoSize = TextFieldAutoSize.LEFT;
			addChild( _labelText );
			
			_labelNumber = Utils.CreateLabel( "-1 / -1", FontType.TextFontBold, function ( format:TextFormat ):void
			{
				format.size = 9;
				format.color = 0x82d9d9;
			} );
			_labelNumber.autoSize = TextFieldAutoSize.LEFT;
			addChild( _labelNumber );
			
			//
			// Register event listeners
			//
			AchievementDatabase.instance.addEventListener( AchievementEvent.LOADED, _onChangedNumAchieved );		// <- What's wrong?
			AchievementDatabase.instance.addEventListener( AchievementEvent.ACHIEVED, _onChangedNumAchieved );
		}
		
		private function _onChangedNumAchieved( e:AchievementEvent ):void 
		{
			try
			{
				value = AchievementDatabase.instance.numAchievedAchievements;
				max = AchievementDatabase.instance.numAchievements;
				
				// Label
				_labelNumber.text = value + " / " + max;
				
				setDirty();
			}
			catch ( e:Error )
			{
				Utils.LogError( e );
			}
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			// Centering
			var labelTotalWidth:Number = _labelText.textWidth + _labelNumber.textWidth + LABEL_MARGIN;
			_labelText.x = halfViewWidth - labelTotalWidth / 2;
			_labelNumber.x = _labelText.x + _labelText.textWidth + LABEL_MARGIN;
		}
		
		override protected function updateProgressBar(progressWidth:Number):void 
		{
			//super.updateProgressBar(progressWidth);
			var g:Graphics = _fgMask.graphics;
			g.clear();
			g.beginFill( 0xFFF );
			g.drawRect( 0, 0, progressWidth, viewHeight );
			g.endFill();
		}
		
		[Embed(source = "assets/ProgressBar_Overall_Fg.png")]
		static private const OverallFgClass:Class;
		
		[Embed(source = "assets/ProgressBar_Overall_Bg.png")]
		static private const OverallBgClass:Class;
		
	}

}