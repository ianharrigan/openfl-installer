package openfl.installer;

import haxe.ui.toolkit.core.Macros;
import haxe.ui.toolkit.core.Root;
import haxe.ui.toolkit.core.Toolkit;
import haxe.ui.toolkit.style.Style;
import haxe.ui.toolkit.style.StyleManager;
import haxe.ui.toolkit.themes.GradientTheme;

class Main {
	public static function main() {
		Toolkit.autoScale = false;
		Toolkit.theme = new GradientTheme();
		Toolkit.init();
		var f = Assets.getFont("fonts/Oxygen.ttf");

		Macros.addStyleSheet("assets/css/openfl.css");
		StyleManager.instance.addStyle("Button", new Style({
			fontName: f.fontName,
			fontEmbedded: true
		}));
		StyleManager.instance.addStyle("Text", new Style({
			fontName: f.fontName,
			fontEmbedded: true,
			fontSize: 14,
		}));
		Toolkit.openFullscreen(function(root:Root) {
			root.addChild(new MainController().view);
		});
	}
}
