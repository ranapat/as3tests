package org.ranapat.tests {
	import flash.events.Event;
	
	internal class TestCaseCompleteEvent extends Event {
		public static const COMPLETE:String = "TestCaseCompleteEvent::COMPLETE";
		
		public function TestCaseCompleteEvent(type:String) {
			super(type);
			
		}
		
	}

}