package achievements 
{
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import ui.BaseView;
	
	/**
	 * ...
	 * @author ractis
	 */
	public class GroupViewHeader extends BaseView 
	{
		private var _groupLabel:TextField;
		
		public function GroupViewHeader( groupName:String ) 
		{
			super();
			
			backgroundColor = 0x050505;
			
			_groupLabel = Utils.CreateLabel( groupName, FontType.TitleFont, function ( format:TextFormat ):void
			{
				format.size = 14;
				format.align = TextFormatAlign.CENTER;
				format.color = 0xFFFFFF;
			} );
			_groupLabel.alpha = 0.75;
			
			addChild( _groupLabel );
		}
		
		override public function updateLayout():void 
		{
			super.updateLayout();
			
			_groupLabel.width = viewWidth;
			_groupLabel.height = _groupLabel.textHeight + 4;
			_groupLabel.y = halfViewHeight - _groupLabel.textHeight / 2 + 2;
		}
		
	}

}