package aop
{
	import flash.utils.getTimer;
	
	import org.swizframework.aop.support.IMethodInvocation;
	import org.swizframework.reflection.BaseMetadataTag;

	public class DemoAOP
	{
		[After( annotation = "AsyncBenchmark" )]
		
		/**
		 * Performa the benchmark on regular methods.
		 *
		 * @param invocation A IMethodInvocation implementation.
		 * @param metadata The metadata which the method was annotated.
		 * @return The method return.
		 *
		 */
		public function performBenchmark ( invocation : IMethodInvocation, metadata : BaseMetadataTag ) : * {
			trace("5656565654646464")
			var method : org.swizframework.aop.support.Method = invocation.getMethod();
			var methodName : String = method.getMethodName();
			var startTimer : int = getTimer();
			var ret : * = invocation.proceed();
			
			//this.printBenchmark( methodName, startTimer );
			
			return ret;
		}
	}
}