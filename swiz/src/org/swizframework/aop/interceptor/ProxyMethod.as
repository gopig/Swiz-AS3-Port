package org.swizframework.aop.interceptor
{
    import org.as3commons.bytecode.interception.IMethodInvocationInterceptor;
    import org.as3commons.bytecode.interception.impl.InvocationKind;
    import org.swizframework.aop.support.AdvisorChain;
    import org.swizframework.aop.support.IMethodInvocation;
    import org.swizframework.aop.support.Method;

    public class ProxyMethod implements IMethodInvocationInterceptor
    {
        private var advisorChain:AdvisorChain;

        public function ProxyMethod( chain:AdvisorChain )
        {
            this.advisorChain = chain;
        }

        public function intercept(  targetInstance:Object, kind:InvocationKind,
                                    member:QName, arguments:Array = null,
                                    method:Function = null):*
        {
            trace("invoking:" + ( member == null ? "NULL MEMBER" : member.localName ) );

            // my proxy method will do nothing to constructors
            // actually, let's ONLY handle Methods for now

            if( kind == InvocationKind.METHOD )
            {
                // if the advisor chain has interceptors for this method, get a method invocation
                if( advisorChain.hasMethodAdvisors( member.localName ) )
                {
                    trace( "found method advisors, building invocation and proceeding" );
                    var targetMethod:Method = new Method( targetInstance, member.localName, method, arguments );
                    var invocation:IMethodInvocation = advisorChain.buildMethodInvocation( targetMethod );
                    return invocation.proceed();
                }
                else
                {
                    trace( "no method advisors, invocation method" );
                    if( arguments != null )
                        return method.apply( null, arguments );
                    else
                        return method();
                }
            }
        }
    }
}
