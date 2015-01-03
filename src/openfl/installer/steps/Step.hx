package openfl.installer.steps;
import openfl.installer.VarManager;

class Step {
	public function new() {
	}
	
	private var _config:Dynamic;
	public var config:Dynamic;
	private function get_config():Dynamic {
		return _config;
	}
	private function set_config(value:Dynamic):Dynamic {
		_config = value;
		return value;
	}
	
	public function execute():Void {
		trace("Step::execute");
	}

	private var _error:String;
	public var error:String;
	private function get_error():String {
		return _error;
	}
	private function set_error(value:String):String {
		_error = value;
		return value;
	}
	
	public function expandString(input:String):String {
		return VarManager.instance.expandString(input);
	}
}