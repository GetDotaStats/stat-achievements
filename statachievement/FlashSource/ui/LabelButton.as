package ui 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ractis
	 */
	public class LabelButton extends BaseView 
	{
		static private const DEFUALT_BUTTON_WIDTH:int = 120;
		static private const DEFAULT_BUTTON_HEIGHT:int = 36;
		
		private var _label:TextField;
		
		public function LabelButton( text:String = "" ) 
		{
			super();
			viewWidth = DEFUALT_BUTTON_WIDTH;
			viewHeight = DEFAULT_BUTTON_HEIGHT;
			
			// Create label
			_label = Utils.CreateLabel( text, FontType.TextFont, function ( format:TextFormat ):void
			{
				format.align = TextFormatAlign.CENTER;
			} );
			addChild( _label );
			_label.textColor = 0x333333;
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			_label.width = viewWidth;
			_label.height = _label.textHeight + 4;
			_label.y = ( viewHeight - _label.textHeight ) / 2;
		}
		
		public function get label():TextField 
		{
			return _label;
		}
		
	}

}