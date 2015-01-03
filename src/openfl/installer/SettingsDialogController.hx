package openfl.installer;

import haxe.Json;
import haxe.ui.toolkit.controls.CheckBox;
import haxe.ui.toolkit.core.Component;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.resources.ResourceManager;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/settings-dialog.xml"))
class SettingsDialogController extends XMLController {
	public function new() {
		buildSettings();
	}
	
	private function buildSettings():Void {
		var settings:Array<Dynamic> = Json.parse(ResourceManager.instance.getText("data/install.json")).settings;
		settingsContainer.removeAllChildren();
		for (setting in settings) {
			var c:Component = createSettingControl(setting);
			if (c != null) {
				settingsContainer.addChild(c);
			}
		}
	}
	
	private function createSettingControl(setting:Dynamic):Component {
		var c:Component = null;
		var value:String = VarManager.instance.getValue(setting.id);
		switch (setting.type) {
			case "boolean":
				c = new CheckBox();
				c.text = setting.label;
				cast(c, CheckBox).selected = (value == "true");
			default:
		}
		if (c != null) {
			c.userData = setting.id;
		}
		return c;
	}
	
	public function saveSettings():Void {
		for (child in settingsContainer.children) {
			var varId:String = cast(child, Component).userData;
			var value:String = getValue(cast(child, Component));
			if (value != null) {
				VarManager.instance.setValue(varId, value);
			}
		}
	}
	
	private function getValue(c:Component):String {
		var value:String = null;
		if (Std.is(c, CheckBox)) {
			value = cast(c, CheckBox).selected == true ? "true" : "false";
		}
		return value;
	}
}