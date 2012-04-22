package  
{
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.tweens.misc.NumTween;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Adrian Dale
	 */
	public class TitleScreen2 extends World
	{
		private var titleText:Text;
		private var authorText:Text;
		private var helpText:Text = new Text("Press SPACE to Start");
		
		private static const TITLE_IN_DURATION:Number = 2.0;
		private static const TITLE_OUT_DURATION:Number = 1.0;
		private var titleVisible:Boolean = false;
		private var waitTime:Number = 10.0;
		
		public var fader:NumTween = new NumTween();
		
		public var sfx_whoosh1:Sfx = new Sfx(Assets.SFX_WHOOSH1);
		public var sfx_whoosh2:Sfx = new Sfx(Assets.SFX_WHOOSH2);
		
		private var helpTweenIn:VarTween = new VarTween(onHelpTweenInDone);
		private var helpTweenOut:VarTween = new VarTween(onHelpTweenOutDone);
		
		public function TitleScreen2() 
		{
			Text.size = 24;
			titleText = new Text("Atom Factory");
			
			// Start title and author text off screen.
			// Finish in the position that is currently commented out
			//titleText.x = FP.screen.width / 2 - titleText.width / 2;
			titleText.x = FP.screen.width;
			titleText.y = FP.screen.height / 2 - titleText.height / 2;
			addGraphic(titleText);
			
			Text.size = 12;
			authorText = new Text("Adrian Dale");
			//authorText.x = FP.screen.width / 2 - authorText.width / 2;
			authorText.x = -authorText.width;
			authorText.y = titleText.y + authorText.height + 8;
			addGraphic(authorText);
			
			var titleTween:VarTween = new VarTween(onTitleTweenDone);
			titleTween.tween(titleText, "x", FP.screen.width / 2 - titleText.width / 2,
							TITLE_IN_DURATION, Ease.bounceOut);
			addTween(titleTween);
			
			var authorTween:VarTween = new VarTween();
			authorTween.tween(authorText, "x", FP.screen.width / 2 - authorText.width / 2,
							TITLE_IN_DURATION, Ease.bounceOut);
			addTween(authorTween);
			
			fader.tween(0, 1, TITLE_IN_DURATION, Ease.quadIn);
			addTween(fader);
			
			helpText.size = 16;
			helpText.y = 285;
			helpText.x = FP.screen.width / 2 - helpText.width / 2;
			helpText.alpha = 0;
			addGraphic(helpText);
			
			sfx_whoosh2.play();
		}
		
		private function onTitleTweenDone():void
		{
			titleVisible = true;
			
			// Bring in the press space text
			helpTweenIn.tween(helpText, "alpha", 1, 3, Ease.cubeInOut);
			addTween(helpTweenIn);
			
			addTween(helpTweenOut);
		}
		
		public function onHelpTweenInDone():void
		{
			helpTweenOut.tween(helpText, "alpha", 0, 3, Ease.cubeInOut);
			helpTweenOut.start();
		}
		
		public function onHelpTweenOutDone():void
		{
			helpTweenIn.tween(helpText, "alpha", 1, 3, Ease.cubeInOut);
			helpTweenIn.start();
		}
		
		public override function update():void
		{
			titleText.alpha = fader.value;
			authorText.alpha = fader.value;
			
			if (titleVisible)
			{
				// Never want to start game without permission
				//waitTime -= FP.elapsed;
				
				if (waitTime < 0 || Input.pressed(Key.SPACE) )
				{
					// Start removing the titles
					titleVisible = false;
					
					// Be nice to play a sound effect here
					// - a decent one, at least! SFXR is a bit strident
					sfx_whoosh1.play();
					
					// Don't bother to fade it out - it all happens so quickly nobody will notice
					helpText.visible = false;
					
					var titleTween:VarTween = new VarTween(onTitleFinished);
					titleTween.tween(titleText, "y",  - titleText.height,
							TITLE_OUT_DURATION, Ease.cubeOut);
					addTween(titleTween);
			
					var authorTween:VarTween = new VarTween();
					authorTween.tween(authorText, "y", FP.screen.height,
							TITLE_OUT_DURATION, Ease.cubeOut);
					addTween(authorTween);
					
					fader.tween(1, 0, TITLE_OUT_DURATION, Ease.quadOut);
				}
			}
		}
		
		public function onTitleFinished():void
		{
			FP.world = new GameWorld();
		}
	}

}