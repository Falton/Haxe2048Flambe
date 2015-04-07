package twistLineHaxe;

import flambe.display.Sprite;
import flambe.Entity;
import flambe.platform.html.HtmlStage;
import flambe.System;
import flambe.asset.AssetPack;
import flambe.asset.Manifest;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import twistLineHaxe.managers.ScreenManager;

class Main
{
	
	private static var _assetPack:AssetPack;
	private static var _screenManager:ScreenManager;
    private static function main ()
    {
        // Wind up all platform-specific stuff
        System.init();

        // Load up the compiled pack in the assets directory named "bootstrap"
        var manifest = Manifest.fromAssets("bootstrap");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
		
		System.stage.resize.connect( onResize );
    }

    private static function onSuccess (pack :AssetPack)
    {
		
        _assetPack = pack;
		
		var screenManagerEntity = new Entity();
		_screenManager =new ScreenManager(_assetPack, screenManagerEntity);
		System.root.addChild(screenManagerEntity);
		
		_screenManager.showSplashScreen();
		
		
		
    }
	
	public static function onResize()
	{
	
		var targetWidth = 1024; 
		var targetHeight = 640;

		// Specifies that the entire application be scaled for the specified target area while maintaining the original aspect ratio.
		var scale = Math.min(System.stage.width / targetWidth, System.stage.height / targetHeight);
		trace(scale,System.stage.width,System.stage.height);
		if (scale > 1) scale = 1; // You could choose to never scale up.

		// re-scale and center the sprite of the container to the middle of the screen.
		_screenManager
			.setScale(scale)
			.setXY((System.stage.width - targetWidth * scale) / 2,(System.stage.height - targetHeight * scale)/2);

		// You can even mask so you cannot look outside of the container
		//_container.get(Sprite).scissor = new Rectangle(0, 0, targetWidth, targetHeight);
	}
}
