package openfl.installer;

import haxe.Json;
import haxe.ui.toolkit.containers.Box;
import haxe.ui.toolkit.containers.VBox;
import haxe.ui.toolkit.controls.HProgress;
import haxe.ui.toolkit.controls.Image;
import haxe.ui.toolkit.controls.Progress;
import haxe.ui.toolkit.controls.Spacer;
import haxe.ui.toolkit.controls.Text;
import haxe.ui.toolkit.core.XMLController;
import haxe.ui.toolkit.resources.ResourceManager;
import openfl.installer.custom.Animation;
import openfl.installer.InstallManager.InstallEvent;

@:build(haxe.ui.toolkit.core.Macros.buildController("assets/ui/checklist.xml"))
class ChecklistController extends XMLController {
	private var _steps:Array<Dynamic>;
	private var _currentStepId:String = null;
	
	public function new() {
		InstallManager.instance.addEventListener(InstallManager.STEP_START, onStepStart);
		InstallManager.instance.addEventListener(InstallManager.STEP_END, onStepEnd);
		InstallManager.instance.addEventListener(InstallManager.STEP_PROGRESS, onStepProgress);
		InstallManager.instance.addEventListener(InstallManager.STEP_ERROR, onStepError);
		InstallManager.instance.addEventListener(InstallManager.INSTALL_COMPLETE, onInstallComplete);
		_steps = Json.parse(ResourceManager.instance.getText("data/install.json")).steps;
		buildList();
	}
	
	public function buildList():Void {
		checklist.removeAllChildren();
		for (step in _steps) {
			if (step.condition != null) {
				if (ConditionEvaluator.evaluate(step.condition) == false) {
					continue;
				}
			}
			
			var animation:Animation = new Animation();
			
			animation.id = step.id + "_icon";
			animation.delay = 40;
			animation.verticalAlign = "center";
			animation.horizontalAlign = "right";
			checklist.addChild(animation);
			
			var box:Box = new Box();
			box.id = step.id + "_box";
			box.percentWidth = 100;
			box.height = 30;
			box.autoSize = false;
			box.style.padding = 0;
			
			
			var label:Text = new Text();
			label.id = step.id + "_label";
			label.text = step.label;
			label.styleName = "to-do";
			box.addChild(label);
			
			var progress:HProgress = new HProgress();
			progress.id = step.id + "_progress";
			progress.percentWidth = 100;
			progress.verticalAlign = "bottom";
			progress.visible = false;
			box.addChild(progress);
			
			checklist.addChild(box);
		}
	}
	
	private function onStepStart(event:InstallEvent):Void {
		if (_currentStepId != null) {
			var animation:Animation = checklist.findChild(_currentStepId + "_icon", null, true);
			var label:Text = checklist.findChild(_currentStepId + "_label", null, true);
			animation.resource = null;
			label.styleName = "complete";
		}
		
		var step:Dynamic = event.data;
		_currentStepId = step.id;
		
		var animation:Animation = checklist.findChild(step.id + "_icon", null, true);
		var label:Text = checklist.findChild(step.id + "_label", null, true);
		
		animation.resource = "gif/spinner.gif";
		label.styleName = "in-progress";
		
		_currentStepId = step.id;
	}
	
	private function onStepEnd(event:InstallEvent):Void {
		var step:Dynamic = event.data;
		
		var animation:Animation = checklist.findChild(step.id + "_icon", null, true);
		var label:Text = checklist.findChild(step.id + "_label", null, true);

		animation.resource = null;
		label.styleName = "complete";
		
		var image:Image = new Image();
		image.autoSize = false;
		image.width = image.height = 24;
		image.resource = "img/tick.png";
		image.verticalAlign = "center";
		image.horizontalAlign = "right";
		
		var index:Int = checklist.indexOfChild(animation);
		checklist.removeChildAt(index);
		checklist.addChildAt(image, index);
		
		
		_currentStepId = null;
	}

	private function onStepError(event:InstallEvent):Void {
		if (_currentStepId == null) {
			return;
		}
		
		var info:Dynamic = event.data;
		
		var box:Box = checklist.findChild(_currentStepId + "_box", null, true);
		var animation:Animation = checklist.findChild(_currentStepId + "_icon", null, true);
		var label:Text = checklist.findChild(_currentStepId + "_label", null, true);
		var progress:Progress = box.findChild(_currentStepId + "_progress", null, true);

		var index:Int = checklist.indexOfChild(box);
		
		checklist.removeChild(progress);
		var error:Text = new Text();
		error.styleName = "error-message";
		error.percentWidth = 100;
		error.wrapLines = true;
		error.multiline = true;
		error.text = info.errorMessage;
		checklist.addChildAt(new Spacer(), index + 1);
		checklist.addChildAt(error, index + 2);
		
		animation.resource = null;
		label.styleName = "complete";
		
		var image:Image = new Image();
		image.autoSize = false;
		image.width = image.height = 24;
		image.resource = "img/cross.png";
		image.verticalAlign = "center";
		image.horizontalAlign = "right";
		
		var index:Int = checklist.indexOfChild(animation);
		checklist.removeChildAt(index);
		checklist.addChildAt(image, index);
		
		
		_currentStepId = null;
	}
	
	private function onStepProgress(event:InstallEvent):Void {
		if (_currentStepId == null) {
			return;
		}

		var min = event.data.min;
		var max = event.data.max;
		var pos = event.data.pos;
		
		var progress:HProgress = checklist.findChild(_currentStepId + "_progress", null, true);
		if (progress != null) {
			if (pos == max) {
				progress.visible = false;
			} else {
				progress.min = min;
				progress.max = max;
				progress.pos = pos;
				progress.visible = true;
			}
		}
	}
	
	private function onInstallComplete(event:InstallEvent):Void {
		var errored = event.data.errored;
		
		var image:Image = new Image();
		image.autoSize = false;
		image.width = image.height = 24;
		if (errored == false) {
			image.resource = "img/tick.png";
		} else {
			image.resource = "img/cross.png";
		}
		image.verticalAlign = "center";
		image.horizontalAlign = "right";
		checklist.addChild(image);
		
		
		var label:Text = new Text();
		if (errored == false) {
			label.text = "Installation complete!";
		} else {
			label.text = "Installation completed with errors.";
		}
 		label.styleName = "complete";
		checklist.addChild(label);
	}
}