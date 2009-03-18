package org.asmodular.modifiers
{
	import org.asmodular.core.AudioObject;

	public class WaveShaper extends AudioObject
	{
		private var k:Number;
		
		public function WaveShaper()
		{
			super();
		}
		
		override protected function init():void
		{
			amount = 0;
		}
		
		/**
		 * amount 
		 */		
		 
		private var _amount:Number;
		
		public function set amount( p_amount:Number ):void
		{
			// try 2 :
			/*
			_amount = p_amount*2-1;
			if (_amount<-1) _amount = -1;
			if (_amount>1) _amount = 1;
			 k =  2*_amount/(1-_amount);
			*/
			// try 3 :
			
			_amount = p_amount;
			k = 1 + _amount * 20;
			
			// try 4 :
			//_amount = p_amount;
			
		}
		
		public function get amount():Number
		{
			return _amount;
		}
		
		
		override protected function computeData():void
		{
			var i:int = _appData.bufferSize;
			var t:Number;
			
			while(i--)
			{
				t = _sourceData.readFloat();
				
				// try 1 :
				//t = 1.5 * t - 0.5 * t *t * t;
				
				// try 2 :
				//t = (1+k)*t/(1+k*Math.abs(t));
				
				// try 3 :
				//f(x,a) = x*(abs(x) + a)/(x^2 + (a-1)*abs(x) + 1)
				t = t * (Math.abs(t) + k) / (t * t + (k-1)*Math.abs(t) + 1 );
				
				// try 4 :
				//if ( t > _amount ) t =  _amount - ( t - _amount );
				//if ( t < -_amount ) t =  -_amount + ( -_amount - t );
								
				_sourceData.position += 4;
				_outputData.writeFloat( t );
				_outputData.writeFloat( t );

			}
		}
		
	}
}