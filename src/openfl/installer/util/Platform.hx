package openfl.installer.util;

class Platform {
	public static var platformString(get, null):String;
	private static function get_platformString() {
		#if windows return "windows"; #end
		#if linux return "linux"; #end
		// TODO: Mac?
		return null;
	}
}