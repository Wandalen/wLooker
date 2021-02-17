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
 * @namespace Tools.looker
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
 * @property {Boolean} iterationPreserve = null
 * @property {*} iterationExtension = null
 * @property {*} iteratorExtension = null
 * @namespace Tools.looker
 */

let Defaults = Object.create( null );

Defaults.onUp = onUp;
Defaults.onDown = onDown;
Defaults.onAscend = onAscend;
Defaults.onTerminal = onTerminal;
Defaults.onSrcChanged = onSrcChanged;
Defaults.onPathJoin = onPathJoin;
Defaults.fast = 0;
Defaults.recursive = Infinity;
Defaults.revisiting = 0;
Defaults.withPartible = 'array';
Defaults.withImplicit = 'map.like';
Defaults.upToken = '/';
Defaults.defaultUpToken = null;
Defaults.path = null;
Defaults.level = 0;
Defaults.src = null;
Defaults.root = null;
Defaults.context = null;
Defaults.Looker = null;
Defaults.it = null;
Defaults.iterationPreserve = null;
Defaults.iterationExtension = null;
Defaults.iteratorExtension = null;

//

/**
 * @typedef {Object} looker
 * @property {Object} Looker
 * @property {Object} Iterator
 * @property {Object} Iteration
 * @property {Boolean} IterationPreserve
 * @property {} iterator
 * @namespace Tools.looker.Defaults
 */

let Looker = Defaults.Looker = Object.create( null );

Looker.constructor = function Looker(){};
Looker.Looker = Looker;
Looker.Iterator = null;
Looker.Iteration = null;
Looker.IterationPreserve = null;

Looker.iteratorIs = iteratorIs;
Looker.iteratorMake = iteratorMake;
Looker.iteratorCopy = iteratorCopy;

Looker.iterationIs = iterationIs;
Looker.iterationMake = iterationMake;
Looker._iterationMakeAct = _iterationMakeAct;
Looker.choose = choose;

Looker.relook = relook;
Looker.start = start;
Looker.look = look;
Looker.visitUp = visitUp;
Looker.visitUpBegin = visitUpBegin;
Looker.visitUpEnd = visitUpEnd;
Looker.visitDown = visitDown;
Looker.visitDownBegin = visitDownBegin;
Looker.visitDownEnd = visitDownEnd;
Looker.visitPush = visitPush;
Looker.visitPop = visitPop;
Looker.canVisit = canVisit;

Looker.canAscend = canAscend;
Looker.canSibling = canSibling;
Looker.ascend = ascend;

Looker._termianlAscend = _termianlAscend;
Looker._elementalAscend = _elementalAscend;
Looker._mapAscend = _mapAscend;
Looker._hashMapAscend = _hashMapAscend;
Looker._setAscend = _setAscend;
Looker._customAscend = _customAscend;

Looker.srcChanged = srcChanged;
Looker.effectiveEval = effectiveEval;
Looker.iterableEval = iterableEval;
Looker.ascendEval = ascendEval;
Looker.revisitedEval = revisitedEval;

//

/**
 * @typedef {Object} Iterator
 * @property {} iterator = null
 * @property {} _iterationMakeAct = _iterationMakeAct
 * @property {} iterationMake = iterationMake
 * @property {} choose = choose
 * @property {} look = look
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
 * @property {} lastSelected = null
 * @property {} continue = true
 * @property {} key = null
 * @property {} error = null
 * @property {} visitedContainer = null
 * @namespace Tools.looker.Defaults.Looker
 */

let Iterator = Looker.Iterator = Object.create( null );

Iterator.iterator = null;
Iterator.path = null;
Iterator.lastPath = null;
Iterator.lastSelected = null;
Iterator.continue = true;
Iterator.key = null;
Iterator.error = null;
Iterator.visitedContainer = null;
Iterator.isPartible = null;
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
 * @namespace Tools.looker.Defaults.Looker
 */

let Iteration = Looker.Iteration = Object.create( null );
Iteration.childrenCounter = 0;
Iteration.level = 0;
Iteration.path = '/';
Iteration.key = null;
Iteration.index = null;
Iteration.containerType = null;
Iteration.src = null;
Iteration.srcEffective = null; /* xxx : replace by another mechanism with srcOriginal */
Iteration.continue = true;
Iteration.ascending = true;
Iteration.ascendAct = null;
Iteration.revisited = false; 
Iteration._ = null;
Iteration.down = null;
Iteration.visiting = false;
Iteration.iterable = null;
Iteration.visitCounting = true;
Iteration.isImplicit = false;
Object.freeze( Iteration );

//

/**
 * @typedef {Object} IterationPreserve
 * @property {} level = null
 * @property {} path = null
 * @property {} src = null
 * @namespace Tools.looker.Defaults.Looker
 */

let IterationPreserve = Looker.IterationPreserve = Object.create( null );
IterationPreserve.level = null;
IterationPreserve.path = null;
IterationPreserve.src = null;
IterationPreserve.srcEffective = null;
Object.freeze( IterationPreserve );

// --
// iterator
// --

function iteratorIs( it )
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
 * @namespace Tools.looker
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

  let iterator = Object.create( o.Looker );
  Object.assign( iterator, this.Iterator );
  Object.assign( iterator, o ); /* xxx : try to retype o */
  if( o.iteratorExtension )
  Object.assign( iterator, o.iteratorExtension );
  Object.preventExtensions( iterator );

  delete iterator.it;

  iterator.iterator = iterator;
  iterator.isPartible = _.looker.withPartibleToIsElementalFunctionMap[ o.withPartible ];
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

  if( iterator.defaultUpToken === null && !iterator.fast )
  iterator.defaultUpToken = _.strsShortest( iterator.upToken );

  if(  iterator.fast )
  {
    delete iterator.childrenCounter;
    delete iterator.level;
    delete iterator.path;
    delete iterator.lastPath;
    delete iterator.lastSelected;
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
  if( it.constructor !== this.constructor )
  return false;
  return true;
}

//

/**
 * @function iterationMake
 * @namespace Tools.looker
 */

function iterationMake()
{
  let it = this;
  let newIt = it._iterationMakeAct();

  // _.assert( arguments.length === 0, 'Expects no arguments' );

  return newIt;
}

//

/**
 * @function _iterationMakeAct
 * @namespace Tools.looker
 */

function _iterationMakeAct()
{
  let it = this;

  // _.assert( arguments.length === 0, 'Expects no arguments' );
  // _.assert( it.level >= 0 );
  // _.assert( _.objectIs( it.iterator ) );
  // _.assert( _.objectIs( it.Looker ) );
  // _.assert( it.looker === undefined );
  // _.assert( _.numberIs( it.level ) && it.level >= 0 );

  let newIt = Object.create( it.iterator );
  Object.assign( newIt, it.Looker.Iteration );
  if( it.iterator.iterationExtension )
  Object.assign( newIt, it.iterator.iterationExtension );
  Object.preventExtensions( newIt );

  _.assert( newIt.isImplicit === false );

  for( let k in it.Looker.IterationPreserve )
  newIt[ k ] = it[ k ];

  if( it.iterationPreserve )
  for( let k in it.iterationPreserve )
  newIt[ k ] = it[ k ];

  if( it.iterator !== it )
  newIt.down = it;

  return newIt;
}

//

/**
 * @function choose
 * @namespace Tools.looker
 */

function choose( e, k )
{
  let it = this;

  _.assert( arguments.length === 2, 'Expects two argument' );
  _.assert( _.objectIs( it.down ) );
  _.assert( it.fast || it.level >= 0 );

  if( e === undefined )
  {
    if( it.down )
    e = _.container.elementGet( it.srcEffective, k, it.down.containerType || false );
    else
    e = _.container.elementGet( it.srcEffective, k );
  }

  /*
    assigning key / src should goes first
  */

  it.key = k;
  it.src = e;

  if( !it.fast )
  {
    it.level = it.level+1;

    let k2 = k;
    if( k2 === null )
    k2 = e;
    if( !_.strIs( k2 ) )
    k2 = _.strEntityShort( k2 );
    let hasUp = _.strIs( k2 ) && _.strHasAny( k2, it.upToken );
    if( hasUp )
    k2 = '"' + k2 + '"';

    it.index = it.down.childrenCounter;
    it.path = it.onPathJoin( it.path, it.upToken, it.defaultUpToken, k2 );

    it.iterator.lastPath = it.path;
    it.iterator.lastSelected = it;
  }

  return it;
}

// --
// visit
// --

function relook( src )
{
  let it = this;
  _.assert( arguments.length === 1 );
  it.src = src;
  it.iterable = null;
  return it.look();
}

//

function start()
{
  let it = this;
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return it.look();
}

//

/**
 * @function look
 * @namespace Tools.looker
 */

function look()
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
 * @namespace Tools.looker
 */

function visitUp()
{
  let it = this;

  it.visitUpBegin();

  _.assert( _.routineIs( it.onUp ) );
  let r = it.onUp.call( it, it.src, it.key, it );
  _.assert( r === undefined );

  if( it.continue === _.dont )
  it.continue = false;
  _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.strType( it.continue ) );

  it.visitUpEnd()

}

//

/**
 * @function visitUpBegin
 * @namespace Tools.looker
 */

function visitUpBegin()
{
  let it = this;

  it.ascending = true;

  _.assert( it.visiting );

  if( it.down && !it.fast )
  it.down.childrenCounter += 1;

  if( it.continue )
  it.srcChanged();

}

//

/**
 * @function visitUpEnd
 * @namespace Tools.looker
 */

function visitUpEnd()
{
  let it = this;

  // if( it.continue === _.dont )
  // it.continue = false;
  // _.assert( _.boolIs( it.continue ), () => 'Expects boolean it.continue, but got ' + _.strType( it.continue ) );

  it.visitPush();

}

//

/**
 * @function visitDown
 * @namespace Tools.looker
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
 * @namespace Tools.looker
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
 * @namespace Tools.looker
 */

function visitDownEnd()
{
  let it = this;
}

//

function visitPush()
{
  let it = this;

  if( it.iterator.visitedContainer )
  if( it.visitCounting && it.iterable )
  {
    it.iterator.visitedContainer.push( it.src );
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
      Object.is( it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ], it.src ),
      () => `Top-most visit ${it.path} does not match ${it.src} <> ${
        it.iterator.visitedContainer.original[ it.iterator.visitedContainer.original.length-1 ]}`
    );
    it.iterator.visitedContainer.pop( it.src );
    it.visitCounting = false;
  }

}

//

/**
 * @function canVisit
 * @namespace Tools.looker
 */

function canVisit()
{
  let it = this;

  if( !it.recursive && it.down )
  return false;

  // if( !it.withStem && it.root === it.src )
  // return false;

  return true;
}

//

/**
 * @function canAscend
 * @namespace Tools.looker
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
  _.assert( arguments.length === 0, 'Expects no arguments' );
  return it.ascendAct( it.srcEffective );
}

//

function _termianlAscend( src )
{
  let it = this;

  _.assert( arguments.length === 1 );

  it.onTerminal( src );

}

//

function _elementalAscend( src )
{
  let it = this;

  if( _.entity.methodIteratorOf( src ) )
  {
    let k = 0;
    for( let e of src )
    {
      let eit = it.iterationMake().choose( e, k );
      eit.look();
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
      eit.look();
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
    eit.look();
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
      debugger;
      let eit = it.iterationMake().choose( e, k );
      eit.isImplicit = true;
      eit.look();
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
    eit.look();
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
    eit.look();
    if( !it.canSibling() )
    break;
  }

}

//

function _customAscend( src )
{
  let it = this;
  let containerType = it.containerType;

  _.assert( arguments.length === 1 );

  containerType._while( src, ( e, k ) =>
  {
    let eit = it.iterationMake().choose( e, k );
    eit.look();
    if( !it.canSibling() )
    return;
    return true;
  });

}

//

function srcChanged()
{
  let it = this;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  it.effectiveEval();

  // if( it.iterable === null ) // xxx : uncomment later, maybe?
  it.iterableEval();

  if( it.onSrcChanged )
  it.onSrcChanged();

  it.ascendEval();

  it.revisitedEval( it.src );

}

//

function effectiveEval()
{
  let it = this;

  it.srcEffective = it.src;

}

//

function iterableEval()
{
  let it = this;
  it.iterable = null;

  _.assert( arguments.length === 0, 'Expects no arguments' );

  _.debugger;
  let containerType = _.container.typeOf( it.srcEffective );
  if( containerType )
  {
    it.iterable = _.looker.containerNameToIdMap.custom;
    it.containerType = containerType;
  }
  // else if( _.arrayLike( it.srcEffective ) )
  // else if( _.iterableIs_( it.srcEffective ) )
  else if( it.isPartible( it.srcEffective ) )
  {
    it.iterable = _.looker.containerNameToIdMap.long;
  }
  else if( _.auxiliary.is( it.srcEffective ) )
  {
    it.iterable = _.looker.containerNameToIdMap.map;
  }
  else if( _.hashMapLike( it.srcEffective ) )
  {
    it.iterable = _.looker.containerNameToIdMap.hashMap;
  }
  else if( _.setLike( it.srcEffective ) )
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
  // _.assert( it.iterable === null ); // xxx : uncomment later, maybe?

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
// is partible
// --

function _isPartible( src )
{
  return _.partibleIs( src );
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

function _false( src )
{
  return false;
}

//

function _isConstructibleLike( src )
{
  debugger;
  return _.constructibleLike( src );
}

//

function _isMapLike( src )
{
  return _.auxiliary.isPrototyped( src );
}

// --
// handler
// --

function onUp( e, k, it )
{
}

//

function onDown( e, k, it )
{
}

//

function onTerminal()
{
  let it = this;
  return it;
}

//

function onSrcChanged()
{
}

//

function onPathJoin( /* selectorPath, upToken, defaultUpToken, selectorName */ )
{
  let it = this;
  let result;

  let selectorPath = arguments[ 0 ];
  let upToken = arguments[ 1 ];
  let defaultUpToken = arguments[ 2 ];
  let selectorName = arguments[ 3 ];

  _.assert( arguments.length === 4 );

  if( _.strEnds( selectorPath, upToken ) )
  {
    result = selectorPath + selectorName;
  }
  else
  {
    result = selectorPath + defaultUpToken + selectorName;
  }

  return result;
}

// --
// expose
// --

function look_head( routine, args )
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
  else _.assert( 0, 'look expects single options map, 2 or 3 arguments' );

  o.Looker = o.Looker || routine.defaults.Looker;

  if( _.boolLike( o.withPartible ) )
  {
    if( o.withPartible )
    o.withPartible = 'partible';
    else
    o.withPartible = '';
  }
  if( _.boolLike( o.withImplicit ) )
  {
    if( o.withImplicit )
    o.withImplicit = 'map.like';
    else
    o.withImplicit = '';
  }

  if( _.boolIs( o.recursive ) )
  o.recursive = o.recursive ? Infinity : 1;
  if( o.iterationPreserve )
  o.iterationExtension = _.mapSupplement( o.iterationExtension, o.iterationPreserve );
  if( o.iterationPreserve )
  o.iteratorExtension = _.mapSupplement( o.iteratorExtension, o.iterationPreserve );

  _.routineOptionsPreservingUndefines( routine, o );
  _.assert( _.objectIs( o.Looker ), 'Expects options {o.Looker}' );
  _.assert( o.Looker.Looker === o.Looker );
  _.assert( o.looker === undefined );
  _.assert( args.length === 1 || args.length === 2 || args.length === 3 );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( o.onUp === null || o.onUp.length === 0 || o.onUp.length === 3, 'onUp should expect exactly three arguments' );
  _.assert( o.onDown === null || o.onDown.length === 0 || o.onDown.length === 3, 'onDown should expect exactly three arguments' );
  _.assert( _.numberIsNotNan( o.recursive ), 'Expects number {- o.recursive -}' );

  _.assert( 0 <= o.revisiting && o.revisiting <= 2 );
  _.assert
  (
    _.longHas( [ 'partible', 'vector', 'long', 'array', '' ], o.withPartible ),
    'Unexpected value of option::withPartible'
  );
  _.assert
  (
    _.longHas( [ 'map.like', '' ], o.withImplicit ),
    'Unexpected value of option::withImplicit'
  );

  if( o.Looker === null )
  o.Looker = Looker;

  if( o.it === null || o.it === undefined )
  {
    let iterator = o.Looker.iteratorMake( o );
    o.it = iterator.iterationMake();
    return o.it;
  }
  else
  {

    o.it.iterator.iteratorCopy( o );

  }

  return o.it;
}

//

function look_body( it )
{
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.objectIs( it.Looker ) );
  _.assert( _.prototype.isPrototypeOf( it.Looker, it ) );
  _.assert( it.looker === undefined );

  it.start();

  return it;
}

look_body.defaults = Object.create( Defaults );

//

/**
 * @function look
 * @namespace Tools.looker
 */

let lookAll = _.routineUnite( look_head, look_body );

var defaults = lookAll.defaults;
defaults.recursive = Infinity;

//

/**
 * @function lookerIs
 * @namespace Tools.looker
 */

function lookerIs( looker )
{
  if( !looker )
  return false;
  if( !looker.Looker )
  return false;
  return _.prototype.isPrototypeOf( looker, looker.Looker );
}

//

/**
 * @function lookIteratorIs
 * @namespace Tools.looker
 */

function lookIteratorIs( it )
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
 * @function lookIterationIs
 * @namespace Tools.looker
 */

function lookIterationIs( it )
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

// --
// declare
// --

let ErrorLooking = _.error.error_functor( 'ErrorLooking' ); /* xxx : cover error_functor in Err.test.s */

let containerNameToIdMap =
{
  'terminal' : 0,
  'long' : 1,
  'map' : 2,
  'hashMap' : 3,
  'set' : 4,
  'custom' : 5,
  'last' : 5,
}

let containerIdToNameMap =
{
  0 : 'terminal',
  1 : 'long', /* xxx : rename to partible */
  2 : 'map',
  3 : 'hashMap',
  4 : 'set',
  5 : 'custom',
}

let containerIdToAscendMap =
{
  0 : _termianlAscend,
  1 : _elementalAscend,
  2 : _mapAscend,
  3 : _hashMapAscend,
  4 : _setAscend,
  5 : _customAscend,
}

let withPartibleToIsElementalFunctionMap =
{
  'partible' : _isPartible,
  'vector' : _isVector,
  'long' : _isLong,
  'array' : _isArray,
  '' : _false,
}

let withImplicitToHasImplicitFunctionMap =
{
  'constructible.like' : _isConstructibleLike,
  'map.like' : _isMapLike,
  '' : _false,
}

let LookerExtension =
{

  Looker,
  ErrorLooking,

  containerNameToIdMap,
  containerIdToNameMap,
  containerIdToAscendMap,
  withPartibleToIsElementalFunctionMap,
  withImplicitToHasImplicitFunctionMap,

  look : lookAll,
  lookAll,

  lookerIs,
  lookIteratorIs,
  lookIterationIs,

}

let ToolsExtension =
{

  Looker,
  ErrorLooking,

  look : lookAll,
  lookAll,

  lookerIs,
  lookIteratorIs,
  lookIterationIs,

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
