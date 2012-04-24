package org.swizframework.aop.support
{
    public interface IMethodInvocation
    {
        function getMethod():Method;
        function proceed():*;
    }
}