package org.asmodular.modifiers
{
	import flash.utils.ByteArray;
	
	import org.asmodular.core.AudioObject;
	
	public interface IModifier
	{
		
		function addSource ( p_source:AudioObject, p_name:String = '' ):void
		
		function removeSource ( p_name:String = '' ):void
		
		function getData (  p_name:String = ''  ):ByteArray
		
		
	}
}