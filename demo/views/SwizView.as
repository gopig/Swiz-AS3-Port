package views
{
	import controllers.ApplicationController;
	
	import flash.display.Sprite;
	
	import models.UserModel;

	public class SwizView extends Sprite
	{
		
		[Inject]
		public var controller:ApplicationController;
		
		[Inject]
		public var userModel:UserModel;
		
		[PostConstruct]
		public function afterCreation():void{
			trace("after creation");
			trace(userModel.user);
			//controller.callService();
		}
		
	}
}