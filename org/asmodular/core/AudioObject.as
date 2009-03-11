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
		
		public function AudioObject()
		{
			_appData = ApplicationData.instance;
			_bufferSize = _appData.bufferSize;
			_outputData = new ByteArray();
			init();
		}
		
		protected function init():void
		{
			trace("init in AudioObject");
		}

		public function getData( p_name:String = '' ):ByteArray
		{
			trace("geData in AudioObject :/");
			return new ByteArray();
		}

	}
	
}