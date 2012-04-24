package org.swizframework.aop.interceptor
{
    import org.swizframework.aop.support.IAdvice;
    import org.swizframework.aop.support.IMethodInvocation;

    public class AfterInterceptor extends MethodInterceptor
    {
        public function AfterInterceptor( advice:IAdvice )
        {
            super( advice );
        }

        public override function invoke(invocation:IMethodInvocation):*
        {
            var results:* = invocation.proceed();

            advice.invoke( invocation );

            return results;
        }
    }
}