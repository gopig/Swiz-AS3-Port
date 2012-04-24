package org.swizframework.aop.support
{
import org.swizframework.reflection.BaseMetadataTag;

public class MethodInvocation implements IMethodInvocation
    {
        private var method:Method;
        private var advisors:Array;
        private var metadata:Array;
        private var currentIndex:int;

        public function MethodInvocation( method:Method, advisors:Array, metadata:Array=null )
        {
            this.method = method;
            this.advisors = advisors;
            this.metadata = metadata;
            currentIndex = -1;
        }

        public function getMethod():Method
        {
            return method;
        }

        public function proceed():*
        {
            // just invoke the method if there are no advisors, else search for matches
            if( advisors == null || advisors.length == 0 )
                return method.invoke();

            var advisor:IAdvisor;
            var interceptor:IMethodInterceptor;

            // look for an interceptor that
            while( interceptor == null )
            {
                currentIndex++;

                if( currentIndex < advisors.length )
                {
                    advisor = IAdvisor( advisors[ currentIndex ] );
                    if( advisorMatches( advisor ) )
                    {
                        interceptor = advisor.getInterceptor();
                        if( advisor.containsAnnotation() && metadata != null )
                        {
                            var md:BaseMetadataTag;
                            for( var i:int = 0; i<metadata.length; i++ )
                            {
                                md = BaseMetadataTag( metadata[ i ] );
                                if( advisor.annotationMatches( md.name ) )
                                {
                                    method.setMetadata( md );
                                    break;
                                }
                            }
                        }
                        else
                        {
                            method.setMetadata( null );
                        }
                    }
                }
                else
                {
                    break;
                }
            }

            if( interceptor != null )
                return interceptor.invoke( this );
            else
                return method.invoke();
        }

        private function advisorMatches( advisor:IAdvisor ):Boolean
        {
            var matches:Boolean = false;

            // extend logic past method matching
            matches = advisor.methodMatches( method );

            return matches;
        }
    }
}