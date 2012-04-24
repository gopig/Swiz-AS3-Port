package org.swizframework.aop.support
{
    public interface IMethodInterceptor
    {
        function invoke( invocation:IMethodInvocation ):*;
    }
}