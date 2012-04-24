package views
{
	import controllers.ApplicationController;
	
	import flash.display.Sprite;
	
	import models.UserModel;
	
	import org.swizframework.utils.logging.SwizLogger;

	public class SwizView extends Sprite
	{
		
		[Inject]
		public var controller:ApplicationController;
		
		[Inject]
		public var userModel:UserModel;
		private static const LOG : SwizLogger = SwizLogger.getLogger( views.SwizView );
		
		
		[PostConstruct]
		public function postConstruct():void{
			LOG.debug("swizView create complete");
			controller.sayHello();
			LOG.debug("getting model value, name :{0},age:{1}",userModel.user.name,userModel.user.age);
		}
		
	}
}