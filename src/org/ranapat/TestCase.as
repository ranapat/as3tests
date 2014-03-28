package org.ranapat {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.describeType;
	
	public class TestCase extends EventDispatcher {
		private var tests:Vector.<Function>;
		private var index:uint;
		private var current:Function;
		
		private var running:Boolean;
		private var destroyed:Boolean;
		
		protected var manualMode:Boolean;
		
		public var result:TestCaseResult;
		
		public function TestCase() {
			//
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
			if (a == b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function assertStrict(a:*, b:*, message:String = ""):void {
			if (a === b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function assertThrows(callback:Function, message:String = ""):void {
			try {
				callback.apply(this);
				
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			} catch (e:Error) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(e.message)));
			}
		}
		
		protected function assertSet(a:*, message:String):void {
			if (a) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function assertNotSet(a:*, message:String):void {
			if (!a) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function assertTrue(a:*, message:String):void {
			this.assert(a, true, message);
		}
		
		protected function assertFalse(a:*, message:String):void {
			this.assert(a, false, message);
		}
		
		protected function assertNot(a:*, b:*, message:String = ""):void {
			if (a != b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function assertNotStrict(a:*, b:*, message:String = ""):void {
			if (a !== b) {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseSuccess(message)));
			} else {
				this.dispatchEvent(new TestCompleteEvent(TestCompleteEvent.COMPLETE, new TestCaseFail(message)));
			}
		}
		
		protected function nextTest():void {
			if (this.manualMode) {
				this.manualMode = false;
				this.next();
			}
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
				this.manualMode = false;
				
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
			this.running = false;
			this.current = null;
			this.process();
		}
		
		private function handleTestComplete(e:TestCompleteEvent):void {
			this.handle(e.result);
		}
		
	}

}