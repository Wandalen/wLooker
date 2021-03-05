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
 * @typedef {Object} Defaults
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

let Defaults = Object.create( null );

/* xxx : avoid writing each field into o-map */
Defaults.onUp = onUp;
Defaults.onDown = onDown;
Defaults.onAscend = onAscend;
Defaults.onTerminal = onTerminal;
Defaults.onSrcChanged = onSrcChanged;
Defaults.pathJoin = pathJoin;
Defaults.fast = 0;
Defaults.recursive = Infinity;
Defaults.revisiting = 0;
Defaults.withCountable = 'array';
Defaults.withImplicit = 'aux';
Defaults.upToken = '/';
Defaults.defaultUpToken = null;
Defaults.path = null;
Defaults.level = 0;
Defaults.src = null;
Defaults.root = null;
Defaults.context = null;
Defaults.Looker = null;

// --
// options
// --

function head( routine, args )
{
  _.assert( arguments.length === 2 );
  let o = Self.optionsFromArguments( args );
  o.Looker = o.Looker || routine.defaults.Looker || Self;
  _.routineOptionsPreservingUndefines( routine, o );
  o.Looker.optionsForm( routine, o );
  let it = o.Looker.optionsToIteration( o );
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

function optionsForm( routine, o )
{

  o.Looker = o.Looker || routine.defaults.Looker;

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

  _.assert( _.aux.is( o ) );
  _.assert( _.objectIs( o.Looker ), 'Expects options {o.Looker}' );
  _.assert( o.Looker.Looker === o.Looker );
  _.assert( o.looker === undefined );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should expect exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onDown should expect exactly three arguments' );
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

function optionsToIteration( o )
{
  _.assert( o.it === undefined );
  _.assert( _.mapIs( o ) );
  let iterator = o.Looker.iteratorMake( o );
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

/**
 * Makes iterator for Looker.
 *
 * @param {Object} o - Options map
 * @function iteratorMake
 * @class Tools.Looker
 */

function iteratorMake( o )
{

  _.assert( arguments.length === 1 );
  _.assert( _.mapIs( o ) );
  _.assert( _.objectIs( this.Iterator ) );
  _.assert( _.objectIs( this.Iteration ) );
  _.assert( _.objectIs( o.Looker ) );
  _.assert( o.Looker === this );
  _.assert( o.looker === undefined );

  /* */

  let iterator = o;
  _.mapSupplement( iterator, this.Iterator );
  _.mapSupplement( iterator, this.Iteration ); /* yyy */
  Object.setPrototypeOf( iterator, iterator.Looker );
  /*
  setPrototypeOf should follow mapSupplement
  */
  if( o.iteratorExtension )
  Object.assign( iterator, o.iteratorExtension );
  delete iterator.it;

  Object.preventExtensions( iterator );

  iterator.iterator = iterator;
  iterator.isCountable = _.looker.withCountableToIsElementalFunctionMap[ o.withCountable ];
  iterator.hasImplicit = _.looker.withImplicitToHasImplicitFunctionMap[ o.withImplicit ];

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

  /* yyy */
  iterator.iterationPrototype = Object.create( iterator );
  Object.assign( iterator.iterationPrototype, iterator.Looker.Iteration ); /* xxx : optimize */
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

  /* important assert, otherwise copying options from iteration could cause problem */
  _.assert( iterator.it === undefined );
  if( !iterator.fast )
  {
    _.assert( _.numberIs( iterator.level ) );
    _.assert( _.strIs( iterator.defaultUpToken ) );
    _.assert( _.strIs( iterator.path ) );
    _.assert( _.strIs( iterator.lastPath ) );
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
  let newIt = it.iterationMake();
  newIt.down = null;
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

/**
 * @function iterationMake
 * @class Tools.Looker
 */

function iterationMake() /* xxx : merge with act */
{
  let it = this;

  // _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.assert( it.level >= 0 );
  // _.assert( _.objectIs( it.iterator ) );
  // _.assert( _.objectIs( it.Looker ) );
  // _.assert( it.looker === undefined );
  // _.assert( _.numberIs( it.level ) && it.level >= 0 );
  // _.assert( !!it.iterationPrototype );

  let newIt = Object.create( it.iterationPrototype );

  if( it.Looker === Self ) /* zzz : achieve such optimization automatically */
  {
    newIt.level = it.level;
    newIt.path = it.path;
    newIt.src = it.src;
    // newIt./*srcEffective*/src = it./*srcEffective*/src;
  }
  else
  {
    for( let k in it.Looker.IterationPreserve )
    newIt[ k ] = it[ k ];
  }

  // if( it.iterator !== it )
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
  it.chooseRoot( src );
  it.iterable = null;
  return it.iterate();
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
  // Parent.performBegin.apply( it, arguments );

  _.assert( arguments.length === 0 );
  _.assert( it.iterationProper( it ) );

  it.chooseRoot( it.src );

  return it;
}

//

function performEnd()
{
  let it = this;

  _.assert( it.iterationProper( it ) );

  // Parent.performEnd.apply( it, arguments );
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
  [ k, e ] = it.elementGet( it./*srcEffective*/src, k );

  it.chooseEnd( e, k );
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
  /* xxx : introduce originalKey2 for equaler */

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
  it.path = it.pathJoin( it.path, /*it.upToken, it.defaultUpToken,*/ k2 );
  it.iterator.lastPath = it.path;
  it.iterator.lastIt = it;

  return it;
}

//

function chooseRoot( e )
{
  let it = this;

  _.assert( arguments.length === 1 );

  it.src = e;
  it.originalSrc = e;

  return it;
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

  // if( it.continue === _.dont ) /* yyy : remove */
  // it.continue = false;
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

  if( it.continue )
  it.srcChanged();

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
  // _.assert( arguments.length === 0, 'Expects no arguments' );
  return it.ascendAct( it./*srcEffective*/src );
}

// --
// eval
// --

/* xxx : overlap with choose */
function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  // it.effectiveEval();

  it.iterableEval();

  if( it.onSrcChanged )
  it.onSrcChanged();

  it.ascendEval();

  it.revisitedEval( it.originalSrc );

}

//

function onSrcChanged()
{
}

//

// /* xxx : remove */
// function effectiveEval()
// {
//   let it = this;
//
//   it./*srcEffective*/src = it.src;
//
// }

//

function iterableEval()
{
  let it = this;
  it.iterable = null;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  if( it.isCountable( it./*srcEffective*/src ) )
  {
    it.iterable = _.looker.containerNameToIdMap.countable;
  }
  else if( _.aux.is( it./*srcEffective*/src ) )
  {
    it.iterable = _.looker.containerNameToIdMap.aux;
  }
  else if( _.hashMapLike( it./*srcEffective*/src ) )
  {
    it.iterable = _.looker.containerNameToIdMap.hashMap;
  }
  else if( _.setLike( it./*srcEffective*/src ) )
  {
    it.iterable = _.looker.containerNameToIdMap.set;
  }
  else
  {
    it.iterable = 0;
  }

  _.assert( it.iterable >= 0 );
}

//

function ascendEval()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  it.ascendAct = _.looker.containerIdToAscendMap[ it.iterable ];

  _.assert( _.routineIs( it.ascendAct ) );

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

function _mapAscend( src )
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
  debugger;
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
  let err = _.ErrorLooking
  (
    ... arguments
  );
  debugger;
  return err;
}

// --
// expose
// --

function look_head( routine, args )
{
  return Self.head( routine, args );
}

//

function look_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.Looker ) );
  _.assert( _.prototype.isPrototypeFor( it.Looker, it ) );
  _.assert( it.looker === undefined );

  it.perform();

  return it;
}

look_body.defaults = Object.create( Defaults );

//

/**
 * @function look
 * @class Tools.Looker
 */

let lookAll = _.routineUnite( look_head, look_body );

var defaults = lookAll.defaults;
defaults.recursive = Infinity;

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

function define( o )
{

  _.routineOptions( define, o );

  if( o.parent === null )
  o.parent = _.Looker;
  if( o.name === null )
  o.name = 'CustomLooker'

  /* xxx : try to use extend instead */
  let looker = Object.create( o.parent );
  looker.Looker = looker;

  if( !o.looker || !o.looker.constructor || o.looker.constructor === Object )
  {
    looker.constructor = (function()
    {
      return ({
        [ o.name ] : function(){},
      })[ o.name ];
    })();
    _.assert( looker.constructor.name === o.name );
  }
  if( o.looker )
  _.mapExtend( looker, o.looker );

  if( o.defaultsSubtraction )
  o.defaults = o.defaults || Object.create( null );
  if( o.defaults )
  looker.exec = exec_functor( looker.exec, o.defaults, o.defaultsSubtraction );

  let iterator = looker.Iterator = Object.assign( Object.create( null ), looker.Iterator );
  if( o.iterator )
  _.mapExtend( iterator, o.iterator );

  let iteration = looker.Iteration = Object.assign( Object.create( null ), looker.Iteration );
  if( o.iteration )
  _.mapExtend( iteration, o.iteration );

  let iterationPreserve = looker.IterationPreserve = Object.assign( Object.create( null ), looker.IterationPreserve );
  if( o.iterationPreserve )
  {
    _.mapExtend( iterationPreserve, o.iterationPreserve );
    _.mapExtend( iteration, o.iterationPreserve ); /* yyy */
  }

  return looker;

  function exec_functor( original, defaults, defaultsSubtraction )
  {
    _.assert( _.routineIs( original ) );
    _.assert( _.routineIs( original.head ) );
    _.assert( _.routineIs( original.body ) );
    _.assert( _.aux.is( original.defaults ) );
    let exec = _.routineUnite( original.head, original.body );
    exec.defaults = { ... original.defaults, ... defaults };
    // if( defaultsSubtraction )
    // debugger;
    if( defaultsSubtraction )
    _.mapBut_( exec.defaults, exec.defaults, defaultsSubtraction );
    return exec;
  }
}

define.defaults =
{
  name : null,
  parent : null,
  defaults : null,
  defaultsSubtraction : null,
  looker : null,
  iterator : null,
  iteration : null,
  iterationPreserve : null,
}

// --
// relations
// --

/**
 * @typedef {Object} looker
 * @property {Object} Looker
 * @property {Object} Iterator
 * @property {Object} Iteration
 * @property {Boolean} IterationPreserve
 * @property {} iterator
 * @class Tools.Looker.Defaults
 */

let Looker = Defaults.Looker = Object.create( null );

Looker.constructor = function Looker(){};
Looker.Looker = Looker;
Looker.Iterator = null;
Looker.Iteration = null;
Looker.IterationPreserve = null;

// inter

/* xxx : sort */
Looker.exec = lookAll;
Looker.head = head;
Looker.optionsFromArguments = optionsFromArguments;
Looker.optionsForm = optionsForm;
Looker.optionsToIteration = optionsToIteration;

// iterator

Looker.iteratorProper = iteratorProper;
Looker.iteratorMake = iteratorMake;
Looker.iteratorIterationMake = iteratorIterationMake;
Looker.iteratorCopy = iteratorCopy;

// iteration

Looker.iterationProper = iterationProper;
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

// eval

Looker.srcChanged = srcChanged;
Looker.onSrcChanged = onSrcChanged;
// Looker.effectiveEval = effectiveEval;
Looker.iterableEval = iterableEval;
Looker.ascendEval = ascendEval;
Looker.revisitedEval = revisitedEval;

// ascend

Looker._termianlAscend = _termianlAscend;
Looker.onTerminal = onTerminal;
Looker._countableAscend = _countableAscend;
Looker._mapAscend = _mapAscend;
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
 * @class Tools.Looker.Defaults.Looker
 */

let Iterator = Looker.Iterator = Object.create( null );

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

_.mapSupplement( Iterator, Defaults );
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
 * @class Tools.Looker.Defaults.Looker
 */

let Iteration = Looker.Iteration = Object.create( null );
Iteration.childrenCounter = 0;
Iteration.level = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.originalKey = null;
Iteration.index = null;
Iteration.src = null;
// Iteration./*srcEffective*/src = null; /* xxx : replace by another mechanism with originalSrc */
Iteration.originalSrc = null;
Iteration.continue = true;
Iteration.ascending = true;
Iteration.ascendAct = null;
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
 * @class Tools.Looker.Defaults.Looker
 */

let IterationPreserve = Looker.IterationPreserve = Object.create( null );
IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = null;
// IterationPreserve./*srcEffective*/src = null;
Object.freeze( IterationPreserve );

// --
// declare
// --

let ErrorLooking = _.error.error_functor( 'ErrorLooking' );

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
  2 : _mapAscend,
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

let LookerExtension =
{

  Looker,
  ErrorLooking,

  containerNameToIdMap,
  containerIdToNameMap,
  containerIdToAscendMap,
  withCountableToIsElementalFunctionMap,
  withImplicitToHasImplicitFunctionMap,

  look : lookAll,
  lookAll,

  is,
  iteratorIs,
  iterationIs,
  define, /* qqq : cover please */

}

let ToolsExtension =
{

  Looker,
  ErrorLooking,

  look : lookAll,
  lookAll,

}

let Self = Looker;
_.mapSupplement( _.looker, LookerExtension );
_.mapSupplement( _, ToolsExtension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
