package twistLineHaxe.screens;

import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.PointerEvent;
import flambe.System;
import flambe.util.SignalConnection;
import twistLineHaxe.managers.ScreenManager;

/**
 * ...
 * @author Dima Svetov
 */
class SplashScreen
{
	private var _screenManager:ScreenManager;
	private var _entity:Entity;
	private var _playConnection:SignalConnection;
	public function new( screenManager:ScreenManager, entity:Entity ) 
	{
		_screenManager = screenManager;
		_entity = entity;
		var title = new ImageSprite( _screenManager._pLib.getTexture("TitleScreen_green"));
		_entity.addChild(new Entity().add(title));
		
		var playbtn = new ImageSprite( _screenManager._pLib.getTexture("PlayButton") );
		playbtn.x._ = 380;
		playbtn.y._ = 380;
		_entity.addChild(new Entity().add(playbtn));
		
		_playConnection = playbtn.pointerUp.connect( onPlayClicked);
		
		
		var font = new Font(_screenManager._pLib, "Arial");
		var val:String = Std.string(System.stage.width) +" , " + Std.string(System.stage.height);
		var text = new TextSprite(font, val);
		this._entity.addChild(new Entity().add(text));
	}
	
	private function onPlayClicked(e:PointerEvent):Void {
		_playConnection.dispose();
		_screenManager.showGameScreen(this._entity );
	}
	
	public function entity():Entity { return _entity; }
	
}