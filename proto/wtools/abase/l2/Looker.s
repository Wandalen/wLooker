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

  let _ = require( '../../../wtools/Tools.s' );

}

let _global = _global_;
let _ = _global_.wTools;
let _ObjectHasOwnProperty = Object.hasOwnProperty;

_.looker = _.looker || Object.create( null );

_.assert( !!_realGlobal_ );

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
Prime.src = null;
Prime.root = null;
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
  // _.assert( o.Looker === routine.defaults );/* xxx : uncomment? */
  _.assertMapHasOnly( o, routine.defaults );
  _.assert
  (
    _.mapKeys( routine.defaults ).length === _.mapKeys( o.Looker ).length,
    () => `${_.mapKeys( routine.defaults ).length} <> ${_.mapKeys( o.Looker ).length}`
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

/* xxx : rename, merge with iteratorMake? */
function optionsForm( routine, o )
{

  o.Looker = o.Looker || routine.defaults;

  if( _.boolLike( o.withCountable ) )
  {
    if( o.withCountable )
    o.withCountable = 'countable';
    else
    o.withCountable = '';
  }
  if( _.boolLike( o.withImplicit ) )
  {
    if( o.withImplicit )
    o.withImplicit = 'aux';
    else
    o.withImplicit = '';
  }

  if( _.boolIs( o.recursive ) )
  o.recursive = o.recursive ? Infinity : 1;

  _.assert( o.iteratorProper( o ) );
  _.assert( _.objectIs( o.Looker ), 'Expects options {o.Looker}' );
  _.assert( o.Looker.Looker === o.Looker, 'Default of a routine and its default Looker are not in agreement' );
  _.assert( o.looker === undefined );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert
  (
    !Reflect.has( o, 'onUp' ) || o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3,
    'onUp should expect exactly three arguments'
  );
  _.assert
  (
    !Reflect.has( o, 'onDown' ) || o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3,
    'onDown should expect exactly three arguments'
  );
  _.assert( _.numberIsNotNan( o.recursive ), 'Expects number {- o.recursive -}' );
  _.assert( 0 <= o.revisiting && o.revisiting <= 2 );
  _.assert
  (
    _.longHas( [ 'countable', 'vector', 'long', 'array', '' ], o.withCountable ),
    'Unexpected value of option::withCountable'
  );
  _.assert
  (
    _.longHas( [ 'aux', '' ], o.withImplicit ),
    'Unexpected value of option::withImplicit'
  );

  if( o.Looker === null )
  o.Looker = Looker;

}

//

function optionsToIteration( iterator, o )
{
  _.assert( o.it === undefined );
  _.assert( _.mapIs( o ) );
  _.assert( !_.property.ownEnumerable( o, 'constructor' ) );
  _.assert( arguments.length === 2 );
  if( iterator === null )
  iterator = o.Looker.iteratorRetype( o );
  else
  Object.assign( iterator, o );
  o.Looker.iteratorInit( iterator );
  let it = iterator.iteratorIterationMake();
  if( !it.Looker.iterationProper( it ) )
  debugger;
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
  _.assert( _.objectIs( this.Iterator ) );
  _.assert( _.objectIs( this.Iteration ) );
  _.assert( _.objectIs( iterator.Looker ) );
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

  _.assert( arguments.length === 1 );
  _.assert( !_.mapIs( iterator ) );
  _.assert( _.objectIs( this.Iterator ) );
  _.assert( _.objectIs( this.Iteration ) );
  _.assert( _.objectIs( iterator.Looker ) );
  _.assert( iterator.Looker === this );
  _.assert( iterator.looker === undefined );
  _.assert( _.routineIs( iterator.iterableEval ) );
  _.assert( _.prototype.has( iterator.Looker, iterator.Looker.OriginalLooker ) );
  _.assert( iterator.iterator === null );

  iterator.iterator = iterator;

  iterator.optionsForm( iterator.exec, iterator );

  iterator.isCountable = iterator.withCountableToIsElementalFunctionMap[ iterator.withCountable ];
  iterator.hasImplicit = iterator.withImplicitToHasImplicitFunctionMap[ iterator.withImplicit ];

  if( iterator.revisiting < 2 )
  {
    if( iterator.revisiting === 0 )
    iterator.visitedContainer = _.containerAdapter.from( new Set );
    else
    iterator.visitedContainer = _.containerAdapter.from( new Array );
  }

  if( iterator.root === null )
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
 * Makes iterator for Looker.
 *
 * @param {Object} o - Options map
 * @function iteratorMake
 * @class Tools.Looker
 */

function iteratorMake( o )
{
  let iterator = this.iteratorRetype( o );
  this.iteratorInit( iterator );
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
  _.assert( _.objectIs( o ) )

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
  // _.assert( _.objectIs( it.iterator ) );
  // _.assert( _.objectIs( it.Looker ) );
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
  it.chooseRoot();
  return it.iterate(); /* xxx : should be same as perform? */
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
  it.src = it.src;
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

function elementGet( src, k )
{
  let it = this;
  let result;
  _.assert( arguments.length === 2, 'Expects two argument' );
  result = [ k, _.container.elementGet( src, k ) ];
  return result;
}

//

/**
 * @function choose
 * @class Tools.Looker
 */

function choose( e, k )
{
  let it = this;

  [ e, k ] = it.chooseBegin( e, k );
  _.assert( arguments.length === 2, 'Expects two argument' );

  if( e === undefined )
  [ k, e ] = it.elementGet( it.src, k );

  it.chooseEnd( e, k );

  it.srcChanged();
  it.revisitedEval( it.originalSrc );

  return it;
}

//

function chooseBegin( e, k )
{
  let it = this;

  _.assert( _.objectIs( it.down ) );
  _.assert( it.fast || it.level >= 0 );
  _.assert( it.originalKey === null );

  if( it.originalKey === null )
  it.originalKey = k;

  return [ e, k ];
}

//

function chooseEnd( e, k )
{
  let it = this;

  _.assert( arguments.length === 2, 'Expects two argument' );
  _.assert( _.objectIs( it.down ) );
  _.assert( it.fast || it.level >= 0 );

  /*
    assigning key and src should goes first
  */

  it.key = k;
  it.src = e;
  it.originalSrc = e;

  if( it.fast )
  return it;

  it.level = it.level+1;

  let k2 = k;
  if( k2 === null )
  k2 = e;
  if( !_.strIs( k2 ) )
  k2 = _.entity.exportStringShort( k2 );
  let hasUp = _.strIs( k2 ) && _.strHasAny( k2, it.upToken );
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
  it.iterable = null;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( it.isCountable( it.src ) )
  {
    it.iterable = it.containerNameToIdMap.countable;
  }
  else if( _.aux.is( it.src ) )
  {
    it.iterable = it.containerNameToIdMap.aux;
  }
  else if( _.hashMapLike( it.src ) )
  {
    it.iterable = it.containerNameToIdMap.hashMap;
  }
  else if( _.setLike( it.src ) )
  {
    it.iterable = it.containerNameToIdMap.set;
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
  return _.escape.is( it.key );
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

  return it.onAscend(); /* xxx : remove? */
}

//

function onAscend()
{
  let it = this;
  _.assert( !!it.containerIdToAscendMap[ it.iterable ], () => `No ascend for ${it.iterable}` );
  it.containerIdToAscendMap[ it.iterable ].call( it, it.src );
  // return it.ascendAct( it.src ); // xxx : clean
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

  if( _.entity.methodIteratorOf( src ) )
  {
    let k = 0;
    for( let e of src )
    {
      let eit = it.iterationMake().choose( e, k );
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
      let e = src[ k ];
      let eit = it.iterationMake().choose( e, k );
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

  for( let k in src )
  {
    let e = src[ k ];
    let eit = it.iterationMake().choose( e, k );
    eit.iterate();
    canSibling = it.canSibling();
    if( !canSibling )
    break;
  }

  if( canSibling )
  if( it.hasImplicit( src ) )
  {
    var props = _.property.onlyImplicit( src );

    for( var [ k, e ] of props )
    {
      let eit = it.iterationMake().choose( e, k );
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

  for( var [ k, e ] of src )
  {
    let eit = it.iterationMake().choose( e, k );
    eit.iterate();
    if( !it.canSibling() )
    break;
  }

}

//

function _setAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  for( let e of src )
  {
    let k = e;
    let eit = it.iterationMake().choose( e, k );
    eit.iterate();
    if( !it.canSibling() )
    break;
  }

}

// --
// typing
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
  /* xxx : group the error */
  let err = _.LookingError
  (
    ... arguments
  );
  debugger;
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
  _.assert( _.objectIs( it.Looker ) );
  _.assert( _.prototype.isPrototypeFor( it.Looker, it ) );
  _.assert( it.looker === undefined );
  it.perform();
  return it;
}

// exec_body.defaults = Prime;
//
// let look = _.routine.uniteCloning_( exec_head, exec_body );

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

  _.routineOptions( classDefine, o );

  if( o.parent === null )
  o.parent = this.Looker;
  if( o.name === null )
  o.name = 'CustomLooker'

  _.assert( _.objectIs( o.parent ) );

  let looker = _.mapExtend( null, o.parent );

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
  _.mapExtend( looker, o.prime );
  if( o.looker )
  _.mapExtend( looker, o.looker );
  if( o.iterator )
  _.mapExtend( looker, o.iterator );

  looker.Looker = looker;
  looker.OriginalLooker = looker;
  looker.Prime = Object.create( looker.Prime || null );
  if( o.prime )
  _.mapExtend( looker.Prime, o.prime );
  Object.preventExtensions( looker.Prime );

  looker.exec = exec_functor( o.exec || looker.exec );
  looker.execIt = exec_functor( o.execIt || looker.execIt );

  let iterator = looker.Iterator = Object.assign( Object.create( null ), looker.Iterator );
  if( o.iterator )
  _.mapExtend( iterator, o.iterator );

  let iteration = looker.Iteration = Object.assign( Object.create( null ), looker.Iteration );
  let iterationPreserve = looker.IterationPreserve = Object.assign( Object.create( null ), looker.IterationPreserve );
  if( o.iterationPreserve )
  {
    _.mapExtend( iterationPreserve, o.iterationPreserve );
  }
  if( o.iteration )
  _.mapExtend( iteration, o.iteration );

  _.assert( looker.Prime.Looker === undefined );
  _.assert( _.routineIs( looker.iterableEval ) );

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

let containerNameToIdMap =
{
  'terminal' : 0,
  'countable' : 1,
  'aux' : 2,
  'hashMap' : 3,
  'set' : 4,
  'last' : 4,
}

let containerIdToNameMap =
{
  0 : 'terminal',
  1 : 'countable',
  2 : 'aux',
  3 : 'hashMap',
  4 : 'set',
}

let containerIdToAscendMap =
{
  0 : _termianlAscend,
  1 : _countableAscend,
  2 : _auxAscend,
  3 : _hashMapAscend,
  4 : _setAscend,
}

let withCountableToIsElementalFunctionMap =
{
  'countable' : _isCountable,
  'vector' : _isVector,
  'long' : _isLong,
  'array' : _isArray,
  '' : _false,
}

let withImplicitToHasImplicitFunctionMap =
{
  'constructible.like' : _isConstructibleLike,
  'aux' : _isAux,
  '' : _false,
}

//

// const Looker = Prime.Looker = Object.create( null );
const Looker = Object.create( null );
const Self = Looker;

Looker.OriginalLooker = Looker;
Looker.constructor = function Looker() /* xxx : implement */
{
  debugger;
  let prototype = _.prototype.of( this );
  _.assert( _.object.is( prototype ) );
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

// Looker.exec = look;
Looker.head = head;
Looker.optionsFromArguments = optionsFromArguments;
Looker.optionsForm = optionsForm;
Looker.optionsToIteration = optionsToIteration;

// iterator

Looker.iteratorProper = iteratorProper;
Looker.iteratorRetype = iteratorRetype;
Looker.iteratorInit = iteratorInit;
Looker.iteratorMake = iteratorMake;
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

// typing

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
Looker.containerNameToIdMap = containerNameToIdMap;
Looker.containerIdToNameMap = containerIdToNameMap;
Looker.containerIdToAscendMap = containerIdToAscendMap;
Looker.withCountableToIsElementalFunctionMap = withCountableToIsElementalFunctionMap;
Looker.withImplicitToHasImplicitFunctionMap = withImplicitToHasImplicitFunctionMap;
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

Iterator.src = undefined; /* xxx yyy */
Iterator.iterator = null;
Iterator.iterationPrototype = null;
Iterator.path = null;
Iterator.lastPath = null;
Iterator.lastIt = null;
Iterator.continue = true;
Iterator.key = null;
Iterator.error = null;
Iterator.visitedContainer = null;
Iterator.isCountable = null;
Iterator.hasImplicit = null;
// Iterator.onUp = onUp;
// Iterator.onDown = onDown;
// Iterator.onAscend = onAscend;
// Iterator.onTerminal = onTerminal;
// Iterator.onSrcChanged = onSrcChanged;
// Iterator.pathJoin = pathJoin;
Iterator.fast = 0;
Iterator.recursive = Infinity;
Iterator.revisiting = 0;
Iterator.withCountable = 'array';
Iterator.withImplicit = 'aux';
Iterator.upToken = '/';
Iterator.defaultUpToken = null;
Iterator.path = null;
Iterator.level = 0;
Iterator.src = null;
Iterator.root = null;
Iterator.context = null;

// _.mapSupplement( Iterator, Prime );
_.mapExtend( Looker, Iterator ); /* xxx : use? */
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

_.assert( Looker.Iteration.src === undefined );

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
IterationPreserve.src = null;
Object.freeze( IterationPreserve );

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

let ToolsExtension =
{

  Looker,
  LookingError,
  look : exec,

}

_.mapExtend( _.looker, LookerNamespaceExtension );
_.mapExtend( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
