package org.asmodular.core
{
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import org.asmodular.utils.ApplicationData;
	
	
	public class AudioObject extends EventDispatcher
	{
		protected var _appData:ApplicationData;
		protected var _bufferSize:int;
		protected var _outputData:ByteArray;
		protected var _source:AudioObject;
		protected var _sourceData:ByteArray;
		
		public function AudioObject()
		{
			_appData = ApplicationData.instance;
			_bufferSize = _appData.bufferSize;
			_outputData = new ByteArray();
			init();
		}
		
		protected function init():void
		{
			
		}

		/**
		 * adds an AudioObject as source for the current object. 
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
		 * ask the AudioObject for audio data.
		 *  
		 * @param p_name
		 * @return A byte array containing the computed data
		 * 
		 */
		public function getData( p_name:String = '' ):ByteArray
		{
			if ( _source )
			{
				_sourceData = _source.getData();
				_sourceData.position = 0;
				_outputData.clear();
				computeData();
				return _outputData
			}
			else
			{
				// no source set, sending silence
				return _appData.silenceBytes;
			}
			
		}
		
		protected function computeData():void
		{
			
		}


	}
	
}