package openfl.installer.steps.demo;

import openfl.installer.InstallManager.InstallEvent;
import openfl.installer.steps.Step;

class Progress extends Step {
	public function new() {
		super();
	}
	
	public override function execute():Void {
		var step:Int = config.step;
		var max:Int = config.max;
		var delay:Float = config.delay;

		var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
		event.data = { min: 0, max: max, pos: 0 };
		InstallManager.instance.dispatchEvent(event);
		
		var start = 0;
		var end = max;
		var n = start;
		while (n < end) {
			var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
			event.data = { min: 0, max: max, pos: n };
			InstallManager.instance.dispatchEvent(event);
			
			n += step;
			Sys.sleep(delay);
		}
		
		var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
		event.data = { min: 0, max: max, pos: max };
		InstallManager.instance.dispatchEvent(event);
	}
}