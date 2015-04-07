package twistLineHaxe.screens.assets;
import flambe.asset.AssetPack;
import flambe.Component;
import flambe.display.FillSprite;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Script;
import flambe.script.Sequence;
import twistLineHaxe.screens.GameScreen;
/**
 * ...
 * @author Dima Svetov
 */
class Grid extends Sprite
{
	public static inline var HEX_WIDTH:Float = 75;
	public static inline var HEX_HEIGHT:Float = 65;
	public static inline var COLS:Int = 7;
	public static inline var ROWS:Int = 4;
	
	private var _entity:Entity;
	private var _hexagons:Array<Hexagon>;
	private var _assets:AssetPack;
	private var _curRotation:Int;
	private var _rotationBlocker:Bool;


	private var _gameScreen:GameScreen;
	public function new( ) 
	{
		super();
		this.centerAnchor();
	}
	
	public function init(entity:Entity, gameAssets:AssetPack, level:Int, gameScreen:GameScreen):Void {
		_assets = gameAssets;
		_entity = entity;
		this._gameScreen = gameScreen;
		this._entity.add(this);
		_hexagons = new Array<Hexagon>();
		_curRotation = 0;
		this._rotationBlocker = false;
		var i:Int = 0;
		var curYStart:Float = 0;
		var curXStart:Float = 0;
		var curRow:Int = ROWS;
		var heighestY:Float=0;
		var lowestY:Float=100;
		var lowestX:Float=100;
		var heighestX:Float=0;
		while ( i < COLS ) {
			var j:Int = 0;
			while ( j < curRow) {
				var tmpHex:Hexagon = new Hexagon(new Entity(), i, j,curRow, _assets );
				//tmpHex.width = HEX_WIDTH;
				//tmpHex.height = HEX_HEIGHT;
				//this._entity.addChild(tmpHex.entity());
				//this.addChild(tmpHex);
				tmpHex.x(curXStart + i * (HEX_WIDTH*0.77) + HEX_WIDTH/2);
				tmpHex.y(curYStart + (HEX_HEIGHT*1.07) * j);
				
				if (heighestY > tmpHex.getY()) heighestY = tmpHex.getY();
				if (lowestX < tmpHex.getX()) lowestX = tmpHex.getX();
				if (lowestY < tmpHex.getY()) lowestY = tmpHex.getY();
				if (heighestX > tmpHex.getX()) heighestX = tmpHex.getX();
				//if (heighestX < tmpHex.x) heighestX = tmpHex.x;
				if(i==0 || j==0 || (j+1)==curRow || (i+1)==7)tmpHex.setType(Hexagon.TYPE_BLOCK);
				else tmpHex.setType(Hexagon.TYPE_ACTIVE);
			
				//if (tmpHex.currentFrame == Hexagon.FRAME_ACTIVE && tmpHex.type == Hexagon.TYPE_NORMAL) this._avaibleHexagons.push(tmpHex);
				_hexagons.push(tmpHex);
				//this._hexagons.push(tmpHex);
				j++;
				//trace("cur j:" + j);
			}
			
			
			if (i * 2 >= (COLS-1)) {
				curRow--;
				curYStart += HEX_HEIGHT/2;
			}else {
				curRow++;
				curYStart -= HEX_HEIGHT/2;
			}
		
				
			i++;
			//trace("cur i:" + i);
		}
		
		var imax:Int = _hexagons.length;
		for (i in 0..._hexagons.length) {
			//_hexagons[i].y (_hexagons[i].getY() - heighestY +50);
			//_hexagons[i].x (_hexagons[i].getX() + 350);
			_hexagons[i].resetPos();
			this._entity.addChild(_hexagons[i].entity());
		}
		//this.centerAnchor();
		
		
		this.anchorX._ = (lowestX-heighestX) / 2 + HEX_WIDTH*0.5+25;
		this.anchorY._ = (lowestY+heighestY) / 2 + HEX_HEIGHT*0.5 + 5;
		trace(lowestX,heighestX," - ",lowestY,heighestY,"=",anchorX,anchorY);
		//this._hexagons[21].addStartIcon();
		//this._hexagons[20].activate();
		/*var point = new FillSprite(0x000000, 5, 5);
		point.x._ = (lowestX - heighestX) / 2 + HEX_WIDTH * 0.5 + 25;
		point.y._ = (lowestY+heighestY) / 2+ HEX_HEIGHT*0.5+5;
		this._entity.addChild(new Entity().add(point));
		*/
		
		this.y._ = lowestY;
		this.x._ += 600;
		
		
		//GET 2 random hexagons
		var rand:Int;
		var flag:Bool = false;
		do {
			rand =  Math.floor(Math.random() * this._hexagons.length);
			if (this._hexagons[rand].getNum() == 0 && this._hexagons[rand].getType()==Hexagon.TYPE_ACTIVE) {
				flag = true;
				this._hexagons[rand].setNumber(4);
			}
		}while (!flag);
		flag = false;
		do {
			rand =  Math.floor(Math.random() * this._hexagons.length);
			if (this._hexagons[rand].getNum() == 0 && this._hexagons[rand].getType()==Hexagon.TYPE_ACTIVE) {
				flag = true;
				this._hexagons[rand].setNumber(2);
			}
		}while (!flag);
		
		//this._hexagons[0].setNumber(2);
	}
	
	public function rotate(dir:Int):Void {
		if (!_rotationBlocker) {
			_rotationBlocker = true;
			var newRotation:Float;
			if (dir > 0) newRotation= this.rotation._ + 360 / 6;
			else newRotation = this.rotation._ - 360 / 6;
			
			var newscript:Script = new Script();
			newscript.run(new Sequence([new AnimateTo(this.rotation,newRotation, 0.5), new CallFunction(rotateComplete)]));
			for (i in 0..._hexagons.length) {
				this._hexagons[i].rotate(dir*-1);
			}
			this._curRotation += dir;
			if (this._curRotation < 0) this._curRotation = 5;
			else if (this._curRotation > 5) this._curRotation = 0;
			this._entity.add(newscript);
			
			
			
			
		}
		//reorganizeHexzagons();
	}
	
	private function rotateComplete():Void {
		trace("Animation finished:",this._curRotation);
		var i:Int = 0;
		var imax:Int = this._hexagons.length;
		var rval:Int;
		var row:Int; 
		var col:Int; 
		var movementCounter:Int = 0;
		if (this._curRotation < 3) {
			i = imax - 2;
			while (i >= 0) {
				if (this._hexagons[i].getNum() != 0) {
					rval = i;	
					row = this._hexagons[i].getMyRow();
					col = this._hexagons[i].getMyCol();
					trace("start rval:", rval, "row:",row,"col:",col );
					switch(this._curRotation) {
						case 0:	//check tile below (3)
							rval++;
							if (rval < this._hexagons.length && rval>=0 && this._hexagons[rval].getMyCol() != col) rval = -1;
						case 1:
							if(COLS % 2!=0 && col >= Math.floor((COLS-1)/2)) rval += row;
							else if(COLS%2==0 && col >= Math.floor(COLS/2)) rval += row;
							else rval += row + 1;
						case 2:
							if (COLS % 2 != 0 && col >= Math.floor((COLS - 1) / 2)) rval += row - 1;
							else if(COLS % 2 == 0 && col >= Math.floor(COLS  / 2)) rval += row - 1;
							else rval += row;
					}
					trace("end rval:", rval);
					if(rval < this._hexagons.length && rval>=0 && rval!=i){
						if (this._hexagons[rval].getNum() == 0 && this._hexagons[rval].getType()==Hexagon.TYPE_ACTIVE) {
							this._hexagons[rval].setNumber( this._hexagons[i].getNum() );
							this._hexagons[i].setNumber( 0 );
							this._hexagons[i].setLock(false);
							movementCounter++;
						}else if ( this._hexagons[rval].getNum() == this._hexagons[i].getNum() && this._hexagons[rval].getType()==Hexagon.TYPE_ACTIVE && !this._hexagons[rval].getLock() && !this._hexagons[i].getLock()) {
							this._hexagons[rval].setNumber( this._hexagons[rval].getNum() * 2 ); 
							//this._gameScreen.score = this._gameScreen.score + this._hexagons[rval].getNum();
							this._hexagons[rval].setLock( true );
							this._hexagons[i].setNumber(0);
							this._hexagons[i].setLock(false);
							movementCounter++;
						}
					}
				}
				i--;
			}
		}else {
			i = 1;
			while (i < imax) {
				if (this._hexagons[i].getNum() != 0) {
					rval = i;	
					row = this._hexagons[i].getMyRow();
					col = this._hexagons[i].getMyCol();
					trace("start rval:", rval, "row:",row,"col:",col );
					switch(this._curRotation) {
						case 3:
							rval--;
							if (rval < this._hexagons.length && rval>=0 && this._hexagons[rval].getMyCol() != col) rval = -1;
						case 4:
							if (COLS % 2 != 0 && col > Math.floor((COLS - 1) / 2)) rval -= row+1;
							else if (COLS % 2 == 0 && col > Math.floor(COLS / 2)) rval -= row+1;
							else rval -= row;
						case 5:
							if (COLS % 2 != 0 && col > Math.floor((COLS - 1) / 2)) rval -= row;
							else if (COLS % 2 == 0 && col > Math.floor(COLS / 2)) rval -= row;
							else rval -= row - 1;
					}
					
					trace("end rval:", rval);
					if(rval < this._hexagons.length && rval>=0 && rval!=i){
						if (this._hexagons[rval].getNum() == 0 && this._hexagons[rval].getType()==Hexagon.TYPE_ACTIVE) {
							this._hexagons[rval].setNumber( this._hexagons[i].getNum() );
							//this._hexagons[rval].locked = true;
							this._hexagons[i].setNumber( 0 );
							this._hexagons[i].setLock(false);
							movementCounter++;
						}else if ( this._hexagons[rval].getNum() == this._hexagons[i].getNum() && this._hexagons[rval].getType()==Hexagon.TYPE_ACTIVE && !this._hexagons[rval].getLock() && !this._hexagons[i].getLock()) {
							this._hexagons[rval].setNumber( this._hexagons[rval].getNum() * 2 );
							this._hexagons[rval].setLock( true );
							//this._gameScreen.score = this._gameScreen.score + this._hexagons[rval].number;
							this._hexagons[i].setNumber( 0);
							this._hexagons[i].setLock(false);
							movementCounter++;
						}
					}
				}
				i++;
			}
		}
		
		if (movementCounter != 0) rotateComplete();
		else addNumber();
	}
	
	
	
	private function addNumber():Void {
		
		var emptyHex:Array<Int> = new Array();
		//find all empty spots
		var imax:Int = this._hexagons.length;
		var i = 0;
		while (i < imax) {
			if (this._hexagons[i].getNum() == 0 && this._hexagons[i].getType()==Hexagon.TYPE_ACTIVE) {
				emptyHex.push(i);
			}
			this._hexagons[i].setLock( false );
			i++;
		}
		
		
		if (emptyHex.length == 0) {
			//GAME OVER
			this._gameScreen.showGameOver();
			trace("GAME OVER");
			return;
		}
		this._rotationBlocker = false;
		var rand:Int =  Math.floor(Math.random() * emptyHex.length);
		this._hexagons[emptyHex[rand]].setNumber(  (Math.random() > 0.7)?2:4 );
		//this._gameScreen.score = this._gameScreen.score + this._hexagons[emptyHex[rand]].number;
		
	}
	
	public function depose():Void{
		this._entity.dispose();
	}
	
	public function entity():Entity { return _entity; }
	
}