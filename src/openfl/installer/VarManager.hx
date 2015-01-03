package openfl.installer;
import haxe.Json;
import haxe.ui.toolkit.resources.ResourceManager;

class VarManager {
	private static var _instance:VarManager;
	public static var instance(get, null):VarManager;
	private static function get_instance():VarManager {
		if (_instance == null) {
			_instance = new VarManager();
		}
		return _instance;
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	private var _vars:Map<String, String>;
	
	public function new() {
		_vars = new Map<String, String>();
		
		var env:Map<String, String> = Sys.environment();
		for (key in env.keys()) {
			_vars.set(key, env.get(key));
		}
		
		var settings:Array<Dynamic> = Json.parse(ResourceManager.instance.getText("data/install.json")).settings;
		for (setting in settings) {
			_vars.set(setting.id, setting.value);
		}
		
		var tempDir = env.get("TMP");
		if (tempDir == null) {
			tempDir = env.get("TEMP");
		}
		_vars.set("TEMP_DIR", tempDir);
	}
	
	public function expandString(input:String):String {
		var output:String = input;
		for (key in _vars.keys()) {
			output = StringTools.replace(output, "%" + key + "%", _vars.get(key));
		}
		return output;
	}
	
	public function getValue(varId:String):String {
		return _vars.get(varId);
	}
	
	public function setValue(varId:String, value:String):Void {
		_vars.set(varId, value);
	}
	
	public var vars(get, null):Map<String, String>;
	private function get_vars():Map < String, String > {
		return _vars;
	}
}