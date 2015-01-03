package openfl.installer.steps.system;

	import openfl.installer.steps.Step;
	import sys.io.Process;

class Exec extends Step {
	public function new() {
		super();
	}
	
	public override function execute():Void {
		var command:String = expandString(config.command);
		var retVal:Int = Sys.command(command);
		trace("Exec::execute - retVal: " + retVal);
	}
}