package  
{
	/**
	 * ...
	 * @author Adrian Dale
	 */
	public class Assets 
	{
		[Embed(source = './../assets/player.png')] public static const PLAYER:Class;
		[Embed(source = "../assets/atom.png")] public static const ATOM:Class;
		[Embed(source = "../assets/grabber.png")] public static const GRABBER:Class;
		[Embed(source = "../assets/side_grabber.png")] public static const GRABBER_SIDE:Class;
		[Embed(source = "../assets/conveyor.png")] public static const CONVEYOR:Class;
		[Embed(source = "../assets/conveyor_cover.png")] public static const CONVEYOR_COVER:Class;
		[Embed(source = "../assets/background.png")] public static const BACKGROUND:Class;
		[Embed(source="../assets/Goal.mp3")] public static const SFX_GOAL:Class;
		[Embed(source = "../assets/Die2.mp3")] public static const SFX_DIE:Class;
		[Embed(source = "../assets/Whoosh1.mp3")] public static const SFX_WHOOSH1:Class;
		[Embed(source="../assets/Whoosh2.mp3")] public static const SFX_WHOOSH2:Class;
		[Embed(source = "../assets/Grab4.mp3")] public static const SFX_GRAB:Class;
		[Embed(source = "../assets/GameOver.mp3")] public static const SFX_GAMEOVER:Class;
	}

}