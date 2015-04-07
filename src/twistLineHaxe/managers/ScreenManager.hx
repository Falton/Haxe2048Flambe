package twistLineHaxe.managers;
import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import twistLineHaxe.screens.GameScreen;
import twistLineHaxe.screens.SplashScreen;
import flambe.Entity;
/**
 * ...
 * @author Dima Svetov
 */
class ScreenManager extends Sprite
{
	private var _splashScreen:SplashScreen;
	private var _gameScreen:GameScreen;
	public var _pLib:AssetPack;
	public var displayObject:Entity;
	
	public function new(pLib:AssetPack, entity:Entity) 
	{
		super();
		displayObject = entity;
		displayObject.add(this);
	
		var background = new ImageSprite( pLib.getTexture("backgroundgreen"));
		displayObject.addChild(new Entity().add(background));
		_pLib = pLib;
		var entitySplashScreen:Entity = new Entity();
		_splashScreen = new SplashScreen( this, entitySplashScreen );
		
		var entityGameScreen:Entity = new Entity();
		_gameScreen = new GameScreen( this,entityGameScreen );
	}
	
	public function showSplashScreen(curScreen:Entity = null):Void {
		displayObject.removeChild(curScreen);
		displayObject.addChild( _splashScreen.entity() );
		
		Main.onResize();
	}
	
	public function showGameScreen(curScreen:Entity= null):Void {
		displayObject.removeChild(curScreen);
		displayObject.addChild( _gameScreen.entity() );
		_gameScreen.initLevel(0);
	}
	
	
	
}