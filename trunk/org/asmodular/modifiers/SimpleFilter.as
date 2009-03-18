package org.asmodular.modifiers
{
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;

	public class SimpleFilter extends AudioObject
	{
		public static const BAND_PASS:String = 'bandPass';
		public static const LOW_PASS:String = 'lowPass';
		public static const HIGH_PASS:String = 'highPass';
		
		private var _fb:Number;
		private var _buf1:Number;
		private var _buf0:Number;
		
		public function SimpleFilter( p_mode:String = LOW_PASS )
		{
			_filterMode = p_mode;
			super();
		}
		
		override protected function init():void
		{
			_f = .9999;
			_q = 0;
			_buf0 = 0;
			_buf1 = 0;
			_fb = 0;
		}
		
		/**
		 * frequency
		 */		
		 
		private var _f:Number;
		
		public function set frequency( p_freq:Number ):void
		{
			_f = p_freq;
			//_f = 2.0*Math.sin(Math.PI*p_freq);
			
			if ( _f == 1 ) _f = .9999;
			//if ( _f >= .99 ) _f = .99;
			updateValues();
		}
		
		public function get frequency():Number
		{
			return _f;
		}
		
		/**
		 * resonance
		 */		
		 
		private var _q:Number;
		
		public function set resonance( p_resonance:Number ):void
		{
			_q = p_resonance;
			if ( _q >= .99 ) _q = .99;
			updateValues();
		}
		
		public function get resonance():Number
		{
			return _q;
		}


		/**
		 *
		 * Filter Mode ( SimpleFilter.LOW_PASS | SimpleFilter.HIGH_PASS | SimpleFilter.BAND_PASS ); 
		 *  
		 */		
		
		private var _filterMode:String;
		
		public function set mode( p_mode:String ):void
		{
			_filterMode = p_mode;
			// updateValues();
		}
		
		public function get mode():String
		{
			return _filterMode;
		}
		
		
		/****** PRIVATE ************/
		
		private function updateValues():void
		{
			//_fb = _q + _q / ( 1 - _f );
			_fb = _q + _q / (1.0 - _f);
		}
		
		override public function getData( p_name:String = '' ):ByteArray
		{
			if ( _source )
			{
				_sourceData = _source.getData();
				_sourceData.position = 0;
				_outputData.clear();
				this['computeData_'+_filterMode]();
				return _outputData
			}
			else
			{
				// no source set, sending silence
				return _appData.silenceBytes;
			}
			
		}
		
		private function computeData_highPass():void
		{
			var i:int = _bufferSize;
			var hp:Number, bp:Number, out:Number;
			
			while( i-- )
			{
				hp = _sourceData.readFloat() - _buf0;
				bp = _buf0 - _buf1;
				_buf0 = _buf0 + _f * (hp + _fb * bp);
				_buf1 = _buf1 + _f * (_buf0 - _buf1);
				
				//out = _buf1; // lowpass
				//out = bp; // bandpass
				out = hp; // highpass
				
				_sourceData.position += 4;
				_outputData.writeFloat( out );
				_outputData.writeFloat( out );
			}
		}
		
		private function computeData_lowPass():void
		{
			var i:int = _bufferSize;
			var hp:Number, bp:Number, out:Number;
			
			while( i-- )
			{
				hp = _sourceData.readFloat() - _buf0;
				bp = _buf0 - _buf1;
				_buf0 = _buf0 + _f * (hp + _fb * bp);
				_buf1 = _buf1 + _f * (_buf0 - _buf1);
				out = _buf1;
				_sourceData.position += 4;
				_outputData.writeFloat( out );
				_outputData.writeFloat( out );
			}
		}
		
				
		private function computeData_bandPass():void
		{
			var i:int = _bufferSize;
			var hp:Number, bp:Number, out:Number;
			
			while( i-- )
			{
				hp = _sourceData.readFloat() - _buf0;
				bp = _buf0 - _buf1;
				_buf0 = _buf0 + _f * (hp + _fb * bp);
				_buf1 = _buf1 + _f * (_buf0 - _buf1);
				out = bp;
				_sourceData.position += 4;
				_outputData.writeFloat( out );
				_outputData.writeFloat( out );
			}
		}
		
	}
	
}