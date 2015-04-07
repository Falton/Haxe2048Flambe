package twistLineHaxe.screens.assets;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
/**
 * ...
 * @author Dima Svetov
 */
class Hexagon
{
	public static inline var TYPE_BLOCK:Int = 1;
	public static inline var TYPE_ACTIVE:Int = 2;
	public static inline var TYPE_CURRENT:Int = 3;
	public static inline var TYPE_USED:Int = 4;
	
	private var _entity:Entity;
	private var _i:Int;
	private var _j:Int;
	private var _curRow:Int;
	private var _type:Entity;
	private var _assets:AssetPack;
	private var _x:Float;
	private var _y:Float;
	private var _blockType:Int;
	private var _lines:Entity;
	private var _slots:Array<Int>; 
	private var _image:ImageSprite;
	private var _text:TextSprite;
	private var _textEntity:Entity;
	private var _font:Font;
	private var _num:Int;
	private var _lock:Bool;
	private var _curTextRotation:Float;
	public function new(entity:Entity, i:Int, j:Int,curRow:Int, assets:AssetPack) 
	{
		this._i = i; 
		this._j = j;
		this._curRow = curRow;
		this._assets = assets;
		this._entity = entity;
		this._lock = false;
		_font = new Font(this._assets, "Arial");
		this._textEntity = new Entity();
		_curTextRotation = 0;
		this._num = 0;
	}
	
	public function x(val:Float):Void {
		this._x = val;
	}
	public function getMyRow():Int { return this._curRow; }
	public function getMyCol():Int { return this._i; }
	public function setLock(val:Bool) { this._lock = val; }
	public function getLock():Bool { return this._lock; }
	public function getX():Float { return this._x; }
	
	public function y(val:Float):Void {
		this._y = val;
	}
	
	public function getY():Float { return this._y; }
	
	public function setType(type:Int):Void {
		this._blockType = type;
	}
	
	public function getType():Int { return this._blockType; }
	
	public function resetPos():Void {
		this._entity.removeChild(_type);
		_type = new Entity();
		var num:Int;
		
		if (_blockType == Hexagon.TYPE_BLOCK) {
			num = Math.floor(Math.random() * 4) + 1;
			_image = new ImageSprite(_assets.getTexture("tiles_edge0" + num));
			
		}else if (_blockType == Hexagon.TYPE_ACTIVE) {
			num = Math.floor(Math.random() * 5) + 1;
			_image = new ImageSprite(_assets.getTexture("tiles_unselected_0" + num));
		}else {
			_image = new ImageSprite(_assets.getTexture("tiles_selected"));
		}
		//trace(_i + ","+_j + ":" + _x + "," + _y);
		
		_image.x._ = this._x;
		_image.y._ = this._y;
		
		_entity.addChild(_type.add(_image));
	}
	
	public function setNumber(val:Int):Void {
		this._num = val;
		if (val != 0) setText(Std.string(val));
		else setText("");
	}
	
	private function setText(val:String):Void {
		
		this._entity.removeChild(this._textEntity);
		
		
		this._text = new TextSprite(_font, val);
		this._textEntity = new Entity();
		this._textEntity.add(_text);
		
		_text.x._ = this._x+Grid.HEX_WIDTH/2+4;
		_text.y._ = this._y+Grid.HEX_HEIGHT/2+8;
		_text.centerAnchor();
		_text.rotation._ = _curTextRotation;
		this._entity.addChild(this._textEntity);
		
		
	}
	
	public function getNum():Int { return this._num; }
	
	public function rotate(dir:Int):Void {
		
		if (dir > 0) _curTextRotation+=  360 / 6;
		else _curTextRotation -= 360 / 6;
		if(this._text!=null){
			this._text.rotation.animateTo(_curTextRotation, 0.5);
		}
	}
	
	public function entity():Entity { return _entity; }
	
}