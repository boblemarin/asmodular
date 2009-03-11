package org.asmodular.core
{
	import __AS3__.vec.Vector;
	
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	
	import org.asmodular.utils.ApplicationData;
	
	public class AudioMixerOutput
	{
		private var _appData:ApplicationData;
		private var _numBytes:Number;
		private var _soundObject:Sound;
		private var _sources:Vector.<AudioObject>;
		private var _datas:Vector.<ByteArray>;
		
		public function AudioMixerOutput()
		{
			_appData = ApplicationData.instance;
			_soundObject = new Sound();
			_soundObject.addEventListener( SampleDataEvent.SAMPLE_DATA, onSampleData );
			_sources = new Vector.<AudioObject>();
			_datas = new Vector.<ByteArray>();
		}
		
		public function addSource( p_source:AudioObject, p_name:String = '' ):void
		{
			_sources.push( p_source );
		}
		
		public function play():void
		{
			if ( _sources.length ) _soundObject.play();
		}

		private function onSampleData( event:SampleDataEvent ):void
		{
			var n:int = _sources.length;
			var s:int = _appData.bufferSize;
			var i:int = 0;
			var o:Number;
			
			// collect audio data
			for( i=0; i<n; i++ )
			{
				_datas[i] = _sources[i].getData();
				_datas[i].position = 0;
			}
			
			// mix sources and write to sound car
			while(s--)
			{
				o = 0;
				for( i=0; i<n; i++ )
				{
					o += _datas[i].readFloat();
					_datas[i].position += 4;
				}
				o /= n;
				event.data.writeFloat( o );
				event.data.writeFloat( o );
			}
		}

	}
}