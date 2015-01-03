package openfl.installer.steps.files;

import haxe.Http;
import haxe.Timer;
import openfl.installer.InstallManager.InstallEvent;
import openfl.installer.steps.Step;
import sys.io.File;

class Download extends Step {
	private var _downloader:Downloader;
	
	public function new() {
		super();
	}
	
	public override function execute():Void {
		var remoteFile:String = expandString(config.remoteFile);
		var localFile:String = expandString(config.localFile);
		
		trace("Download::execute - Downloading '" + remoteFile + "' to '" + localFile + "'");
		
		var out;
		try {
			out = File.write(localFile, true);
		} catch (e:Dynamic) {
			this.error = "There was a problem creating the local file.";
			return;
		}
		
		_downloader = new Downloader(out);
		var http:Http = new Http(remoteFile);
		http.onStatus = onStatus;
		http.onError = onError;
		http.onData = onData;
		http.customRequest(false, _downloader);
	}
	
	private function onStatus(status) {
		//trace("Download::onStatus - " + status);
	}
	
	private function onError(msg) {
		this.error = "There was a problem downloading the remote file. (" + msg + ")";
		_downloader.close();
	}
	
	private function onData(data) {
		//trace(data);
	}
}

class Downloader extends haxe.io.Output {
	var o : haxe.io.Output;
	public var cur : Int;
	var max : Int;
	var start : Float;

	var lastPercent:Int = 0;
	
	public function new(o) {
		this.o = o;
		cur = 0;
		start = Timer.stamp();
	}

	function bytes(n) {
		cur += n;
		var details:Dynamic = { };
		var newPercent:Int = 0;
		#if neko
		if( max == null ) {
			details = { min: 0, max: 100, pos: 0 };
		} else {
			details = { min: 0, max: 100, pos: Std.int((cur * 100.0) / max) };
			newPercent = Std.int((cur * 100.0) / max);
		}
		#else
		if ( max == 0 ) {
			details = { min: 0, max: 100, pos: 0 };
		} else {
			details = { min: 0, max: 100, pos: Std.int((cur * 100.0) / max) };
			newPercent = Std.int((cur * 100.0) / max);
		}
		#end
		
		if (newPercent != lastPercent) {
			var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
			event.data = details;
			InstallManager.instance.dispatchEvent(event);
			lastPercent = newPercent;
		}
	}

	public override function writeByte(c) {
		o.writeByte(c);
		bytes(1);
	}

	public override function writeBytes(s,p,l) {
		var r = o.writeBytes(s,p,l);
		bytes(r);
		return r;
	}

	public override function close() {
		super.close();
		o.close();
		var time = Timer.stamp() - start;
		var speed = (cur / time) / 1024;
		time = Std.int(time * 10) / 10;
		speed = Std.int(speed * 10) / 10;
		
		var details:Dynamic = {
			min: 0,
			max: 100,
			pos: 100,
			speed: speed,
			time: time,
		};
		var event:InstallEvent = new InstallEvent(InstallManager.STEP_PROGRESS);
		event.data = details;
		InstallManager.instance.dispatchEvent(event);
	}

	public override function prepare(m) {
		max = m;
	}
}
