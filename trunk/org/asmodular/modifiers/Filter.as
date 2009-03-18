package org.asmodular.modifiers
{
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;

	public class Filter extends AudioObject implements IModifier
	{
		public static const LOW_PASS:String = 'lowPass';
		public static const HIGH_PASS:String = 'highPass';
		public static const BAND_PASS:String = 'bandPass';
		
		private var _low:Number;
		private var _high:Number;
		private var _band:Number;
		private var _notch:Number;
		private var _f:Number;
		private var _scale:Number;


		public function Filter( p_mode:String = LOW_PASS )
		{
			_filterMode = p_mode;
			super();
		}
		
		override protected function init():void
		{
			_low = 0;
			_high = 0;
			_band = 0;
			_notch = 0;
			_freq = 1;
			_scale = _q = 0.1;
			updateValues();
		}
		
		
		/**
		 *  
		 * Filter frequency
		 */		
		 
		private var _freq:Number;
		
		public function set frequency( p_freq:Number ):void
		{
			_freq = p_freq;
			if ( _freq < 0 ) _freq = 0;
			if ( _freq > 1 ) _freq = 1;
			updateValues();
		}
		
		public function get frequency():Number
		{
			return _freq;
		}
		
		
		/**
		 * 
		 * Filter resonance ( [0 < q <= 1] most res: q=1, less: q=0 ) 
		 * 
		 */		
		 
		private var _q:Number;
		
		public function set resonance( p_res:Number ):void
		{
			_q = 1 - p_res;
			if ( _q < .1 ) _q = .1;
			if ( _q > 1 ) _q = 1;
			_scale = Math.sqrt( _q );
			//trace( p_res  +' > ' + _q + ' > ' + _scale );
			//trace('_q='+_q+'\t $$$ _scale='+_scale);
		}
		
		public function get resonance():Number
		{
			return 1 - _q;
		}
		
		/**
		 *
		 * Filter Mode ( Filter.LOW_PASS | Filter.HIGH_PASS | Filter.BAND_PASS ); 
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
		
		
		/* *********************** */
		
		private function updateValues():void
		{
			// var c:Number;
			_f = 2 * Math.sin( Math.PI * ( _freq * _appData.sampleRate / 4 ) / _appData.sampleRate );	
		}
				
		override public function getData( p_name:String = '' ):ByteArray
		{
			var source:ByteArray;
			
			if ( _source )
			{
				source = _source.getData();
				source.position = 0;
				_outputData.clear();
				this['compute_'+_filterMode](source);
				return _outputData;
			}
			else
			{
				// no source set, sending silence
				return _appData.silenceBytes;
			}
			
			
		}
		
		private function compute_lowPass(source:ByteArray):void
		{
			var i:int = _bufferSize;
			var out:Number;
			
			while( i-- )
			{
				_low = _low + _f * _band;
				_high = _scale * source.readFloat() - _low - _q * _band;
				_band = _f * _high + _band;
				//_notch = _high + _low;
				
				out = (_low + _band) / 2;
				_outputData.writeFloat( out );
				_outputData.writeFloat( out );
				source.position += 4;
			}
		}
		
		private function compute_highPass(source:ByteArray):void
		{
			var i:int = _bufferSize;
			var out:Number;
			
			while( i-- )
			{
				_low = _low + _f * _band;
				_high = _scale * source.readFloat() - _low - _q * _band;
				_band = _f * _high + _band;
				
				out = (_high + _band) / 2;
				_outputData.writeFloat( out );
				_outputData.writeFloat( out );
				source.position += 4;
			}
		}
		
		private function compute_bandPass(source:ByteArray):void
		{
			var i:int = _bufferSize;
			var out:Number;
			
			while( i-- )
			{
				_low = _low + _f * _band;
				_high = _scale * source.readFloat() - _low - _q * _band;
				_band = _f * _high + _band;

				_outputData.writeFloat( _band );
				_outputData.writeFloat( _band );
				source.position += 4;
			}
		}
		
	}
}