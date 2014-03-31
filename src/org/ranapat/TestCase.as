package org.ranapat {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.describeType;
	import flash.utils.Timer;
	
	public class TestCase extends EventDispatcher {
		private var tests:Vector.<Function>;
		private var index:uint;
		private var current:Function;
		
		private var _runner:TestRunner;
		
		private var _waiter:Timer;
		private var _waiterCallback:Function;
		private var _cancelWaiterOnAssert:Boolean;
		
		private var running:Boolean;
		private var destroyed:Boolean;
		
		protected var manualMode:Boolean;
		
		public var result:TestCaseResult;
		
		public function TestCase() {
			//
		}
		
		public function set runner(runner:TestRunner):void {
			this._runner = runner;
		}
		
		public function run():void {
			if (!this.running) {
				this.destroyed = false;
				this.initializeEventListeners();
				this.initializeTests();
				
				this.initialize();
				this.process();
			}
		}
		
		protected function initialize():void {
			//
		}
		
		protected function destroy():void {
			//
		}
		
		protected function assert(a:*, b:*, message:String = ""):void {
			this.beforeAssert();
			
			if (a == b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertStrict(a:*, b:*, message:String = ""):void {
			this.beforeAssert();
			
			if (a === b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertThrows(callback:Function, message:String = ""):void {
			this.beforeAssert();
			
			try {
				callback.apply(this);
				
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			} catch (e:Error) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(e.message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertSet(a:*, message:String):void {
			this.beforeAssert();
			
			if (a) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertNotSet(a:*, message:String):void {
			this.beforeAssert();
			
			if (!a) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertNot(a:*, b:*, message:String = ""):void {
			this.beforeAssert();
			
			if (a != b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertNotStrict(a:*, b:*, message:String = ""):void {
			this.beforeAssert();
			
			if (a !== b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
			
			this.afterAssert();
		}
		
		protected function assertTrue(a:*, message:String):void {
			this.assert(a, true, message);
		}
		
		protected function assertFalse(a:*, message:String):void {
			this.assert(a, false, message);
		}
		
		protected function pass(message:String):void {
			this.assert(true, true, message);
		}
		
		protected function fail(message:String):void {
			this.assert(true, false, message);
		}
		
		protected function wait(delay:Number, callback:Function, cancelOnAssert:Boolean = true):void {
			this.clearWaiter();
			
			this._waiterCallback = callback;
			this._cancelWaiterOnAssert = cancelOnAssert;
			
			this._waiter = new Timer(delay, 1);
			this._waiter.addEventListener(TimerEvent.TIMER, this.handleWaiterComplete, false, 0, true);
			this._waiter.start();
		}
		
		protected function nextTest():void {
			if (this.manualMode) {
				this.manualMode = false;
				this.next();
			}
		}
		
		protected function shared(key:String):* {
			return this._runner? this._runner.shared(key) : null;
		}
		
		private function initializeEventListeners():void {
			this.addEventListener(TestCompleteEvent.COMPLETE, this.handleTestComplete, false, 0, true);
		}
		
		private function destroyEventListeners():void {
			this.removeEventListener(TestCompleteEvent.COMPLETE, this.handleTestComplete);
		}
		
		private function initializeTests():void {
			this.tests = new Vector.<Function>();
			this.index = 0;
			this.current = null;
			
			var description:XML = describeType(this);
			var className:Object = description.@name;
			var methods:XMLList = description..method.(@name.match("^test"));
			var methodNames:Object = methods.@name;
			var methodNamesArray:Array = [];
			for each (var item:Object in methodNames) {
				methodNamesArray.push(item.toString());
				
			}
			methodNamesArray.sort(this.sortFunctionNames);
			var length:uint = methodNamesArray.length;
			for (var i:uint = 0; i < length; ++i) {
				this.tests.push(this[methodNamesArray[i]]);
			}
			
			this.result = new TestCaseResult(className.toString());
		}
		
		private function beforeAssert():void {
			this.checkWaiter();
		}
		
		private function afterAssert():void {
			//
		}
		
		private function checkWaiter():void {
			if (this._waiter && this._cancelWaiterOnAssert) {
				this.clearWaiter();
			}
		}
		
		private function clearWaiter():void {
			if (this._waiter) {
				this._waiter.stop();
				this._waiter.removeEventListener(TimerEvent.TIMER, this.handleWaiterComplete);
			}
			
			this._waiter = null;
			this._waiterCallback = null;
			this._cancelWaiterOnAssert = true;
		}
		
		private function sortFunctionNames(a:String, b:String):int {
			if (a > b) {
				return 1;
			} else if (a < b) {
				return -1;
			} else {
				return 0;
			}
		}
		
		private function process():void {
			if (this.index < this.tests.length) {
				this.current = this.tests[this.index];
				++this.index;
				
				this.running = true;
				try {
					this.current.apply(this);
				} catch (e:Error) {
					this.handle(e);
				}
				
				if (!this.manualMode) {
					this.next();
				}
			} else if (!this.destroyed) {
				this.destroyed = true;
				
				this.destroyEventListeners();
				this.destroy();
				
				this.dispatchEvent(new TestCaseCompleteEvent(TestCaseCompleteEvent.COMPLETE));
			}
		}
		
		private function getFunctionName(callee:Function):String {
			var methods:XMLList = describeType(this)..method;
			for each (var m:XML in methods) {
				if (this[m.@name] == callee) {
					return m.@name;
				}
			}
			return "-null-";
		}
		
		private function handle(result:Error):void {
			this.result.apped(result, this.getFunctionName(this.current));
		}
		
		private function next():void {
			this.clearWaiter();
			
			this.running = false;
			this.manualMode = false;
			this.current = null;
			this.process();
		}
		
		private function handleTestComplete(e:TestCompleteEvent):void {
			this.handle(e.result);
		}
		
		private function handleWaiterComplete(e:TimerEvent):void {
			if (this._waiterCallback) {
				this._waiterCallback.apply(this);
				
				this.clearWaiter();
			}
		}
		
	}

}