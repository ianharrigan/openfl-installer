package openfl.installer;
import haxe.Json;
import haxe.ui.toolkit.resources.ResourceManager;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.installer.steps.Step;
import openfl.installer.steps.StepManager;

#if neko
import neko.vm.Thread;
#else
import cpp.vm.Thread;
#end

class InstallEvent extends Event {
	public var data:Dynamic;
	public function new(type:String) {
		super(type);
	}
}

class InstallManager extends EventDispatcher {
	public static inline var STEP_START:String = "stepStart";
	public static inline var STEP_END:String = "stepEnd";
	public static inline var STEP_PROGRESS:String = "stepProgress";
	public static inline var STEP_ERROR:String = "stepError";
	public static inline var INSTALL_COMPLETE:String = "installComplete";
	
	private static var _instance:InstallManager;
	public static var instance(get, null):InstallManager;
	private static function get_instance():InstallManager {
		if (_instance == null) {
			_instance = new InstallManager();
		}
		return _instance;
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	private var _thread:Thread;
	
	public function new() {
		super();
	}
	
	public function beginInstall():Void {
		_thread = Thread.create(installFunc);
	}
	
	private function installFunc():Void {
		var steps:Array<Dynamic> = Json.parse(ResourceManager.instance.getText("data/install.json")).steps;
		var errored:Bool = false;
		for (stepData in steps) {
			var event:InstallEvent = new InstallEvent(STEP_START);
			event.data = stepData;
			dispatchEvent(event);
			
			var step:Step = StepManager.instance.createStepInstance(stepData);
			if (step != null) {
				step.execute();
				if (step.error != null) {
					var event:InstallEvent = new InstallEvent(STEP_ERROR);
					event.data = { errorMessage: step.error };
					dispatchEvent(event);
					errored = true;
					break;
				}
			}
			
			var event:InstallEvent = new InstallEvent(STEP_END);
			event.data = stepData;
			dispatchEvent(event);
		}

		var event:InstallEvent = new InstallEvent(INSTALL_COMPLETE);
		event.data = { errored: errored };
		dispatchEvent(event);
	}
}