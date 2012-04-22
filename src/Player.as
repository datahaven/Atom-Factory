package  
{
	/**
	 * ...
	 * @author Adrian Dale
	 */
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	public class Player extends Entity
	{
		
		private static const PLAYER_SPEED:Number = 175.0;
		
		// Optimistic use of a spritemap so I can animate the graphics. If I get that far!
		private var sprite:Spritemap = new Spritemap(Assets.PLAYER, 48, 24);
		private var grabber:Grabber;
		private var gl:Graphiclist;
		
		private var tx:Number;
		private var ty:Number;
		private var py:int;
		
		private var dx:int;
		private var dy:int;
		
		private const PLAYER_COLUMN:int = 416 - 48 - 16;
		
		public function Player() 
		{
			x = PLAYER_COLUMN;
			y = 32;
			tx = x;
			ty = y;
			dx = 0;
			dy = 0;
			py = 0;
			
			grabber = new Grabber();
			Main.gameWorld.add(grabber);
			
			// TODO - probably should be just sprite now, unless I add particle explosion,
			// or something.
			gl = new Graphiclist(sprite);
			
			super(x, y, gl);
			//sprite.centerOO();
			//sprite.add("jump", [0, 1, 2], 0, false);
			sprite.add("walk", [0], 10, true);
			sprite.play("walk");
			sprite.add("holding", [1], 10, true);
		
			type = "player";
			name = "player";
			layer = 60;
		}
		
		override public function update():void
		{
			
			var indx:Number = 0;
			var indy:Number = 0;
			if (Input.check(Key.LEFT) && grabber.gs != "flinging") { indx -= 1;  }
			if (Input.check(Key.RIGHT) && grabber.gs != "flinging") { indx += 1; }
			if (Input.check(Key.UP) && dy==0 && dx==0 && grabber.gs != "flinging") { indy  -= 1; }
			if (Input.check(Key.DOWN) && dy==0 && dx==0 && grabber.gs != "flinging") { indy += 1; }
			
			if ( dy != 0 )
			{
				y += dy * FP.elapsed * PLAYER_SPEED;
				if ((dy == 1 && y >= ty) || (dy==-1 && y<=ty))
				{
					// Stop moving once we reach or pass our target
					dy = 0;
					y = ty;
				}
			}
			else
			{
				// Only look at up/down input if we're not currently moving
				var oldpy:int = py;
				py += indy;
				if (py < 0 || py > 4 || dx != 0 || x != PLAYER_COLUMN)
				{
					py = oldpy;
				}
				else
				{
					dy = indy;
					if (py == 0) ty = 24;
					else
					{
						ty = 48 +32 + 4  + ((py-1 ) * 64);
					}
					tx = PLAYER_COLUMN;
				}
			}
			
			if (dy == 0 && py > 0)
			{
				// We're not moving up or down and we're near a belt, so
				// left/right moves are allowed
				if (dx != 0 )
				{
					x += dx * FP.elapsed * PLAYER_SPEED;
					if (tx == PLAYER_COLUMN && (dx == 1 && x >= tx) )
					{
						// Stop moving once we reach or pass our target
						dx = 0;
						x = tx;
						
						tx = 0;
					}
				}
				else
				{
					x += indx * FP.elapsed * PLAYER_SPEED;
					if ((x > 320-12) && indx == 1) // ie past end of belt
					{
						// Snap to column when moving right
						tx = PLAYER_COLUMN;
						dx = 1;
					}	
				}
				
				if (x > PLAYER_COLUMN) x = PLAYER_COLUMN;
				// 29 so we don't run into belt covers
				// A better solution would be to redesign the covers
				// so player can walk under them
				if (x < 29) x = 29;
			}
			
			// Grabbing
			
			if (x < 320 && indy == -1)
			{
				if (grabber.gs == "retracted_empty")
				{
					grabber.gs = "extending";
				}
			}
			
			if (grabber.gs == "extended" && indy != -1)
			{
				grabber.gs = "retracting_empty";
				sprite.play("walk");
			}
			
			// Also works with pressed() if I want user to explicitly fling atom
			// I think that makes the game feel slower, though.
			// However, it stops accidentally putting the atom on the belt in the wrong
			// place.
			if (grabber.gs == "retracted_holding_atom" && Input.check(Key.RIGHT)
				&& x == PLAYER_COLUMN)
			{
				grabber.gs = "flinging";
				sprite.play("walk");
				Grabber.grabSfx.play();
			}
			else if (grabber.gs == "retracted_holding_atom" || grabber.gs == "retracting_holding_atom")
			{
				sprite.play("holding");
			}
			
			
			Main.gameWorld.testText.text = "x:" + x + " y: " + y + " py:" + py;
			Main.gameWorld.testText.text = "";
			
			super.update();
		}
		
	}

}