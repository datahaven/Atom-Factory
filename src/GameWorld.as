package  
{
	/**
	 * ...
	 * @author Adrian Dale
	 */
	import flash.display.BitmapData;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	public class GameWorld extends World
	{
		public var testText:Text = new Text("");
		public var background:Image = new Image(Assets.BACKGROUND);
		public var gameTime:Number = 0;
		public var nextAtomTime:Number = 0;
		public const ATOM_START_INTERVAL:Number = 5;
		public const ATOM_INTERVAL_MIN:Number = 2;
		public var atomInterval:Number;
		
		public var livesText:Text = new Text("");
		public var scoreText:Text = new Text("");
		public var comboText:Text = new Text("Combo:");
		private var comboSprites:Array = new Array();
		private const MAX_COMBO:int = 8;
		
		private var lives:int = 3;
		private var score:int = 0;
		public var gametime:int = 0;
		public var comboColour:uint = 0;
		public var comboCount:uint = 0;
		
		private var gameOverText:Text = new Text("GAME OVER");
		private var gameOverSfx:Sfx = new Sfx(Assets.SFX_GAMEOVER);
		public var gamePause:Boolean = false;
		public var gameOver:Boolean = false;
		
		public function GameWorld() 
		{
			Main.gameWorld = this;
			gameOverText.visible = false;
			gameOverText.size = 72; // 64
			gameOverText.x = FP.screen.width / 2;
			gameOverText.y = FP.screen.height / 2;
			gameOverText.centerOO();
			addGraphic(gameOverText, 0);
		}
		
		override public function begin():void
		{	
			// Add the horizontal belts
			var by:int = 320 / 4 - 32;
			for (var b:int = 0; b < 4; b++)
			{
				var bx:int = 0;
				for (bx = 0; bx < 10; bx++)
				{
					add(new Conveyor(bx*32, by, 0));
				}
				by += 64;
				
				// Add the covers over the start of the belts
				var beltCover1:Image = new Image(Assets.CONVEYOR_COVER);
				beltCover1.x = 0;
				beltCover1.y = 320 / 4 - 32 - 16 + (b*64);
				addGraphic(beltCover1,75);
			}
			
			// Add the vertical belt
			for (by = 0; by < 9; by++)
			{
				add(new Conveyor(416, 32 + by * 32, 1));
			}
			var beltCover2:Image = new Image(Assets.CONVEYOR_COVER);
			beltCover2.angle = 90;
			beltCover2.y = 292+32;
			beltCover2.x = 416 - 16;
			addGraphic(beltCover2,75);
			
			add(new Player());
			testText.y = 32;
			addGraphic(testText);
			
			addGraphic(background,100);
			
			// Start at zero so we get an atom straight away
			nextAtomTime = 0;
			atomInterval = ATOM_START_INTERVAL;
			
			livesText.x = 16;
			livesText.y = 8;
			changeLife(0);
			addGraphic(livesText);
			
			scoreText.x = 92;
			scoreText.y = 8;
			addToScore(0);
			addGraphic(scoreText);
			
			comboText.x = 182;
			comboText.y = 8;
			addGraphic(comboText);
			for (var i:int = 0; i < MAX_COMBO; i++)
			{
				var comboSprite:Spritemap = new Spritemap(Assets.ATOM, 16, 16);
				comboSprite.y = 8;
				comboSprite.x = i * 16 + 242;
				comboSprite.color = 0xffffff;
				addGraphic(comboSprite);
				comboSprites[i] = comboSprite;
			}
		}
		
		public function addToScore(s:int):void
		{
			score += s;
			scoreText.text = "Score: " + score;
		}
		
		public function updateComboDisplay():void
		{
			for (var i:int = 0; i < MAX_COMBO; i++)
			{
				var comboSprite:Spritemap = comboSprites[i];
				if (comboSprite != null)
				{
					if (i >= comboCount)	comboSprite.color = 0xffffff;
					else comboSprite.color = Atom.colourLookup[comboColour];
				}
			}
		}
		
		public function atomDelivered(c:uint):void
		{
			if ( c == comboColour )
			{
				comboCount++;
				if (comboCount > MAX_COMBO) comboCount = MAX_COMBO;
			}
			else
			{
				comboColour = c;
				comboCount = 1;
			}
			addToScore(comboCount);
			updateComboDisplay();
		}
		
		public function changeLife(s:int):void
		{
			lives += s;
			livesText.text = "Lives: " + lives;
			comboCount = 0;
			comboColour = 0;
			updateComboDisplay();
			
			if (lives == 0)
			{
				// Game Over!
				Main.gameWorld.gamePause = true;
				Main.gameWorld.gameOver = true;
				var GOTween:VarTween = new VarTween();
				gameOverText.visible = true;
				gameOverText.alpha = 0;
				GOTween.tween(gameOverText, "alpha", 1, 3, Ease.quadIn);
				addTween(GOTween);
				
				var GOScaleTween:VarTween = new VarTween();
				gameOverText.scale = 0.5;
				GOScaleTween.tween(gameOverText, "scale", 1, 8, Ease.bounceOut);
				addTween(GOScaleTween);
				
				// Dim the screen
				var overlay:Image = Image.createRect(FP.screen.width, FP.screen.height, 0);
				addGraphic(overlay, 1);
				overlay.alpha = 0.0;
				var dimTween:VarTween = new VarTween();
				dimTween.tween(overlay, "alpha", 0.65, 3);
				addTween(dimTween);
				
				gameOverSfx.play();
				
				FP.alarm(15, onGOComplete);
				
			}
		}
		
		public function onGOComplete():void
		{
			FP.world = new TitleScreen2();
		}
		
		override public function update():void
		{
			super.update();
			
			// For impatient players
			if (gameOver && Input.pressed(Key.SPACE)) onGOComplete();
			
			// Do some levelling up
			gameTime += FP.elapsed;
			if (gameTime < 30 ) atomInterval = ATOM_START_INTERVAL;
			else if (gameTime < 60) atomInterval = ATOM_START_INTERVAL - 1;
			else if (gameTime < 90) atomInterval = ATOM_START_INTERVAL - 2;
			else if (gameTime < 120) atomInterval = ATOM_START_INTERVAL - 3;
			
			nextAtomTime -= FP.elapsed;
			if (nextAtomTime < 0)
			{
				nextAtomTime = atomInterval;
				var belt:int = Math.floor(Math.random() * (1 + 3 - 0)) + 0;
				var col:uint = Math.floor(Math.random() * 4) + 1;
				add(new Atom(belt, 10, col));
			}
			
		}
	}

}