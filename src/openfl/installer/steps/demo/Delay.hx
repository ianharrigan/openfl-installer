package openfl.installer.steps.demo;

import openfl.installer.steps.Step;

class Delay extends Step {
	public function new() {
		super();
	}
	
	public override function execute():Void {
		Sys.sleep(config.delay);
	}
}