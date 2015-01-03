package openfl.installer.custom;

import haxe.ui.toolkit.core.Component;
import gif.AnimatedGif;
import haxe.io.Bytes;
import openfl.Assets;
import haxe.ui.toolkit.util.ByteConverter;

class Animation extends Component {
	private var _resource:String;
	private var _gif:AnimatedGif;
	private var _delay:Int = -1;
	
	public function new() {
		super();
		_autoSize = true;
	}
	
	public var resource(get, set):String;
	private function get_resource():String {
		return _resource;
	}
	private function set_resource(value:String):String {
		if (value == null) {
			_gif.stop();
			sprite.removeChild(_gif);
			_resource = value;
			return value;
		}
		
		_resource = value;
		var bytes:Bytes = ByteConverter.toHaxeBytes(Assets.getBytes(_resource));
		_gif = new AnimatedGif(bytes);
		_gif.delayTime = _delay;
		sprite.addChild(_gif);
		if (_autoSize == true) {
			this.width = _gif.width;
			this.height = _gif.height;
		}
		_gif.play();
		return value;
	}
	
	public var delay(get, set):Int;
	private function get_delay():Int {
		return _delay;
	}
	private function set_delay(value:Int):Int {
		_delay = value;
		return value;
	}
}