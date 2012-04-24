package aop
{
	import flash.utils.getTimer;
	
	import org.swizframework.aop.support.IMethodInvocation;
	import org.swizframework.reflection.BaseMetadataTag;
	import org.swizframework.utils.logging.SwizLogger;

	public class DemoAOP
	{
		private static const LOG : SwizLogger = SwizLogger.getLogger( aop.DemoAOP);
		
		/**
		 * Performa the benchmark on regular methods.
		 *
		 * @param invocation A IMethodInvocation implementation.
		 * @param metadata The metadata which the method was annotated.
		 * @return The method return.
		 *
		 */
		[After( annotation = "AsyncBenchmark" )]
		public function performBenchmark ( invocation : IMethodInvocation, metadata : BaseMetadataTag ) : * {
			LOG.debug("aop function ---> performBenchmark")
			var method : org.swizframework.aop.support.Method = invocation.getMethod();
			var methodName : String = method.getMethodName();
			var startTimer : int = getTimer();
			//this will invoke the target function again. so you will see "call Service is invoked" twice.
			var ret : * = invocation.proceed();
			return ret;
		}
	}
}