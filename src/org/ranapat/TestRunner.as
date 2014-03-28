package org.ranapat {
	import flash.utils.Dictionary;
	
	public class TestRunner {
		private var todo:Vector.<Class>;
		private var complete:Vector.<TestCaseResult>;
		private var current:TestCase;
		
		private var _total:uint;
		private var _passed:uint;
		private var _failed:uint;
		private var _errors:uint;
		
		public function TestRunner() {
			this.todo = new Vector.<Class>();
			this.complete = new Vector.<TestCaseResult>();
		}
		
		public function get total():uint {
			return this._total;
		}
		
		public function get passed():uint {
			return this._passed;
		}
		
		public function get failed():uint {
			return this._failed;
		}
		
		public function get errors():uint {
			return this._errors;
		}
		
		public function push(_class:Class):void {
			this.todo.push(_class);
		}
		
		public function run():void {
			var _class:Class = this.todo.shift();
			if (_class) {
				var _instance:TestCase = new _class();
				
				this.current = _instance;
				
				_instance.addEventListener(TestCaseCompleteEvent.COMPLETE, this.handleTestCaseComplete, false, 0, true);
				
				_instance.run();
			} else {
				this.finalize();
			}
		}
		
		private function finalize():void {
			var result:String = ""
				+ "--------------------------------------------------------\n"
				+ "--------------------------------------------------------\n"
				+ "------------------------TOTAL---------------------------\n"
				+ "0:PASSED: " + this.passed + "\n"
				+ "3:FAILED: " + this.failed + "\n"
				+ "4:ERRORS: " + this.errors + "\n"
				+ "======\n"
				+ "1:TOTAL:  " + this.total + "\n"
				+ "-----------------------\\TOTAL---------------------------\n"
				+ "--------------------------------------------------------\n"
				+ "--------------------------------------------------------\n"
			;
			
			trace(result);
		}
		
		private function handleTestCaseComplete(e:TestCaseCompleteEvent):void {
			var result:TestCaseResult = this.current.result;
			
			this._total += result.total;
			this._passed += result.passed;
			this._failed += result.failed;
			this._errors += result.errors;
			
			this.complete.push(result);
			
			this.current.removeEventListener(TestCaseCompleteEvent.COMPLETE, this.handleTestCaseComplete);
			this.current = null;
			
			trace(result);
			
			this.run();
		}
		
	}

}