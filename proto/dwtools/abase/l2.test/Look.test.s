( function _Looker_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );

  require( '../l2/Looker.s' );

  _.include( 'wTesting' );
  _.include( 'wStringer' );

}

var _global = _global_;
var _ = _global_.wTools;

/*
cls && node builder\include\dwtools\abase\l3.test\Looker.test.s && node builder\include\dwtools\abase\l4.test\LookerExtra.test.s && node builder\include\dwtools\abase\l4.test\Replicator.test.s && node builder\include\dwtools\abase\l5.test\Selector.test.s && node builder\include\dwtools\abase\l6.test\SelectorExtra.test.s && node builder\include\dwtools\abase\l6.test\LookerComparator.test.s
*/

// --
// tests
// --

function look( test )
{

  var structure1 =
  {
    a : 1,
    b : 's',
    c : [ 1,3 ],
    d : [ 1,{ date : new Date( Date.UTC( 1990, 0, 0 ) ) } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1,2,3 ]),
  }

  var expectedUpPaths = [ '/', '/a', '/b', '/c', '/c/0', '/c/1', '/d', '/d/0', '/d/1', '/d/1/date', '/e', '/f', '/g' ];
  var expectedDownPaths = [ '/a', '/b', '/c/0', '/c/1', '/c', '/d/0', '/d/1/date', '/d/1', '/d', '/e', '/f', '/g', '/' ];
  var expectedUpIndinces = [ null, 0, 1, 2, 0, 1, 3, 0, 1, 0, 4, 5, 6 ];
  var expectedDownIndices = [ 0, 1, 0, 1, 2, 0, 0, 1, 3, 4, 5, 6, null ];

  var gotUpPaths = [];
  var gotDownPaths = [];
  var gotUpIndinces = [];
  var gotDownIndices = [];

  var it = _.look( structure1, handleUp1, handleDown1 );
  // var it = _.look({ src : structure1, onUp : handleUp1, onDown : handleDown1 });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );
  test.is( _.lookIteratorIs( Object.getPrototypeOf( it ) ) );
  test.is( _.lookerIs( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) ) );
  test.is( Object.getPrototypeOf( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) ) === null );
  test.is( Object.getPrototypeOf( Object.getPrototypeOf( it ) ) === it.Looker );
  test.is( Object.getPrototypeOf( it ) === it.iterator );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );
  test.case = 'indices on up';
  test.identical( gotUpIndinces, expectedUpIndinces );
  test.case = 'indices on down';
  test.identical( gotDownIndices, expectedDownIndices );

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
    gotUpIndinces.push( it.index );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownIndices.push( it.index );
  }

}

//

function lookRecursive( test )
{

  var structure1 =
  {
    a1 :
    {
      b1 :
      {
        c1 : 'abc',
        c2 : 'c2',
      },
      b2 : 'b2',
    },
    a2 : 'a2',
  }

  /* */

  test.open( 'recursive : 0' );

  var expectedUpPaths = [ '/' ];
  var expectedDownPaths = [ '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 0,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 0' );

  /* */

  test.open( 'recursive : 1' );

  var expectedUpPaths = [ '/', '/a1', '/a2' ];
  var expectedDownPaths = [ '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 1,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 1' );

  /* */

  test.open( 'recursive : 2' );

  var expectedUpPaths = [ '/', '/a1', '/a1/b1', '/a1/b2', '/a2' ];
  var expectedDownPaths = [ '/a1/b1', '/a1/b2', '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 2,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : 2' );

  /* */

  test.open( 'recursive : Infinity' );

  var expectedUpPaths = [ '/', '/a1', '/a1/b1', '/a1/b1/c1', '/a1/b1/c2', '/a1/b2', '/a2' ];
  var expectedDownPaths = [ '/a1/b1/c1', '/a1/b1/c2', '/a1/b1', '/a1/b2', '/a1', '/a2', '/' ];
  var gotUpPaths = [];
  var gotDownPaths = [];

  var it = _.look
  ({
    src : structure1,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : Infinity,
  });

  test.case = 'iteration';
  test.is( _.Looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : Infinity' );

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
  }

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
  }

}

//

function fieldPaths( test )
{

  let upc = 0;
  function onUp()
  {
    let it = this;
    let expectedPaths = [ '/', '/a', '/d', '/d/b', '/d/c' ];
    test.identical( it.path, expectedPaths[ upc ] );
    upc += 1;
  }
  let downc = 0;
  function onDown()
  {
    let it = this;
    let expectedPaths = [ '/a', '/d/b', '/d/c', '/d', '/' ];
    test.identical( it.path, expectedPaths[ downc ] );
    downc += 1;
  }

  /* */

  var src =
  {
    a : 11,
    d :
    {
      b : 13,
      c : 15,
    }
  }
  var got = _.look
  ({
    src : src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  test.identical( got, got );
  test.identical( upc, 5 );
  test.identical( downc, 5 );

  /* */

}

//

function callbacksComplex( test )
{
  let ups = [];
  let dws = [];

  /* - */

  let expUps =
  [
    '/',
    '/null',
    '/undefined',
    '/boolean.true',
    '/boolean.false',
    '/string.defined',
    '/string.empty',
    '/number.zero',
    '/number.small',
    '/number.big',
    '/number.infinity.positive',
    '/number.infinity.negative',
    '/number.nan',
    '/number.signed.zero.negative',
    '/number.signed.zero.positive',
    '/bigInt.zero',
    '/bigInt.small',
    '/bigInt.big',
    '/regexp.simple1',
    '/regexp.simple2',
    '/regexp.simple3',
    '/regexp.simple4',
    '/regexp.simple5',
    '/regexp.complex0',
    '/regexp.complex1',
    '/regexp.complex2',
    '/regexp.complex3',
    '/regexp.complex4',
    '/regexp.complex5',
    '/regexp.complex6',
    '/regexp.complex7',
    '/date.now',
    '/date.fixed',
    '/buffer.node',
    '/buffer.raw',
    '/buffer.bytes',
    '/array.simple',
    '/array.simple/0',
    '/array.simple/1',
    '/array.complex',
    '/array.complex/0',
    '/array.complex/0/null',
    '/array.complex/0/undefined',
    '/array.complex/0/boolean.true',
    '/array.complex/0/boolean.false',
    '/array.complex/0/string.defined',
    '/array.complex/0/string.empty',
    '/array.complex/0/number.zero',
    '/array.complex/0/number.small',
    '/array.complex/0/number.big',
    '/array.complex/0/number.infinity.positive',
    '/array.complex/0/number.infinity.negative',
    '/array.complex/0/number.nan',
    '/array.complex/0/number.signed.zero.negative',
    '/array.complex/0/number.signed.zero.positive',
    '/array.complex/0/bigInt.zero',
    '/array.complex/0/bigInt.small',
    '/array.complex/0/bigInt.big',
    '/array.complex/0/regexp.simple1',
    '/array.complex/0/regexp.simple2',
    '/array.complex/0/regexp.simple3',
    '/array.complex/0/regexp.simple4',
    '/array.complex/0/regexp.simple5',
    '/array.complex/0/regexp.complex0',
    '/array.complex/0/regexp.complex1',
    '/array.complex/0/regexp.complex2',
    '/array.complex/0/regexp.complex3',
    '/array.complex/0/regexp.complex4',
    '/array.complex/0/regexp.complex5',
    '/array.complex/0/regexp.complex6',
    '/array.complex/0/regexp.complex7',
    '/array.complex/0/date.now',
    '/array.complex/0/date.fixed',
    '/array.complex/0/buffer.node',
    '/array.complex/0/buffer.raw',
    '/array.complex/0/buffer.bytes',
    '/array.complex/0/array.simple',
    '/array.complex/0/array.simple/0',
    '/array.complex/0/array.simple/1',
    '/array.complex/0/array.complex',
    '/array.complex/0/array.complex/0',
    '/array.complex/0/array.complex/1',
    '/array.complex/0/set',
    '/array.complex/0/set/null',
    '/array.complex/0/hashmap',
    '/array.complex/0/hashmap/element0',
    '/array.complex/0/hashmap/element1',
    '/array.complex/0/map',
    '/array.complex/0/map/element0',
    '/array.complex/0/map/element1',
    '/array.complex/0/recursion.self',
    '/array.complex/1',
    '/array.complex/1/null',
    '/array.complex/1/undefined',
    '/array.complex/1/boolean.true',
    '/array.complex/1/boolean.false',
    '/array.complex/1/string.defined',
    '/array.complex/1/string.empty',
    '/array.complex/1/number.zero',
    '/array.complex/1/number.small',
    '/array.complex/1/number.big',
    '/array.complex/1/number.infinity.positive',
    '/array.complex/1/number.infinity.negative',
    '/array.complex/1/number.nan',
    '/array.complex/1/number.signed.zero.negative',
    '/array.complex/1/number.signed.zero.positive',
    '/array.complex/1/bigInt.zero',
    '/array.complex/1/bigInt.small',
    '/array.complex/1/bigInt.big',
    '/array.complex/1/regexp.simple1',
    '/array.complex/1/regexp.simple2',
    '/array.complex/1/regexp.simple3',
    '/array.complex/1/regexp.simple4',
    '/array.complex/1/regexp.simple5',
    '/array.complex/1/regexp.complex0',
    '/array.complex/1/regexp.complex1',
    '/array.complex/1/regexp.complex2',
    '/array.complex/1/regexp.complex3',
    '/array.complex/1/regexp.complex4',
    '/array.complex/1/regexp.complex5',
    '/array.complex/1/regexp.complex6',
    '/array.complex/1/regexp.complex7',
    '/array.complex/1/date.now',
    '/array.complex/1/date.fixed',
    '/array.complex/1/buffer.node',
    '/array.complex/1/buffer.raw',
    '/array.complex/1/buffer.bytes',
    '/array.complex/1/array.simple',
    '/array.complex/1/array.simple/0',
    '/array.complex/1/array.simple/1',
    '/array.complex/1/array.complex',
    '/array.complex/1/array.complex/0',
    '/array.complex/1/array.complex/1',
    '/array.complex/1/set',
    '/array.complex/1/set/null',
    '/array.complex/1/hashmap',
    '/array.complex/1/hashmap/element0',
    '/array.complex/1/hashmap/element1',
    '/array.complex/1/map',
    '/array.complex/1/map/element0',
    '/array.complex/1/map/element1',
    '/array.complex/1/recursion.self',
    '/set',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/hashmap',
    '/hashmap/element0',
    '/hashmap/element0/null',
    '/hashmap/element0/undefined',
    '/hashmap/element0/boolean.true',
    '/hashmap/element0/boolean.false',
    '/hashmap/element0/string.defined',
    '/hashmap/element0/string.empty',
    '/hashmap/element0/number.zero',
    '/hashmap/element0/number.small',
    '/hashmap/element0/number.big',
    '/hashmap/element0/number.infinity.positive',
    '/hashmap/element0/number.infinity.negative',
    '/hashmap/element0/number.nan',
    '/hashmap/element0/number.signed.zero.negative',
    '/hashmap/element0/number.signed.zero.positive',
    '/hashmap/element0/bigInt.zero',
    '/hashmap/element0/bigInt.small',
    '/hashmap/element0/bigInt.big',
    '/hashmap/element0/regexp.simple1',
    '/hashmap/element0/regexp.simple2',
    '/hashmap/element0/regexp.simple3',
    '/hashmap/element0/regexp.simple4',
    '/hashmap/element0/regexp.simple5',
    '/hashmap/element0/regexp.complex0',
    '/hashmap/element0/regexp.complex1',
    '/hashmap/element0/regexp.complex2',
    '/hashmap/element0/regexp.complex3',
    '/hashmap/element0/regexp.complex4',
    '/hashmap/element0/regexp.complex5',
    '/hashmap/element0/regexp.complex6',
    '/hashmap/element0/regexp.complex7',
    '/hashmap/element0/date.now',
    '/hashmap/element0/date.fixed',
    '/hashmap/element0/buffer.node',
    '/hashmap/element0/buffer.raw',
    '/hashmap/element0/buffer.bytes',
    '/hashmap/element0/array.simple',
    '/hashmap/element0/array.simple/0',
    '/hashmap/element0/array.simple/1',
    '/hashmap/element0/array.complex',
    '/hashmap/element0/array.complex/0',
    '/hashmap/element0/array.complex/1',
    '/hashmap/element0/set',
    '/hashmap/element0/set/null',
    '/hashmap/element0/hashmap',
    '/hashmap/element0/hashmap/element0',
    '/hashmap/element0/hashmap/element1',
    '/hashmap/element0/map',
    '/hashmap/element0/map/element0',
    '/hashmap/element0/map/element1',
    '/hashmap/element0/recursion.self',
    '/hashmap/element1',
    '/hashmap/element1/null',
    '/hashmap/element1/undefined',
    '/hashmap/element1/boolean.true',
    '/hashmap/element1/boolean.false',
    '/hashmap/element1/string.defined',
    '/hashmap/element1/string.empty',
    '/hashmap/element1/number.zero',
    '/hashmap/element1/number.small',
    '/hashmap/element1/number.big',
    '/hashmap/element1/number.infinity.positive',
    '/hashmap/element1/number.infinity.negative',
    '/hashmap/element1/number.nan',
    '/hashmap/element1/number.signed.zero.negative',
    '/hashmap/element1/number.signed.zero.positive',
    '/hashmap/element1/bigInt.zero',
    '/hashmap/element1/bigInt.small',
    '/hashmap/element1/bigInt.big',
    '/hashmap/element1/regexp.simple1',
    '/hashmap/element1/regexp.simple2',
    '/hashmap/element1/regexp.simple3',
    '/hashmap/element1/regexp.simple4',
    '/hashmap/element1/regexp.simple5',
    '/hashmap/element1/regexp.complex0',
    '/hashmap/element1/regexp.complex1',
    '/hashmap/element1/regexp.complex2',
    '/hashmap/element1/regexp.complex3',
    '/hashmap/element1/regexp.complex4',
    '/hashmap/element1/regexp.complex5',
    '/hashmap/element1/regexp.complex6',
    '/hashmap/element1/regexp.complex7',
    '/hashmap/element1/date.now',
    '/hashmap/element1/date.fixed',
    '/hashmap/element1/buffer.node',
    '/hashmap/element1/buffer.raw',
    '/hashmap/element1/buffer.bytes',
    '/hashmap/element1/array.simple',
    '/hashmap/element1/array.simple/0',
    '/hashmap/element1/array.simple/1',
    '/hashmap/element1/array.complex',
    '/hashmap/element1/array.complex/0',
    '/hashmap/element1/array.complex/1',
    '/hashmap/element1/set',
    '/hashmap/element1/set/null',
    '/hashmap/element1/hashmap',
    '/hashmap/element1/hashmap/element0',
    '/hashmap/element1/hashmap/element1',
    '/hashmap/element1/map',
    '/hashmap/element1/map/element0',
    '/hashmap/element1/map/element1',
    '/hashmap/element1/recursion.self',
    '/map',
    '/map/element0',
    '/map/element0/null',
    '/map/element0/undefined',
    '/map/element0/boolean.true',
    '/map/element0/boolean.false',
    '/map/element0/string.defined',
    '/map/element0/string.empty',
    '/map/element0/number.zero',
    '/map/element0/number.small',
    '/map/element0/number.big',
    '/map/element0/number.infinity.positive',
    '/map/element0/number.infinity.negative',
    '/map/element0/number.nan',
    '/map/element0/number.signed.zero.negative',
    '/map/element0/number.signed.zero.positive',
    '/map/element0/bigInt.zero',
    '/map/element0/bigInt.small',
    '/map/element0/bigInt.big',
    '/map/element0/regexp.simple1',
    '/map/element0/regexp.simple2',
    '/map/element0/regexp.simple3',
    '/map/element0/regexp.simple4',
    '/map/element0/regexp.simple5',
    '/map/element0/regexp.complex0',
    '/map/element0/regexp.complex1',
    '/map/element0/regexp.complex2',
    '/map/element0/regexp.complex3',
    '/map/element0/regexp.complex4',
    '/map/element0/regexp.complex5',
    '/map/element0/regexp.complex6',
    '/map/element0/regexp.complex7',
    '/map/element0/date.now',
    '/map/element0/date.fixed',
    '/map/element0/buffer.node',
    '/map/element0/buffer.raw',
    '/map/element0/buffer.bytes',
    '/map/element0/array.simple',
    '/map/element0/array.simple/0',
    '/map/element0/array.simple/1',
    '/map/element0/array.complex',
    '/map/element0/array.complex/0',
    '/map/element0/array.complex/1',
    '/map/element0/set',
    '/map/element0/set/null',
    '/map/element0/hashmap',
    '/map/element0/hashmap/element0',
    '/map/element0/hashmap/element1',
    '/map/element0/map',
    '/map/element0/map/element0',
    '/map/element0/map/element1',
    '/map/element0/recursion.self',
    '/map/element1',
    '/map/element1/null',
    '/map/element1/undefined',
    '/map/element1/boolean.true',
    '/map/element1/boolean.false',
    '/map/element1/string.defined',
    '/map/element1/string.empty',
    '/map/element1/number.zero',
    '/map/element1/number.small',
    '/map/element1/number.big',
    '/map/element1/number.infinity.positive',
    '/map/element1/number.infinity.negative',
    '/map/element1/number.nan',
    '/map/element1/number.signed.zero.negative',
    '/map/element1/number.signed.zero.positive',
    '/map/element1/bigInt.zero',
    '/map/element1/bigInt.small',
    '/map/element1/bigInt.big',
    '/map/element1/regexp.simple1',
    '/map/element1/regexp.simple2',
    '/map/element1/regexp.simple3',
    '/map/element1/regexp.simple4',
    '/map/element1/regexp.simple5',
    '/map/element1/regexp.complex0',
    '/map/element1/regexp.complex1',
    '/map/element1/regexp.complex2',
    '/map/element1/regexp.complex3',
    '/map/element1/regexp.complex4',
    '/map/element1/regexp.complex5',
    '/map/element1/regexp.complex6',
    '/map/element1/regexp.complex7',
    '/map/element1/date.now',
    '/map/element1/date.fixed',
    '/map/element1/buffer.node',
    '/map/element1/buffer.raw',
    '/map/element1/buffer.bytes',
    '/map/element1/array.simple',
    '/map/element1/array.simple/0',
    '/map/element1/array.simple/1',
    '/map/element1/array.complex',
    '/map/element1/array.complex/0',
    '/map/element1/array.complex/1',
    '/map/element1/set',
    '/map/element1/set/null',
    '/map/element1/hashmap',
    '/map/element1/hashmap/element0',
    '/map/element1/hashmap/element1',
    '/map/element1/map',
    '/map/element1/map/element0',
    '/map/element1/map/element1',
    '/map/element1/recursion.self',
    '/level1',
    '/level1/null',
    '/level1/undefined',
    '/level1/boolean.true',
    '/level1/boolean.false',
    '/level1/string.defined',
    '/level1/string.empty',
    '/level1/number.zero',
    '/level1/number.small',
    '/level1/number.big',
    '/level1/number.infinity.positive',
    '/level1/number.infinity.negative',
    '/level1/number.nan',
    '/level1/number.signed.zero.negative',
    '/level1/number.signed.zero.positive',
    '/level1/bigInt.zero',
    '/level1/bigInt.small',
    '/level1/bigInt.big',
    '/level1/regexp.simple1',
    '/level1/regexp.simple2',
    '/level1/regexp.simple3',
    '/level1/regexp.simple4',
    '/level1/regexp.simple5',
    '/level1/regexp.complex0',
    '/level1/regexp.complex1',
    '/level1/regexp.complex2',
    '/level1/regexp.complex3',
    '/level1/regexp.complex4',
    '/level1/regexp.complex5',
    '/level1/regexp.complex6',
    '/level1/regexp.complex7',
    '/level1/date.now',
    '/level1/date.fixed',
    '/level1/buffer.node',
    '/level1/buffer.raw',
    '/level1/buffer.bytes',
    '/level1/array.simple',
    '/level1/array.simple/0',
    '/level1/array.simple/1',
    '/level1/array.complex',
    '/level1/array.complex/0',
    '/level1/array.complex/1',
    '/level1/set',
    '/level1/set/null',
    '/level1/hashmap',
    '/level1/hashmap/element0',
    '/level1/hashmap/element1',
    '/level1/map',
    '/level1/map/element0',
    '/level1/map/element1',
    '/level1/recursion.self',
    '/level1/recursion.super',
    '/recursion.self'
  ]

  let expDws =
  [
    '/null',
    '/undefined',
    '/boolean.true',
    '/boolean.false',
    '/string.defined',
    '/string.empty',
    '/number.zero',
    '/number.small',
    '/number.big',
    '/number.infinity.positive',
    '/number.infinity.negative',
    '/number.nan',
    '/number.signed.zero.negative',
    '/number.signed.zero.positive',
    '/bigInt.zero',
    '/bigInt.small',
    '/bigInt.big',
    '/regexp.simple1',
    '/regexp.simple2',
    '/regexp.simple3',
    '/regexp.simple4',
    '/regexp.simple5',
    '/regexp.complex0',
    '/regexp.complex1',
    '/regexp.complex2',
    '/regexp.complex3',
    '/regexp.complex4',
    '/regexp.complex5',
    '/regexp.complex6',
    '/regexp.complex7',
    '/date.now',
    '/date.fixed',
    '/buffer.node',
    '/buffer.raw',
    '/buffer.bytes',
    '/array.simple/0',
    '/array.simple/1',
    '/array.simple',
    '/array.complex/0/null',
    '/array.complex/0/undefined',
    '/array.complex/0/boolean.true',
    '/array.complex/0/boolean.false',
    '/array.complex/0/string.defined',
    '/array.complex/0/string.empty',
    '/array.complex/0/number.zero',
    '/array.complex/0/number.small',
    '/array.complex/0/number.big',
    '/array.complex/0/number.infinity.positive',
    '/array.complex/0/number.infinity.negative',
    '/array.complex/0/number.nan',
    '/array.complex/0/number.signed.zero.negative',
    '/array.complex/0/number.signed.zero.positive',
    '/array.complex/0/bigInt.zero',
    '/array.complex/0/bigInt.small',
    '/array.complex/0/bigInt.big',
    '/array.complex/0/regexp.simple1',
    '/array.complex/0/regexp.simple2',
    '/array.complex/0/regexp.simple3',
    '/array.complex/0/regexp.simple4',
    '/array.complex/0/regexp.simple5',
    '/array.complex/0/regexp.complex0',
    '/array.complex/0/regexp.complex1',
    '/array.complex/0/regexp.complex2',
    '/array.complex/0/regexp.complex3',
    '/array.complex/0/regexp.complex4',
    '/array.complex/0/regexp.complex5',
    '/array.complex/0/regexp.complex6',
    '/array.complex/0/regexp.complex7',
    '/array.complex/0/date.now',
    '/array.complex/0/date.fixed',
    '/array.complex/0/buffer.node',
    '/array.complex/0/buffer.raw',
    '/array.complex/0/buffer.bytes',
    '/array.complex/0/array.simple/0',
    '/array.complex/0/array.simple/1',
    '/array.complex/0/array.simple',
    '/array.complex/0/array.complex/0',
    '/array.complex/0/array.complex/1',
    '/array.complex/0/array.complex',
    '/array.complex/0/set/null',
    '/array.complex/0/set',
    '/array.complex/0/hashmap/element0',
    '/array.complex/0/hashmap/element1',
    '/array.complex/0/hashmap',
    '/array.complex/0/map/element0',
    '/array.complex/0/map/element1',
    '/array.complex/0/map',
    '/array.complex/0/recursion.self',
    '/array.complex/0',
    '/array.complex/1/null',
    '/array.complex/1/undefined',
    '/array.complex/1/boolean.true',
    '/array.complex/1/boolean.false',
    '/array.complex/1/string.defined',
    '/array.complex/1/string.empty',
    '/array.complex/1/number.zero',
    '/array.complex/1/number.small',
    '/array.complex/1/number.big',
    '/array.complex/1/number.infinity.positive',
    '/array.complex/1/number.infinity.negative',
    '/array.complex/1/number.nan',
    '/array.complex/1/number.signed.zero.negative',
    '/array.complex/1/number.signed.zero.positive',
    '/array.complex/1/bigInt.zero',
    '/array.complex/1/bigInt.small',
    '/array.complex/1/bigInt.big',
    '/array.complex/1/regexp.simple1',
    '/array.complex/1/regexp.simple2',
    '/array.complex/1/regexp.simple3',
    '/array.complex/1/regexp.simple4',
    '/array.complex/1/regexp.simple5',
    '/array.complex/1/regexp.complex0',
    '/array.complex/1/regexp.complex1',
    '/array.complex/1/regexp.complex2',
    '/array.complex/1/regexp.complex3',
    '/array.complex/1/regexp.complex4',
    '/array.complex/1/regexp.complex5',
    '/array.complex/1/regexp.complex6',
    '/array.complex/1/regexp.complex7',
    '/array.complex/1/date.now',
    '/array.complex/1/date.fixed',
    '/array.complex/1/buffer.node',
    '/array.complex/1/buffer.raw',
    '/array.complex/1/buffer.bytes',
    '/array.complex/1/array.simple/0',
    '/array.complex/1/array.simple/1',
    '/array.complex/1/array.simple',
    '/array.complex/1/array.complex/0',
    '/array.complex/1/array.complex/1',
    '/array.complex/1/array.complex',
    '/array.complex/1/set/null',
    '/array.complex/1/set',
    '/array.complex/1/hashmap/element0',
    '/array.complex/1/hashmap/element1',
    '/array.complex/1/hashmap',
    '/array.complex/1/map/element0',
    '/array.complex/1/map/element1',
    '/array.complex/1/map',
    '/array.complex/1/recursion.self',
    '/array.complex/1',
    '/array.complex',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set/{- Map with 41 elements -}/null',
    '/set/{- Map with 41 elements -}/undefined',
    '/set/{- Map with 41 elements -}/boolean.true',
    '/set/{- Map with 41 elements -}/boolean.false',
    '/set/{- Map with 41 elements -}/string.defined',
    '/set/{- Map with 41 elements -}/string.empty',
    '/set/{- Map with 41 elements -}/number.zero',
    '/set/{- Map with 41 elements -}/number.small',
    '/set/{- Map with 41 elements -}/number.big',
    '/set/{- Map with 41 elements -}/number.infinity.positive',
    '/set/{- Map with 41 elements -}/number.infinity.negative',
    '/set/{- Map with 41 elements -}/number.nan',
    '/set/{- Map with 41 elements -}/number.signed.zero.negative',
    '/set/{- Map with 41 elements -}/number.signed.zero.positive',
    '/set/{- Map with 41 elements -}/bigInt.zero',
    '/set/{- Map with 41 elements -}/bigInt.small',
    '/set/{- Map with 41 elements -}/bigInt.big',
    '/set/{- Map with 41 elements -}/regexp.simple1',
    '/set/{- Map with 41 elements -}/regexp.simple2',
    '/set/{- Map with 41 elements -}/regexp.simple3',
    '/set/{- Map with 41 elements -}/regexp.simple4',
    '/set/{- Map with 41 elements -}/regexp.simple5',
    '/set/{- Map with 41 elements -}/regexp.complex0',
    '/set/{- Map with 41 elements -}/regexp.complex1',
    '/set/{- Map with 41 elements -}/regexp.complex2',
    '/set/{- Map with 41 elements -}/regexp.complex3',
    '/set/{- Map with 41 elements -}/regexp.complex4',
    '/set/{- Map with 41 elements -}/regexp.complex5',
    '/set/{- Map with 41 elements -}/regexp.complex6',
    '/set/{- Map with 41 elements -}/regexp.complex7',
    '/set/{- Map with 41 elements -}/date.now',
    '/set/{- Map with 41 elements -}/date.fixed',
    '/set/{- Map with 41 elements -}/buffer.node',
    '/set/{- Map with 41 elements -}/buffer.raw',
    '/set/{- Map with 41 elements -}/buffer.bytes',
    '/set/{- Map with 41 elements -}/array.simple/0',
    '/set/{- Map with 41 elements -}/array.simple/1',
    '/set/{- Map with 41 elements -}/array.simple',
    '/set/{- Map with 41 elements -}/array.complex/0',
    '/set/{- Map with 41 elements -}/array.complex/1',
    '/set/{- Map with 41 elements -}/array.complex',
    '/set/{- Map with 41 elements -}/set/null',
    '/set/{- Map with 41 elements -}/set',
    '/set/{- Map with 41 elements -}/hashmap/element0',
    '/set/{- Map with 41 elements -}/hashmap/element1',
    '/set/{- Map with 41 elements -}/hashmap',
    '/set/{- Map with 41 elements -}/map/element0',
    '/set/{- Map with 41 elements -}/map/element1',
    '/set/{- Map with 41 elements -}/map',
    '/set/{- Map with 41 elements -}/recursion.self',
    '/set/{- Map with 41 elements -}',
    '/set',
    '/hashmap/element0/null',
    '/hashmap/element0/undefined',
    '/hashmap/element0/boolean.true',
    '/hashmap/element0/boolean.false',
    '/hashmap/element0/string.defined',
    '/hashmap/element0/string.empty',
    '/hashmap/element0/number.zero',
    '/hashmap/element0/number.small',
    '/hashmap/element0/number.big',
    '/hashmap/element0/number.infinity.positive',
    '/hashmap/element0/number.infinity.negative',
    '/hashmap/element0/number.nan',
    '/hashmap/element0/number.signed.zero.negative',
    '/hashmap/element0/number.signed.zero.positive',
    '/hashmap/element0/bigInt.zero',
    '/hashmap/element0/bigInt.small',
    '/hashmap/element0/bigInt.big',
    '/hashmap/element0/regexp.simple1',
    '/hashmap/element0/regexp.simple2',
    '/hashmap/element0/regexp.simple3',
    '/hashmap/element0/regexp.simple4',
    '/hashmap/element0/regexp.simple5',
    '/hashmap/element0/regexp.complex0',
    '/hashmap/element0/regexp.complex1',
    '/hashmap/element0/regexp.complex2',
    '/hashmap/element0/regexp.complex3',
    '/hashmap/element0/regexp.complex4',
    '/hashmap/element0/regexp.complex5',
    '/hashmap/element0/regexp.complex6',
    '/hashmap/element0/regexp.complex7',
    '/hashmap/element0/date.now',
    '/hashmap/element0/date.fixed',
    '/hashmap/element0/buffer.node',
    '/hashmap/element0/buffer.raw',
    '/hashmap/element0/buffer.bytes',
    '/hashmap/element0/array.simple/0',
    '/hashmap/element0/array.simple/1',
    '/hashmap/element0/array.simple',
    '/hashmap/element0/array.complex/0',
    '/hashmap/element0/array.complex/1',
    '/hashmap/element0/array.complex',
    '/hashmap/element0/set/null',
    '/hashmap/element0/set',
    '/hashmap/element0/hashmap/element0',
    '/hashmap/element0/hashmap/element1',
    '/hashmap/element0/hashmap',
    '/hashmap/element0/map/element0',
    '/hashmap/element0/map/element1',
    '/hashmap/element0/map',
    '/hashmap/element0/recursion.self',
    '/hashmap/element0',
    '/hashmap/element1/null',
    '/hashmap/element1/undefined',
    '/hashmap/element1/boolean.true',
    '/hashmap/element1/boolean.false',
    '/hashmap/element1/string.defined',
    '/hashmap/element1/string.empty',
    '/hashmap/element1/number.zero',
    '/hashmap/element1/number.small',
    '/hashmap/element1/number.big',
    '/hashmap/element1/number.infinity.positive',
    '/hashmap/element1/number.infinity.negative',
    '/hashmap/element1/number.nan',
    '/hashmap/element1/number.signed.zero.negative',
    '/hashmap/element1/number.signed.zero.positive',
    '/hashmap/element1/bigInt.zero',
    '/hashmap/element1/bigInt.small',
    '/hashmap/element1/bigInt.big',
    '/hashmap/element1/regexp.simple1',
    '/hashmap/element1/regexp.simple2',
    '/hashmap/element1/regexp.simple3',
    '/hashmap/element1/regexp.simple4',
    '/hashmap/element1/regexp.simple5',
    '/hashmap/element1/regexp.complex0',
    '/hashmap/element1/regexp.complex1',
    '/hashmap/element1/regexp.complex2',
    '/hashmap/element1/regexp.complex3',
    '/hashmap/element1/regexp.complex4',
    '/hashmap/element1/regexp.complex5',
    '/hashmap/element1/regexp.complex6',
    '/hashmap/element1/regexp.complex7',
    '/hashmap/element1/date.now',
    '/hashmap/element1/date.fixed',
    '/hashmap/element1/buffer.node',
    '/hashmap/element1/buffer.raw',
    '/hashmap/element1/buffer.bytes',
    '/hashmap/element1/array.simple/0',
    '/hashmap/element1/array.simple/1',
    '/hashmap/element1/array.simple',
    '/hashmap/element1/array.complex/0',
    '/hashmap/element1/array.complex/1',
    '/hashmap/element1/array.complex',
    '/hashmap/element1/set/null',
    '/hashmap/element1/set',
    '/hashmap/element1/hashmap/element0',
    '/hashmap/element1/hashmap/element1',
    '/hashmap/element1/hashmap',
    '/hashmap/element1/map/element0',
    '/hashmap/element1/map/element1',
    '/hashmap/element1/map',
    '/hashmap/element1/recursion.self',
    '/hashmap/element1',
    '/hashmap',
    '/map/element0/null',
    '/map/element0/undefined',
    '/map/element0/boolean.true',
    '/map/element0/boolean.false',
    '/map/element0/string.defined',
    '/map/element0/string.empty',
    '/map/element0/number.zero',
    '/map/element0/number.small',
    '/map/element0/number.big',
    '/map/element0/number.infinity.positive',
    '/map/element0/number.infinity.negative',
    '/map/element0/number.nan',
    '/map/element0/number.signed.zero.negative',
    '/map/element0/number.signed.zero.positive',
    '/map/element0/bigInt.zero',
    '/map/element0/bigInt.small',
    '/map/element0/bigInt.big',
    '/map/element0/regexp.simple1',
    '/map/element0/regexp.simple2',
    '/map/element0/regexp.simple3',
    '/map/element0/regexp.simple4',
    '/map/element0/regexp.simple5',
    '/map/element0/regexp.complex0',
    '/map/element0/regexp.complex1',
    '/map/element0/regexp.complex2',
    '/map/element0/regexp.complex3',
    '/map/element0/regexp.complex4',
    '/map/element0/regexp.complex5',
    '/map/element0/regexp.complex6',
    '/map/element0/regexp.complex7',
    '/map/element0/date.now',
    '/map/element0/date.fixed',
    '/map/element0/buffer.node',
    '/map/element0/buffer.raw',
    '/map/element0/buffer.bytes',
    '/map/element0/array.simple/0',
    '/map/element0/array.simple/1',
    '/map/element0/array.simple',
    '/map/element0/array.complex/0',
    '/map/element0/array.complex/1',
    '/map/element0/array.complex',
    '/map/element0/set/null',
    '/map/element0/set',
    '/map/element0/hashmap/element0',
    '/map/element0/hashmap/element1',
    '/map/element0/hashmap',
    '/map/element0/map/element0',
    '/map/element0/map/element1',
    '/map/element0/map',
    '/map/element0/recursion.self',
    '/map/element0',
    '/map/element1/null',
    '/map/element1/undefined',
    '/map/element1/boolean.true',
    '/map/element1/boolean.false',
    '/map/element1/string.defined',
    '/map/element1/string.empty',
    '/map/element1/number.zero',
    '/map/element1/number.small',
    '/map/element1/number.big',
    '/map/element1/number.infinity.positive',
    '/map/element1/number.infinity.negative',
    '/map/element1/number.nan',
    '/map/element1/number.signed.zero.negative',
    '/map/element1/number.signed.zero.positive',
    '/map/element1/bigInt.zero',
    '/map/element1/bigInt.small',
    '/map/element1/bigInt.big',
    '/map/element1/regexp.simple1',
    '/map/element1/regexp.simple2',
    '/map/element1/regexp.simple3',
    '/map/element1/regexp.simple4',
    '/map/element1/regexp.simple5',
    '/map/element1/regexp.complex0',
    '/map/element1/regexp.complex1',
    '/map/element1/regexp.complex2',
    '/map/element1/regexp.complex3',
    '/map/element1/regexp.complex4',
    '/map/element1/regexp.complex5',
    '/map/element1/regexp.complex6',
    '/map/element1/regexp.complex7',
    '/map/element1/date.now',
    '/map/element1/date.fixed',
    '/map/element1/buffer.node',
    '/map/element1/buffer.raw',
    '/map/element1/buffer.bytes',
    '/map/element1/array.simple/0',
    '/map/element1/array.simple/1',
    '/map/element1/array.simple',
    '/map/element1/array.complex/0',
    '/map/element1/array.complex/1',
    '/map/element1/array.complex',
    '/map/element1/set/null',
    '/map/element1/set',
    '/map/element1/hashmap/element0',
    '/map/element1/hashmap/element1',
    '/map/element1/hashmap',
    '/map/element1/map/element0',
    '/map/element1/map/element1',
    '/map/element1/map',
    '/map/element1/recursion.self',
    '/map/element1',
    '/map',
    '/level1/null',
    '/level1/undefined',
    '/level1/boolean.true',
    '/level1/boolean.false',
    '/level1/string.defined',
    '/level1/string.empty',
    '/level1/number.zero',
    '/level1/number.small',
    '/level1/number.big',
    '/level1/number.infinity.positive',
    '/level1/number.infinity.negative',
    '/level1/number.nan',
    '/level1/number.signed.zero.negative',
    '/level1/number.signed.zero.positive',
    '/level1/bigInt.zero',
    '/level1/bigInt.small',
    '/level1/bigInt.big',
    '/level1/regexp.simple1',
    '/level1/regexp.simple2',
    '/level1/regexp.simple3',
    '/level1/regexp.simple4',
    '/level1/regexp.simple5',
    '/level1/regexp.complex0',
    '/level1/regexp.complex1',
    '/level1/regexp.complex2',
    '/level1/regexp.complex3',
    '/level1/regexp.complex4',
    '/level1/regexp.complex5',
    '/level1/regexp.complex6',
    '/level1/regexp.complex7',
    '/level1/date.now',
    '/level1/date.fixed',
    '/level1/buffer.node',
    '/level1/buffer.raw',
    '/level1/buffer.bytes',
    '/level1/array.simple/0',
    '/level1/array.simple/1',
    '/level1/array.simple',
    '/level1/array.complex/0',
    '/level1/array.complex/1',
    '/level1/array.complex',
    '/level1/set/null',
    '/level1/set',
    '/level1/hashmap/element0',
    '/level1/hashmap/element1',
    '/level1/hashmap',
    '/level1/map/element0',
    '/level1/map/element1',
    '/level1/map',
    '/level1/recursion.self',
    '/level1/recursion.super',
    '/level1',
    '/recursion.self',
    '/'
  ]

  var generated = _.diagnosticStructureGenerate({ depth : 1, defaultComplexity : 5, defaultLength : 2 });

  clean();
  _.look({ src : generated.structure, onUp, onDown });
  test.identical( ups, expUps );
  test.identical( dws, expDws );

  /* - */

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
  }

} /* end of function callbacksComplex */

//

function relook( test )
{
  let upsLevel = [];
  let upsLogicalLevel = [];
  let upsSelector = [];
  let upsPath = [];
  let dwsLevel = [];
  let dwsLogicalLevel = [];
  let dwsSelector = [];
  let dwsPath = [];

  /* */

  test.case = 'onUp';

  clean();

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.look
  ({
    src : src,
    onUp : onUp,
    onDown : onDown,
  });

  var exp = [ 0, 1, 2, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ]
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/value',
    '/b',
    '/b/name',
    '/b/value',
    '/c',
    '/c/value',
    '/c/date'
  ]
  test.identical( upsPath, exp );

  var exp = [ 2, 3, 3, 3, 2, 2, 1, 2, 2, 1, 2, 2, 1, 0 ];
  test.identical( dwsLevel, exp );
  var exp =
  [
    '/a/name',
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/name',
    '/a/value',
    '/a',
    '/b/name',
    '/b/value',
    '/b',
    '/c/value',
    '/c/date',
    '/c',
    '/'
  ]
  test.identical( dwsPath, exp );

  /* */

  test.case = 'onTerminal';

  clean();

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  var it = _.look
  ({
    src : src,
    onUp : onUp,
    onDown : onDown,
    onTerminal : onTerminal,
  });

  var exp = [ 0, 1, 2, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ]
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/value',
    '/b',
    '/b/name',
    '/b/value',
    '/c',
    '/c/value',
    '/c/date'
  ]
  test.identical( upsPath, exp );

  var exp = [ 3, 3, 3, 2, 2, 2, 1, 2, 2, 1, 2, 2, 1, 0 ];
  test.identical( dwsLevel, exp );
  var exp =
  [
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/name',
    '/a/name',
    '/a/value',
    '/a',
    '/b/name',
    '/b/value',
    '/b',
    '/c/value',
    '/c/date',
    '/c',
    '/'
  ]
  test.identical( dwsPath, exp );

  /* */

  function onUp( e, k, it )
  {

    upsLevel.push( it.level );
    upsLogicalLevel.push( it.logicalLevel );
    upsSelector.push( it.selector );
    upsPath.push( it.path );

    test.identical( arguments.length, 3 );

  }

  function onDown0( e, k, it )
  {

    dwsLevel.push( it.level );
    dwsLogicalLevel.push( it.logicalLevel );
    dwsSelector.push( it.selector );
    dwsPath.push( it.path );

    test.identical( arguments.length, 3 );

  }

  function onDown( e, k, it )
  {

    onDown0.apply( this, arguments );

    if( it.path === '/a/name' )
    if( !_.arrayIs( it.src ) )
    {
      it.relook( [ 'r1', 'r2', 'r3' ] );
    }

  }

  function onTerminal( e )
  {
    let it = this;
    debugger;

    test.identical( arguments.length, 1 );

    if( it.path === '/a/name' )
    if( !_.arrayIs( it.src ) )
    {
      debugger;
      it.relook( [ 'r1', 'r2', 'r3' ] );
    }

  }

  function clean()
  {
    upsLevel.splice( 0 );
    upsLogicalLevel.splice( 0 );
    upsSelector.splice( 0 );
    upsPath.splice( 0 );
    dwsLevel.splice( 0 );
    dwsLogicalLevel.splice( 0 );
    dwsSelector.splice( 0 );
    dwsPath.splice( 0 );
  }

  /* */

}

//

function optionRevisiting( test )
{
  let ups = [];
  let dws = [];

  let structure =
  {
    arr : [ 0, { a : 1, b : null, c : 3 }, 4 ],
  }
  structure.arr[ 1 ].b = structure.arr;
  structure.arr2 = structure.arr;

  /* - */

  test.case = 'revisiting : 0';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2'
  ]
  var got = _.look({ src : structure, revisiting : 0, onUp, onDown });

  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  test.case = 'revisiting : 1';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var got = _.look({ src : structure, revisiting : 1, onUp, onDown });

  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  test.case = 'revisiting : 2';
  clean();
  var expUps =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/0',
    '/arr/1',
    '/arr/1/a',
    '/arr/1/b',
    '/arr/1/c',
    '/arr/2',
    '/arr2',
    '/arr2/0',
    '/arr2/1',
    '/arr2/1/a',
    '/arr2/1/b',
    '/arr2/1/c',
    '/arr2/2'
  ]
  var got = _.look({ src : structure, revisiting : 2, onUp : onUp2, onDown });
  test.identical( ups, expUps );
  test.identical( ups, expDws );

  /* - */

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
    logger.log( 'up', it.level, it.path );
  }

  function onUp2( e, k, it )
  {
    ups.push( it.path );
    logger.log( 'up', it.level, it.path );
    if( it.level >= 3 )
    it.continue = false;
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    logger.log( 'down', it.level, it.path );
  }

}

//

function optionOnSrcChanged( test )
{
  let ups = [];
  let dws = [];
  let upNames = [];
  let dwNames = [];

  var a1 = new Obj({ name : 'a1' });
  var a2 = new Obj({ name : 'a2' });
  var b = new Obj({ name : 'b', elements : [ a1, a2 ] });
  var c = new Obj({ name : 'c', elements : [ b ] });

  var expUps = [ '/', '/0', '/0/0', '/0/1' ];
  var expDws = [ '/', '/0', '/0/0', '/0/1' ];
  var expUpNames = [ 'c', 'b', 'a1', 'a2' ];
  var expDwNames = [ 'a1', 'a2', 'b', 'c' ];

  var got = _.look({ src : c, onUp, onDown, onSrcChanged });
  test.identical( ups, expUps );
  test.identical( ups, expDws );
  test.identical( upNames, expUpNames );
  test.identical( dwNames, expDwNames );

  /* - */

  function Obj( o )
  {
    this.str = 'str';
    this.num = 13;
    Object.assign( this, o );
  }

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
    upNames.push( it.src.name );
    logger.log( 'up', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    dwNames.push( it.src.name );
    logger.log( 'down', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onSrcChanged()
  {
    let it = this;
    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = 'Obj';
        it.ascendAct = function objAscend( src )
        {
          return this._longAscend( src.elements );
        }
        // it.ascendAct = function objAscend( onIteration, src )
        // {
        //   return this._longAscend( onIteration, src.elements );
        // }
      }
    }
  }

}

//

function optionOnUpNonContainer( test )
{
  let ups = [];
  let dws = [];
  let upNames = [];
  let dwNames = [];

  var a1 = new Obj({ name : 'a1' });
  var a2 = new Obj({ name : 'a2' });
  var b = new Obj({ name : 'b', elements : [ a1, a2 ] });
  var c = new Obj({ name : 'c', elements : [ b ] });

  var expUps = [ '/', '/0', '/0/0', '/0/1' ];
  var expDws = [ '/', '/0', '/0/0', '/0/1' ];
  var expUpNames = [ 'c', 'b', 'a1', 'a2' ];
  var expDwNames = [ 'a1', 'a2', 'b', 'c' ];

  var got = _.look({ src : c, onUp, onDown });
  test.identical( ups, expUps );
  test.identical( ups, expDws );
  test.identical( upNames, expUpNames );
  test.identical( dwNames, expDwNames );

  /* - */

  function Obj( o )
  {
    this.str = 'str';
    this.num = 13;
    Object.assign( this, o );
  }

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = 'Obj';
        it.ascendAct = function objAscend( src )
        {
          return this._longAscend( src.elements );
        }
        // it.ascendAct = function objAscend( onIteration, src )
        // {
        //   return this._longAscend( onIteration, src.elements );
        // }
      }
    }

    ups.push( it.path );
    upNames.push( it.src.name );
    logger.log( 'up', it.level, it.path, it.src ? it.src.name : '' );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
    dwNames.push( it.src.name );
    logger.log( 'down', it.level, it.path, it.src ? it.src.name : '' );
  }

}

//

function optionOnPathJoin( test )
{
  let ups = [];
  let dws = [];
  let structure =
  {
    int : 0,
    str : 'str',
    arr : [ 1, 3 ],
    map : { m1 : new Date( Date.UTC( 1990, 0, 0 ) ), m3 : 'str' },
    set : new Set([ 1, 3 ]),
    hash : new HashMap([ [ new Date( Date.UTC( 1990, 0, 0 ) ), function(){} ], [ 'm3', 'str' ] ]),
  }

  /* - */

  test.case = 'basic';
  clean();
  var it = _.look
  ({
    src : structure,
    onUp : onUp,
    onDown : onDown,
    onPathJoin : onPathJoin,
  });
  var exp =
  [
    '/',
    '/Number::int',
    '/String::str',
    '/Array::arr',
    '/Array::arr/Number::0',
    '/Array::arr/Number::1',
    '/Object::map',
    '/Object::map/Date::m1',
    '/Object::map/String::m3',
    '/Set::set',
    '/Set::set/Number::1',
    '/Set::set/Number::3',
    '/Map::hash',
    '/Map::hash/Function::1989-12-31T00:00:00.000Z',
    '/Map::hash/String::m3'
  ]
  test.identical( ups, exp );
  var exp =
  [
    '/Number::int',
    '/String::str',
    '/Array::arr/Number::0',
    '/Array::arr/Number::1',
    '/Array::arr',
    '/Object::map/Date::m1',
    '/Object::map/String::m3',
    '/Object::map',
    '/Set::set/Number::1',
    '/Set::set/Number::3',
    '/Set::set',
    '/Map::hash/Function::1989-12-31T00:00:00.000Z',
    '/Map::hash/String::m3',
    '/Map::hash',
    '/'
  ]
  test.identical( dws, exp );

  /* - */

  function clean()
  {
    ups.splice( 0, ups.length );
    dws.splice( 0, dws.length );
  }

  function onUp( e, k, it )
  {
    ups.push( it.path );
  }

  function onDown( e, k, it )
  {
    dws.push( it.path );
  }

  function onPathJoin( selectorPath, upToken, defaultUpToken, selectorName )
  {
    let it = this;
    let result;

    _.assert( arguments.length === 4 );

    if( _.strEnds( selectorPath, upToken ) )
    {
      result = selectorPath + _.strType( it.src ) + '::' + selectorName;
    }
    else
    {
      result = selectorPath + defaultUpToken + _.strType( it.src ) + '::' + selectorName;
    }

    debugger;
    return result;
  }

}

//

function optionAscend( test )
{
  let upsLevel = [];
  let upsLogicalLevel = [];
  let upsSelector = [];
  let upsPath = [];
  let dwsLevel = [];
  let dwsLogicalLevel = [];
  let dwsSelector = [];
  let dwsPath = [];

  /* */

  test.case = 'basic';

  clean();

  var src =
  {
    a : { name : 'name1', value : 13 },
    b : { name : 'name2', value : 77 },
    c : { value : 25, date : new Date( Date.UTC( 1990, 0, 0 ) ) },
  }

  debugger;
  var it = _.look
  ({
    src : src,
    onDown : onDown,
    onUp : onUp,
    onAscend : onAscend,
  });
  debugger;

  var exp = [ 0, 1, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ];
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/value',
    '/b',
    '/b/name',
    '/b/value',
    '/c',
    '/c/value',
    '/c/date'
  ]
  test.identical( upsPath, exp );

  var exp = [ 3, 3, 3, 2, 2, 1, 2, 2, 1, 2, 2, 1, 0 ];
  test.identical( dwsLevel, exp );
  var exp =
  [
    '/a/name/0',
    '/a/name/1',
    '/a/name/2',
    '/a/name',
    '/a/value',
    '/a',
    '/b/name',
    '/b/value',
    '/b',
    '/c/value',
    '/c/date',
    '/c',
    '/'
  ]
  test.identical( dwsPath, exp );

  /* */

  function onUp( e, k, it )
  {
    upsLevel.push( it.level );
    upsLogicalLevel.push( it.logicalLevel );
    upsSelector.push( it.selector );
    upsPath.push( it.path );
  }

  function onDown( e, k, it )
  {

    dwsLevel.push( it.level );
    dwsLogicalLevel.push( it.logicalLevel );
    dwsSelector.push( it.selector );
    dwsPath.push( it.path );

  }

  function onAscend()
  {
    let it = this;
    test.is( arguments.length === 0 );
    if( it.src === 'name1' )
    debugger;
    if( it.src === 'name1' )
    it._longAscend( [ 'r1', 'r2', 'r3' ] );
    else
    it.ascendAct( it.src );
  }

  function clean()
  {
    upsLevel.splice( 0 );
    upsLogicalLevel.splice( 0 );
    upsSelector.splice( 0 );
    upsPath.splice( 0 );
    dwsLevel.splice( 0 );
    dwsLogicalLevel.splice( 0 );
    dwsSelector.splice( 0 );
    dwsPath.splice( 0 );
  }

  /* */

}

//

function optionRoot( test )
{

  var structure1 =
  {
    a : 1,
    b : 's',
    c : [ 1,3 ],
    d : [ 1, { date : new Date( Date.UTC( 1990, 0, 0 ) ) } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1,2,3 ]),
  }
  var gotUpRoots = [];
  var gotDownRoots = [];

  test.case = 'explicit';
  clean();
  var it = _.look({ src : structure1, onUp : handleUp1, onDown: handleDown1, root : structure1 });
  var expectedRoots = [ structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1 ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, structure1 );

  test.case = 'implicit';
  clean();
  var it = _.look({ src : structure1, onUp : handleUp1, onDown: handleDown1 });
  var expectedRoots = [ structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1, structure1 ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, structure1 );

  test.case = 'node as root';
  clean();
  var it = _.look({ src : structure1, onUp : handleUp1, onDown: handleDown1, root : structure1.c });
  var expectedRoots = [ structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c, structure1.c ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, structure1.c );

  test.case = 'another structure as root';
  clean();
  var structure2 =
  {
    a : 's',
    b : 1,
    c : { d : [ 2 ] }
  };
  var it = _.look({ src : structure1, onUp : handleUp1, onDown: handleDown1, root : structure2 });
  var expectedRoots = [ structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2, structure2 ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, structure2 );

  function clean()
  {
    gotUpRoots.splice( 0, gotUpRoots.length );
    gotDownRoots.splice( 0, gotDownRoots.length );
  }

  function handleUp1( e, k, it )
  {
    gotUpRoots.push( it.root );
  }

  function handleDown1( e, k, it )
  {
    gotDownRoots.push( it.root );
  }

}

//

/*
  Total time, running 10 times.

  | Interpreter  | Current | Fewer fields |  Fast  |
  |   v13.3.0    | 20.084s |   19.099s    | 4.588s |
  |   v12.7.0    | 19.985s |   19.597s    | 4.556s |
  |   v11.3.0    | 49.195s |   26.296s    | 8.814s |
  |   v10.16.0   | 51.266s |   26.610s    | 9.048s |

  Fast has less fields.
  Fast isn't making map copies.

*/

function optionFastPerformance( test )
{
  var structure = _.diagnosticStructureGenerate({ depth : 5, mapComplexity : 3, mapLength : 5 });
  structure = structure.structure;
  var times = 10;

  var time = _.time.now();
  for( let i = times ; i > 0 ; i-- )
  var it1 = _.look({ src : structure });
  console.log( `The current implementation of _.look took ${_.time.spent( time )} on Njs ${process.version}`  );

  var time = _.time.now();
  for( let i = times ; i > 0 ; i-- )
  var it2 = _.look({ src : structure, fast : 1 });
  console.log( `_.look with the fast option took ${_.time.spent( time )} on Njs ${process.version}`  );

  // Being green :)
  test.identical( it1.src, it2.src );
}

optionFastPerformance.experimental = true;
optionFastPerformance.timeOut = 1e6;

//

function optionFast( test )
{

  let structure =
  {
    a : 1,
    b : 's',
    c : [ 1, 3 ],
    /* qqq : comment out lines above and uncomment lines below */
    // int : 0,
    // str : 'str',
    // arr : [ 1, 3 ],
    // map : { m1 : new Date( Date.UTC( 1990, 0, 0 ) ), m3 : 'str' },
    // set : new Set([ 1, 3 ]),
    // hash : new HashMap([ [ new Date( Date.UTC( 1990, 0, 0 ) ), function(){} ], [ 'm3', 'str' ] ]),
  }

  let gotUpKeys = [];
  let gotDownKeys = [];
  let gotUpValues = [];
  let gotDownValues = [];
  let gotUpRoots = [];
  let gotDownRoots = [];
  let gotUpRecursive = [];
  let gotDownRecursive = [];
  let gotUpRevisited = [];
  let gotDownRevisited = [];
  let gotUpVisitingCounting = [];
  let gotDownVisitingCounting = [];
  let gotUpVisiting = [];
  let gotDownVisiting = [];
  let gotUpAscending = [];
  let gotDownAscending = [];
  let gotUpContinue = [];
  let gotDownContinue = [];
  let gotUpIterable = [];
  let gotDownIterable = [];
  let wasIt = undefined;

  run({ fast : 0 });
  run({ fast : 1 });

  function run( o )
  {

    test.case = 'fast ' + o.fast;
    clean();

    var it = _.look
    ({
      src : structure,
      onUp : function() { return handleUp( o, ... arguments ) },
      onDown : function() { return handleDown( o, ... arguments ) },
      fast : o.fast,
    });

    test.description = 'keys on up';
    var expectedUpKeys = [ null, 'a', 'b', 'c', 0, 1 ];
    test.identical( gotUpKeys, expectedUpKeys );
    test.description = 'keys on down';
    var expectedDownKeys = [ 'a', 'b', 0, 1, 'c', null ];
    test.identical( gotDownKeys, expectedDownKeys );
    test.description = 'values on up';
    var expectedUpValues = [ structure, structure.a, structure.b, structure.c, structure.c[0], structure.c[1] ];
    test.identical( gotUpValues, expectedUpValues );
    test.description = 'values on down';
    var expectedDownValues = [ structure.a, structure.b, structure.c[0], structure.c[1], structure.c, structure ];
    test.identical( gotDownValues, expectedDownValues );
    test.description = 'roots on up';
    var expectedRoots = [ structure, structure, structure, structure, structure, structure ];
    test.identical( gotUpRoots, expectedRoots );
    test.description = 'roots on down';
    var expectedRoots = [ structure, structure, structure, structure, structure, structure ];
    test.identical( gotDownRoots, expectedRoots );
    test.description = 'recursive on up';
    var expectedRecursive = [ Infinity, Infinity, Infinity, Infinity, Infinity, Infinity ];
    test.identical( gotUpRecursive, expectedRecursive );
    test.description = 'recursive on down';
    var expectedRecursive = [ Infinity, Infinity, Infinity, Infinity, Infinity, Infinity ];
    test.identical( gotDownRecursive, expectedRecursive );
    test.description = 'revisited on up';
    var expectedRevisited = [ false, false, false, false, false, false ];
    test.identical( gotUpRevisited, expectedRevisited );
    test.description = 'revisited on down';
    var expectedRevisited = [ false, false, false, false, false, false ];
    test.identical( gotDownRevisited, expectedRevisited );
    test.description = 'visitCounting on up';
    var expectedVisitingCounting = [ true, true, true, true, true, true ];
    test.identical( gotUpVisitingCounting, expectedVisitingCounting );
    test.description = 'visitCounting on down';
    var expectedVisitingCounting = [ true, true, true, true, true, true ];
    test.identical( gotDownVisitingCounting, expectedVisitingCounting );
    test.description = 'visiting on up';
    var expectedVisiting = [ true, true, true, true, true, true ];
    test.identical( gotUpVisiting, expectedVisiting );
    test.description = 'visiting on down';
    var expectedVisiting = [ true, true, true, true, true, true ];
    test.identical( gotDownVisiting, expectedVisiting );
    test.description = 'ascending on up';
    var expectedUpAscending = [ true, true, true, true, true, true ];
    test.identical( gotUpAscending, expectedUpAscending );
    test.description = 'ascending on down';
    var expectedDownAscending = [ false, false, false, false, false, false ];
    test.identical( gotDownAscending, expectedDownAscending );
    test.description = 'continue on up';
    var expectedContinue = [ true, true, true, true, true, true ];
    test.identical( gotUpContinue, expectedContinue );
    test.description = 'continue on down';
    var expectedContinue = [ true, true, true, true, true, true ];
    test.identical( gotDownContinue, expectedContinue );
    test.description = 'iterable on up';
    var expectedUpIterable = [ 'map-like', false, false, 'long-like', false, false ];
    test.identical( gotUpIterable, expectedUpIterable );
    test.description = 'iterable on down';
    var expectedDownIterable = [ false, false, false, false, 'long-like', 'map-like' ];
    test.identical( gotDownIterable, expectedDownIterable );

    test.description = 'it src';
    test.identical( it.src, structure );
    test.description = 'it key';
    test.identical( it.key, null );
    test.description = 'it continue';
    test.identical( it.continue, true );
    test.description = 'it ascending';
    test.identical( it.ascending, false );
    test.description = 'it revisited';
    test.identical( it.revisited, false );
    test.description = 'it visiting';
    test.identical( it.visiting, true );
    test.description = 'it iterable';
    test.identical( it.iterable, 'map-like' );
    test.description = 'it visitCounting';
    test.identical( it.visitCounting, true );
    test.description = 'it root';
    test.identical( it.root, structure );

    if( o.fast )
    test.is( wasIt === it );

  }

  function clean()
  {
    wasIt = undefined;
    gotUpKeys.splice( 0, gotUpKeys.length );
    gotDownKeys.splice( 0, gotDownKeys.length );
    gotUpValues.splice( 0, gotUpValues.length );
    gotDownValues.splice( 0, gotDownValues.length );
    gotUpRoots.splice( 0, gotUpRoots.length );
    gotDownRoots.splice( 0, gotDownRoots.length );
    gotUpRecursive.splice( 0, gotUpRecursive.length );
    gotDownRecursive.splice( 0, gotDownRecursive.length );
    gotUpRevisited.splice( 0, gotUpRevisited.length );
    gotDownRevisited.splice( 0, gotDownRevisited.length );
    gotUpVisitingCounting.splice( 0, gotUpVisitingCounting.length );
    gotDownVisitingCounting.splice( 0, gotDownVisitingCounting.length );
    gotUpVisiting.splice( 0, gotUpVisiting.length );
    gotDownVisiting.splice( 0, gotDownVisiting.length );
    gotUpAscending.splice( 0, gotUpAscending.length );
    gotDownAscending.splice( 0, gotDownAscending.length );
    gotUpContinue.splice( 0, gotUpContinue.length );
    gotDownContinue.splice( 0, gotDownContinue.length );
    gotUpIterable.splice( 0, gotUpIterable.length );
    gotDownIterable.splice( 0, gotDownIterable.length );
  }

  function handleUp( op, e, k, it )
  {

    debugger;
    if( op.fast )
    {
      test.is( wasIt === undefined || wasIt === it );
      wasIt = it;
    }

    gotUpKeys.push( k ); // k === it.key
    gotUpValues.push( e ); // e === it.src
    gotUpRoots.push( it.root );
    gotUpRecursive.push( it.recursive );
    gotUpRevisited.push( it.revisited );
    gotUpVisitingCounting.push( it.visitCounting );
    gotUpVisiting.push( it.visiting );
    gotUpAscending.push( it.ascending );
    gotUpContinue.push( it.continue );
    gotUpIterable.push( it.iterable );

  }

  function handleDown( op, e, k, it )
  {

    debugger;
    if( op.fast )
    {
      test.is( wasIt === it );
    }

    gotDownKeys.push( k ); // k === it.key
    gotDownValues.push( e ); // e === it.src
    gotDownRoots.push( it.root );
    gotDownRecursive.push( it.recursive );
    gotDownRevisited.push( it.revisited );
    gotDownVisitingCounting.push( it.visitCounting );
    gotDownVisiting.push( it.visiting );
    gotDownAscending.push( it.ascending );
    gotDownContinue.push( it.continue );
    gotDownIterable.push( it.iterable );
  }

}

//

function optionFastCycled( test )
{
  let structure =
  {
    a : [ { d : { e : [ 1, 2 ] } }, { f : [ 'a', 'b' ] } ],
  }

  let gotUpKeys = [];
  let gotDownKeys = [];
  let gotUpValues = [];
  let gotDownValues = [];
  let gotUpRoots = [];
  let gotDownRoots = [];
  let gotUpRecursive = [];
  let gotDownRecursive = [];
  let gotUpRevisited = [];
  let gotDownRevisited = [];
  let gotUpVisitingCounting = [];
  let gotDownVisitingCounting = [];
  let gotUpVisiting = [];
  let gotDownVisiting = [];
  let gotUpAscending = [];
  let gotDownAscending = [];
  let gotUpContinue = [];
  let gotDownContinue = [];
  let gotUpIterable = [];
  let gotDownIterable = [];
  let wasIt = undefined;

  run({ fast : 0 });
  run({ fast : 1 });

  function run( o )
  {

    test.case = 'cycled fast ' + o.fast;
    clean();

    var it = _.look
    ({
      src : structure,
      onUp : function() { return handleUp( o, ... arguments ) },
      onDown : function() { return handleDown( o, ... arguments ) },
      fast : o.fast,
    });

    test.description = 'keys on up';
    var expectedUpKeys = [ null, 'a', 0, 'd', 'e', 0, 1, 1, 'f', 0, 1 ];
    test.identical( gotUpKeys, expectedUpKeys );
    test.description = 'keys on down';
    var expectedDownKeys = [ 0, 1, 'e', 'd', 0, 0, 1, 'f', 1, 'a', null ];
    test.identical( gotDownKeys, expectedDownKeys );
    test.description = 'values on up';
    var expectedUpValues = [ structure, structure.a, structure.a[0], structure.a[0].d, structure.a[0].d.e, structure.a[0].d.e[0], structure.a[0].d.e[1], structure.a[1], structure.a[1].f, structure.a[1].f[0], structure.a[1].f[1] ];
    test.identical( gotUpValues, expectedUpValues );
    test.description = 'values on down';
    var expectedDownValues = [ structure.a[0].d.e[0], structure.a[0].d.e[1], structure.a[0].d.e, structure.a[0].d, structure.a[0], structure.a[1].f[0], structure.a[1].f[1], structure.a[1].f, structure.a[1], structure.a, structure ];
    test.identical( gotDownValues, expectedDownValues );
    test.description = 'roots on up';
    var expectedRoots = [ structure, structure, structure, structure, structure, structure, structure, structure, structure, structure, structure ];
    test.identical( gotUpRoots, expectedRoots );
    test.description = 'roots on down';
    var expectedRoots = [ structure, structure, structure, structure, structure, structure, structure, structure, structure, structure, structure ];
    test.identical( gotDownRoots, expectedRoots );
    test.description = 'recursive on up';
    var expectedRecursive = [ Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity ];
    test.identical( gotUpRecursive, expectedRecursive );
    test.description = 'recursive on down';
    var expectedRecursive = [ Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity, Infinity ];
    test.identical( gotDownRecursive, expectedRecursive );
    test.description = 'revisited on up';
    var expectedRevisited = [ false, false, false, false, false, false, false, false, false, false, false ];
    test.identical( gotUpRevisited, expectedRevisited );
    test.description = 'revisited on down';
    var expectedRevisited = [ false, false, false, false, false, false, false, false, false, false, false ];
    test.identical( gotDownRevisited, expectedRevisited );
    test.description = 'visitCounting on up';
    var expectedVisitingCounting = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotUpVisitingCounting, expectedVisitingCounting );
    test.description = 'visitCounting on down';
    var expectedVisitingCounting = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotDownVisitingCounting, expectedVisitingCounting );
    test.description = 'visiting on up';
    var expectedVisiting = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotUpVisiting, expectedVisiting );
    test.description = 'visiting on down';
    var expectedVisiting = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotDownVisiting, expectedVisiting );
    test.description = 'ascending on up';
    var expectedUpAscending = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotUpAscending, expectedUpAscending );
    test.description = 'ascending on down';
    var expectedDownAscending = [ false, false, false, false, false, false, false, false, false, false, false ];
    test.identical( gotDownAscending, expectedDownAscending );
    test.description = 'continue on up';
    var expectedContinue = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotUpContinue, expectedContinue );
    test.description = 'continue on down';
    var expectedContinue = [ true, true, true, true, true, true, true, true, true, true, true ];
    test.identical( gotDownContinue, expectedContinue );
    test.description = 'iterable on up';
    var expectedUpIterable = [ 'map-like', 'long-like', 'map-like', 'map-like', 'long-like', false, false, 'map-like', 'long-like', false, false ];
    test.identical( gotUpIterable, expectedUpIterable );
    test.description = 'iterable on down';
    var expectedDownIterable = [ false, false, 'long-like', 'map-like', 'map-like', false, false, 'long-like', 'map-like', 'long-like', 'map-like' ];
    test.identical( gotDownIterable, expectedDownIterable );

    test.description = 'it src';
    test.identical( it.src, structure );
    test.description = 'it key';
    test.identical( it.key, null );
    test.description = 'it continue';
    test.identical( it.continue, true );
    test.description = 'it ascending';
    test.identical( it.ascending, false );
    test.description = 'it revisited';
    test.identical( it.revisited, false );
    test.description = 'it visiting';
    test.identical( it.visiting, true );
    test.description = 'it iterable';
    test.identical( it.iterable, 'map-like' );
    test.description = 'it visitCounting';
    test.identical( it.visitCounting, true );
    test.description = 'it root';
    test.identical( it.root, structure );

    if( o.fast )
    test.is( wasIt === it );

  }

  function clean()
  {
    wasIt = undefined;
    gotUpKeys.splice( 0, gotUpKeys.length );
    gotDownKeys.splice( 0, gotDownKeys.length );
    gotUpValues.splice( 0, gotUpValues.length );
    gotDownValues.splice( 0, gotDownValues.length );
    gotUpRoots.splice( 0, gotUpRoots.length );
    gotDownRoots.splice( 0, gotDownRoots.length );
    gotUpRecursive.splice( 0, gotUpRecursive.length );
    gotDownRecursive.splice( 0, gotDownRecursive.length );
    gotUpRevisited.splice( 0, gotUpRevisited.length );
    gotDownRevisited.splice( 0, gotDownRevisited.length );
    gotUpVisitingCounting.splice( 0, gotUpVisitingCounting.length );
    gotDownVisitingCounting.splice( 0, gotDownVisitingCounting.length );
    gotUpVisiting.splice( 0, gotUpVisiting.length );
    gotDownVisiting.splice( 0, gotDownVisiting.length );
    gotUpAscending.splice( 0, gotUpAscending.length );
    gotDownAscending.splice( 0, gotDownAscending.length );
    gotUpContinue.splice( 0, gotUpContinue.length );
    gotDownContinue.splice( 0, gotDownContinue.length );
    gotUpIterable.splice( 0, gotUpIterable.length );
    gotDownIterable.splice( 0, gotDownIterable.length );
  }

  function handleUp( op, e, k, it )
  {

    debugger;
    if( op.fast )
    {
      test.is( wasIt === undefined || wasIt === it );
      wasIt = it;
    }

    gotUpKeys.push( k ); // k === it.key
    gotUpValues.push( e ); // e === it.src
    gotUpRoots.push( it.root );
    gotUpRecursive.push( it.recursive );
    gotUpRevisited.push( it.revisited );
    gotUpVisitingCounting.push( it.visitCounting );
    gotUpVisiting.push( it.visiting );
    gotUpAscending.push( it.ascending );
    gotUpContinue.push( it.continue );
    gotUpIterable.push( it.iterable );
  }

  function handleDown( op, e, k, it )
  {

    if( op.fast )
    {
      test.is( wasIt === it );
    }

    gotDownKeys.push( k ); // k === it.key
    gotDownValues.push( e ); // e === it.src
    gotDownRoots.push( it.root );
    gotDownRecursive.push( it.recursive );
    gotDownRevisited.push( it.revisited );
    gotDownVisitingCounting.push( it.visitCounting );
    gotDownVisiting.push( it.visiting );
    gotDownAscending.push( it.ascending );
    gotDownContinue.push( it.continue );
    gotDownIterable.push( it.iterable );
  }

}

// --
// declare
// --

var Self =
{

  name : 'Tools.base.l3.Look',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {

    look,
    lookRecursive,
    fieldPaths,
    callbacksComplex,
    relook,

    optionRevisiting,
    optionOnSrcChanged,
    optionOnUpNonContainer,
    optionOnPathJoin,

    optionAscend,
    optionRoot,
    optionFastPerformance,
    // optionFast,
    // optionFastCycled,

  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
