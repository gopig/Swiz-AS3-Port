package org.swizframework.aop.support
{
import org.swizframework.reflection.BaseMetadataTag;

public class Advice implements IAdvice
    {
        private var parameters:Array;
        private var method:Function;

        public function Advice( method:Function, parameters:Array=null )
        {
            this.method = method;
            this.parameters = parameters;
        }


        public function invoke( invocation:IMethodInvocation ):void
        {
            // execute teh advice method. however, we are interested in passing arguments as well
            method.apply( null, constructParameters( invocation ) );
        }

        private function constructParameters( invocation:IMethodInvocation ):Array
        {
            var params:Array;

            if( parameters != null && parameters.length > 0 )
            {
                params = [];
                var paramIx:int = 0;
                var args:Array = invocation.getMethod().getArgs();
                var md:BaseMetadataTag = invocation.getMethod().getMetadata();

                // first see if we can put the invocation itself in the advice parameters
                if( invocation is parameters[ paramIx ] )
                    params[ paramIx++ ] = invocation;

                // now see if the invocation has any metadata for this advice method
                if( md != null && md is parameters[ paramIx ] )
                    params[ paramIx ++ ] = md;

                // now loop over all the arguments and try to add them in order
                if( args != null && args.length > 0 )
                {
                    for( var i:int=0; i<args.length; i++ )
                    {
						// if we have moved past the end of he advice method's parameter array, return it
						if( paramIx >= parameters.length )
							return params;
						else if( args[ i ] is parameters[ paramIx ] )
                            params[ paramIx++ ] = args[ i ];
                    }
                }
            }

            return params;
        }
    }
}