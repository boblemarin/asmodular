package org.asmodular.generators
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;

	[Event(name="complete", type="flash.events.Event")]

	public class MP3Player extends AudioObject
	{
		private var _soundLoaded:Boolean;
		private var _soundLoader:Sound;
		private var _soundData:ByteArray;
		private var _soundPosition:int;
		private var _soundLength:int;
		
		public function MP3Player()
		{
			_soundLoaded = false;
			super();
		}
		
		public function load( p_filename:String ):void
		{
			_soundLoader = new Sound();
			_soundLoader.addEventListener( Event.COMPLETE, onLoadComplete );
			_soundLoader.load( new URLRequest( p_filename ) );
		}
		
		private function onLoadComplete( event:Event = null ):void
		{
			_soundData = new ByteArray();
			_soundLength = _soundLoader.extract( _soundData, _soundLoader.length * 44100 ); //99999999 ); //
			_soundLoader.removeEventListener( Event.COMPLETE, onLoadComplete );
			_soundLoader = null;
			_soundData.position = 0;
			_soundPosition = 0;
			_soundLoaded = true;
			dispatchEvent( new Event( Event.COMPLETE ) );
		}
		
		override public function getData( p_name:String = '' ):ByteArray
		{
			var i:int;
			
			if ( _soundLoaded )
			{
				// sound loaded, playing
				
				// compute
				i = _soundLength - _soundPosition;
				var n:int = (i<_bufferSize)?i:_bufferSize;
				_outputData.clear();
				
				// play
				for ( i=0; i<n; i++ )
				{
					_outputData.writeDouble( _soundData.readDouble() );
				}
				
				// loop and play more if necessary
				if ( i < _bufferSize )
				{
					_soundPosition = _bufferSize - i;
					_soundData.position = 0;
					
					while( i < _bufferSize )
					{
						_outputData.writeDouble( _soundData.readDouble() );
						i++;
					} 
				}
				else
				{
					_soundPosition += _bufferSize;
				}	
			}
			else
			{
				// sound not loaded, sending silence
				_outputData.clear();
				i = _bufferSize;
				while(i--) _outputData.writeDouble( 0 );
			
			}
			
			return _outputData;
		}
		
	}
}