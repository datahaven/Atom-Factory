package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Key;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class Main extends Engine
	{
		public static var gameWorld:GameWorld;
		
		public function Main()
		{
			// TODO - Add a site-lock?
			// Probably not worth it if I'm publishing the source code anyway.
			super(480, 320, 60, false);
			
			//FP.screen.scale = 2.0;
			
			var s:Splash = new Splash(0xff3366, 0x808080);
			FP.world.add(s);
			s.start(onSplashComplete);
		
			//FP.console.enable(); // TODO - Remember to remove this from final
			FP.console.toggleKey = Key.DIGIT_1;
			
		}
		
		public function onSplashComplete():void
		{
			FP.screen.color = 0x606060;
			//FP.world = new GameWorld();
			FP.world = new TitleScreen2(); // TODO - Remember to put titles back into final
		}
		
	}
}