package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Adrian Dale
	 */
	public class Grabber extends Entity
	{
		private var grabber:Spritemap = new Spritemap(Assets.GRABBER, 48, 24);
		
		// retracted_empty
		// retracted_holding_atom
		// extended
		// extending
		// retracting_empty
		// retracting_holding_atom
		// flinging (onto conveyor)
		// flinging_retract
		public var gs:String = "retracted_empty";
		public static const GRABBER_SPEED:Number = 50;
		public static const FLING_SPEED:Number = 50;
		
		public var grabberExtension:Number = 0;
		public var gFlingExt:Number = 0;
		public var grabbedAtom:Atom = null;
		
		public static var grabSfx:Sfx = new Sfx(Assets.SFX_GRAB);
		
		public function Grabber() 
		{
			grabber.centerOO();
			grabber.add("grab", [0], 10, true);
			grabber.play("grab");
			super(x, y, grabber);
			type = "grabber";
			setHitbox(16, 16, 8, 8);
			layer = 70;
		}
		
		public override function update():void
		{
			
			var xoff:int = 16 + 8;
			var yoff:int = 0;
			if (gs == "flinging" || gs == "flinging_retract")
			{
				grabber.angle = -90;
				xoff = 18;
				yoff = -4;
			}
			else
			{
				grabber.angle = 0;
			}
			
			// Move grabber with player
			var player:Player = Main.gameWorld.getInstance("player") as Player;
			x = player.x + gFlingExt + xoff;
			y = player.y + grabberExtension + 12 + yoff;
			
			// If we're holding an atom, move that, too
			if (grabbedAtom != null)
			{
				grabbedAtom.x = player.x + 16 + gFlingExt;
				grabbedAtom.y = player.y + grabberExtension; // TODO - line this up
			}
			
			if (gs == "extending")
			{
				grabberExtension -= Grabber.GRABBER_SPEED * FP.elapsed;
				if (grabberExtension < -24)
				{
					grabberExtension = -24;
					gs = "extended";
				}
			}
			
			if (gs == "retracting_empty")
			{
				grabberExtension += Grabber.GRABBER_SPEED * FP.elapsed;
				if (grabberExtension > 0)
				{
					grabberExtension = 0;
					gs = "retracted_empty";
				}
			}
			
			if (gs == "retracting_holding_atom")
			{
				grabberExtension += Grabber.GRABBER_SPEED * FP.elapsed;
				if (grabberExtension > 0)
				{
					// TODO - maybe don't extend it all the way in if holding?
					grabberExtension = 0;
					gs = "retracted_holding_atom";
				}
			}
			
			if (gs == "flinging")
			{
				gFlingExt += Grabber.FLING_SPEED * FP.elapsed;
				if (gFlingExt > 38)
				{
					gs = "flinging_retract";
					grabbedAtom.onBelt = true;
					grabbedAtom.grabbed = false;
					grabbedAtom = null;
				}
			}
			
			if (gs == "flinging_retract")
			{
				gFlingExt -= Grabber.FLING_SPEED * FP.elapsed;
				if (gFlingExt < 0)
				{
					gFlingExt = 0;
					gs = "retracted_empty";
				}
			}
			
			// Only check for grabbing an atom if grabber is extended and
			// not holding one already
			if (gs == "retracting_empty" || gs == "extending" || gs == "extended")
			{
				grabbedAtom = collide("atom", x, y) as Atom;
				if (grabbedAtom != null)
				{
					gs = "retracting_holding_atom";
					grabbedAtom.grabbed = true;
					grabSfx.play();
				}
			}
			super.update();
		}
	}

}