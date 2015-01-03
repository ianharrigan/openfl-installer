package openfl.installer.steps.haxelib;

import haxe.io.Bytes;
import openfl.installer.InstallManager.InstallEvent;
import openfl.installer.steps.Step;
import sys.io.Process;
#if neko
import neko.vm.Thread;
#elseif cpp
import cpp.vm.Thread;
#end

class Install extends Step {
	public function new() {
		super();
	}
	
	public override function execute():Void {
		var lib:String = expandString(config.lib);
		
		var proc:Process = new Process("haxelib", ["install", lib]);
		var lastPercent:Int = -1;
		if (proc.stdout != null) {
			try {
				var s:String = "";
				while (true) {
					var b:Bytes = proc.stdout.read(1);
					var temp = b.toString();
					if (temp == "\n" || temp == "\r") {
						if (s.indexOf("%") != -1) {
							var arr = s.split(" ");
							var percentString = arr[1];
							percentString = StringTools.replace(percentString, "(", "");
							percentString = StringTools.replace(percentString, ")", "");
							percentString = StringTools.replace(percentString, "%", "");
							var percent:Int = Std.parseInt(percentString);
							if (lastPercent != percent) {
								lastPercent = percent;

								var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
								event.data = { min: 0, max: 100, pos: percent };
								InstallManager.instance.dispatchEvent(event);
							}
						}
						
						s = "";
					} else {
						s += temp;
					}
				}
			} catch (e:Dynamic) {
				//trace(e);
			}
		}
		
		var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
		event.data = { min: 0, max: 100, pos: 100 };
		InstallManager.instance.dispatchEvent(event);
	}
}