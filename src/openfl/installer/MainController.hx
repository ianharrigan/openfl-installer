package openfl.installer;

import haxe.ui.toolkit.core.PopupManager.PopupButton;
import haxe.ui.toolkit.core.Screen;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.events.UIEvent;
import motion.Actuate;
import motion.easing.Linear;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/main.xml"))
class MainController extends XMLController {
	private static inline var ANIMATION_SPEED:Float = 2; // set to 0 to speed up dev
	
	private var _checklist:ChecklistController;
	
	public function new() {
		InstallManager.instance.addEventListener(InstallManager.INSTALL_COMPLETE, onInstallComplete);
		beginButton.onClick = function(e) {
			startInstall();
		};
		
		settingsButton.onClick = function(e) {
			showSettings();
		};
		
		exitButton.onClick = function(e) {
			Sys.exit(0);
		};
	}
	
	private override function onReady():Void {
		logo.x = (container.width / 2) - (logo.width / 2);
		logo.y = (container.height / 2) - (logo.height / 2);
		
		beginButton.x = (container.width / 2) - (beginButton.width / 2);
		beginButton.y = (container.height / 2) - (beginButton.height / 2);

		settingsButton.x = container.width - settingsButton.width;

		exitButton.x = container.width - exitButton.width - 10;
		exitButton.y = container.height - exitButton.height - 10;
		
		var totalHeight:Float = logo.height + beginButton.height;
		var diff:Float = totalHeight - logo.height;
		Actuate.tween(logo, ANIMATION_SPEED, { alpha: 1 } ).delay(.5).onComplete(function() {
			Actuate.tween(logo, ANIMATION_SPEED, { y: logo.y - (diff) } );
			Actuate.tween(beginButton, ANIMATION_SPEED, { y: beginButton.y + (diff), alpha: 1 } );
			Actuate.tween(settingsButton, ANIMATION_SPEED, { alpha: 1 } ).delay(ANIMATION_SPEED);
		}).ease(Linear.easeNone);
	}
	
	private function startInstall() {
		_checklist = new ChecklistController();
		container.addChild(_checklist.view);
		
		_checklist.view.x = (container.width / 2) - (_checklist.view.width / 2);
		_checklist.view.y = Screen.instance.height;
		
		var logoY:Float = logo.y - 100;
		Actuate.tween(logo, ANIMATION_SPEED, { y: logoY } );
		Actuate.tween(beginButton, ANIMATION_SPEED, { y: logoY + logo.height, alpha: 0 } );
		Actuate.tween(settingsButton, ANIMATION_SPEED, { alpha: 0 } ).onComplete(function() {
				settingsButton.visible = false;
		});
		Actuate.tween(_checklist.view, ANIMATION_SPEED, { alpha: 1, y: logoY + logo.height + 25 } ).onComplete(function() {
			InstallManager.instance.beginInstall();
		});
	}
	
	private function showSettings() {
		var controller:SettingsDialogController = new SettingsDialogController();
		var config:Dynamic = { };
		config.buttons = [PopupButton.CONFIRM, PopupButton.CANCEL];
		config.styleName = "settings-dialog";
		config.width = 400;
		showCustomPopup(controller.view, "Settings", config, function(e) {
			if (e == PopupButton.CONFIRM) {
				controller.saveSettings();
			}
		});
	}
	
	private function onInstallComplete(event:UIEvent):Void {
		Actuate.tween(exitButton, ANIMATION_SPEED, { alpha: 1 } );
	}
}