package org.ranapat.examples {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.ranapat.TestCase;
	
	public class ExampleTest extends TestCase {
		
		public function ExampleTest() {
			super();
			
		}
		
		public function test1():void {
			trace("1");
			
			this.assertTrue(true, "this is always true (1)");
			this.assertTrue(1, "this is always true (2)");
			this.assertSet("something", "this is always true (3)");
			this.assertSet([], "this is always true (4)");
			this.assertSet({}, "this is always true (5)");
			this.assertNotSet(null, "this is always true (6)");
			
			this.assertStrict(true, true, "this is always true (1.1)");
			this.assertNotStrict(1, true, "this is always true (1.2)");
			this.assertStrict("something", true, "this is always true (1.3)");
			this.assertStrict([], true, "this is always true (1.4)");
			this.assertStrict({}, true, "this is always true (1.5)");
			this.assertStrict(null, true, "this is always true (1.6)");
		}
		
		public function test2():void {
			trace("2");
			this.assertTrue(false, "this is always false");
		}
		
		public function test3():void {
			trace("3");
			throw new Error("Accident exception");
		}
		
		public function test4():void {
			trace("4");
			this.assertThrows(this.throwExcaption, "It shall throw exception");
		}
		private function throwExcaption():void {
			throw new Error("Throw exception on purpose");
		}
		
		public function test5():void {
			trace("5");
			var a:Object = new Object();
			var b:Object = a;
			
			this.assertStrict(a, b, "They shall be the same");
		}

		private var timer:Timer;
		public function test6():void {
			this.manualMode = true;
			
			trace("6");
			
			this.assertTrue(true, "this is always true");
			
			timer = new Timer(1000 * 1, 1);
			timer.addEventListener(TimerEvent.TIMER, this.handleTimer, false, 0, true);
			timer.start();
		}
		private function handleTimer(e:TimerEvent):void {
			trace("(6/7).1");
			timer.removeEventListener(TimerEvent.TIMER, this.handleTimer);
			this.assertTrue(true, "lazy timer is complete");
			
			this.nextTest();
		}
		
		public function test7():void {
			this.manualMode = true;
			
			trace("7");
			
			this.assertFalse(false, "this is always false");
			
			timer = new Timer(1000 * 1, 1);
			timer.addEventListener(TimerEvent.TIMER, this.handleTimer, false, 0, true);
			timer.start();
		}
		
		public function test8():void {
			trace("8");
			this.assert(1, true, "1 and true are the same");
		}
		
		public function test9():void {
			trace("9");
			this.assertNotStrict(1, true, "1 and true are not very much the same");
		}
		
		public function test10():void {
			trace("10");
			this.assertNot(1, 2, "1 and 2 are not the same");
		}
		
		public function test11():void {
			trace("11");
			this.assertNot( { }, { }, "They are not the same");
			this.assertNotStrict( { }, { }, "The are different");
			
			var tmp1:Object = { };
			var tmp2:Object = { };
			var tmp3:Object = tmp1;
			this.assertNot(tmp1, tmp2, "Different");
			this.assertNot(tmp2, tmp3, "Different");
			this.assert(tmp1, tmp3, "Same");
			this.assertNotStrict(tmp1, tmp2, "Different");
			this.assertNotStrict(tmp2, tmp3, "Different");
			this.assertStrict(tmp1, tmp3, "Same");
		}
	}

}