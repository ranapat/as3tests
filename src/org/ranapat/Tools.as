package org.ranapat {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Tools {
		
		public function Tools() {
			//
		}
		
		public static function getObjectsAt(parent:DisplayObjectContainer, point:Point):Vector.<DisplayObject> {
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			
			var length:uint = parent.numChildren;
			var tmp:DisplayObject;
			for (var i:uint = 0; i < length; ++i) {
				tmp = parent.getChildAt(i);
				
				var global:Point = parent.localToGlobal(new Point(tmp.x, tmp.y));
				if (
					global.x <= point.x && global.x + tmp.width >= point.x
					&& global.y <= point.y && global.y + tmp.height >= point.y
				) {
					result.push(tmp);
				}
				
				if (tmp is DisplayObjectContainer) {
					result = result.concat(Tools.getObjectsAt(tmp as DisplayObjectContainer, point));
				}
			}
			
			return result;
		}
		
		public static function dispatchEventAt(parent:DisplayObjectContainer, point:Point, event:Event):void {
			var result:Vector.<DisplayObject> = Tools.getObjectsAt(parent, point);
			
			var lenth:uint = result.length;
			var tmp:DisplayObject;
			for (var i:uint = 0; i < lenth; ++i) {
				try {
					tmp = result[i];
					
					if (Tools.checkIfShallDispatchEvent(tmp, event)) {
						tmp.dispatchEvent(event);
					}
				} catch (e:Error) {
					//
				}
			}
		}
		
		private static function checkIfShallDispatchEvent(object:DisplayObject, event:Event):Boolean {
			var result:Boolean;
			
			if (
				event is MouseEvent
				&& object is InteractiveObject
				&& Tools.checkIfAllParentsAreMouseChildrenEnabled(object)
			) {
				result = (object as InteractiveObject).mouseEnabled;
			} else {
				result = true;
			}
			
			return result;
		}
		
		private static function checkIfAllParentsAreMouseChildrenEnabled(object:DisplayObject):Boolean {
			return (
					object.parent
					&& object.parent.mouseChildren
					&& Tools.checkIfAllParentsAreMouseChildrenEnabled(object.parent)
				) || (
					!object.parent
				)
			;
		}
		
	}

}