package org.asmodular.modifiers
{
	import org.asmodular.core.AudioObject;

	public class Decimator extends AudioObject
	{
		private var num:Number;
		private var pos:Number;
		private var tmp:Number;
		
		public function Decimator()
		{
			super();
		}
		
		override protected function init():void
		{
			amount = 0;
			pos = 0;
			tmp = 0;
		}
		
		/**
		 * amount
		 */		
		 
		private var _amount:Number;
		
		public function set amount( p_amount:Number ):void
		{
			_amount = p_amount;
			num = _amount * 100;
		}
		
		public function get amount():Number
		{
			return _amount;
		}
		
		override protected function computeData():void
		{
			var i:int = _appData.bufferSize;
			
			while(i--)
			{
				if (++pos > num) 
				{
					tmp = _sourceData.readFloat();
					_sourceData.position += 4;
					pos = 0;
				}
				else
				{
					_sourceData.position += 8;
				}
				_outputData.writeFloat( tmp );
				_outputData.writeFloat( tmp );
				
			}
		}
	}
}