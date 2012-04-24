package org.swizframework.aop.support
{
    import flash.utils.Dictionary;

    import org.swizframework.reflection.BaseMetadataTag;

    public class AdvisorChain
    {
        private var methodAdvisors:Dictionary;
        private var methodMetadata:Dictionary;
        private var methodNames:Array;

        public function AdvisorChain()
        {
            methodAdvisors = new Dictionary();
            methodMetadata = new Dictionary();
            methodNames = [];
        }

        public function addMethodAdvisor( methodName:String, advisor:Advisor, metaData:BaseMetadataTag=null ):void
        {
            if( methodAdvisors[ methodName ] == null )
            {
                methodAdvisors[ methodName ] = [];
                methodNames.push( methodName );
            }
            methodAdvisors[ methodName ].push( advisor );

            if( metaData != null )
            {
                methodMetadata[ methodName ] ||= [];
                methodMetadata[ methodName ].push( metaData );
            }
        }

        public function hasMethodAdvisors( methodName:String ):Boolean
        {
            return methodAdvisors[ methodName ] != null;
        }

        public function buildMethodInvocation( method:Method ):MethodInvocation
        {
            return new MethodInvocation( method, methodAdvisors[ method.getMethodName() ], methodMetadata[ method.getMethodName() ] );
        }

        public function getAdvisedMethods():Array
        {
            return methodNames;
        }
    }
}