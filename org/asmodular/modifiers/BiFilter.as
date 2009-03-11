package org.asmodular.modifiers
{
	
	/********************************
	 * 
	 * 	DEPRECATED, use Filter
	 * 
	 * ********************************/	
	
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;
	import org.asmodular.utils.ApplicationData;

	public class BiFilter extends AudioObject implements IModifier
	{
		public static const LOW_PASS:String = 'lowPass';
		public static const HIGH_PASS:String = 'hiPass';
		
		private var _source:AudioObject;
		private var in1:Number;
		private var in2:Number;
		private var out1:Number;
		private var out2:Number;
		private var a1:Number;
		private var a2:Number;
		private var a3:Number;
		private var b1:Number;
		private var b2:Number;
		
		public function BiFilter( p_mode:String = LOW_PASS )
		{
			_filterMode = p_mode;
			super();
		}
		
		override protected function init():void
		{
			_freq = 11000;
			_res = 0.1;
			in1 = in2 = 0;
			out1 = out2 = 0;
			updateValues();
		}
		
		
		/**
		 * addSource
		 * 
		 * @param source
		 * @param name
		 * 
		 */		
		
		public function addSource( p_source:AudioObject, p_name:String = '' ):void
		{
			_source = p_source;
		}
		
		/**
		 * removeSource 
		 * @param name
		 * 
		 */		
		
		public function removeSource( p_name:String = '' ):void
		{
			_source = null;
		}
		
		
		
		
		/**
		 *  
		 * Filter frequency (from ~0 Hz to SampleRate/2 )
		 * 
		 */		
		 
		private var _freq:Number;
		
		public function set frequency( p_freq:Number ):void
		{
			_freq = p_freq;
			if ( _freq < 0 ) _freq = 1;
			if ( _freq > _appData.sampleRate / 2 ) _freq = _appData.sampleRate / 2;
			updateValues();
		}
		
		public function get frequency():Number
		{
			return _freq;
		}
		
		
		/**
		 * 
		 * Filter resonance ( from sqrt(2) to ~ 0.1 ) 
		 * 
		 */		
		 
		private var _res:Number;
		
		public function set resonance( p_res:Number ):void
		{
			_res = p_res;
			if ( _res < .1 ) _res = .1;
			if ( _res > 1.41 ) _res = 1.41;
			updateValues();
		}
		
		public function get resonance():Number
		{
			return _res;
		}
		
		
		
		/**
		 *
		 * Filter Mode ( Filter.LOW_PASS | Filter.HIGH_PASS ); 
		 *  
		 */		
		
		private var _filterMode:String;
		
		public function set mode( p_mode:String ):void
		{
			_filterMode = p_mode;
			updateValues();
		}
		
		public function get mode():String
		{
			return _filterMode;
		}
		
		
		/* *********************** */
		
		private function updateValues():void
		{
			var c:Number;
			
			if ( _filterMode == LOW_PASS )
			{
				c = 1.0 / Math.tan(Math.PI * _freq / _appData.sampleRate);
				
				a1 = 1.0 / ( 1.0 + _res * c + c * c);
				a2 = 2* a1;
				a3 = a1;
				b1 = 2.0 * ( 1.0 - c*c) * a1;
				b2 = ( 1.0 - _res * c + c * c) * a1;
			}
			else
			{
				c = Math.tan(Math.PI * _freq / _appData.sampleRate);
				
				a1 = 1.0 / ( 1.0 + _res * c + c * c);
				a2 = -2*a1;
				a3 = a1;
				b1 = 2.0 * ( c*c - 1.0) * a1;
				b2 = ( 1.0 - _res * c + c * c) * a1;
			}
			
		}
		
		override public function getData( p_name:String = '' ):ByteArray
		{
			
			var source:ByteArray;
			var i:int, in0:Number, out0:Number;
			
			if ( _source )
			{
				source = _source.getData();
				source.position = 0;
				_outputData.clear();
				i = _bufferSize;
				while( i-- )
				{
					in0 = source.readFloat();
					out0 = a1 * in0 + a2 * in1 + a3 * in2 - b1 * out1 - b2 * out2;
					_outputData.writeFloat( out0 );
					_outputData.writeFloat( out0 );
					source.position += 4;
					in2 = in1;
					in1 = in0;
					out2 = out1;
					out1 = out0;
				}
			}
			else
			{
				// no source set, sending silence
				_outputData.clear();
				i = _bufferSize;
				while(i--) _outputData.writeDouble( 0 );
			}
			
			return _outputData;
		}
		
	}
}