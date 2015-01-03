package openfl.installer;

import haxe.Json;
import haxe.ui.toolkit.resources.ResourceManager;
import openfl.installer.util.Platform;

class ConditionEvaluator {
	public static function evaluate(condition:String):Bool {
		// just so we can use short coditions also, ie, "x = 1 & y = 2" as well as "x == 1 && y == 2"
		condition = StringTools.replace(condition, "==", "=");
		condition = StringTools.replace(condition, "=", "==");

		condition = StringTools.replace(condition, "&&", "&");
		condition = StringTools.replace(condition, "&", "&&");

		condition = StringTools.replace(condition, "||", "|");
		condition = StringTools.replace(condition, "|", "||");
		
		var retVal = false;
		try {
			var parser = new hscript.Parser();
			var program = parser.parseString(condition);
			var interp = new hscript.Interp();
			
			var settings:Array<Dynamic> = Json.parse(ResourceManager.instance.getText("data/install.json")).settings;
			for (setting in settings) {
				var value:String = VarManager.instance.getValue(setting.id);
				switch (setting.type) {
					case "boolean":
						interp.variables.set(setting.id, (value == "true"));
					default:
						interp.variables.set(setting.id, value);
				}
			}

			interp.variables.set("PLATFORM", Platform.platformString);
			retVal = interp.execute(program);
		} catch (e:Dynamic) {
			trace(e);
			retVal = false;
		}
		return retVal;
	}
}