package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Adrian Dale
	 */
	public class Atom extends Entity
	{
		private var sprite:Spritemap = new Spritemap(Assets.ATOM, 16, 16);
		private var vx:Number;
		public var grabbed:Boolean = false;
		public var onBelt:Boolean = false;
		private var VBELT_SPEED:Number = 10;
		private var FLING_SPEED:Number = 50;
		public var colourCode:uint;
		public static const colourLookup:Array = [0xffffff, 0xff0000, 0x00ff00, 0x0000ff, 0xffff00];
		
		public var sfx_die:Sfx = new Sfx(Assets.SFX_DIE);
		public var sfx_goal:Sfx = new Sfx(Assets.SFX_GOAL);
		
		// b is belt number to spawn on
		public function Atom(b:int, speed:Number, col:uint) 
		{
			x = -32;
			y = 48 + 8 + b * 64;
			vx = speed;
			super(x, y, sprite);
			//sprite.centerOO();
			sprite.add("anim", [0], 10, true);
			sprite.play("anim");
			
			sprite.add("die", [0, 1, 2, 3], 5, false);
			sprite.add("goal", [0, 1, 2, 3], 5, false);
			
			type = "atom";
			setHitbox(16, 16);
			layer = 80;
			
			colourCode = col;
			sprite.color = colourLookup[colourCode];
			sprite.callback = null;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Main.gameWorld.gamePause == true) return;
			
			if (grabbed == false && onBelt == false)
			{
				x += vx * FP.elapsed;
				if (x > 320)
				{
					// Fallen off horizontal belt
					sprite.play("die");
					sprite.callback = onAtomAnimEnd;
					type = "dead_atom"; // change name so we can't pick it up
					sfx_die.play();
					Main.gameWorld.gamePause = true;
				}
			}
			
			if (onBelt == true)
			{
				if (x < 424)
				{
					// A bit of a hack because pusher piston isn't long
					// enough to reach belt
					x += FLING_SPEED * FP.elapsed;
					if (x > 424) x = 424;
				}
				else
				{
					y -= VBELT_SPEED * FP.elapsed;
					if (y < 16 && sprite.currentAnim != "goal")
					{
						// moved into goal
						sprite.play("goal");
						sprite.callback = onAtomAnimEnd;
						sfx_goal.play();
					}
				}
			}
		}
		
		public function onAtomAnimEnd():void
		{
			if (sprite.currentAnim == "die")
			{
				Main.gameWorld.changeLife( -1);
				if (Main.gameWorld.gameOver == false)
				{
					// Wait a bit longer before restarting so user
					// can really savour their loss of life ;-)
					FP.alarm(2, onAtomDeathWaitEnd);
				}
			}
			else if (sprite.currentAnim == "goal")
			{
				Main.gameWorld.atomDelivered(colourCode);
			}
			this.world.remove(this);
		}
		
		public function onAtomDeathWaitEnd():void
		{
			Main.gameWorld.gamePause = false;
		}
	}

}