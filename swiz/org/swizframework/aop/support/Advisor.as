package org.swizframework.aop.support
{
    public class Advisor implements IAdvisor
    {
        private var pointcut:IPointcut;
        private var interceptor:IMethodInterceptor;

        public function Advisor( pointcut:IPointcut, interceptor:IMethodInterceptor )
        {
            this.pointcut = pointcut;
            this.interceptor = interceptor;
        }

        public function getPointcut():IPointcut
        {
            return pointcut;
        }

        public function getInterceptor():IMethodInterceptor
        {
            return interceptor;
        }

        public function methodNameMatches( methodName:String ):Boolean
        {
            return pointcut.methodNameMatches( methodName );
        }

        public function methodMatches( method:Method ):Boolean
        {
            return pointcut.methodMatches( method );
        }

        public function classMatches( className:String ):Boolean
        {
            return pointcut.classMatches( className );
        }

        public function annotationMatches( annotation:String ):Boolean
        {
            return pointcut.annotationMatches( annotation );
        }

        public function containsAnnotation():Boolean
        {
            return pointcut.containsAnnotation();
        }

        /*
        public function patternMatches(pattern:String):Boolean
        {
            return pointcut.patternMatches( pattern );
        }
        */
    }
}