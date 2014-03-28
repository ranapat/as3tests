package org.ranapat {
	
	public class TestCaseResult {
		private var _className:String;
		private var results:Vector.<TestResultObject>;
		
		public function TestCaseResult(_className:String) {
			this._className = _className;
			this.results = new Vector.<TestResultObject>();
		}
		
		public function get className():String {
			return this._className;
		}
		
		public function get total():uint {
			return this.results.length;
		}
		
		public function get passed():uint {
			var result:uint;
			var length:uint = this.results.length;
			for (var i:uint = 0; i < length; ++i) {
				if ((this.results[i] as TestResultObject).result is TestCaseSuccess) {
					++result;
				}
			}
			return result;
		}
		
		public function get failed():uint {
			var result:uint;
			var length:uint = this.results.length;
			for (var i:uint = 0; i < length; ++i) {
				if ((this.results[i] as TestResultObject).result is TestCaseFail) {
					++result;
				}
			}
			return result;
		}
		
		public function get errors():uint {
			var result:uint;
			var length:uint = this.results.length;
			for (var i:uint = 0; i < length; ++i) {
				if (!((this.results[i] as TestResultObject).result is TestCaseSuccess) && !((this.results[i] as TestResultObject).result is TestCaseFail)) {
					++result;
				}
			}
			return result;
		}
		
		public function getResult(index:uint):TestResultObject {
			return this.results.length > index? this.results[index] : null;
		}
		
		public function push(result:TestResultObject):void {
			this.results.push(result);
		}
		
		public function apped(result:Error, functionName:String):void {
			this.push(new TestResultObject(result, functionName));
		}
		
		public function toString():String {
			var detailed:String = "";
			var length:uint = this.results.length;
			var tmp:TestResultObject;
			for (var i:uint = 0; i < length; ++i) {
				tmp = this.results[i] as TestResultObject;
				if (tmp.result is TestCaseSuccess) {
					detailed += "0:+++ PASSED) " + tmp.functionName + " .. " + tmp.result.message + "\n";
				} else if (tmp.result is TestCaseFail) {
					detailed += "3:--- FAILED) " + tmp.functionName + " .. " + tmp.result.message + "\n";
				} else {
					detailed += "4:!!! ERRORS) " + tmp.functionName + " .. " + tmp.result.message + "\n";
				}
			}
			
			return ""
				+ "--------------------------------------------------------\n"
				+ this.className + "\n"
				+ "--------------------------------------------------------\n"
				+ "0:passed: " + this.passed + "\n"
				+ "3:failed: " + this.failed + "\n"
				+ "4:errors: " + this.errors + "\n"
				+ "======\n"
				+ "1:total:  " + this.total + "\n"
				+ "--------------------------------------------------------\n"
				+ detailed
				+ "--------------------------------------------------------\n"
			;
		}
		
	}

}