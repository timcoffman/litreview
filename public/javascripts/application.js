
var gDOMLoaded = false ;
document.observe( 'dom:loaded', function() { gDOMLoaded = true ; }  ) ;

function withLoadedDocument(f){
	if (typeof f == 'string') {
		var functionBody = f ;
		f = function() { eval(functionBody); } ;
	}
	if ( typeof f == 'undefined' )
		return f ;
	if ( typeof f != 'function' )
		throw 'withLoadedDocument(...) requires a function argument'
	
	var args = Array.prototype.slice.call(arguments, 1) ;
	if ( gDOMLoaded )
		f.apply(args);
	else
		document.observe('dom:loaded', function() { f.apply(this,args) ; } ) ;
	
	return f ;
}
