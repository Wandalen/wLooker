( function _Looker_s_()
{

'use strict';

/**
 * Collection of light-weight routines to traverse complex data structure. The module takes care of cycles in a data structure( recursions ) and can be used for comparison or operation on several similar data structures, for replication. Several other modules used this to traverse abstract data structures.
  @module Tools/base/Looker
*/

/**
 * Collection of light-weight routines to traverse complex data structure.
 * @namespace Tools.Looker
 * @module Tools/base/Looker
 */

/**
 * Collection of light-weight routines to traverse complex data structure.
 * @class Tools.Looker
 * @module Tools/base/Looker
 */

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

}

const _global = _global_;
const _ = _global_.wTools;
const _ObjectHasOwnProperty = Object.hasOwnProperty;

_.looker = _.looker || Object.create( null );

_.assert( !!_realGlobal_ );

/* qqq : write nice example for readme */
/* xxx : write nice example for readme */

// --
// relations
// --

/**
 * Default options for {@link module:Tools/base/Looker.Looker.look} routine.
 * @typedef {Object} Prime
 * @property {Function} onUp
 * @property {Function} onDown
 * @property {Function} onTerminal
 * @property {Function} ascend
 * @property {Function} onIterable
 * @property {Number} recursive = Infinity
 * @property {Boolean} trackingVisits = 1
 * @property {String} upToken = '/'
 * @property {String} path = null
 * @property {Number} level = 0
 * @property {*} src = null
 * @property {*} root = null
 * @property {*} context = null
 * @property {Object} Looker = null
 * @property {Object} it = null
 * @class Tools.Looker
 */

let Prime = Object.create( null );

Prime.src = undefined;
Prime.root = undefined;
Prime.onUp = onUp;
Prime.onDown = onDown;
Prime.onAscend = onAscend;
Prime.onTerminal = onTerminal;
Prime.onSrcChanged = onSrcChanged;
Prime.pathJoin = pathJoin;
Prime.fast = 0;
Prime.recursive = Infinity;
Prime.revisiting = 0;
Prime.withCountable = 'array';
Prime.withImplicit = 'aux';
Prime.upToken = '/';
Prime.defaultUpToken = null;
Prime.path = null;
Prime.level = 0;
Prime.context = null;

// --
// options
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  _.assert( !!routine.defaults.Looker );
  let o = routine.defaults.Looker.optionsFromArguments( args );
  o.Looker = o.Looker || routine.defaults;
  _.map.assertHasOnly( o, routine.defaults );
  _.assert
  (
    _.props.keys( routine.defaults ).length === _.props.keys( o.Looker ).length,
    () => `${_.props.keys( routine.defaults ).length} <> ${_.props.keys( o.Looker ).length}`
  );
  let it = o.Looker.optionsToIteration( null, o );
  // let it = o.Looker.optionsToIteration( this !== o.Looker ? this : null, o );
  return it;
}

//

function optionsFromArguments( args )
{
  let o;

  if( args.length === 1 )
  {
    if( _.numberIs( args[ 0 ] ) )
    o = { accuracy : args[ 0 ] }
    else
    o = args[ 0 ];
  }
  else if( args.length === 2 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ] };
  }
  else if( args.length === 3 )
  {
    o = { src : args[ 0 ], onUp : args[ 1 ], onDown : args[ 2 ] };
  }
  else _.assert( 0, 'look expects single options-map, 2 or 3 arguments' );

  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );

  return o;
}

//

function optionsToIteration( iterator, o )
{
  _.assert( o.it === undefined );
  _.assert( _.mapIs( o ) );
  _.assert( !_.props.ownEnumerable( o, 'constructor' ) );
  _.assert( arguments.length === 2 );
  if( iterator === null )
  iterator = o.Looker.iteratorRetype( o );
  else
  Object.assign( iterator, o );
  o.Looker.iteratorInit( iterator );
  let it = iterator.iteratorIterationMake();
  _.assert( it.Looker.iterationProper( it ) );
  return it;
}

// --
// iterator
// --

function iteratorProper( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( it.iterator !== it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

function iteratorRetype( iterator )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( iterator ) );
  _.assert( _.object.isBasic( this.Iterator ) );
  _.assert( _.object.isBasic( this.Iteration ) );
  _.assert( _.object.isBasic( iterator.Looker ) );
  _.assert( iterator.Looker === this );
  _.assert( iterator.looker === undefined );
  _.assert( iterator.iterableEval !== null );
  _.assert( iterator.iterator === undefined );
  _.assert( iterator.Looker.Looker === iterator.Looker, 'Default of a routine and its default Looker are not in agreement' );
  _.assert( _.prototype.has( iterator.Looker, iterator.Looker.OriginalLooker ) );

  Object.setPrototypeOf( iterator, iterator.Looker );

  _.assert( iterator.it === undefined );

  return iterator;
}

//

function iteratorInit( iterator )
{
  let looker = this;
  looker.iteratorInitBegin( iterator );
  looker.iteratorInitEnd( iterator );
}

//

function iteratorInitBegin( iterator )
{

  _.assert( arguments.length === 1 );
  _.assert( !_.mapIs( iterator ) );
  _.assert( _.object.isBasic( this.Iterator ) );
  _.assert( _.object.isBasic( this.Iteration ) );
  _.assert( _.object.isBasic( iterator.Looker ) );
  _.assert( iterator.Looker === this );
  _.assert( iterator.looker === undefined );
  _.assert( _.routineIs( iterator.iterableEval ) );
  _.assert( _.prototype.has( iterator.Looker, iterator.Looker.OriginalLooker ) );
  _.assert( iterator.iterator === null );

  iterator.iterator = iterator;

  return iterator;
}

//

function iteratorInitEnd( iterator )
{

  /* */

  if( _.boolLike( iterator.withCountable ) )
  {
    if( iterator.withCountable )
    iterator.withCountable = 'countable';
    else
    iterator.withCountable = '';
  }
  if( _.boolLike( iterator.withImplicit ) )
  {
    if( iterator.withImplicit )
    iterator.withImplicit = 'aux';
    else
    iterator.withImplicit = '';
  }

  if( _.boolIs( iterator.recursive ) )
  iterator.recursive = iterator.recursive ? Infinity : 1;

  _.assert( iterator.iteratorProper( iterator ) );
  _.assert( iterator.Looker.Looker === iterator.Looker, 'Default of a routine and its default Looker are not in agreement' );
  _.assert( iterator.looker === undefined );
  _.assert
  (
    !Reflect.has( iterator, 'onUp' ) || iterator.onUp === null || iterator.onUp.length === 0 || iterator.onUp.length === 3,
    'onUp should expect exactly three arguments'
  );
  _.assert
  (
    !Reflect.has( iterator, 'onDown' ) || iterator.onDown === null || iterator.onDown.length === 0 || iterator.onDown.length === 3,
    'onDown should expect exactly three arguments'
  );
  _.assert( _.numberIsNotNan( iterator.recursive ), 'Expects number {- iterator.recursive -}' );
  _.assert( 0 <= iterator.revisiting && iterator.revisiting <= 2 );
  _.assert
  (
    // _.longHas( [ 'countable', 'vector', 'long', 'array', '' ], iterator.withCountable ),
    this.WithCountable[ iterator.withCountable ] !== undefined,
    'Unexpected value of option::withCountable'
  );
  _.assert
  (
    // _.longHas( [ 'aux', '' ], iterator.withImplicit ),
    this.WithImplicict[ iterator.withImplicit ] !== undefined,
    'Unexpected value of option::withImplicit'
  );

  if( iterator.Looker === null )
  iterator.Looker = Looker;

  /* */

  iterator.isCountable = iterator.WithCountableToIsElementalFunctionMap[ iterator.withCountable ];
  iterator.hasImplicit = iterator.WithImplicitToHasImplicitFunctionMap[ iterator.withImplicit ];

  if( iterator.revisiting < 2 )
  {
    if( iterator.revisiting === 0 )
    iterator.visitedContainer = _.containerAdapter.from( new Set );
    else
    iterator.visitedContainer = _.containerAdapter.from( new Array );
  }

  if( iterator.root === undefined )
  iterator.root = iterator.src;

  if( iterator.defaultUpToken === null )
  iterator.defaultUpToken = _.strsShortest( iterator.upToken );

  iterator.iterationPrototype = Object.create( iterator );
  Object.assign( iterator.iterationPrototype, iterator.Looker.Iteration );
  Object.preventExtensions( iterator.iterationPrototype );

  if( iterator.fast )
  {
    delete iterator.childrenCounter;
    delete iterator.level;
    delete iterator.path;
    delete iterator.lastPath;
    delete iterator.lastIt;
    delete iterator.upToken;
    delete iterator.defaultUpToken;
    delete iterator.context;
  }
  else
  {
    if( iterator.path === null )
    iterator.path = iterator.defaultUpToken;
    iterator.lastPath = iterator.path;
  }

  /*
  important assert, otherwise copying options from iteration could cause problem
  */
  _.assert( iterator.it === undefined );

  if( !iterator.fast )
  {
    _.assert( _.numberIs( iterator.level ) );
    _.assert( _.strIs( iterator.defaultUpToken ) );
    _.assert( _.strIs( iterator.path ) );
    _.assert( _.strIs( iterator.lastPath ) );
    _.assert( _.routineIs( iterator.iterableEval ) );
    _.assert( iterator.iterationPrototype.constructor === iterator.constructor );
    _.assert( iterator.iterationPrototype.constructor === iterator.Looker.constructor );
  }

  return iterator;
}

//

/**
 * @function iteratorIterationMake
 * @class Tools.Looker
 */

function iteratorIterationMake()
{
  let it = this;
  let newIt = it.iterationMakeCommon();
  _.assert( newIt.down === null );
  _.assert( Object.is( newIt.src, it.src ) );
  _.assert( newIt.originalSrc === null );
  return newIt;
}

//

function iteratorCopy( o )
{
  let it = this;

  _.assert( arguments.length === 1 );
  _.assert( _.object.isBasic( o ) )

  for( let k in o )
  {
    if( it[ k ] === null && o[ k ] !== null && o[ k ] !== undefined )
    {
      it[ k ] = o[ k ];
    }
  }

  return it;
}

// --
// iteration
// --

function iterationProper( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

function iterationMakeCommon()
{
  let it = this;

  let newIt = Object.create( it.iterationPrototype );

  return newIt;
}

//

/**
 * @function iterationMake
 * @class Tools.Looker
 */

function iterationMake()
{
  let it = this;

  // _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.assert( it.level >= 0 );
  // _.assert( _.object.isBasic( it.iterator ) );
  // _.assert( _.object.isBasic( it.Looker ) );
  // _.assert( it.looker === undefined );
  // _.assert( _.numberIs( it.level ) && it.level >= 0 );
  // _.assert( !!it.iterationPrototype );

  let newIt = it.iterationMakeCommon();

  if( it.Looker === Self ) /* zzz : achieve such optimization automatically */
  {
    newIt.level = it.level;
    newIt.path = it.path;
    newIt.src = it.src;
  }
  else
  {
    for( let k in it.Looker.IterationPreserve )
    newIt[ k ] = it[ k ];
  }

  newIt.down = it;

  return newIt;
}

// --
// perform
// --

function reperform( src )
{
  let it = this;
  _.assert( arguments.length === 1 );
  _.assert( it.iterationProper( it ) );
  it.src = src;
  return it.perform();
  // it.chooseRoot();
  // return it.iterate(); /* yyy : should be same as perform? */
}

//

function perform()
{
  let it = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  it.performBegin();
  it.iterate();
  it.performEnd();
  return it;
}

//

function performBegin()
{
  let it = this;
  _.assert( arguments.length === 0 );
  _.assert( it.iterationProper( it ) );
  it.chooseRoot();
  return it;
}

//

function performEnd()
{
  let it = this;
  _.assert( it.iterationProper( it ) );
  return it;
}

// --
// choose
// --

/**
 * @function elementGet
 * @class Tools.Looker
 */

function elementGet( e, k, c )
{
  let it = this;
  let result;
  _.assert( arguments.length === 3, 'Expects two argument' );
  result = _.container.elementWithImplicit( e, k ); /* xxx : use maybe functor */
  if( c === null )
  c = _.container.cardinalWithKey( e, k );
  return [ result[ 0 ], result[ 1 ], c, result[ 2 ] ];
}

//

/**
 * @function choose
 * @class Tools.Looker
 */

// function choose( e, k, exists )
function choose()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  [ e, k, c, exists ] = it.chooseBegin( e, k, c, exists );

  _.assert( arguments.length === 4 );
  _.assert( _.boolIs( exists ) || exists === null );

  if( e === undefined )
  [ e, k, c, exists ] = it.elementGet( it.src, k, c );

  it.chooseEnd( e, k, c, exists );

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  return it;
}

//

// function chooseBegin( e, k, exists )
function chooseBegin()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  _.assert( _.object.isBasic( it.down ) );
  _.assert( it.fast || it.level >= 0 );
  _.assert( it.originalKey === null );
  _.assert( arguments.length === 4 );

  if( it.originalKey === null )
  it.originalKey = k;

  return [ e, k, c, exists ];
}

//

// function chooseEnd( e, k, exists )
function chooseEnd()
{
  let it = this;
  let e = arguments[ 0 ];
  let k = arguments[ 1 ];
  let c = arguments[ 2 ];
  let exists = arguments[ 3 ];

  _.assert( arguments.length === 4, 'Expects three argument' );
  _.assert( _.object.isBasic( it.down ) );
  _.assert( _.boolIs( exists ) );
  _.assert( it.fast || it.level >= 0 );

  /*
  assigning of key and src should goes first
  */

  it.key = k;
  it.cardinal = c;
  it.src = e;
  it.originalSrc = e;

  if( it.fast )
  return it;

  it.level = it.level+1;

  let k2 = k;
  if( k2 === null )
  k2 = e;
  // if( _.numberIs( k2 ) )
  // {
  //   k2 = `#${k2}`;
  // }
  // else
  if( _.strIs( k2 ) )
  {
    /* xxx : test escaped path
    .!not-prototype
    .#not-cardinal
    */
    if( k2 === '' )
    k2 = '""';
  }
  else if( _.props.implicit.is( k2 ) )
  {
    k2 = `!${Symbol.keyFor( k2.val )}`;
  }
  else
  {
    // debugger;
    // k2 = _.entity.exportStringDiagnosticShallow( k2 );
    _.assert( c >= 0 );
    k2 = `#${c}`;
  }
  _.assert( k2 );
  let hasUp = _.strHasAny( k2, it.upToken );
  if( hasUp )
  k2 = '"' + k2 + '"';

  it.index = it.down.childrenCounter;
  it.path = it.pathJoin( it.path, k2 );
  it.iterator.lastPath = it.path;
  it.iterator.lastIt = it;

  return it;
}

//

function chooseRoot()
{
  let it = this;

  _.assert( arguments.length === 0 );

  it.originalSrc = it.src;

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  it.iterator.lastPath = it.path;
  it.iterator.lastIt = it;

  return it;
}

// --
// eval
// --

function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  it.iterableEval();

  if( it.onSrcChanged )
  it.onSrcChanged();

}

//

function onSrcChanged()
{
}

//

function iterableEval()
{
  let it = this;
  it.iterable = null; /* xxx : comment out */

  _.assert( it.iterable === null );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( _.aux.is( it.src ) )
  {
    it.iterable = it.ContainerNameToIdMap.aux;
  }
  else if( _.hashMapLike( it.src ) )
  {
    it.iterable = it.ContainerNameToIdMap.hashMap;
  }
  else if( _.setLike( it.src ) )
  {
    it.iterable = it.ContainerNameToIdMap.set;
  }
  else if( it.isCountable( it.src ) )
  {
    it.iterable = it.ContainerNameToIdMap.countable;
  }
  else
  {
    it.iterable = 0;
  }

  _.assert( it.iterable >= 0 );
}

//

function revisitedEval( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  if( it.iterator.visitedContainer )
  if( it.iterable )
  {
    if( it.iterator.visitedContainer.has( src ) )
    it.revisited = true;
  }

}

//

function isImplicit()
{
  let it = this;
  _.assert( it.iterationProper( it ) );
  return _.props.implicit.is( it.key );
}

// --
// iterate
// --

/**
 * @function look
 * @class Tools.Looker
 */

function iterate()
{
  let it = this;

  if( !it.fast )
  _.assert( it.level >= 0 );
  _.assert( arguments.length === 0, 'Expects no arguments' );

  it.visiting = it.canVisit();
  if( !it.visiting )
  return it;

  it.visitUp();

  it.ascending = it.canAscend();
  if( it.ascending )
  {
    it.ascend();
  }

  it.visitDown();

  return it;
}

//

/**
 * @function visitUp
 * @class Tools.Looker
 */

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined, 'Callback should not return something' );
  _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.entity.strType( it.continue ) );

  it.visitUpEnd()

}

//

/**
 * @function visitUpBegin
 * @class Tools.Looker
 */

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  if( !it.fast )
  if( it.down )
  it.down.childrenCounter += 1;

}

//

/**
 * @function visitUpEnd
 * @class Tools.Looker
 */

function visitUpEnd()
{
  let it = this;

  it.visitPush();

}

//

function onUp( e, k, it )
{
}

//

/**
 * @function visitDown
 * @class Tools.Looker
 */

function visitDown()
{
  let it = this;

  it.visitDownBegin();

  _.assert( it.visiting );

  if( it.onDown )
  {
    let r = it.onDown.call( it, it.src, it.key, it );
    _.assert( r === undefined );
  }

  it.visitDownEnd();

  return it;
}

//

/**
 * @function visitDownBegin
 * @class Tools.Looker
 */

function visitDownBegin()
{
  let it = this;

  it.ascending = false;

  _.assert( it.visiting );

  it.visitPop();

}

//

/**
 * @function visitDownEnd
 * @class Tools.Looker
 */

function visitDownEnd()
{
  let it = this;
}

//

function onDown( e, k, it )
{
}

//

function visitPush()
{
  let it = this;

  if( it.iterator.visitedContainer )
  if( it.visitCounting && it.iterable )
  {
    it.iterator.visitedContainer.push( it.originalSrc );
    it.visitCounting = true;
  }

}

//

function visitPop()
{
  let it = this;

  if( it.iterator.visitedContainer && it.iterator.revisiting !== 0 )
  if( it.visitCounting && it.iterable )
  if( _.arrayIs( it.iterator.visitedContainer.original ) || !it.revisited )
  {
    if( _.arrayIs( it.iterator.visitedContainer.original ) )
    _.assert
    (
      Object.is( it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ], it.originalSrc ),
      () => `Top-most visit ${it.path} does not match ${it.originalSrc} <> ${
        it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ]}`
    );
    it.iterator.visitedContainer.pop( it.originalSrc );
    it.visitCounting = false;
  }

}

//

/**
 * @function canVisit
 * @class Tools.Looker
 */

function canVisit()
{
  let it = this;

  if( !it.recursive && it.down )
  return false;

  return true;
}

//

/**
 * @function canAscend
 * @class Tools.Looker
 */

function canAscend()
{
  let it = this;

  _.assert( _.boolIs( it.continue ) );
  _.assert( _.boolIs( it.iterator.continue ) );

  if( !it.ascending )
  return false;

  if( it.continue === false )
  return false;
  else if( it.iterator.continue === false )
  return false;
  else if( it.revisited )
  return false;

  _.assert( _.numberIs( it.recursive ) );
  if( it.recursive > 0 && !it.fast )
  if( !( it.level < it.recursive ) )
  return false;

  return true;
}

//

function canSibling()
{
  let it = this;

  if( !it.continue || it.continue === _.dont )
  return false;

  if( !it.iterator.continue || it.iterator.continue === _.dont )
  return false;

  return true;
}

//

function ascend()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );
  _.assert( it.iterable !== null && it.iterable !== undefined );
  _.assert( !!it.continue );
  _.assert( !!it.iterator.continue );

  return it.onAscend();
}

//

function onAscend()
{
  let it = this;
  _.assert( !!it.ContainerIdToAscendMap[ it.iterable ], () => `No ascend for ${it.iterable}` );
  it.ContainerIdToAscendMap[ it.iterable ].call( it, it.src );
}

// --
// ascend
// --

function _termianlAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  it.onTerminal( src );

}

//

function onTerminal()
{
  let it = this;
  return it;
}

//

function _countableAscend( src )
{
  let it = this;

  if( _.class.methodIteratorOf( src ) )
  {
    let k = 0;
    for( let e of src ) /* xxx : implement test with e === undefined */
    {
      let eit = it.iterationMake().choose( e, k, k, true );
      eit.iterate();
      if( !it.canSibling() )
      break;
      k += 1;
    }
  }
  else
  {
    for( let k = 0 ; k < src.length ; k++ )
    {
      let e = src[ k ]; /* xxx : implement test with e === undefined */
      let eit = it.iterationMake().choose( e, k, k, true );
      eit.iterate();
      if( !it.canSibling() )
      break;
    }
  }

}

//

function _auxAscend( src )
{
  let it = this;
  let canSibling = true;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( let k in src ) /* xxx : implement test with e === undefined */
  {
    let e = src[ k ];
    let eit = it.iterationMake().choose( e, k, c, true );
    eit.iterate();
    canSibling = it.canSibling();
    c += 1;
    if( !canSibling )
    break;
  }

  if( canSibling )
  if( it.hasImplicit( src ) )
  {
    var props = _.props.onlyImplicit( src );

    for( var [ k, e ] of props )
    {
      if( _.props.implicit.is( k ) )
      debugger;
      let eit = it.iterationMake().choose( e, k, -1, true );
      eit.iterate();
      canSibling = it.canSibling();
      if( !canSibling )
      break;
    }

  }

}

//

function _hashMapAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( var [ k, e ] of src ) /* xxx : implement test with e === undefined */
  {
    let eit = it.iterationMake().choose( e, k, c, true );
    eit.iterate();
    c += 1;
    if( !it.canSibling() )
    break;
  }

}

//

function _setAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  let c = 0;
  for( let e of src ) /* xxx : implement test with e === undefined */
  {
    // let eit = it.iterationMake().choose( e, c, c, true );
    let eit = it.iterationMake().choose( e, e, c, true );
    eit.iterate();
    c += 1;
    if( !it.canSibling() )
    break;
  }

}

// --
// dichotomy
// --

function _isCountable( src )
{
  return _.countableIs( src );
}

//

function _isVector( src )
{
  return _.vectorIs( src );
}

//

function _isLong( src )
{
  return _.longIs( src );
}

//

function _isArray( src )
{
  return _.arrayIs( src );
}

//

function _isConstructibleLike( src )
{
  return _.constructibleLike( src );
}

//

function _isAux( src )
{
  return _.aux.isPrototyped( src );
}

//

function _false( src )
{
  return false;
}

// --
// etc
// --

function pathJoin( selectorPath, selectorName )
{
  let it = this;
  let result;

  _.assert( arguments.length === 2 );
  selectorPath = _.strRemoveEnd( selectorPath, it.upToken );
  result = selectorPath + it.defaultUpToken + selectorName;

  return result;
}

//

function errMake()
{
  let it = this;
  let err = _.looker.LookingError
  (
    ... arguments
  );
  debugger; /* eslint-disable-line no-debugger */
  return err;
}

// --
// expose
// --

/**
 * @function look
 * @class Tools.Looker
 */

function exec_head( routine, args )
{
  return routine.defaults.head( routine, args );
}

function exec_body( it )
{
  return it.execIt.body.call( this, it );
}

function execIt_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.object.isBasic( it.Looker ) );
  _.assert( _.prototype.isPrototypeFor( it.Looker, it ) );
  _.assert( it.looker === undefined );
  it.perform();
  return it;
}

//

/**
 * @function is
 * @class Tools.Looker
 */

function is( looker )
{
  if( !looker )
  return false;
  if( !looker.Looker )
  return false;
  return _.prototype.isPrototypeFor( looker, looker.Looker );
}

//

/**
 * @function iteratorIs
 * @class Tools.Looker
 */

function iteratorIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( it.iterator !== it )
  return false;
  return true;
}

//

/**
 * @function iterationIs
 * @class Tools.Looker
 */

function iterationIs( it )
{
  if( !it )
  return false;
  if( !it.Looker )
  return false;
  if( !it.iterator )
  return false;
  if( it.iterator === it )
  return false;
  return true;
}

//

function classDefine( o )
{

  _.routine.options_( classDefine, o );

  if( o.parent === null )
  o.parent = this.Looker;
  if( o.name === null )
  o.name = 'CustomLooker'

  _.assert( _.object.isBasic( o.parent ), `Parent should be object` );

  let looker = _.props.extend( null, o.parent );

  if( !o.looker || !o.looker.constructor || o.looker.constructor === Object )
  {
    let CustomLooker = (function()
    {
      return ({
        [ o.name ] : function(){},
      })[ o.name ];
    })();
    looker.constructor = CustomLooker;
    _.assert( looker.constructor.name === o.name );
  }

  if( o.prime )
  _.props.extend( looker, o.prime );
  if( o.looker )
  _.props.extend( looker, o.looker );
  if( o.iterator )
  _.props.extend( looker, o.iterator );
  if( o.iterationPreserve )
  _.props.supplement( looker, o.iterationPreserve );

  looker.Looker = looker;
  looker.OriginalLooker = looker;
  looker.Prime = Object.create( looker.Prime || null );
  if( o.prime )
  _.props.extend( looker.Prime, o.prime );
  Object.preventExtensions( looker.Prime );

  looker.exec = exec_functor( o.exec || looker.exec );
  looker.execIt = exec_functor( o.execIt || looker.execIt );

  let iterator = looker.Iterator = Object.assign( Object.create( null ), looker.Iterator );
  if( o.iterator )
  _.props.extend( iterator, o.iterator );

  let iteration = looker.Iteration = Object.assign( Object.create( null ), looker.Iteration );
  let iterationPreserve = looker.IterationPreserve = Object.assign( Object.create( null ), looker.IterationPreserve );
  if( o.iterationPreserve )
  {
    _.props.extend( iterationPreserve, o.iterationPreserve );
  }
  if( o.iteration )
  _.props.extend( iteration, o.iteration );

  if( Config.debug )
  validate();

  return looker;

  function exec_functor( original )
  {
    _.assert( _.routineIs( original.head ) );
    _.assert( _.routineIs( original.body ) );
    if( !original.body.defaults )
    original.body.defaults = looker;
    let exec = _.routine._amend
    ({
      dst : null,
      srcs : [ original, { defaults : looker } ],
      strategy : 'replacing',
      amending : 'extending',
    });
    _.assert( exec.defaults === looker );
    _.assert( exec.body.defaults === looker );
    return exec;
  }

  function validate()
  {
    /* qqq : add explanation for each assert */
    _.assert( looker.Prime.Looker === undefined );
    _.assert( _.routineIs( looker.iterableEval ) );
    _.assert( !_.props.has( looker.Iteration, 'src' ) && looker.Iteration.src === undefined );
    _.assert( _.props.has( looker.IterationPreserve, 'src' ) && looker.IterationPreserve.src === undefined );
    _.assert( _.props.has( looker, 'src' ) && looker.src === undefined );
    _.assert( !_.props.has( looker.Iteration, 'root' ) && looker.Iteration.root === undefined );
    _.assert( _.props.has( looker, 'root' ) && looker.root === undefined );
    if( _.props.has( looker, 'dst' ) )
    {
      _.assert( _.props.has( looker.Iteration, 'dst' ) && looker.Iteration.dst === undefined );
      _.assert( _.props.has( looker, 'dst' ) && looker.dst === undefined );
    }
    if( _.props.has( looker, 'result' ) )
    {
      _.assert( _.props.has( looker.Iterator, 'result' ) && looker.Iterator.result === undefined );
      _.assert( _.props.has( looker, 'result' ) && looker.result === undefined );
    }
  }

}

classDefine.defaults =
{
  name : null,
  parent : null,
  prime : null,
  looker : null,
  iterator : null,
  iteration : null,
  iterationPreserve : null,
  exec : null,
  execIt : null,
}

// --
// relations
// --

let LookingError = _.error.error_functor( 'LookingError' );

let ContainerNameToIdMap =
{
  'terminal' : 0,
  'countable' : 1,
  'aux' : 2,
  'hashMap' : 3,
  'set' : 4,
  'last' : 4,
}

let ContainerIdToNameMap =
{
  0 : 'terminal',
  1 : 'countable',
  2 : 'aux',
  3 : 'hashMap',
  4 : 'set',
}

let ContainerIdToAscendMap =
{
  0 : _termianlAscend,
  1 : _countableAscend,
  2 : _auxAscend,
  3 : _hashMapAscend,
  4 : _setAscend,
}

let WithCountableToIsElementalFunctionMap =
{
  'countable' : _isCountable,
  'vector' : _isVector,
  'long' : _isLong,
  'array' : _isArray,
  '' : _false,
}

let WithImplicitToHasImplicitFunctionMap =
{
  'constructible.like' : _isConstructibleLike,
  'aux' : _isAux,
  '' : _false,
}

let WithCountable =
{
  'countable' : 'countable',
  'vector' : 'vector',
  'long' : 'long',
  'array' : 'array',
  '' : '',
}

let WithImplicict =
{
  'aux' : 'aux',
  '' : '',
}

//

const Looker = Object.create( null );
const Self = Looker;

Looker.OriginalLooker = Looker;
Looker.constructor = function Looker() /* zzz : implement */
{
  _.assert( 0, 'not implemented' );
  let prototype = _.prototype.of( this );
  _.assert( _.object.isBasic( prototype ) );
  _.assert( prototype.exec.defaults === prototype );
  let result = this.head( prototype.exec, arguments );
  _.assert( result === this );
  return this;
}
Looker.Looker = Looker;
Looker.Iterator = null;
Looker.Iteration = null;
Looker.IterationPreserve = null;

// inter

Looker.head = head;
Looker.optionsFromArguments = optionsFromArguments;
Looker.optionsToIteration = optionsToIteration;

// iterator

Looker.iteratorProper = iteratorProper;
Looker.iteratorRetype = iteratorRetype;
Looker.iteratorInit = iteratorInit;
Looker.iteratorInitBegin = iteratorInitBegin;
Looker.iteratorInitEnd = iteratorInitEnd;
Looker.iteratorIterationMake = iteratorIterationMake;
Looker.iteratorCopy = iteratorCopy;

// iteration

Looker.iterationProper = iterationProper;
Looker.iterationMakeCommon = iterationMakeCommon;
Looker.iterationMake = iterationMake;

// perform

Looker.reperform = reperform;
Looker.perform = perform;
Looker.performBegin = performBegin;
Looker.performEnd = performEnd;

// choose

Looker.elementGet = elementGet;
Looker.choose = choose;
Looker.chooseBegin = chooseBegin;
Looker.chooseEnd = chooseEnd;
Looker.chooseRoot = chooseRoot;

// eval

Looker.srcChanged = srcChanged;
Looker.onSrcChanged = onSrcChanged;
Looker.iterableEval = iterableEval;
Looker.revisitedEval = revisitedEval;
Looker.isImplicit = isImplicit;

// iterate

Looker.iterate = iterate;
Looker.visitUp = visitUp;
Looker.visitUpBegin = visitUpBegin;
Looker.visitUpEnd = visitUpEnd;
Looker.onUp = onUp;
Looker.visitDown = visitDown;
Looker.visitDownBegin = visitDownBegin;
Looker.visitDownEnd = visitDownEnd;
Looker.onDown = onDown;
Looker.visitPush = visitPush;
Looker.visitPop = visitPop;
Looker.canVisit = canVisit;
Looker.canAscend = canAscend;
Looker.canSibling = canSibling;
Looker.ascend = ascend;
Looker.onAscend = onAscend;

// ascend

Looker._termianlAscend = _termianlAscend;
Looker.onTerminal = onTerminal;
Looker._countableAscend = _countableAscend;
Looker._auxAscend = _auxAscend;
Looker._hashMapAscend = _hashMapAscend;
Looker._setAscend = _setAscend;

// dichotomy

Looker._isCountable = _isCountable;
Looker._isVector = _isVector;
Looker._isLong = _isLong;
Looker._isArray = _isArray;
Looker._isConstructibleLike = _isConstructibleLike;
Looker._isAux = _isAux;
Looker._false = _false;

// etc

Looker.pathJoin = pathJoin;
Looker.errMake = errMake;

// feilds

Looker.LookingError = LookingError;
Looker.ContainerNameToIdMap = ContainerNameToIdMap;
Looker.ContainerIdToNameMap = ContainerIdToNameMap;
Looker.ContainerIdToAscendMap = ContainerIdToAscendMap;
Looker.WithCountableToIsElementalFunctionMap = WithCountableToIsElementalFunctionMap;
Looker.WithImplicitToHasImplicitFunctionMap = WithImplicitToHasImplicitFunctionMap;
Looker.WithCountable = WithCountable;
Looker.WithImplicict = WithImplicict;
Looker.Prime = Prime;

//

/**
 * @typedef {Object} Iterator
 * @property {} iterator = null
 * @property {} iterationMake = iterationMake
 * @property {} choose = choose
 * @property {} iterate = iterate
 * @property {} visitUp = visitUp
 * @property {} visitUpBegin = visitUpBegin
 * @property {} visitUpEnd = visitUpEnd
 * @property {} visitDown = visitDown
 * @property {} visitDownBegin = visitDownBegin
 * @property {} visitDownEnd = visitDownEnd
 * @property {} canVisit = canVisit
 * @property {} canAscend = canAscend
 * @property {} path = null
 * @property {} lastPath = null
 * @property {} lastIt = null
 * @property {} continue = true
 * @property {} key = null
 * @property {} error = null
 * @property {} visitedContainer = null
 * @class Tools.Looker
 */

let Iterator = Looker.Iterator = Object.create( null );

Iterator.src = undefined;
Iterator.iterator = null;
Iterator.iterationPrototype = null;
Iterator.path = null; /* xxx : remove? */
Iterator.lastPath = null;
Iterator.lastIt = null;
Iterator.continue = true;
Iterator.key = null; /* xxx : remove? */
Iterator.error = null;
Iterator.visitedContainer = null;
Iterator.isCountable = null;
Iterator.hasImplicit = null;
Iterator.fast = 0;
Iterator.recursive = Infinity;
Iterator.revisiting = 0;
Iterator.withCountable = 'array';
Iterator.withImplicit = 'aux';
Iterator.upToken = '/';
Iterator.defaultUpToken = null;
Iterator.path = null;
Iterator.level = 0;
Iterator.root = undefined;
Iterator.context = null;

_.props.extend( Looker, Iterator );
Object.freeze( Iterator );

//

/**
 * @typedef {Object} Iteration
 * @property {} childrenCounter = 0
 * @property {} level = 0
 * @property {} path = '/'
 * @property {} key = null
 * @property {} index = null
 * @property {} src = null
 * @property {} continue = true
 * @property {} ascending = true
 * @property {} revisited = false
 * @property {} _ = null
 * @property {} down = null
 * @property {} visiting = false
 * @property {} iterable = null
 * @property {} visitCounted = 1
 * @class Tools.Looker.Looker
 */

let Iteration = Looker.Iteration = Object.create( null );
Iteration.childrenCounter = 0;
Iteration.level = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.cardinal = null;
Iteration.originalKey = null;
Iteration.index = null;
Iteration.originalSrc = null;
Iteration.continue = true;
Iteration.ascending = true;
Iteration.revisited = false;
Iteration._ = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.visitCounting = true;
Object.freeze( Iteration );

//

/**
 * @typedef {Object} IterationPreserve
 * @property {} level = null
 * @property {} path = null
 * @property {} src = null
 * @class Tools.Looker.Looker
 */

let IterationPreserve = Looker.IterationPreserve = Object.create( null );
IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = undefined;
Object.freeze( IterationPreserve );

_.assert( !_.props.has( Looker.Iteration, 'src' ) && Looker.Iteration.src === undefined );
_.assert( _.props.has( Looker.IterationPreserve, 'src' ) && Looker.IterationPreserve.src === undefined );
_.assert( _.props.has( Looker, 'src' ) && Looker.src === undefined );
_.assert( !_.props.has( Looker.Iteration, 'root' ) && Looker.Iteration.root === undefined );
_.assert( _.props.has( Looker, 'root' ) && Looker.root === undefined );

_.map.assertHasAll( Looker, Prime );

//

exec_body.defaults = Looker;
let exec = _.routine.uniteReplacing( exec_head, exec_body );
Looker.exec = exec;

execIt_body.defaults = Looker;
let execIt = _.routine.uniteReplacing( exec_head, execIt_body );
Looker.execIt = execIt;

// --
// declare
// --

let LookerObjectExtension =
{

}

let LookerNamespaceExtension =
{

  name : 'looker',
  Looker,
  LookingError,

  look : exec,
  lookIt : execIt,

  is,
  iteratorIs,
  iterationIs,
  classDefine, /* qqq : cover please */

}

let ErrorExtension =
{

  LookingError,

}

let ToolsExtension =
{

  Looker,
  look : exec,

}

_.props.extend( _.looker, LookerNamespaceExtension );
_.props.extend( _.error, ErrorExtension );
_.props.extend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();

