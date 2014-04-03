package org.ranapat.tests {
	import flash.events.Event;
	
	internal class TestCompleteEvent extends Event {
		public static const COMPLETE:String = "TestCompleteEvent::COMPLETE";
		
		public var result:Error;
		
		public function TestCompleteEvent(type:String, result:Error) {
			super(type);
			
			this.result = result;
		}
		
	}

}