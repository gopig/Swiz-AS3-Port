package org.swizframework.aop.support
{
    public interface IPointcut
    {
        function methodNameMatches( methodName:String ):Boolean;
        function methodMatches( method:Method ):Boolean;
		function classMatches( className:String ):Boolean;
		function annotationMatches( annotation:String ):Boolean;
        function containsAnnotation():Boolean;

        // function patternMatches( expression:String, pattern:String ):Boolean;
    }
}