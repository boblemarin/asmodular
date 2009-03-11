package org.asmodular.utils
{
	import flash.utils.ByteArray;
	
	public class ApplicationData
	{
		private static const _instance:ApplicationData = new ApplicationData( SingletonLock );
		
		public var bufferSize:int = 2500;
		public var sampleRate:int = 44100;
		public var silenceBytes:ByteArray;
		
		public function ApplicationData( lock:Class )
		{
			if ( lock != SingletonLock )
			{
				throw new Error('ApplicationData is a singleton, use ApplicationData.instance');
			}
			
			// create silence byteArray for no-source objects
			silenceBytes = new ByteArray();
			var i:int = bufferSize;
			while(i--) silenceBytes.writeDouble( 0 );
		}
		
		public static function get instance():ApplicationData
		{
			return _instance;
		}
		
	}
}

class SingletonLock
{
}