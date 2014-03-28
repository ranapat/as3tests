package org.ranapat.examples {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.ranapat.TestCase;
	import org.ranapat.TestRunner;
	
	public class Main extends Sprite {
		private var testRunner:TestRunner;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			testRunner = new TestRunner();
			testRunner.push(ExampleTest);
			testRunner.push(ExampleTest1);
			testRunner.run();
		}
		
	}
	
}