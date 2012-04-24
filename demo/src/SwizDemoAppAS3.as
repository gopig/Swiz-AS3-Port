package
{
	import aop.DemoAOP;
	
	import com.adobe.viewsource.ViewSource;
	
	import controllers.ApplicationController;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	import models.UserModel;
	
	import org.swizframework.core.Bean;
	import org.swizframework.core.BeanFactory;
	import org.swizframework.core.BeanProvider;
	import org.swizframework.core.Swiz;
	import org.swizframework.core.SwizConfig;
	import org.swizframework.events.SwizEvent;
	import org.swizframework.utils.logging.SwizLogger;
	import org.swizframework.utils.logging.SwizTraceTarget;
	
	import views.SwizView;
	
	
	[Frame(factoryClass="Preloader")]
	public class SwizDemoAppAS3 extends Sprite
	{
		private static const LOG : SwizLogger = SwizLogger.getLogger( SwizDemoAppAS3 );
		private var bp:BeanProvider;
		private var cf:SwizConfig;
		private var swiz:Swiz;
		public function SwizDemoAppAS3()
		{
			
			/**
			 * Each copy of SwizView contains its own independent instance of Swiz.
			 */
			/**
			 * You provide dependencies to Swiz using IBeanProviders.
			 * Here we are defining a BeanProvider directly, which is basically just an Array.
			 * Beans can be added and removed at runtime.
			 * BeanLoader is not yet implemented in this release but will implement IBeanProvider once it is.
			 * 
			 * The Controller bean will be available for autowiring by type only.
			 * The Model bean will be available for autowiring by name as well as type.
			 */
			
			bp = new BeanProvider( [new Bean(new ApplicationController(),"applicationController"),new Bean(new UserModel(),"userModel") ] );		
			
			cf = new SwizConfig();
			cf.eventPackages = ["flash.events","org.swizframework.events"];
			cf.viewPackages = ["views"];
				
			
			/**
			 * Create an instance of Swiz and pass in dependencies and custom processors.
			 * SwizConfig is not yet implemented in this release but will be soon.
			 */
			swiz = new Swiz( Preloader.instance );
			swiz.config = cf;
			swiz.beanProviders = [bp];
			swiz.aop = [new DemoAOP()];
			swiz.loggingTargets = [new SwizTraceTarget()];
			// manually intialize Swiz. this is done automatically when defining Swiz in MXML.
			swiz.init();
			swiz.dispatcher.addEventListener(SwizEvent.LOAD_COMPLETE,onLoadComplete);
		}
		
		protected function onLoadComplete(event:SwizEvent):void
		{
			LOG.debug("swiz load complete");
			//now will dispatch a COMPLETE event, and ApplicatioinController will handle it.
			//at the sametime, DemoAOP has a metadata trigger 
			this.dispatchEvent(new Event(Event.COMPLETE,true));
			//then we add a children to check if injection works fine.
			addChild(new SwizView());
		}
	}
}