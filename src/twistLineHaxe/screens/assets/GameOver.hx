package twistLineHaxe.screens.assets;

import flambe.display.Sprite;
import flambe.Entity;
import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.input.PointerEvent;
import flambe.util.SignalConnection;
import twistLineHaxe.screens.GameScreen;
/**
 * ...
 * @author Dima Svetov
 */
class GameOver extends Sprite
{
	private var _entity:Entity;
	private var _assets:AssetPack;
	private var _gameScreen:GameScreen;
	private var _replaySingnal:SignalConnection;
	public function new(entity:Entity, assets:AssetPack, gameScreen:GameScreen ) 
	{
		super();
		
		this._entity = entity;
		this._assets = assets;
		this._gameScreen = gameScreen;
		this._entity.add(this);
		
		var bg:ImageSprite = new ImageSprite(_assets.getTexture("GameOverWindow"));
		bg.x._ = (1024-bg.getNaturalWidth())/2;
		bg.y._ = 50;
		this._entity.addChild(new Entity().add(bg));
		
		var playbtn:ImageSprite = new ImageSprite(_assets.getTexture("ReplayButtonNormal"));
		playbtn.x._ = (1024-playbtn.getNaturalWidth())/2;
		playbtn.y._ = bg.getNaturalHeight() - 150;
		this._entity.addChild(new Entity().add(playbtn));
		
		_replaySingnal = playbtn.pointerUp.connect(onReplay);
		
	}
	
	private function onReplay(e:PointerEvent):Void {
		_replaySingnal.dispose();
		_gameScreen.initLevel(0);
		
		_gameScreen.entity().removeChild(this._entity);
		this._entity.dispose();
	}
	
	public function entity():Entity { return this._entity; }
	
}