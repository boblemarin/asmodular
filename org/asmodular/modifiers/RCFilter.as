package org.asmodular.modifiers
{
	
	/********************************
	 * 
	 * 	DEPRECATED, use Filter
	 * 
	 * ********************************/
	
	
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;

	public class RCFilter extends AudioObject implements IModifier
	{
		private var _source:AudioObject;
		private var _p0:Number;
		private var _p1:Number;
		private var _r:Number;
		private var _c:Number;
		
		public function RCFilter()
		{
			super();
		}
		
		override protected function init():void
		{
			_p0 = _p1 = 0;
			frequency = 0;
			resonance = 0;
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
		
		public function removeSource( p_name:String = '' ):void
		{
			_source = null;
		}
		
		
		
		
		/**
		 *  
		 * Filter frequency (0 - 127)
		 * 
		 */		
		 
		private var _freq:Number;
		
		public function set frequency( p_freq:Number ):void
		{
			_freq = p_freq;
			_c = Math.pow( .5, (128 - _freq) / 16 );
		}
		
		public function get frequency():Number
		{
			return _freq;
		}
		
		
		/**
		 * 
		 * Filter resonance (0 - 127) 
		 * 
		 */		
		 
		private var _res:Number;
		
		public function set resonance( p_res:Number ):void
		{
			_res = p_res;
			_r = Math.pow( .5, (_res + 24) / 16 );
		}
		
		public function get resonance():Number
		{
			return _res;
		}
		
		
		
		override public function getData( p_name:String = '' ):ByteArray
		{
			
			var source:ByteArray;
			var i:int;
			
			if ( _source )
			{
				source = _source.getData();
				source.position = 0;
				_outputData.clear();
				i = _bufferSize;
				while( i-- )
				{
					_p0 = ( 1 - _r * _c ) * _p0 - _c * _p1 + _c * source.readFloat();
					_p1 = ( 1 - _r * _c ) * _p1 + _c * _p0;
					_outputData.writeFloat( _p1 );
					_outputData.writeFloat( _p1 );
					source.position += 4;
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