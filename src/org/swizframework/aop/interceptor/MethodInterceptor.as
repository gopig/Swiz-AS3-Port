package org.swizframework.aop.interceptor
{
    import org.swizframework.aop.support.IAdvice;
    import org.swizframework.aop.support.IMethodInterceptor;
    import org.swizframework.aop.support.IMethodInvocation;

    public class MethodInterceptor implements IMethodInterceptor
    {
        protected var advice:IAdvice;

        public function MethodInterceptor( advice:IAdvice )
        {
            this.advice = advice;
        }

        public function invoke( invocation:IMethodInvocation ):*
        {
            return advice.invoke( invocation );
        }
    }
}