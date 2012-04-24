package org.swizframework.aop.support
{
    public interface IAdvice
    {
        function invoke( invocation:IMethodInvocation ):void;
    }
}