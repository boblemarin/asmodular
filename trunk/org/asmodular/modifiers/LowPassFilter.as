package org.asmodular.modifiers
{
	/********************************
	 * 
	 * 	DEPRECATED, use Filter
	 * 
	 * ********************************/
	
	
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;

	public class LowPassFilter extends AudioObject implements IModifier
	{
		private var _source:AudioObject;
		private var _previousOut:Number;
		public var q:Number;
		
		public function LowPassFilter()
		{
			super();
		}
		
		override protected function init():void
		{
			_previousOut = 0;
			q = 1;
		}
		
		public function addSource( p_source:AudioObject, p_name:String = '' ):void
		{
			_source = p_source;
		}
		
		public function removeSource( p_name:String = '' ):void
		{
			_source = null;
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
					_outputData.writeFloat( _previousOut );
					_outputData.writeFloat( _previousOut );
					_previousOut = _previousOut + q * ( source.readFloat() - _previousOut );
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