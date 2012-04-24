package org.swizframework.aop.support
{
    public interface IAdvisor extends IPointcut
    {
        function getPointcut():IPointcut;
        function getInterceptor():IMethodInterceptor;
    }
}