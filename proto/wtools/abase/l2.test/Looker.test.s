( function _Looker_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../l2/Looker.s' );
  _.include( 'wStringer' );
  _.include( 'wTesting' );
}

const _global = _global_;
const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

/*

node wtools/abase/l2.test/Looker.test.s && \
node wtools/abase/l4.test/LookerExtra.test.s && \
node wtools/abase/l4.test/Replicator.test.s && \
node wtools/abase/l5.test/Selector.test.s && \
node wtools/abase/l6.test/SelectorExtra.test.s && \
node wtools/abase/l6.test/Equaler.test.s && \
node wtools/abase/l6.test/Resolver.test.s && \
node wtools/abase/l7.test/ResolverExtra.test.s && \
node wtools/amid/l5_mapper.test/TemplateTreeResolver.test.s && \
node wtools/amid/l5_mapper.test/TemplateTreeEnvironment.test.s && \
tst.local wtools/amid/l3/introspector.test n:1 && \
node wtools/atop/will.test/Int.test.s n:1 rapidity:-3

tst.local wtools/abase/l0 n:1 && \
tst.local wtools/abase/l1.test n:1

*/

// --
// tests
// --

function look( test )
{

  var src =
  {
    a : 1,
    b : 's',
    c : [ 1, 3 ],
    d : [ 1, { date : new Date( Date.UTC( 1990, 0, 0 ) ) } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1, 2, 3 ]),
  }

  var expectedUpPaths = [ '/', '/a', '/b', '/c', '/c/#0', '/c/#1', '/d', '/d/#0', '/d/#1', '/d/#1/date', '/e', '/f', '/g' ];
  var expectedDownPaths = [ '/a', '/b', '/c/#0', '/c/#1', '/c', '/d/#0', '/d/#1/date', '/d/#1', '/d', '/e', '/f', '/g', '/' ];
  var expectedUpIndinces = [ null, 0, 1, 2, 0, 1, 3, 0, 1, 0, 4, 5, 6 ];
  var expectedDownIndices = [ 0, 1, 0, 1, 2, 0, 0, 1, 3, 4, 5, 6, null ];

  var gotUpPaths = [];
  var gotDownPaths = [];
  var gotUpIndinces = [];
  var gotDownIndices = [];

  var it = _.look( src, handleUp1, handleDown1 );

  test.case = 'iteration';

  test.true( it.Looker === undefined );
  test.true( _.looker.Looker === _.looker.Seeker );
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.Looker.iteratorProper( _.prototype.each( it )[ 3 ] ) );
  test.true( _.looker.iterationIs( it ) );
  test.true( _.looker.iteratorIs( _.prototype.each( it )[ 3 ] ) );
  test.true( _.looker.is( _.prototype.each( it )[ 4 ] ) );
  test.identical( _.prototype.each( it ).length, 5 );
  test.true( _.prototype.each( it )[ 3 ] === it.iterator );
  test.true( _.prototype.each( it )[ 4 ] === it.Seeker );

  test.description = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.description = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );
  test.description = 'indices on up';
  test.identical( gotUpIndinces, expectedUpIndinces );
  test.description = 'indices on down';
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

function lookWithCountableVector( test )
{

  var src =
  {
    a : 1,
    b : 's',
    c : [ 1, 3 ],
    d : [ 1, { date : new Date( Date.UTC( 1990, 0, 0 ) ) } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1, 2, 3 ]),
  }

  var expectedUpPaths = [ '/', '/a', '/b', '/c', '/c/#0', '/c/#1', '/d', '/d/#0', '/d/#1', '/d/#1/date', '/e', '/f', '/g', '/g/#0', '/g/#1', '/g/#2' ];
  var expectedDownPaths = [ '/a', '/b', '/c/#0', '/c/#1', '/c', '/d/#0', '/d/#1/date', '/d/#1', '/d', '/e', '/f', '/g/#0', '/g/#1', '/g/#2', '/g', '/' ];
  var expectedUpIndinces = [ null, 0, 1, 2, 0, 1, 3, 0, 1, 0, 4, 5, 6, 0, 1, 2 ];
  var expectedDownIndices = [ 0, 1, 0, 1, 2, 0, 0, 1, 3, 4, 5, 0, 1, 2, 6, null ];

  var gotUpPaths = [];
  var gotDownPaths = [];
  var gotUpIndinces = [];
  var gotDownIndices = [];

  var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : 'vector' });

  test.case = 'iteration';

  test.true( it.Looker === undefined );
  test.true( _.looker.Looker === _.looker.Seeker );
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.Looker.iteratorProper( _.prototype.each( it )[ 3 ] ) );
  test.true( _.looker.iterationIs( it ) );
  test.true( _.looker.iteratorIs( _.prototype.each( it )[ 3 ] ) );
  test.true( _.looker.is( _.prototype.each( it )[ 4 ] ) );
  test.identical( _.prototype.each( it ).length, 5 );
  test.true( _.prototype.each( it )[ 3 ] === it.iterator );
  test.true( _.prototype.each( it )[ 4 ] === it.Seeker );

  test.description = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.description = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );
  test.description = 'indices on up';
  test.identical( gotUpIndinces, expectedUpIndinces );
  test.description = 'indices on down';
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

  var src =
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
    src,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 0,
  });

  test.case = 'iteration';
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.iterationIs( it ) );

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
    src,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 1,
  });

  test.case = 'iteration';
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.iterationIs( it ) );

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
    src,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : 2,
  });

  test.case = 'iteration';
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.iterationIs( it ) );

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
    src,
    onUp : handleUp1,
    onDown : handleDown1,
    recursive : Infinity,
  });

  test.case = 'iteration';
  test.true( _.looker.Looker.iterationProper( it ) );
  test.true( _.looker.iterationIs( it ) );

  test.case = 'paths on up';
  test.identical( gotUpPaths, expectedUpPaths );
  test.case = 'paths on down';
  test.identical( gotDownPaths, expectedDownPaths );

  test.close( 'recursive : Infinity' );

  /* */

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

function lookWithIterator( test )
{

  let gotUpPaths, gotDownPaths, gotUpKeys, gotDownKeys, gotUpValues, gotDownValues;

  /* */

  test.case = 'countable : 1, default';
  clean();
  var ins1 = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], countable : 1 });
  var it = _.look( ins1, handleUp1, handleDown1 );
  var expectedUpPaths = [ '/' ];
  test.identical( gotUpPaths, expectedUpPaths );
  var expectedDownPaths = [ '/' ];
  test.identical( gotDownPaths, expectedDownPaths );
  var expectedUpKeys = [ null ];
  test.identical( gotUpKeys, expectedUpKeys );
  var expectedDownKeys = [ null ];
  test.identical( gotDownKeys, expectedDownKeys );
  var expectedUpValues = [ ins1 ];
  test.identical( gotUpValues, expectedUpValues );
  var expectedDownValues = [ ins1 ];
  test.identical( gotDownValues, expectedDownValues );

  /* */

  test.case = 'countable : 1, withCountable : 1';
  clean();
  var ins1 = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], countable : 1 });
  var it = _.look({ src : ins1, onUp : handleUp1, onDown : handleDown1, withCountable : 1 });
  var expectedUpPaths = [ '/', '/#0', '/#1' ];
  test.identical( gotUpPaths, expectedUpPaths );
  var expectedDownPaths = [ '/#0', '/#1', '/' ];
  test.identical( gotDownPaths, expectedDownPaths );
  var expectedUpKeys = [ null, 0, 1 ];
  test.identical( gotUpKeys, expectedUpKeys );
  var expectedDownKeys = [ 0, 1, null ];
  test.identical( gotDownKeys, expectedDownKeys );
  var expectedUpValues = [ ins1, 'a', 'b' ];
  test.identical( gotUpValues, expectedUpValues );
  var expectedDownValues = [ 'a', 'b', ins1 ];
  test.identical( gotDownValues, expectedDownValues );

  /* */

  test.case = 'countable : 0';
  clean();
  var ins1 = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], countable : 0 });
  var it = _.look( ins1, handleUp1, handleDown1 );
  var expectedUpPaths = [ '/' ];
  test.identical( gotUpPaths, expectedUpPaths );
  var expectedDownPaths = [ '/' ];
  test.identical( gotDownPaths, expectedDownPaths );
  var expectedUpKeys = [ null ];
  test.identical( gotUpKeys, expectedUpKeys );
  var expectedDownKeys = [ null ];
  test.identical( gotDownKeys, expectedDownKeys );
  var expectedUpValues = [ ins1 ];
  test.identical( gotUpValues, expectedUpValues );
  var expectedDownValues = [ ins1 ];
  test.identical( gotDownValues, expectedDownValues );

  /* */

  // function _iterate()
  // {
  //
  //   let iterator = Object.create( null );
  //   iterator.next = next;
  //   iterator.index = 0;
  //   iterator.instance = this;
  //   return iterator;
  //
  //   function next()
  //   {
  //     let result = Object.create( null );
  //     result.done = this.index === this.instance.elements.length;
  //     if( result.done )
  //     return result;
  //     result.value = this.instance.elements[ this.index ];
  //     this.index += 1;
  //     return result;
  //   }
  //
  // }
  //
  // /* */
  //
  // function Obj1( o )
  // {
  //   _.props.extend( this, o );
  //   if( o.countable )
  //   this[ Symbol.iterator ] = _iterate;
  //   return this;
  // }

  /* */

  function clean()
  {
    gotUpPaths = [];
    gotDownPaths = [];
    gotUpKeys = [];
    gotDownKeys = [];
    gotUpValues = [];
    gotDownValues = [];
  }

  /* */

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
    gotUpKeys.push( k );
    gotUpValues.push( e );
  }

  /* */

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownKeys.push( k );
    gotDownValues.push( e );
  }

  /* */

}

//

function lookHashMap( test )
{
  let ups = [];
  let downs = [];

  /* */

  test.case = 'basic';
  clean();
  var src = new HashMap([ [ 'k1', 'v1' ], [ 'k2', 'v2' ] ]);
  var got = _.look( src, onUp, onDown );
  test.true( got.iterationProper( got ) );
  var exp = [ '/', '/k1', '/k2' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/k1', '/k2', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  test.case = 'deep';
  clean();
  var src = new HashMap([ [ 'k1', { v : 'v1' } ], [ 'k2', new HashMap([ [ 'k1', 'v1' ], [ 'k2', 'v2' ] ]) ] ]);
  var got = _.look( src, onUp, onDown );
  var exp = [ '/', '/k1', '/k1/v', '/k2', '/k2/k1', '/k2/k2' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/k1/v', '/k1', '/k2/k1', '/k2/k2', '/k2', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  test.case = 'special';
  clean();
  var src = new HashMap([ [ 'k1', 'v1' ], [ undefined, undefined ], [ null, null ], [ 10, 20 ] ]);
  var got = _.look( src, onUp, onDown );
  test.true( got.iterationProper( got ) );
  var exp = [ '/', '/k1', '/#1', '/#2', '/#3' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/k1', '/#1', '/#2', '/#3', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  function clean()
  {
    ups = [];
    downs = [];
  }

  function onUp()
  {
    let it = this;
    ups.push( _.props.extend( null, it ) );
  }

  function onDown()
  {
    let it = this;
    downs.push( _.props.extend( null, it ) );
  }

}

//

function lookSet( test )
{
  let ups = [];
  let downs = [];

  /* */

  test.case = 'basic';
  clean();
  var src = new Set([ 'k1', 'k2' ]);
  var got = _.look( src, onUp, onDown );
  test.true( got.iterationProper( got ) );
  var exp = [ '/', '/k1', '/k2' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ src, 'k1', 'k2' ];
  test.identical( __.select( ups, '*/src' ), exp );
  var exp = [ '/k1', '/k2', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );
  var exp = [ 'k1', 'k2', src ];
  test.identical( __.select( downs, '*/src' ), exp );

  /* */

  test.case = 'deep';
  clean();
  var src = new Set([ 'k1', new Set([ 'v1', 'v2' ]) ]);
  var got = _.look( src, onUp, onDown );
  var exp = [ '/', '/k1', '/#1', '/#1/v1', '/#1/v2' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/k1', '/#1/v1', '/#1/v2', '/#1', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  test.case = 'special';
  clean();
  var src = new Set([ undefined, null, 10, 'k' ]);
  var got = _.look( src, onUp, onDown );
  test.true( got.iterationProper( got ) );
  var exp = [ '/', '/#0', '/#1', '/#2', '/k' ] ;
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ new Set([ undefined, null, 10, 'k' ]), undefined, null, 10, 'k' ];
  test.identical( __.select( ups, '*/src' ), exp );
  var exp = [ '/#0', '/#1', '/#2', '/k', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );
  var exp = [ undefined, null, 10, 'k', new Set([ undefined, null, 10, 'k' ]) ];
  test.identical( __.select( downs, '*/src' ), exp );

  /* */

  function clean()
  {
    ups = [];
    downs = [];
  }

  function onUp()
  {
    let it = this;
    ups.push( _.props.extend( null, it ) );
  }

  function onDown()
  {
    let it = this;
    downs.push( _.props.extend( null, it ) );
  }

}

//

function lookMethodAscend( test )
{
  let ups, downs;

  /* */

  test.case = 'uncountable assumption';
  clean();
  var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], countable : 0 });
  var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
  var exp = [ '/' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  test.case = 'countable assumption';
  clean();
  var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], countable : 1 });
  var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
  var exp = [ '/', '/#0', '/#1' ];
  test.identical( __.select( ups, '*/path' ), exp );
  var exp = [ '/#0', '/#1', '/' ];
  test.identical( __.select( downs, '*/path' ), exp );

  /* */

  caseEach({ countable : 0 });
  caseEach({ countable : 1 });

  /* - */

  function caseEach( env )
  {

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, ascend with iterate`;
    clean();
    var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], ascend : ascend1, ... env });
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', 'b', src ];
    test.identical( __.select( downs, '*/src' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/originalSrc' ), exp );
    var exp = [ 'a', 'b', src ];
    test.identical( __.select( downs, '*/originalSrc' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, ascend with ascend`;
    clean();
    var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], ascend : ascend2, ... env });
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', 'b', [ 'a', 'b' ] ];
    test.identical( __.select( downs, '*/src' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/originalSrc' ), exp );
    var exp = [ 'a', 'b', src ];
    test.identical( __.select( downs, '*/originalSrc' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, ascend with ascendSrc`;
    clean();
    var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], ascend : ascend3, ... env });
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', 'b', [ 'a', 'b' ] ];
    test.identical( __.select( downs, '*/src' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/originalSrc' ), exp );
    var exp = [ 'a', 'b', src ];
    test.identical( __.select( downs, '*/originalSrc' ), exp );

  }

  /* - */

  function ascend1( it )
  {
    for( let i = 0 ; i < it.src.elements.length ; i++ )
    {
      let e = it.src.elements[ i ];
      let eit = it.iterationMake().choose( e, i, i, true );
      eit.iterate();
      if( !it.canSibling() )
      break;
    }
  }

  /* - */

  function ascend2( it )
  {
    it.src = it.src.elements;
    it.iterable = null;
    it.srcChanged();
    it.ascend();
  }

  /* - */

  function ascend3( it )
  {
    it.ascendSrc( it.src.elements );
  }

  /* - */

  function clean()
  {
    ups = [];
    downs = [];
  }

  /* - */

  function onUp( src, key, it )
  {
    ups.push( _.props.extend( null, it ) );
  }

  /* - */

  function onDown( src, key, it )
  {
    downs.push( _.props.extend( null, it ) );
  }

  /* - */

}

//

function lookCustomized( test )
{
  let ups, downs;

  caseEach({ countable : 0 });
  caseEach({ countable : 1 });

  /* - */

  function caseEach( env )
  {

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, object`;
    clean();
    var src = __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], ... env });
    var it = _.look({ src, onUp, onDown, srcChanged, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ [ 'a', 'b' ], 'a', 'b' ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', 'b', [ 'a', 'b' ] ];
    test.identical( __.select( downs, '*/src' ), exp );
    var exp = [ src, 'a', 'b' ];
    test.identical( __.select( ups, '*/originalSrc' ), exp );
    var exp = [ 'a', 'b', src ];
    test.identical( __.select( downs, '*/originalSrc' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, object in map`;
    clean();
    var src = { x : __.diagnostic.objectMake({ c : 'c1', elements : [ 'a', 'b' ], ... env }) };
    var it = _.look({ src, onUp, onDown, srcChanged, withCountable : 'countable' });
    var exp = [ '/', '/x', '/x/#0', '/x/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/x/#0', '/x/#1', '/x', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, [ 'a', 'b' ], 'a', 'b' ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', 'b', [ 'a', 'b' ], src ];
    test.identical( __.select( downs, '*/src' ), exp );
    var exp = [ src, src.x, 'a', 'b' ];
    test.identical( __.select( ups, '*/originalSrc' ), exp );
    var exp = [ 'a', 'b', src.x, src ];
    test.identical( __.select( downs, '*/originalSrc' ), exp );

    /* */

  }

  /* - */

  function srcChanged()
  {
    let it = this;
    if( it.src && _.long.is( it.src.elements ) )
    it.src = it.src.elements;
    it.Seeker.srcChanged.call( it );
  }

  /* - */

  function clean()
  {
    ups = [];
    downs = [];
  }

  /* - */

  function onUp( src, key, it )
  {
    ups.push( _.props.extend( null, it ) );
  }

  /* - */

  function onDown( src, key, it )
  {
    downs.push( _.props.extend( null, it ) );
  }

  /* - */

}

//

function lookUndefined( test )
{
  let ups, downs;

  caseEach({});

  /* - */

  function caseEach( env )
  {

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, countable`;
    clean();
    var src = __.diagnostic.objectMake({ c : 'c1', elements : [ undefined, undefined ], ... env });
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, array`;
    clean();
    var src = [ undefined, undefined ];
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/#0', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/#0', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, set`;
    clean();
    var src = new Set([ 'a', undefined ]);
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/a', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/a', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, 'a', undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ 'a', undefined, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, hashmap`;
    clean();
    var src = new HashMap([ [ 'a', undefined ], [ undefined, undefined ] ]);
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/a', '/#1' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/a', '/#1', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, map`;
    clean();
    var src = { a : undefined, b : undefined };
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/a', '/b' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/a', '/b', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, aux`;
    clean();
    var src = Object.create( Object.create( null ) );
    src.a = undefined;
    src.b = undefined;
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/a', '/b', '/!prototype' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/a', '/b', '/!prototype', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined, {} ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, {}, src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

    test.case = `${__.entity.exportStringSolo( env )}, aux with undefined in prototype`;
    clean();
    var src = Object.create({ a : undefined, b : undefined });
    var it = _.look({ src, onUp, onDown, withCountable : 'countable' });
    var exp = [ '/', '/a', '/b', '/!prototype', '/!prototype/a', '/!prototype/b' ];
    test.identical( __.select( ups, '*/path' ), exp );
    var exp = [ '/a', '/b', '/!prototype/a', '/!prototype/b', '/!prototype', '/' ];
    test.identical( __.select( downs, '*/path' ), exp );
    var exp = [ src, undefined, undefined, _.prototype.of( src ), undefined, undefined ];
    test.identical( __.select( ups, '*/src' ), exp );
    var exp = [ undefined, undefined, undefined, undefined, _.prototype.of( src ), src ];
    test.identical( __.select( downs, '*/src' ), exp );

    /* */

  }

  /* - */

  function clean()
  {
    ups = [];
    downs = [];
  }

  /* - */

  function onUp( src, key, it )
  {
    ups.push( _.props.extend( null, it ) );
  }

  /* - */

  function onDown( src, key, it )
  {
    downs.push( _.props.extend( null, it ) );
  }

  /* - */

}

//

function fieldPath( test )
{
  let upPaths, downPaths;

  /* */

  test.case = 'basic map';

  clean();

  var src =
  {
    a : 11,
    d :
    {
      b : 13,
      5 : 15,
    }
  }
  var got = _.look
  ({
    src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  var exp = [ '/', '/a', '/d', '/d/5', '/d/b' ];
  test.identical( upPaths, exp );
  var exp = [ '/a', '/d/5', '/d/b', '/d', '/' ];
  test.identical( downPaths, exp );

  /* */

  test.case = 'basic hashMap';

  clean();

  var src = new HashMap();
  src.set( 'a', 11 );
  var d = new HashMap()
  d.set( 'b', 13 );
  d.set( 5, 15 );
  src.set( 'd', d );
  var got = _.look
  ({
    src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  var exp = [ '/', '/a', '/d', '/d/b', '/d/#1' ];
  test.identical( upPaths, exp );
  var exp = [ '/a', '/d/b', '/d/#1', '/d', '/' ];
  test.identical( downPaths, exp );

  /* */

  test.case = 'basic set';

  clean();
  var src = new Set();
  src.add( 'a', 11 );
  var d = new Set()
  d.add( 'b' );
  d.add( 5 );
  src.add( d );
  var got = _.look
  ({
    src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  var exp = [ '/', '/a', '/#1', '/#1/b', '/#1/#1' ];
  test.identical( upPaths, exp );
  var exp = [ '/a', '/#1/b', '/#1/#1', '/#1', '/' ];
  test.identical( downPaths, exp );

  /* */

  test.case = 'basic array';

  clean();
  var src = [ 'a', [ 'b', 'c' ] ];
  var got = _.look
  ({
    src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
  });
  var exp = [ '/', '/#0', '/#1', '/#1/#0', '/#1/#1' ];
  test.identical( upPaths, exp );
  var exp = [ '/#0', '/#1/#0', '/#1/#1', '/#1', '/' ];
  test.identical( downPaths, exp );

  /* */

  test.case = 'countalbe';

  clean();
  var b = __.diagnostic.objectMake({ /* ttt */ new : 1, countable : 1, elements : [ 'c', 'd' ] });
  var src = __.diagnostic.objectMake({ /* ttt */ new : 1, countable : 1, elements : [ 'a', b ] });
  var got = _.look
  ({
    src,
    upToken : [ '/', './' ],
    onUp,
    onDown,
    withCountable : 'countable',
  });
  var exp = [ '/', '/#0', '/#1', '/#1/#0', '/#1/#1' ];
  test.identical( upPaths, exp );
  var exp = [ '/#0', '/#1/#0', '/#1/#1', '/#1', '/' ];
  test.identical( downPaths, exp );

  /* */

  function clean()
  {
    upPaths = [];
    downPaths = [];
  }

  function onUp()
  {
    let it = this;
    upPaths.push( it.path );
  }

  function onDown()
  {
    let it = this;
    downPaths.push( it.path );
  }

  /* */

  // function _iterate()
  // {
  //
  //   let iterator = Object.create( null );
  //   iterator.next = next;
  //   iterator.index = 0;
  //   iterator.instance = this;
  //   return iterator;
  //
  //   function next()
  //   {
  //     let result = Object.create( null );
  //     result.done = this.index === this.instance.elements.length;
  //     if( result.done )
  //     return result;
  //     result.value = this.instance.elements[ this.index ];
  //     this.index += 1;
  //     return result;
  //   }
  //
  // }
  //
  // /* */
  //
  // function countableConstructor( o )
  // {
  //   return countableMake( this, o );
  // }
  //
  // /* */
  //
  // function countableMake( dst, o )
  // {
  //   if( dst === null )
  //   dst = Object.create( null );
  //   _.props.extend( dst, o );
  //   if( o.countable )
  //   dst[ Symbol.iterator ] = _iterate;
  //   return dst;
  // }

  /* */

}

fieldPath.description =
`
  - field path has sane values during traversing
  - cardinals are prefixed with #
  - empty string is quoted
  - keys with spaces are quoted
  - keys with delimeter are quoted
`

//

// qqq : for Rahul : for Junior : write the test as if routine::diagnosticStructureGenerate was used, but without using it.
// function complexStructure( test )
// {
//   let ups = [];
//   let dws = [];
//
//   /* - */
//
//   let expUps =
//   [
//   ]
//
//   let expDws =
//   [
//   ]
//
//   var generated = _.diagnosticStructureGenerate
//   ({
//     depth : 1,
//     defaultComplexity : 5,
//     defaultLength : 1,
//     defaultSize : 1,
//     random : 0,
//   });
//
//   clean();
//   _.look({ src : generated.result, onUp, onDown });
//   test.identical( ups, expUps );
//   test.identical( dws, expDws );
//
//   /* - */
//
//   function clean()
//   {
//     ups.splice( 0, ups.length );
//     dws.splice( 0, dws.length );
//   }
//
//   function onUp( e, k, it )
//   {
//     ups.push( it.path );
//   }
//
//   function onDown( e, k, it )
//   {
//     dws.push( it.path );
//   }
//
// } /* end of function complexStructure */

//

function reperform( test )
{
  let upsLevel = [];
  let upsSelector = [];
  let upsPath = [];
  let dwsLevel = [];
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
    src,
    onUp,
    onDown,
  });

  var exp = [ 0, 1, 2, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ]
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    src,
    onUp,
    onDown,
    onTerminal,
  });

  var exp = [ 0, 1, 2, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ]
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name',
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    upsSelector.push( it.selector );
    upsPath.push( it.path );

    test.identical( arguments.length, 3 );

  }

  function onDown0( e, k, it )
  {

    dwsLevel.push( it.level );
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
      it.reperform( [ 'r1', 'r2', 'r3' ] );
    }

  }

  function onTerminal( e )
  {
    let it = this;

    test.identical( arguments.length, 1 );

    if( it.path === '/a/name' )
    if( !_.arrayIs( it.src ) )
    {
      it.reperform( [ 'r1', 'r2', 'r3' ] );
    }

  }

  function clean()
  {
    upsLevel.splice( 0 );
    upsSelector.splice( 0 );
    upsPath.splice( 0 );
    dwsLevel.splice( 0 );
    dwsSelector.splice( 0 );
    dwsPath.splice( 0 );
  }

  /* */

}

//

function makeCustomBasic( test )
{
  let its = [];
  let cid = _.looker.Looker.ContainerType;
  _.assert( _.auxIs( cid ) );

  /* */

  test.case = 'control';
  clean();

  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1 });
  var exp = [ '/', '/#0' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ cid.countable, cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );

  /* */

  test.case = 'extending Looker, extending';
  clean();

  var Looker2 = _.props.extend( null, _.looker.Looker );
  Looker2.Seeker = Looker2;
  Looker2.OriginalSeeker = Looker2;
  Looker2.iterableEval = iterableEval;
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  test.case = 'extending Looker, prototyping';
  clean();

  var Looker2 = Object.create( _.looker.Looker );
  Looker2.Seeker = Looker2;
  Looker2.iterableEval = iterableEval;
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  test.case = 'extending Looker, making';
  clean();

  var Looker2 = _.looker.classDefine({ seeker : { iterableEval, constructor : function Looker2(){} } });
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  test.case = 'extending Iterator, cloning';
  clean();

  var Looker2 = _.props.extend( null, _.looker.Looker );
  Looker2.Seeker = Looker2;
  Looker2.OriginalSeeker = Looker2;
  var Iterator = Looker2.Iterator = _.props.extend( null, Looker2.Iterator );
  Iterator.field1 = 'field1';
  Iterator.iterableEval = iterableEval;
  /*
  should be never called
  */
  /*
  extending iterator manually should have no effect
  because looker should be extended by iterator once in define
  not during each look
  */
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/', '/#0' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ undefined, undefined ];
  test.identical( its.map( ( it ) => it.field1 ), exp );
  var exp = [ cid.countable, cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  test.case = 'extending Iterator, prototyping';
  clean();

  var Looker2 = Object.create(_.looker.Looker );
  Looker2.Seeker = Looker2;
  var Iterator = Looker2.Iterator = Object.create( Looker2.Iterator );
  Iterator.field1 = 'field1';
  Iterator.iterableEval = iterableEval;
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/', '/#0' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ undefined, undefined ];
  test.identical( its.map( ( it ) => it.field1 ), exp );
  var exp = [ cid.countable, cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  test.case = 'extending Iterator, making';
  clean();

  var Looker2 = _.looker.classDefine({ iterator : { iterableEval } });
  var src = new _.props.Implicit( 'abc' );
  var got = _.look({ src, withCountable : 'countable', onUp : handleUp1, Seeker : Looker2 });
  var exp = [ '/' ];
  test.identical( its.map( ( it ) => it.path ), exp );
  var exp = [ cid.terminal ];
  test.identical( its.map( ( it ) => it.iterable ), exp );
  its.map( ( it ) => test.true( Looker2.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !Looker2.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iterationProper( it ) ) );
  its.map( ( it ) => test.true( !_.looker.Looker.iteratorProper( it ) ) );
  its.map( ( it ) => test.true( _.looker.iterationIs( it ) ) );
  its.map( ( it ) => test.true( !_.looker.iteratorIs( it ) ) );

  /* */

  function clean()
  {
    its = [];
  }

  function handleUp1( e, k, it )
  {
    its.push( _.props.extend( null, it ) );
  }

  function iterableEval()
  {
    let it = this;
    it.iterable = null;
    if( _.aux.is( it.src ) )
    {
      it.iterable = _.looker.Looker.ContainerType.aux;
    }
    else
    {
      it.iterable = 0;
    }
  }

}

//

function errMakeBasic( test )
{

  /* */

  test.case = 'basic';
  var got = _.looker.SeekingError();
  test.true( _.errIs( got ) );
  test.true( got instanceof _.looker.SeekingError );
  test.identical( got.originalMessage, 'SeekingError' );
  test.identical( got.SeekingError, true );
  var exp =
  {
    'value' : true,
    'writable' : true,
    'enumerable' : false,
    'configurable' : true,
  };
  var got = _.props.descriptorOwnOf( got, 'SeekingError' );
  test.identical( got, exp );

  /* */

  test.case = 'basic, new';
  var got = new _.looker.SeekingError();
  test.true( _.errIs( got ) );
  test.true( got instanceof _.looker.SeekingError );
  test.identical( got.originalMessage, 'SeekingError' );
  test.identical( got.SeekingError, true );
  var exp =
  {
    'value' : true,
    'writable' : true,
    'enumerable' : false,
    'configurable' : true,
  };
  var got = _.props.descriptorOwnOf( got, 'SeekingError' );
  test.identical( got, exp );

  /* */

  test.case = 'with message';
  var got = _.looker.SeekingError( 'abc', 'def' );
  test.true( _.errIs( got ) );
  test.true( got instanceof _.looker.SeekingError );
  test.identical( got.originalMessage, 'abc def' );
  test.identical( got.SeekingError, true );
  var exp =
  {
    'value' : true,
    'writable' : true,
    'enumerable' : false,
    'configurable' : true,
  };
  var got = _.props.descriptorOwnOf( got, 'SeekingError' );
  test.identical( got, exp );

  /* */

  test.case = 'with message, new';
  var got = new _.looker.SeekingError( 'abc', 'def' );
  test.true( _.errIs( got ) );
  test.true( got instanceof _.looker.SeekingError );
  test.identical( got.originalMessage, 'abc def' );
  test.identical( got.SeekingError, true );
  var exp =
  {
    'value' : true,
    'writable' : true,
    'enumerable' : false,
    'configurable' : true,
  };
  var got = _.props.descriptorOwnOf( got, 'SeekingError' );
  test.identical( got, exp );

  /* */

  test.case = 'remake';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = _.looker.SeekingError( err1 );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'abc' );
  test.identical( err2.originalMessage, 'abc' );
  test.true( err1 === err2 );

  /* */

  test.case = 'remake, new';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = new _.looker.SeekingError( err1 );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'abc' );
  test.identical( err2.originalMessage, 'abc' );
  test.true( err1 !== err2 );

  /* */

  test.case = 'remake, extra argument, right';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = _.looker.SeekingError( err1, 'def' );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'abc def' );
  test.identical( err2.originalMessage, 'abc def' );
  test.true( err1 === err2 );

  /* */

  test.case = 'remake, extra argument, right, new';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = new _.looker.SeekingError( err1, 'def' );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'abc' );
  test.identical( err2.originalMessage, 'abc def' );
  test.true( err1 !== err2 );

  /* */

  test.case = 'remake, extra argument, left';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = _.looker.SeekingError( 'def', err1 );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'def abc' );
  test.identical( err2.originalMessage, 'def abc' );
  test.true( err1 === err2 );

  /* */

  test.case = 'remake, extra argument, left, new';
  var err1 = _.looker.SeekingError( 'abc' );
  var err2 = new _.looker.SeekingError( 'def', err1 );
  test.true( err1 instanceof _.looker.SeekingError );
  test.true( err2 instanceof _.looker.SeekingError );
  test.identical( err1.originalMessage, 'abc' );
  test.identical( err2.originalMessage, 'def abc' );
  test.true( err1 !== err2 );

  /* */

}

//

function optionWithCountable( test )
{
  let gotUpPaths = [];
  let gotDownPaths = [];
  let gotUpIndinces = [];
  let gotDownIndices = [];

  caseEach({ withCountable : 'countable' });
  caseEach({ withCountable : 'vector' });
  caseEach({ withCountable : 'long' });
  caseEach({ withCountable : 'array' });
  caseEach({ withCountable : true });
  caseEach({ withCountable : 1 });
  caseEach({ withCountable : '' });
  caseEach({ withCountable : false });
  caseEach({ withCountable : 0 });

  function caseEach( env )
  {

    /* */

    test.case = `withCountable:${env.withCountable}, str`;
    var src =
    {
      a : 'abc',
    }
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, routine`;
    var src =
    {
      a : function(){},
    }
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, raw buffer`;
    var src =
    {
      a : new BufferRaw( 13 ),
    }
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, array`;
    var src =
    {
      a : [ 1, 3 ],
    }
    test.true( _.countableIs( src.a ) );
    test.true( _.vectorIs( src.a ) );
    test.true( _.longIs( src.a ) );
    test.true( _.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a', '/a/#0', '/a/#1' ];
    if( !env.withCountable )
    exp = [ '/', '/a' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, typed buffer`;
    var src =
    {
      a : new F32x([ 0, 10 ]),
    }
    test.true( _.countableIs( src.a ) );
    test.true( _.vectorIs( src.a ) );
    test.true( _.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a', '/a/#0', '/a/#1' ];
    if( !env.withCountable || env.withCountable === 'array' )
    exp = [ '/', '/a' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, vector`;
    var src =
    {
      a : _.diagnostic.objectMake({ elements : [ '1', '10' ], countable : 1, length : 2, new : 1 }),
    }
    test.true( _.countableIs( src.a ) );
    test.true( _.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    if( env.withCountable === 'countable' || env.withCountable === 'vector' || env.withCountable === true || env.withCountable === 1 )
    exp = [ '/', '/a', '/a/#0', '/a/#1' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, countable`;
    var src =
    {
      a : _.diagnostic.objectMake({ elements : [ '1', '10' ], countable : 1, new : 1 }),
    }
    test.true( _.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    if( env.withCountable === 'countable' || env.withCountable === true || env.withCountable === 1 )
    exp = [ '/', '/a', '/a/#0', '/a/#1' ];
    test.identical( gotUpPaths, exp );

    /* */

    test.case = `withCountable:${env.withCountable}, countable made`;
    var src =
    {
      a : _.diagnostic.objectMake({ elements : [ '1', '10' ], countable : 1 }),
    }
    test.true( _.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withCountable : env.withCountable });
    var exp = [ '/', '/a' ];
    if( env.withCountable === 'countable' || env.withCountable === true || env.withCountable === 1 )
    exp = [ '/', '/a', '/a/#0', '/a/#1' ];
    test.identical( gotUpPaths, exp );

    /* */

  }

  /* */

  function clean()
  {
    gotUpPaths = [];
    gotUpIndinces = [];
    gotDownPaths = [];
    gotDownIndices = [];
  }

  /* */

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
    gotUpIndinces.push( it.index );
  }

  /* */

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownIndices.push( it.index );
  }

  /* */

}

//

function optionWithImplicitBasic( test )
{
  let its = [];

  caseEach({ withImplicit : 1 });
  caseEach({ withImplicit : true });
  caseEach({ withImplicit : 'aux' });
  caseEach({ withImplicit : 0 });
  caseEach({ withImplicit : false });
  caseEach({ withImplicit : '' });

  function caseEach( env )
  {
    let exp;

    /* */

    test.case = `withImplicit:${env.withImplicit}, str`;
    var src = 'anc';
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });
    exp = [ '/' ];
    test.identical( its.map( ( it ) => it.path ), exp );
    exp = [ src ];
    test.identical( its.map( ( it ) => it.src ), exp );
    exp = [ null ];
    test.identical( its.map( ( it ) => it.key ), exp );
    exp = [ false ];
    test.identical( its.map( ( it ) => it.isImplicit() ), exp );

    /* */

    test.case = `withImplicit:${env.withImplicit}, prototyped map`;
    var prototype = Object.create( null );
    prototype.p = 0;
    var src = Object.create( prototype );
    src.a = 1;
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

    if( env.withImplicit )
    {
      exp = [ '/', '/a', '/p', '/!prototype', '/!prototype/p' ];
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 1, 0, _.prototype.of( src ), 0 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp =
      [
        null,
        'a',
        'p',
        new _.props.Implicit( Symbol.for( 'prototype' ) ),
        'p'
      ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false, false, true, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp );
    }
    else
    {
      exp = [ '/', '/a', '/p' ];
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 1, 0 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp = [ null, 'a', 'p' ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp );
    }

    /* */

    test.case = `withImplicit:${env.withImplicit}, shadowed prototyped map`;
    var prototype = Object.create( null );
    prototype.a = 0;
    var src = Object.create( prototype );
    src.a = 1;
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

    if( env.withImplicit )
    {
      exp = [ '/', '/a', '/!prototype', '/!prototype/a' ];
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 1, _.prototype.of( src ), 0 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp =
      [
        null,
        'a',
        new _.props.Implicit( Symbol.for( 'prototype' ) ),
        'a'
      ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false, true, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp );
    }
    else
    {
      exp = [ '/', '/a' ];
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 1 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp = [ null, 'a' ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp );
    }

    /* */

    test.case = `withImplicit:${env.withImplicit}, deep prototyped map`;
    var prototype1 = {};
    prototype1.a = 0;
    var prototype2 = Object.create( prototype1 );
    prototype2.a = 1;
    var src = Object.create( prototype2 );
    src.a = 2;
    test.true( !_.countableIs( src.a ) );
    test.true( !_.vectorIs( src.a ) );
    test.true( !_.longIs( src.a ) );
    test.true( !_.arrayIs( src.a ) );
    clean();
    var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

    if( env.withImplicit )
    {
      exp =
      [
        '/',
        '/a',
        '/!prototype',
        '/!prototype/a',
        '/!prototype/!prototype',
        '/!prototype/!prototype/a'
      ]
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 2, _.prototype.each( src )[ 1 ], 1, _.prototype.each( src )[ 2 ], 0 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp =
      [
        null,
        'a',
        new _.props.Implicit( Symbol.for( 'prototype' ) ),
        'a',
        new _.props.Implicit( Symbol.for( 'prototype' ) ),
        'a',
      ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false, true, false, true, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp );
    }
    else
    {
      exp = [ '/', '/a' ];
      test.identical( its.map( ( it ) => it.path ), exp );
      exp = [ src, 2 ];
      test.identical( its.map( ( it ) => it.src ), exp );
      exp = [ null, 'a' ];
      test.identical( its.map( ( it ) => it.key ), exp );
      exp = [ false, false ];
      test.identical( its.map( ( it ) => it.isImplicit() ), exp ); /* qqq : use such mapping as standard for the test suite */
    }

    /* */

  }

  /* */

  function clean()
  {
    its = [];
  }

  /* */

  function handleUp1( e, k, it )
  {
    its.push( _.props.extend( null, it ) );
  }

  /* */

  function handleDown1( e, k, it )
  {
  }

  /* */

}

//

function optionWithImplicitGenerated( test )
{
  let gotUpPaths = [];
  let gotUpVals = [];
  let gotDownPaths = [];
  let gotUpIndinces = [];
  let gotDownVals = [];
  let gotDownIndices = [];

  let sets =
  {
    countable : 0,
    pure : [ 0, 1 ],
    withOwnConstructor : [ 0, 1 ],
    withConstructor : [ 0, 1 ],
    new : [ 0, 1 ],
    withImplicit : 1,
  };
  let samples = _.permutation.eachSample({ sets });

  for( let env of samples )
  caseEach( env );

  /* */

  function caseEach( env )
  {
    let exp, src, it;

    /* - */

    if( env.new && env.withConstructor )
    {
      test.case = `${toStr( env )}`;
      src = _.diagnostic.objectMake( { elements : [ '1', '10' ], ... env } );

      clean();
      it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

      exp = [ '/' ]
      test.identical( gotUpPaths, exp );

    }
    else if( env.new )
    {
      test.case = `${toStr( env )}`;
      src = _.diagnostic.objectMake( { elements : [ '1', '10' ], ... env } );

      clean();
      it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

      exp =
      [
        '/',
        '/elements',
        '/elements/#0',
        '/elements/#1',
        '/countable',
        '/pure',
        '/withOwnConstructor',
        '/withConstructor',
        '/new',
        '/withImplicit',
        '/basic',
        '/iteratorIsGenerator',
        '/vector',
      ]
      if( env.withOwnConstructor )
      exp.push( '/constructor' );
      if( env.withImplicit )
      exp.push( '/!prototype' );
      test.identical( gotUpPaths, exp );
    }
    else
    {
      test.case = `${toStr( env )}`;
      src = _.diagnostic.objectMake({ elements : [ '1', '10' ], ... env });

      clean();
      it = _.look({ src, onUp : handleUp1, onDown : handleDown1, withImplicit : env.withImplicit });

      exp =
      [
        '/',
        '/elements',
        '/elements/#0',
        '/elements/#1',
        '/countable',
        '/pure',
        '/withOwnConstructor',
        '/withConstructor',
        '/new',
        '/withImplicit',
        '/basic',
        '/iteratorIsGenerator',
        '/vector',
      ]
      if( env.withOwnConstructor )
      exp.push( '/constructor' );
      test.identical( gotUpPaths, exp );

    }
  }

  /* */

  function toStr( src )
  {
    return __.entity.exportStringSolo( src );
  }

  /* */

  function clean()
  {
    gotUpPaths = [];
    gotUpVals = [];
    gotUpIndinces = [];
    gotDownPaths = [];
    gotDownVals = [];
    gotDownIndices = [];
  }

  /* */

  function handleUp1( e, k, it )
  {
    gotUpPaths.push( it.path );
    gotUpVals.push( it.src );
    gotUpIndinces.push( it.index );
  }

  /* */

  function handleDown1( e, k, it )
  {
    gotDownPaths.push( it.path );
    gotDownVals.push( it.src );
    gotDownIndices.push( it.index );
  }
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
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
    '/arr2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
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
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
    '/arr2',
    '/arr2/#0',
    '/arr2/#1',
    '/arr2/#1/a',
    '/arr2/#1/b',
    '/arr2/#1/c',
    '/arr2/#2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
    '/arr2',
    '/arr2/#0',
    '/arr2/#1',
    '/arr2/#1/a',
    '/arr2/#1/b',
    '/arr2/#1/c',
    '/arr2/#2'
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
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
    '/arr2',
    '/arr2/#0',
    '/arr2/#1',
    '/arr2/#1/a',
    '/arr2/#1/b',
    '/arr2/#1/c',
    '/arr2/#2'
  ]
  var expDws =
  [
    '/',
    '/arr',
    '/arr/#0',
    '/arr/#1',
    '/arr/#1/a',
    '/arr/#1/b',
    '/arr/#1/c',
    '/arr/#2',
    '/arr2',
    '/arr2/#0',
    '/arr2/#1',
    '/arr2/#1/a',
    '/arr2/#1/b',
    '/arr2/#1/c',
    '/arr2/#2'
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

  act({});

  function act( env )
  {

    var a1 = new Obj({ name : 'a1' });
    var a2 = new Obj({ name : 'a2' });
    var b = new Obj({ name : 'b', elements : [ a1, a2 ] });
    var c = new Obj({ name : 'c', elements : [ b ] });

    var expUps =
    [
      '/',
      '/str',
      '/num',
      '/name',
      '/elements',
      '/elements/#0',
      '/elements/#0/str',
      '/elements/#0/num',
      '/elements/#0/name',
      '/elements/#0/elements',
      '/elements/#0/elements/#0',
      '/elements/#0/elements/#1'
    ];
    var expDws =
    [
      '/',
      '/str',
      '/num',
      '/name',
      '/elements',
      '/elements/#0',
      '/elements/#0/str',
      '/elements/#0/num',
      '/elements/#0/name',
      '/elements/#0/elements',
      '/elements/#0/elements/#0',
      '/elements/#0/elements/#1'
    ]
    var expUpNames =
    [
      'c',
      undefined,
      undefined,
      undefined,
      undefined,
      'b',
      undefined,
      undefined,
      undefined,
      undefined,
      'a1',
      'a2'
    ]
    var expDwNames =
    [
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      undefined,
      'a1',
      'a2',
      undefined,
      'b',
      undefined,
      'c'
    ]

    clean();
    // var got = _.look({ src : c, onUp, onDown, onSrcChanged : onSrcChangedBoth });
    var got = _.look({ src : c, onUp, onDown, srcChanged : onSrcChangedBoth });
    test.identical( ups, expUps );
    test.identical( ups, expDws );
    test.identical( upNames, expUpNames );
    test.identical( dwNames, expDwNames );

    clean();
    // var got = _.look({ src : c, onUp, onDown, onSrcChanged : onSrcChangedWithIterable });
    var got = _.look({ src : c, onUp, onDown, srcChanged : onSrcChangedWithIterable });
    test.identical( ups, expUps );
    test.identical( ups, expDws );
    test.identical( upNames, expUpNames );
    test.identical( dwNames, expDwNames );

    clean();
    // var got = _.look({ src : c, onUp, onDown, onSrcChanged : onSrcChangedWithAux });
    var got = _.look({ src : c, onUp, onDown, srcChanged : onSrcChangedWithAux });
    test.identical( ups, expUps );
    test.identical( ups, expDws );
    test.identical( upNames, expUpNames );
    test.identical( dwNames, expDwNames );

  }

  /* - */

  function Obj( o )
  {
    this.str = 'str';
    this.num = 13;
    Object.assign( this, o );
  }

  function clean()
  {
    ups = [];
    dws = [];
    upNames = [];
    dwNames = [];
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

  function onSrcChangedBoth()
  {
    let it = this;

    it.Seeker.srcChanged.call( it );

    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = _.looker.Looker.ContainerType.aux;
        it.ascend = function objAscend()
        {
          this._auxAscend( this.src );
        }
        // it.onAscend = function objAscend()
        // {
        //   this._auxAscend( this.src );
        // }
      }
    }
  }

  function onSrcChangedWithIterable()
  {
    let it = this;

    it.Seeker.srcChanged.call( it );

    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        it.iterable = _.looker.Looker.ContainerType.aux;
      }
    }
  }

  function onSrcChangedWithAux()
  {
    let it = this;

    it.Seeker.srcChanged.call( it );

    if( !it.iterable )
    if( it.src instanceof Obj )
    {
      if( _.longIs( it.src.elements ) )
      {
        // it.onAscend = function objAscend()
        it.ascend = function objAscend()
        {
          this._auxAscend( this.src );
        }
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

  var expUps = [ '/', '/#0', '/#0/#0', '/#0/#1' ];
  var expDws = [ '/', '/#0', '/#0/#0', '/#0/#1' ];
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
        // it.onAscend = function objAscend()
        it.ascend = function objAscend()
        {
          return this._countableAscend( this.src.elements );
        }
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
    onUp,
    onDown,
    pathJoin,
  });
  var exp =
  [
    '/',
    '/Number::int',
    '/String::str',
    '/Array::arr',
    '/Array::arr/Number::#0',
    '/Array::arr/Number::#1',
    '/Map.polluted::map',
    '/Map.polluted::map/Date.constructible::m1',
    '/Map.polluted::map/String::m3',
    '/Set::set',
    '/Set::set/Number::#0',
    '/Set::set/Number::#1',
    '/HashMap::hash',
    '/HashMap::hash/Routine::#0',
    '/HashMap::hash/String::m3'
  ]
  test.identical( ups, exp );
  var exp =
  [
    '/Number::int',
    '/String::str',
    '/Array::arr/Number::#0',
    '/Array::arr/Number::#1',
    '/Array::arr',
    '/Map.polluted::map/Date.constructible::m1',
    '/Map.polluted::map/String::m3',
    '/Map.polluted::map',
    '/Set::set/Number::#0',
    '/Set::set/Number::#1',
    '/Set::set',
    '/HashMap::hash/Routine::#0',
    '/HashMap::hash/String::m3',
    '/HashMap::hash',
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

  function pathJoin( selectorPath, selectorName )
  {
    let it = this;
    let result;

    _.assert( arguments.length === 2 );

    selectorPath = _.strRemoveEnd( selectorPath, it.upToken );

    result = selectorPath + it.defaultUpToken + _.entity.strType( it.src ) + '::' + selectorName;

    return result;
  }

}

//

function optionAscend( test )
{
  let upsLevel = [];
  let upsSelector = [];
  let upsPath = [];
  let dwsLevel = [];
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

  var it = _.look
  ({
    src,
    onDown,
    onUp,
    ascend,
    // onAscend,
  });

  var exp = [ 0, 1, 2, 3, 3, 3, 2, 1, 2, 2, 1, 2, 2 ];
  test.identical( upsLevel, exp );
  var exp =
  [
    '/',
    '/a',
    '/a/name',
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    '/a/name/#0',
    '/a/name/#1',
    '/a/name/#2',
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
    upsSelector.push( it.selector );
    upsPath.push( it.path );
  }

  function onDown( e, k, it )
  {

    dwsLevel.push( it.level );
    dwsSelector.push( it.selector );
    dwsPath.push( it.path );

  }

  function ascend()
  {
    let it = this;
    test.true( arguments.length === 0 );
    if( it.src === 'name1' )
    it._countableAscend( [ 'r1', 'r2', 'r3' ] );
    else
    it.Seeker.ascend.call( it );
  }

  // function onAscend()
  // {
  //   let it = this;
  //   test.true( arguments.length === 0 );
  //   if( it.src === 'name1' )
  //   it._countableAscend( [ 'r1', 'r2', 'r3' ] );
  //   else
  //   it.Seeker.onAscend.call( it );
  // }

  function clean()
  {
    upsLevel.splice( 0 );
    upsSelector.splice( 0 );
    upsPath.splice( 0 );
    dwsLevel.splice( 0 );
    dwsSelector.splice( 0 );
    dwsPath.splice( 0 );
  }

  /* */

}

//

function optionRoot( test )
{

  var src =
  {
    a : 1,
    b : 's',
    c : [ 1, 3 ],
    d : [ 1, { date : new Date( Date.UTC( 1990, 0, 0 ) ) } ],
    e : function(){},
    f : new BufferRaw( 13 ),
    g : new F32x([ 1, 2, 3 ]),
  }
  var gotUpRoots = [];
  var gotDownRoots = [];

  test.case = 'explicit';
  clean();
  var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, root : src });
  var expectedRoots =
  [
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src
  ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, src );

  test.case = 'implicit';
  clean();
  var it = _.look({ src, onUp : handleUp1, onDown : handleDown1 });
  var expectedRoots =
  [
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src,
    src
  ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, src );

  test.case = 'node as root';
  clean();
  var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, root : src.c });
  var expectedRoots =
  [
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c,
    src.c
  ];
  test.description = 'roots on up';
  test.identical( gotUpRoots, expectedRoots );
  test.description = 'roots on down';
  test.identical( gotDownRoots, expectedRoots );
  test.description = 'get root';
  test.identical( it.root, src.c );

  test.case = 'another structure as root';
  clean();
  var structure2 =
  {
    a : 's',
    b : 1,
    c : { d : [ 2 ] }
  };
  var it = _.look({ src, onUp : handleUp1, onDown : handleDown1, root : structure2 });
  var expectedRoots =
  [
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2,
    structure2
  ];
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
  var structure = _.diagnosticStructureGenerate({ depth : 5, mapComplexity : 3, mapLength : 5, random : 0 });
  structure = structure.structure;
  var times = 10;
  var it1, it2;

  var time = _.time.now();
  for( let i = times ; i > 0 ; i-- )
  it1 = _.look({ src : structure });
  console.log( `The current implementation of _.look took ${_.time.spent( time )} on Njs ${process.version}` );

  var time = _.time.now();
  for( let i = times ; i > 0 ; i-- )
  it2 = _.look({ src : structure, fast : 1 });
  console.log( `_.look with the fast option took ${_.time.spent( time )} on Njs ${process.version}` );

  test.true( true );
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
    var expectedUpValues = [ structure, structure.a, structure.b, structure.c, structure.c[ 0 ], structure.c[ 1 ] ];
    test.identical( gotUpValues, expectedUpValues );
    test.description = 'values on down';
    var expectedDownValues = [ structure.a, structure.b, structure.c[ 0 ], structure.c[ 1 ], structure.c, structure ];
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
    test.true( wasIt === it );

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

  function handleUp( /* op, e, k, it */ )
  {
    let op = arguments[ 0 ];
    let e = arguments[ 1 ];
    let k = arguments[ 2 ];
    let it = arguments[ 3 ];

    if( op.fast )
    {
      test.true( wasIt === undefined || wasIt === it );
      wasIt = it;
    }

    gotUpKeys.push( k ); /* k === it.key */
    gotUpValues.push( e ); /* e === it.src */
    gotUpRoots.push( it.root );
    gotUpRecursive.push( it.recursive );
    gotUpRevisited.push( it.revisited );
    gotUpVisitingCounting.push( it.visitCounting );
    gotUpVisiting.push( it.visiting );
    gotUpAscending.push( it.ascending );
    gotUpContinue.push( it.continue );
    gotUpIterable.push( it.iterable );

  }

  function handleDown( /* op, e, k, it */ )
  {

    let op = arguments[ 0 ];
    let e = arguments[ 1 ];
    let k = arguments[ 2 ];
    let it = arguments[ 3 ];

    if( op.fast )
    {
      test.true( wasIt === it );
    }

    gotDownKeys.push( k ); /* k === it.key */
    gotDownValues.push( e ); /* e === it.src */
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
    var expectedUpValues =
    [
      structure,
      structure.a,
      structure.a[ 0 ],
      structure.a[ 0 ].d,
      structure.a[ 0 ].d.e,
      structure.a[ 0 ].d.e[ 0 ],
      structure.a[ 0 ].d.e[ 1 ],
      structure.a[ 1 ],
      structure.a[ 1 ].f,
      structure.a[ 1 ].f[ 0 ],
      structure.a[ 1 ].f[ 1 ]
    ];
    test.identical( gotUpValues, expectedUpValues );
    test.description = 'values on down';
    var expectedDownValues =
    [
      structure.a[ 0 ].d.e[ 0 ],
      structure.a[ 0 ].d.e[ 1 ],
      structure.a[ 0 ].d.e,
      structure.a[ 0 ].d,
      structure.a[ 0 ],
      structure.a[ 1 ].f[ 0 ],
      structure.a[ 1 ].f[ 1 ],
      structure.a[ 1 ].f,
      structure.a[ 1 ],
      structure.a,
      structure
    ];
    test.identical( gotDownValues, expectedDownValues );
    test.description = 'roots on up';
    var expectedRoots =
    [
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure
    ];
    test.identical( gotUpRoots, expectedRoots );
    test.description = 'roots on down';
    var expectedRoots =
    [
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure,
      structure
    ];
    test.identical( gotDownRoots, expectedRoots );
    test.description = 'recursive on up';
    var expectedRecursive =
    [
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity
    ];
    test.identical( gotUpRecursive, expectedRecursive );
    test.description = 'recursive on down';
    var expectedRecursive =
    [
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity,
      Infinity
    ];
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
    test.true( wasIt === it );

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

  function handleUp( /* op, e, k, it */ )
  {
    let op = arguments[ 0 ];
    let e = arguments[ 1 ];
    let k = arguments[ 2 ];
    let it = arguments[ 3 ];

    if( op.fast )
    {
      test.true( wasIt === undefined || wasIt === it );
      wasIt = it;
    }

    gotUpKeys.push( k ); /* k === it.key */
    gotUpValues.push( e ); /* e === it.src */
    gotUpRoots.push( it.root );
    gotUpRecursive.push( it.recursive );
    gotUpRevisited.push( it.revisited );
    gotUpVisitingCounting.push( it.visitCounting );
    gotUpVisiting.push( it.visiting );
    gotUpAscending.push( it.ascending );
    gotUpContinue.push( it.continue );
    gotUpIterable.push( it.iterable );
  }

  function handleDown( /* op, e, k, it */ )
  {

    let op = arguments[ 0 ];
    let e = arguments[ 1 ];
    let k = arguments[ 2 ];
    let it = arguments[ 3 ];

    if( op.fast )
    {
      test.true( wasIt === it );
    }

    gotDownKeys.push( k ); /* k === it.key */
    gotDownValues.push( e ); /* e === it.src */
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
// samples
// --

function sampleTrivial( test )
{

  let logger = new __.LoggerToString();
  let structure =
  {
    number : 1,
    string : 's',
    array : [ 1, { date : new Date() } ],
    routine : function(){},
    set : new Set([ 'a', 13 ]),
    hasmap : new HashMap([ [ 'a', 13 ], [ null, 0 ] ]),
  }

  _.look( structure, ( e, k, it ) => logger.log( it.path ) );

  var exp =
`
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
`
  test.equivalent( logger.outputData, exp );

}

// --
// performance
// --

function performance( test ) /* xxx : write similar test for other lookers */
{
  const configDebug = Config.debug;
  Config.debug = false;

  /* */

  test.case = 'inner';

  var counter = 0;
  var nruns = 10;
  var data = _.diagnosticStructureGenerate({ defaultComplexity : 5, depth : 3 }).result;
  var time = _.time.now();

  debugger; /* eslint-disable-line no-debugger */
  for( let i = 0 ; i < nruns ; i++ )
  run( data );
  console.log( `Inner : ${_.time.spent( time )}` );
  test.identical( counter, 309516 * nruns );
  debugger; /* eslint-disable-line no-debugger */

  test.case = 'outer';

  var counter = 0;
  var nruns = 1000;
  var data = _.diagnosticStructureGenerate({ defaultComplexity : 5, depth : 1 }).result;
  var time = _.time.now();

  debugger; /* eslint-disable-line no-debugger */
  for( let i = 0 ; i < nruns ; i++ )
  run( data );
  console.log( `Outer : ${_.time.spent( time )}` );
  test.identical( counter, 1068 * nruns );
  debugger; /* eslint-disable-line no-debugger */

  Config.debug = configDebug;

  /*

== Inner

= before
nruns:10 time:43s
= after
nruns:10 time:8.3s
= now
nruns:10 time:10.8s

== Outer

= before
nruns:1000 time:14.5s
= after
nruns:1000 time:3.3s
= now
nruns:1000 time:4.1s

  */

  function run( data )
  {
    _.look( data, ( e, k, it ) => { ( counter += 1, undefined ) } );
  }

}

performance.experimental = 1;
performance.rapidity = -1;
performance.timeOut = 1e6;

// --
// declare
// --

const Proto =
{

  name : 'Tools.l3.Look',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {

    look,
    lookWithCountableVector,
    lookRecursive,
    lookWithIterator,
    lookHashMap,
    lookSet,
    lookMethodAscend,
    lookCustomized,
    lookUndefined,

    fieldPath,
    // complexStructure,
    reperform,
    makeCustomBasic,
    errMakeBasic,

    optionWithCountable,
    optionWithImplicitBasic,
    optionWithImplicitGenerated,
    optionRevisiting,
    optionOnSrcChanged,
    optionOnUpNonContainer,
    optionOnPathJoin,
    optionAscend,
    optionRoot,
    optionFastPerformance,
    // optionFast,
    // optionFastCycled,

    // samples

    sampleTrivial,

    // performance

    performance,

  }

}

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
