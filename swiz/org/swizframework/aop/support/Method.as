package org.swizframework.aop.support
{
import org.swizframework.reflection.BaseMetadataTag;

public class Method
    {
		// ========================================
		// public properties
		// ========================================

        /**
         * Target object to invoke the method on.
         */
        private var target:*;

        /**
         * Target method name to invoke on target object.
         */
        private var methodName:String;

        /**
         * Target method to invoke.
         */
        private var method:Function;

        /**
         * Arguments array to invoke method with
         */
        private var args:Array;

        /**
         * Metadata for annotation based pointcut
         */
        private var metadata:BaseMetadataTag;

		// ========================================
		// constructor
		// ========================================

        public function Method( target:*, methodName:String, targetMethod:Function, args:Array=null )
        {
            this.target = target;
            this.methodName = methodName;
            this.method = targetMethod;
            this.args = args;
        }

		// ========================================
		// public methods
		// ========================================

        public function invoke():*
        {
            if( args != null )
                return method.apply( null, args );
            else
                return method();
        }

        public function getTarget():*
        {
            return target;
        }

        public function getMethodName():String
        {
            return methodName;
        }

        public function getMethod():Function
        {
            return method;
        }

        public function getArgs():Array
        {
            return args;
        }

        public function setMetadata( metadata:BaseMetadataTag ):void
        {
            this.metadata = metadata;
        }

        public function getMetadata():BaseMetadataTag
        {
            return metadata;
        }
    }
}