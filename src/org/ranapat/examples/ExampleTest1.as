package org.ranapat.examples {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.ranapat.TestCase;
	
	public class ExampleTest1 extends TestCase {
		
		public function ExampleTest1() {
			super();
			
		}
		
		public function test1():void {
			//trace("1");
			this.assertTrue(true, "this is always true");
		}
		
		public function test2():void {
			//trace("2");
			this.assertTrue(false, "this is always false");
		}
		
		public function test3():void {
			//trace("3");
			throw new Error("Accident exception");
		}
		
		public function test4():void {
			//trace("4");
			this.assertThrows(this.throwExcaption, "It shall throw exception");
		}
		private function throwExcaption():void {
			//throw new Error("Throw exception on purpose");
		}
		
		public function test5():void {
			//trace("5");
			var a:Object = new Object();
			var b:Object = a;
			
			this.assertStrict(a, b, "They shall be the same");
		}

		private var timer:Timer;
		public function test6():void {
			//trace("6");
			timer = new Timer(1000 * 1, 1);
			timer.addEventListener(TimerEvent.TIMER, this.handleTimer, false, 0, true);
			timer.start();
		}
		private function handleTimer(e:TimerEvent):void {
			//trace("(6/7).1");
			timer.removeEventListener(TimerEvent.TIMER, this.handleTimer);
			this.assertTrue(true, "lazy timer is complete")
		}
		
		public function test7():void {
			//trace("7");
			timer = new Timer(1000 * 1, 1);
			timer.addEventListener(TimerEvent.TIMER, this.handleTimer, false, 0, true);
			timer.start();
		}
		
		public function test8():void {
			//trace("8");
			this.assert(1, true, "1 and true are the same");
		}
		
		public function test9():void {
			//trace("9");
			this.assertNotStrict(1, true, "1 and true are not very much the same");
		}
		
		public function test10():void {
			//trace("10");
			this.assertNot(1, 2, "1 and 2 are not the same");
		}
	}

}