
let _ = require( 'wlooker' )

/**/

let structure =
{
  a : 1,
  b : 's',
  c : [ 1,3 ],
  d : [ 1,{ date : new Date() } ],
  e : function(){},
  f : new ArrayBuffer( 13 ),
  g : new Float32Array([ 1,2,3 ]),
}

function handleUp( e, k, it )
{
  console.log( it.path );
}

_.look( structure, handleUp );
