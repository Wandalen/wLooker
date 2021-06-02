
let _ = require( 'wlooker' )

/**/

let structure =
{
  number : 1,
  string : 's',
  array : [ 1, { date : new Date() } ],
  routine : function(){},
  set : new Set([ 'a', 13 ]),
  hasmap : new HashMap([ [ 'a', 13 ], [ null, 0 ] ]),
}

_.look( structure, ( e, k, it ) => console.log( it.path ) );

/* output :
/
/number
/string
/array
/array/#0
/array/#1
/array/#1/date
/routine
/set
/set/a
/set/#1
/hasmap
/hasmap/a
/hasmap/#1
*/
