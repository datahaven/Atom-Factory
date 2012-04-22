package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	/**
	 * ...
	 * @author Adrian Dale
	 */
	public class Conveyor extends Entity
	{
		private var sprite:Spritemap = new Spritemap(Assets.CONVEYOR, 32, 32);
		private var dir:int = 0; // probably don't need this
		
		public function Conveyor(sx:int, sy:int, sdir:int) 
		{
			sprite.centerOO();
			// Speed is in fps.
			// One frame moves the belt two pixels
			var beltSpeed:int;
			if (sdir == 0) beltSpeed = 5;
			else beltSpeed = 5;
			
			sprite.add("belt_stop", [0], 10, false);
			sprite.add("belt", [0, 1, 2, 3], beltSpeed, true);
			sprite.play("belt");
			super(sx+16, sy+16, sprite);
			dir = sdir;
			if (dir == 1) sprite.angle = 90;
			
			layer = 90;
		}
		
		public override function update():void
		{
			// There must be a nice way to use events to do this?
			// Rather than have this called every frame?
			if (Main.gameWorld.gamePause) sprite.play("belt_stop");
			else sprite.play("belt");
		}
	}

}