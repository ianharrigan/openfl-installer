package openfl.installer.steps;
import openfl.installer.steps.Step;

class StepManager {
	private static var _instance:StepManager;
	public static var instance(get, null):StepManager;
	private static function get_instance():StepManager {
		if (_instance == null) {
			_instance = new StepManager();
		}
		return _instance;
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	private var _stepMap:Map<String,Class<Step>>;
	public function new() {
		_stepMap = new Map<String, Class<Step>>();
		_stepMap.set("demo.delay", openfl.installer.steps.demo.Delay);
		_stepMap.set("demo.progress", openfl.installer.steps.demo.Progress);
		
		_stepMap.set("files.download", openfl.installer.steps.files.Download);
		
		_stepMap.set("system.exec", openfl.installer.steps.system.Exec);
		
		_stepMap.set("haxelib.install", openfl.installer.steps.haxelib.Install);
	}
	
	public function createStepInstance(stepData:Dynamic):Step {
		var c:Class<Step> = _stepMap.get(stepData.type);
		if (c == null) {
			return null;
		}
		
		var step:Step = Type.createInstance(c, []);
		if (step != null) {
			step.config = stepData.config;
		}
		
		return step;
	}
}