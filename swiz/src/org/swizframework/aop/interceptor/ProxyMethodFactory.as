package org.swizframework.aop.interceptor
{
    import mx.core.IFactory;
    
    import org.as3commons.bytecode.interception.IMethodInvocationInterceptorFactory;
    import org.swizframework.aop.support.AdvisorChain;

    public class ProxyMethodFactory implements IMethodInvocationInterceptorFactory
    {
        private var chain:AdvisorChain;

        public function ProxyMethodFactory( chain:AdvisorChain )
        {
            this.chain = chain;
        }


        public function newInstance():*
        {
            return new ProxyMethod( chain );
        }
    }
}
