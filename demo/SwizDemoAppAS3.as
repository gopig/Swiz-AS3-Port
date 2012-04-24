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
	
	import mx.containers.ApplicationControlBar;
	
	import org.as3commons.bytecode.reflect.ByteCodeType;
	import org.swizframework.core.Bean;
	import org.swizframework.core.BeanFactory;
	import org.swizframework.core.BeanProvider;
	import org.swizframework.core.Swiz;
	import org.swizframework.core.SwizConfig;
	import org.swizframework.events.SwizEvent;
	import org.swizframework.utils.logging.SwizTraceTarget;
	
	import views.SwizView;
	
	
	[Frame(factoryClass="Preloader")]
	public class SwizDemoAppAS3 extends Sprite
	{
		public static var LOADER_INFO:LoaderInfo;
		public static var INSTANCE:Object;
		private var bp:BeanProvider;
		private var cf:SwizConfig;
		public var systemManager:SwizDemoAppAS3;
		private var swiz:Swiz;

		private var view:SwizView;
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
			
			/**
			 * Support for custom metadata processors is probably the coolest feature in Swiz 1.0.0
			 * Definitely check out their source to see how easy they are to implement.
			 * Swiz uses this exact mechanism to implement its built in metadata tags like Autowire, Mediate and VirtualBean.
			 */
			//cp = [ new ClockProcessor(), new RandomProcessor() ];
			cf = new SwizConfig();
			cf.eventPackages = ["flash.events","org.swizframework.events"];
			cf.viewPackages = ["views"];
				
			/**
			 * Create an instance of Swiz and pass in dependencies and custom processors.
			 * SwizConfig is not yet implemented in this release but will be soon.
			 */
			systemManager = this;
			swiz = new Swiz( Preloader.instance );
			swiz.config = cf;
			swiz.beanProviders = [bp];
			swiz.aop = [new DemoAOP()];
			swiz.loggingTargets = [new SwizTraceTarget()];
			// manually intialize Swiz. this is done automatically when defining Swiz in MXML.
			swiz.init();
			Preloader.instance.stage.addEventListener(MouseEvent.CLICK,onMouseClick);
		}
		
		protected function onLoadComplete(event:SwizEvent):void
		{
			// TODO Auto-generated method stub
			trace("----------------------------------------------Created");
			//onMouseClick(null);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			trace("clcclclccl");
//			view = new SwizView();
//			addChild(view);
//			var bean:Bean = swiz.beanFactory.getBeanByName("applicationController");
//			var controller:ApplicationController = bean.source;
//			controller.callService();
			this.dispatchEvent(new Event(Event.COMPLETE,true));
			// TODO Auto-generated method stub
			//controller.onApplicationComplete(null);
		}
	}
}