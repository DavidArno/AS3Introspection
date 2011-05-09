/* 

    Autogenerated file. Do not edit

    Generated by AS3Enums v0.2

*/
package org.ghostfish.as3introspection.enums
{
	import org.ghostfish.collections.immutable.OrderedList;
	
	public final class NameSpaces
	{
		public static const Public:NameSpaces = 
			new NameSpaces(0, "Public", "public");
		public static const Protected:NameSpaces = 
			new NameSpaces(1, "Protected", "protected");
		public static const Internal:NameSpaces = 
			new NameSpaces(2, "Internal", "internal");
		public static const Private:NameSpaces = 
			new NameSpaces(3, "Private", "private");
		public static const Custom:NameSpaces = 
			new NameSpaces(4, "Custom", "");
		
		private static var _values:Array;
		private static var _valuesCount:int;
		private static var _enumSet:OrderedList;
		
		private var _ordinal:int;
		private var _name:String;
		private var _keyword:String;
		
		function NameSpaces(ordinal:int,
							name:String,
							keyword:String)
		{
			if (_values == null)
			{
				_values = [];
			}
			
			_values[ordinal] = this;
			_ordinal = ordinal;
			_name = name;
			_valuesCount++;
			
			if (_valuesCount == 5)
			{
				_enumSet = OrderedList.fromArray(_values);
			}
			
			_keyword = keyword;
		}
		
		public function get keyword():String
		{
			return _keyword;
		}
		
		public function get ordinal():Number
		{
			return _ordinal;
		}
		
		public function toString():String
		{
			return _name;
		}
		
		public static function get values():OrderedList
		{
			return _enumSet;
		}
	}
}
