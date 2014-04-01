package org.ranapat.examples {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import org.ranapat.TestCase;
	import org.ranapat.Tools;
	
	public class ExampleTest1 extends TestCase {
		private var stage:Stage;
		private var text:TextField;
		
		
		public function ExampleTest1() {
			super();
			
		}
		
		override protected function initialize():void {
			this.stage = this.shared("stage");
			
			/*
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0xff00ff);
			sprite.graphics.drawRect(0, 0, 100, 100);
			sprite.graphics.endFill();
			sprite.x = 80;
			sprite.y = 80;
			sprite.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
				trace("click on the sprite");
			}, false, 0, true);
			this.stage.addChild(sprite);
			*/
			
			var container:Sprite = new Sprite();
			container.x = 70;
			container.y = 70;
			container.mouseEnabled = true;
			container.mouseChildren = true;
			var anothercontainer:Sprite = new Sprite();
			container.addChild(anothercontainer);
			var anothertext:TextField = new TextField();
			anothertext.text = "anothertext";
			anothertext.height = 20;
			anothertext.x = 30;
			anothertext.y = 30;
			//anothertext.mouseEnabled = false;
			anothertext.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
				trace("click on the anothertext");
			}, false, 0, true);
			anothercontainer.addChild(anothertext);
			this.stage.addChild(container);
			
			this.text = new TextField();
			this.text.text = "This is some text";
			this.text.height = 20;
			this.text.x = 120;
			this.text.y = 100;
			this.text.mouseEnabled = true;
			this.stage.addChild(this.text);
		}
		
		override protected function destroy():void {
			trace("*** destroy")
		}
		
		public function test1():void {
			trace("1");
			
			this.manualMode = true;
			
			this.text.addEventListener(MouseEvent.CLICK, this.handleTest1Click, false, 0, true);
			
			this.wait(.1, this.handleTest1NotClick, false);
			
			Tools.dispatchEventAt(this.stage, new Point(120, 110), new MouseEvent(MouseEvent.CLICK));
			
		}
		private function handleTest1Click(e:MouseEvent):void {
			trace("1.1");
			
			this.pass("click handled");
			
			//this.nextTest();
		}
		private function handleTest1NotClick():void {
			trace("1.2");
			
			this.fail("it's not clicked for too long!");
			
			this.nextTest();
		}
		
	}

}