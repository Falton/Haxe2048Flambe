package twistLineHaxe.screens;
import flambe.asset.AssetPack;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.util.SignalConnection;
import twistLineHaxe.managers.ScreenManager;
import flambe.asset.Manifest;
import twistLineHaxe.screens.assets.GameOver;
import twistLineHaxe.screens.assets.Grid;
/**
 * ...
 * @author Dima Svetov
 */
class GameScreen
{
	private var _screenManager:ScreenManager;
	private var _entity:Entity;
	private var _gameAssets:AssetPack;
	private var _assetsReady:Bool;
	private var _initLevel:Int;
	
	private var _grid:Grid;
	private var _rotationConnection:SignalConnection;
	private var _rotationConnection2:SignalConnection;
	private var _gameOver:GameOver;
	
	public function new(screenManager:ScreenManager, entity:Entity) 
	{
		_screenManager = screenManager;
		_entity = entity;
		_assetsReady = false;
		_initLevel = -1;
		var rotateLeft = new ImageSprite(_screenManager._pLib.getTexture("RotateLeft"));
		rotateLeft.x._ = 192;
		rotateLeft.y._ = 425;
		this._entity.addChild(new Entity().add(rotateLeft));
		_rotationConnection2 = rotateLeft.pointerUp.connect( onLeftClick);
		
		var rotateRight = new ImageSprite(_screenManager._pLib.getTexture("RotateLeft"));
		rotateRight.scaleX._ *= -1;
		rotateRight.x._ = 37+rotateRight.getNaturalWidth();
		rotateRight.y._ = 319;
		this._entity.addChild(new Entity().add(rotateRight));
		_rotationConnection = rotateRight.pointerUp.connect( onRightClick);
		
		
		/*var ok = new ImageSprite(_screenManager._pLib.getTexture("OK"));
		ok.x._ = 1117;
		ok.y._ = 625;
		this._entity.addChild(new Entity().add(ok));*/
		
		var manifest = Manifest.fromAssets("gameassets");
        var loader = System.loadAssetPack(manifest);
        loader.get(onSuccess);
		
    }
	
	private function onRightClick(e:PointerEvent):Void {
		this._grid.rotate(1);
	}
	
	private function onLeftClick(e:PointerEvent):Void {
		this._grid.rotate(-1);
	}

    private function onSuccess (pack :AssetPack)
    {
		_gameAssets = pack;
		_assetsReady = true;
		
		if (_initLevel != -1) {
			this.initLevel(_initLevel);
		}
	}
	
	public function showGameOver():Void {
		_gameOver = new GameOver(new Entity(), this._gameAssets, this);
		this._entity.addChild(_gameOver.entity());
	}
	
	public function initLevel(val:Int):Void {
		if (_grid != null) {
			this._entity.removeChild(_grid.entity());
			_grid.depose();
			
		}
		
		if (_assetsReady) {
			_initLevel = -1;
			var gridEntity = new Entity();
			_grid = new Grid();
			this._grid.init(gridEntity, _gameAssets, val,this);
			this._entity.addChild(_grid.entity());
		}else {
			_initLevel = val;
		}
	}
	
	public function entity():Entity { return _entity; }
	
}