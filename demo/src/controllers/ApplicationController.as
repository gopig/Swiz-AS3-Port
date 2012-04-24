package controllers {
	
	import flash.events.Event;
	
	import models.UserModel;
	
	import org.swizframework.events.SwizEvent;
	import org.swizframework.utils.logging.SwizLogger;
	
	/**
	 * The application controller.
	 * 
	 * @author wlepinski
	 *
	 */
	public class ApplicationController {
		
		//------------------------------------------------
		//
		//   Static Properties 
		//
		//------------------------------------------------
		
		//---------------------------------
		//   Private Properties 
		//---------------------------------
		[Inject]
		public var model:UserModel;
		
		
		private static const LOG : SwizLogger = SwizLogger.getLogger( controllers.ApplicationController );
		
		//------------------------------------------------
		//
		//   Event Handlers 
		//
		//------------------------------------------------
		[EventHandler( event = "Event.COMPLETE",properties="type,target"  )]
		[Benchmark]
		public function onApplicationComplete ( type:String,target:Object ) : void {
			//SWIZ can handle event metadata quite smart. you can pass the type and target to the function param
			//instead of event itself.
			LOG.debug("application Startuped,type:{0},target:{1}",type,target);
			this.callService();
			
		}
		
		//------------------------------------------------
		//
		//   Constructor 
		//
		//------------------------------------------------
		
		public function ApplicationController () {
		}
		
		//------------------------------------------------
		//
		//   Methods 
		//
		//------------------------------------------------
		
		[AsyncBenchmark]
		public function callService () : Object {
			//wonder why callService is invoked is display twice?
			//please navigate to DemoAOP and for more information
			LOG.debug("callService is invoked");
			return null;
		}
		[PostConstruct]
		public function postConstruct():void{
			model.user = {name:"catfood",age:22};
		}
		
		public function sayHello():void{
			LOG.debug("hello world from ApplicationController");
		}
	}
}
