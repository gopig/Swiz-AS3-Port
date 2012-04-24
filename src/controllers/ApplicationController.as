package controllers {
	
	import flash.events.Event;
	
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
		
		private static const LOG : SwizLogger = SwizLogger.getLogger( controllers.ApplicationController );
		
		//------------------------------------------------
		//
		//   Event Handlers 
		//
		//------------------------------------------------
		[EventHandler( event = "Event.COMPLETE",properties="type,target"  )]
		[Benchmark]
		public function onApplicationComplete ( type:String,target:Object ) : void {
			
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
			trace("34343434");
//			var service : HTTPService = new HTTPService();
//			service.url = 'http://www.google.com.br/';
//			service.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
//			return service.send();
			return null;
		}
	}
}
