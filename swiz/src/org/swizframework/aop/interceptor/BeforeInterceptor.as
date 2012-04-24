package org.swizframework.aop.interceptor
{
    import org.swizframework.aop.support.IAdvice;
    import org.swizframework.aop.support.IMethodInvocation;

    public class BeforeInterceptor extends MethodInterceptor
    {
        public function BeforeInterceptor( advice:IAdvice )
        {
            super( advice )
        }

        public override function invoke(invocation:IMethodInvocation):*
        {
            advice.invoke( invocation );

            return invocation.proceed();
        }
    }
}