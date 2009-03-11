package org.asmodular.core
{
	import __AS3__.vec.Vector;
	
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	
	import org.asmodular.utils.ApplicationData;
	
	public class AudioOutput
	{
		private var _appData:ApplicationData;
		private var _numBytes:Number;
		private var _soundObject:Sound;
		//private var _sources:Vector.<AudioObject>;
		private var _source:AudioObject;
		
		public function AudioOutput()
		{
			_appData = ApplicationData.instance;
			_soundObject = new Sound();
			_soundObject.addEventListener( SampleDataEvent.SAMPLE_DATA, onSampleData );
			//_sources = new Vector.<AudioObject>();
		}
		
		public function addSource( p_source:AudioObject, p_name:String = '' ):void
		{
			//_sources.push( p_source );
			_source = p_source;
		}
		
		public function play():void
		{
			_soundObject.play();
		}

		private function onSampleData( event:SampleDataEvent ):void
		{
			event.data.writeBytes( _source.getData(), 0, 0 );
		}

	}
}