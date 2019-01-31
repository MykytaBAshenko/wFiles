( function _Partial_s_() {

'use strict';

let _global = _global_;
let _ = _global_.wTools;

_.assert( !_.FileProvider.wFileProviderPartial );
_.assert( _.routineIs( _.routineVectorize_functor ) );
_.assert( _.routineIs( _.path.join ) );

//

/**
  * Definitions :
  *  Terminal file :: leaf of files sysytem, contains series of bytes. Terminal file cant contain other files.
  *  Directory :: non-leaf node of files sysytem, contains other dirs and terminal file(s).
  *  File :: any node of files sysytem, could be leaf( terminal file ) or non-leaf( directory ).
  *  Only terminal files contains series of bytes, function of directory to organize logical space for terminal files.
  *  self :: pathCurrent object.
  *  Self :: pathCurrent class.
  *  Parent :: parent class.
  *  Statics :: static fields.
  */

/*
 Act version of method :

- should assert that path is absolute
- should not extend or delete fields of options map, no _providerDefaults, routineOptions
- should path.nativize all paths in options map if needed by its own means
- should expect normalized path, but not nativized
- should expect ready options map, no complex arguments preprocessing
- should not create folders structure for path

*/

//

let Parent = _.FileProvider.Abstract;
let Self = function wFileProviderPartial( o )
{
  return _.instanceConstructor( Self, this, arguments );
}

Self.shortName = 'Partial';

// --
// shortcuts
// --

function _vectorizeKeysAndVals( routine, select )
{
  select = select || 1;

  let routineName = routine.name;

  _.assert( _.routineIs( routine ) );
  _.assert( _.strDefined( routineName ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let routine2 = _.routineVectorize_functor // qqq : uncomment it, please
  ({
    routine : [ routineName ],
    vectorizingArray : 1,
    vectorizingMap : 1,
    vectorizingKeys : 1,
    select : select,
  });

  // function routine2( srcs )
  // {
  //   _.assert( arguments.length === 1 );
  //   if( _.mapIs( srcs ) )
  //   {
  //     let result = Object.create( null );
  //     for( let s in srcs )
  //     {
  //       let val = routine.call( this, srcs[ s ] );
  //       let key = routine.call( this, s );
  //       result[ key ] = val;
  //     }
  //     return result;
  //   }
  //   else if( _.arrayIs( srcs ) )
  //   {
  //     let result = [];
  //     for( let s = 0 ; s < srcs.length ; s++ )
  //     result[ s ] = routine.call( this, srcs[ s ] );
  //     return result;
  //   }
  //   else
  //   {
  //     return routine.call( this, srcs );
  //   }
  // }

  _.routineExtend( routine2, routine );

  return routine2;
}

//

function _vectorize( routine, select )
{
  select = select || 1;

  let routineName = routine.name;

  _.assert( _.routineIs( routine ) );
  _.assert( _.strDefined( routineName ) );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  let routine2 = _.routineVectorize_functor
  ({
    routine : [ routineName ],
    vectorizingArray : 1,
    vectorizingMap : 0,
    vectorizingKeys : 0,
    select : select,
  });

  _.routineExtend( routine2, routine );

  return routine2;
}

//

function _vectorizeAll( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  let routine2 = _vectorize( routine, select );
  _.routineExtend( all, routine );
  return all;

  /* */

  function all()
  {
    let result = routine2.apply( this, arguments );
    return _.all( result );
  }

}

//

function _vectorizeAny( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  let routine2 = _vectorize( routine, select );
  _.routineExtend( any, routine );
  return any;

  /* */

  function any()
  {
    let result = routine2.apply( this, arguments );
    return _.any( result );
  }

}

//

function _vectorizeNone( routine, select )
{
  _.assert( arguments.length === 1 || arguments.length === 2 );
  let routine2 = _vectorize( routine, select );
  _.routineExtend( none, routine );
  return none;

  /* */

  function none()
  {
    let result = routine2.apply( this, arguments );
    return _.none( result );
  }

}

// --
// inter
// --

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self );

  // self[ protocolsSymbol ] = [];
  // self[ protocolSymbol ] = null;

  _.instanceInit( self );

  _.assert( _.arrayIs( self.protocols ) );
  _.assert( self.protocol !== undefined );

  if( self.Self === Self )
  Object.preventExtensions( self );

  if( o )
  {
    if( o.logger )
    self.logger = o.logger;
    else
    self.logger = new _.Logger({ output : console });
    self.copy( o );
  }
  else
  {
    self.logger = new _.Logger({ output : console });
  }

  if( self.path === null )
  {
    self.path = self.Path.CloneExtending({ fileProvider : self });
  }

  if( self.logger === null )
  self.logger = new _.Logger({ output : _global.logger });

  if( o )
  if( o.protocol !== undefined || o.originPath !== undefined )
  {
    if( o.protocol !== undefined )
    self.protocol = o.protocol;
    else if( o.originPath !== undefined )
    self.originPath = o.originPath;
  }

  if( self.verbosity >= 2 )
  self.logger.log( 'new', _.strType( self ) );

}

//

function finit()
{
  let self = this;
  if( self.hub )
  self.hub.providerUnregister( self );
  _.Copyable.prototype.finit.call( self );
}

//

function MakeDefault()
{

  _.assert( !!_.FileProvider.Default );
  _.assert( !_.fileProvider );
  _.fileProvider = new _.FileProvider.Default();
  _.assert( _.path.fileProvider === null );
  _.path.fileProvider = _.fileProvider;
  _.assert( _.path.fileProvider === _.fileProvider );
  _.assert( _.uri.fileProvider === _.fileProvider );

  return _.fileProvider;
}

// --
// etc
// --

function _providerDefaults( o )
{
  let self = this;

  _.assert( _.objectIs( o ), 'Expects map { o }' );

  if( o.verbosity === null && self.verbosity !== null )
  o.verbosity = _.numberClamp( self.verbosity - 3, 0, 9 );

  for( let k in self.ProviderDefaults )
  {
    if( o[ k ] === null )
    if( self[ k ] !== undefined && self[ k ] !== null )
    o[ k ] = self[ k ];
  }

  if( o.verbosity !== undefined && o.verbosity !== null )
  {
    if( !_.numberIs( o.verbosity ) )
    o.verbosity = o.verbosity ? 1 : 0;
    if( o.verbosity < 0 )
    o.verbosity = 0;
  }

}

function assertProviderDefaults( o )
{
  let self = this;

  _.assert( _.objectIs( o ), 'Expects map { o }' );
  _.assert( o.verbosity === null, 'Verbosity was not set to provider default' )

  for( let k in self.ProviderDefaults )
  {
    if( o[ k ] === null )
    if( self[ k ] !== undefined && self[ k ] !== null )
    _.assert( 0, k, 'was not set to provider default' )
  }

}

//

function _preFilePathScalarWithoutProviderDefaults( routine, args )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.objectIs( args[ 0 ] ) || path.is( args[ 0 ] ), 'Expects options map or path' );
  _.assert( args && args.length === 1, 'Routine ' + routine.name + ' expects exactly one arguments' );

  let o = args[ 0 ];

  if( path.like( o ) )
  o = { filePath : path.from( o ) };

  _.routineOptions( routine, o );

  o.filePath = path.normalize( o.filePath );

  _.assert( path.isAbsolute( o.filePath ), () => 'Expects absolute path {-o.filePath-}, but got ' + _.strQuote( o.filePath ) );

  return o;
}

//

function _preFilePathScalarWithProviderDefaults( routine, args )
{
  let self = this;

  let o = self._preFilePathScalarWithoutProviderDefaults.apply( self, arguments );

  if( o.verbosity === null )
  o.verbosity = _.numberClamp( self.verbosity - 4, 0, 9 );

  self._providerDefaults( o );

  return o;
}

//

function _preFilePathVectorWithoutProviderDefaults( routine, args )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args && args.length === 1, 'Routine ' + routine.name + ' expects exactly one arguments' );

  let o = args[ 0 ];

  if( path.like( o ) )
  o = { filePath : path.from( o ) };
  else if( _.arrayIs( o ) )
  o = { filePath : path.s.from( o ) };
  else if( _.arrayIs( o.filePath ) )
  o.filePath = path.s.from( o.filePath );

  _.routineOptions( routine, o );

  _.assert( path.s.allAreAbsolute( o.filePath ), () => 'Expects absolute path {-o.filePath-}, but got ' + _.strQuote( o.filePath ) );

  o.filePath = path.s.normalize( o.filePath );

  return o;
}

//

function _preFilePathVectorWithProviderDefaults( routine, args )
{
  let self = this;

  let o = self._preFilePathVectorWithoutProviderDefaults.apply( self, arguments );

  if( o.verbosity === null )
  o.verbosity = _.numberClamp( self.verbosity - 4, 0, 9 );

  self._providerDefaults( o );

  return o;
}

//

function _preSrcDstPathWithoutProviderDefaults( routine, args )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2, 'Routine ' + routine.name + ' expects one or two arguments' );

  let o = args[ 0 ];

  if( path.like( args[ 0 ] ) || path.like( args[ 1 ] ) )
  o = { dstPath : args[ 0 ], srcPath : args[ 1 ] }

  _.routineOptions( routine, o );

  if( o.dstPath !== null )
  {
    o.dstPath = path.s.from( o.dstPath );
    o.dstPath = path.s.normalize( o.dstPath );
  }

  if( o.srcPath !== null )
  {
    o.srcPath = path.s.from( o.srcPath );
    o.srcPath = path.s.normalize( o.srcPath );
  }

  return o;
}

//

function _preSrcDstPathWithProviderDefaults( routine, args )
{
  let self = this;

  let o = self._preSrcDstPathWithoutProviderDefaults.apply( self, arguments );

  if( o.verbosity === null )
  o.verbosity = _.numberClamp( self.verbosity - 4, 0, 9 );

  self._providerDefaults( o );

  return o;
}

//

/**
 * Return options for file read/write. If `filePath is an object, method returns it. Method validate result option
    properties by default parameters from invocation context.
 * @param {string|Object} filePath
 * @param {Object} [o] Object with default options parameters
 * @returns {Object} Result options
 * @private
 * @throws {Error} If arguments is missed
 * @throws {Error} If passed extra arguments
 * @throws {Error} If missed `PathFiile`
 * @method _fileOptionsGet
 * @memberof FileProvider.Partial
 */

function _fileOptionsGet( filePath, o )
{
  let self = this;
  o = o || Object.create( null );

  if( _.objectIs( filePath ) )
  {
    o = filePath;
  }
  else
  {
    o.filePath = filePath;
  }

  if( !o.filePath )
  throw _.err( '_fileOptionsGet :', 'Expects (-o.filePath-)' );

  _.assertMapHasOnly( o, this.defaults );
  _.assert( arguments.length === 1 || arguments.length === 2 );

  if( o.sync === undefined )
  o.sync = 1;

  return o;
}

//

function protocolsForOrigins( origins )
{
  if( origins === null )
  return origins;

  if( _.arrayIs( origins ) )
  return origins.map( ( origin ) => self.protocolsForOrigins( origin ) );
  _.assert( _.strIs( origins ) );
  return _.strRemoveEnd( _.strRemoveEnd( origins, '//' ), ':' );
}

//

function originsForProtocols( protocols )
{
  if( _.arrayIs( protocols ) )
  return protocols.map( ( protocol ) => self.originsForProtocols( protocol ) );
  _.assert( _.strIs( protocols ) );
  return protocols + '://';
}

//

function providerForPath( path )
{
  let self = this;
  _.assert( _.strIs( path ), 'Expects string' );
  _.assert( !self.path.isGlobal( path ), () => 'Path for the file provider should be local, but is ' + _.strQuote( path ) );
  return self;
}

//

function providerRegisterTo( hub )
{
  let self = this;
  hub.providerRegister( self );
  return self;
}

//

function providerUnregister()
{
  let self = this;
  _.assert( arguments.length === 0 );
  if( self.hub )
  self.hub.providerUnregister( self );
  return self;
}

//

function hasProvider( provider )
{
  let self = this;
  _.assert( arguments.length === 1 );
  return self === provider;
}

// --
// path
// --

function localFromGlobal( globalPath )
{
  let self = this;

  if( _.boolLike( globalPath ) )
  return globalPath;

  if( _.strIs( globalPath ) )
  {
    if( !_.path.isGlobal( globalPath ) )
    return globalPath;
    globalPath = _.uri.parse( globalPath );
  }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.mapIs( globalPath ) ) ;
  _.assert( _.strIs( globalPath.localPath ) );
  _.assert( !self.protocols || !globalPath.protocol || _.arrayHas( self.protocols, globalPath.protocol ) );

  return globalPath.localPath;
}

//

function globalFromLocal( localPath )
{
  let self = this;
  let path = self.path.parse ? self.path : _.uri;

  if( _.boolLike( localPath ) )
  return localPath;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( localPath ) )
  _.assert( !self.protocols.length || _.strIs( self.originPath ) );

  if( self.originPath )
  return path.join( self.originPath, localPath );
  else
  return localPath;
}

//

function pathNativizeAct( filePath )
{
  let self = this;
  _.assert( _.strIs( filePath ), 'Expects string' ) ;
  return filePath;
}

var having = pathNativizeAct.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 1;
having.kind = 'path';

//

let pathCurrentAct = null;

//

function pathDirTempAct()
{
  let self = this;
  let path = self.path;
  return '/temp';
}

//

function pathForCopy_pre( routine, args )
{
  let self = this;

  _.assert( args.length === 1 );

  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { path : o };

  _.routineOptions( routine, o );
  _.assert( self instanceof _.FileProvider.Abstract );
  _.assert( _.strIs( o.path ) );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return o;
}

//

function pathForCopy_body( o )
{
  let fileProvider = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let postfix = _.strPrependOnce( o.postfix, o.postfix ? '-' : '' );
  let file = fileProvider.recordFactory().record( o.path );
  let name = file.name;

  let splits = _.strSplitFast({ src : name, delimeter : '-', preservingEmpty : 0, preservingDelimeters : 0 });
  if( splits[ splits.length-1 ] === o.postfix )
  name = splits.slice( 0, splits.length-1 ).join( '-' );

  // !!! this condition (first if below) is not necessary, because if it fulfilled then previous fulfiled too, and has the
  // same effect as previous

  if( splits.length > 1 && splits[ splits.length-1 ] === o.postfix )
  name = splits.slice( 0, splits.length-1 ).join( '-' );
  else if( splits.length > 2 && splits[ splits.length-2 ] === o.postfix )
  name = splits.slice( 0, splits.length-2 ).join( '-' );

  /*file.absolute =  file.dir + '/' + file.name + file.extWithDot;*/

  let path = fileProvider.path.join( file.dir , name + postfix + file.extWithDot );
  if( !fileProvider.statResolvedRead({ filePath : path , sync : 1 }) )
  return path;

  let attempts = 1 << 13;
  let index = 1;

  while( attempts > 0 )
  {

    let path = fileProvider.path.join( file.dir , name + postfix + '-' + index + file.extWithDot );

    if( !fileProvider.statResolvedRead({ filePath : path , sync : 1 }) )
    return path;

    attempts -= 1;
    index += 1;

  }

  throw _.err( 'Cant make copy path for : ' + file.absolute );
}

pathForCopy_body.defaults =
{
  delimeter : '-',
  postfix : 'copy',
  path : null,
}

var having = pathForCopy_body.having = Object.create( null );
having.driving = 0;
having.aspect = 'body';

//

let pathResolveSoftLinkAct = Object.create( null );
pathResolveSoftLinkAct.name = 'pathResolveSoftLinkAct';

var defaults = pathResolveSoftLinkAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingMultiple = 0;
defaults.resolvingIntermediateDirectories = 0;

var having = pathResolveSoftLinkAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = pathResolveSoftLinkAct.operates  = Object.create( null );
operates.filePath = { pathToRead : 1 };

//

function pathResolveSoftLink_body( o )
{
  let self = this;

  _.assert( _.routineIs( self.pathResolveSoftLinkAct ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!o.filePath );

  /* should not have redundant conditions */

  let result = self.pathResolveSoftLinkAct( o );

  result = self.path.normalize( result );

  return result;
}

_.routineExtend( pathResolveSoftLink_body, pathResolveSoftLinkAct );

var having = pathResolveSoftLink_body.having;
having.driving = 0;
having.aspect = 'body';

//

let pathResolveSoftLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, pathResolveSoftLink_body );

var having = pathResolveSoftLink.having;
having.aspect = 'entry';

//

let pathResolveTextLinkAct = Object.create( null );
pathResolveTextLinkAct.name = 'pathResolveTextLinkAct';

var defaults = pathResolveTextLinkAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingMultiple = 0;
defaults.resolvingIntermediateDirectories = 0;

var having = pathResolveTextLinkAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = pathResolveTextLinkAct.operates  = Object.create( null );
operates.filePath = { pathToRead : 1 };

//

function pathResolveTextLink_pre( routine, args )
{
  let self = this;
  let path = self.path;

  let o = args[ 0 ];

  if( !_.mapIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1, 'Expects single argument for', routine.name );
  _.routineOptions( routine, o );
  _.assert( _.strIs( o.filePath ), 'Expects string' );

  return o;
}

//

function pathResolveTextLink_body( o )
{
  let self = this;

  if( !self.usingTextLink )
  return o.filePath;

  _.assertRoutineOptions( pathResolveTextLink_body, arguments );
  _.assert( _.strIs( o.filePath ), 'Expects string' );
  _.assert( arguments.length === 1, 'Expects exactly one argument' );

  let result = self.pathResolveTextLinkAct( o );

  if( !result )
  return o.filePath;

  self.logger.log( 'pathResolveTextLink :', o.filePath, '->', result );

  return result;
}

_.routineExtend( pathResolveTextLink_body, pathResolveTextLinkAct );

var having = pathResolveTextLink_body.having;
having.driving = 0;
having.aspect = 'body';

let pathResolveTextLink = _.routineFromPreAndBody( pathResolveTextLink_pre, pathResolveTextLink_body );

//

let _pathResolveLink = Object.create( null );

var defaults = _pathResolveLink.defaults = Object.create( null );
defaults.hub = null;
defaults.filePath = null;
defaults.resolvingSoftLink = null;
defaults.resolvingTextLink = null;
defaults.throwing = 1;
defaults.allowingMissed = 1;
defaults.allowingCycled = 1;

var having = _pathResolveLink.having = Object.create( null );
having.driving = 0;
having.aspect = 'body';
having.hubRedirecting = 0;

var operates = _pathResolveLink.operates  = Object.create( null );
operates.filePath = { pathToRead : 1 };

//

function pathResolveLinkFull_pre()
{
  let self = this;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );
  return o;
}

//

function pathResolveLinkFull_body( o )
{
  let self = this;
  let path = self.path;
  let result = o.filePath;

  _.assert( _.routineIs( self.pathResolveLinkTailChain.body ) );
  _.assert( path.isAbsolute( o.filePath ) );
  _.assert( !!o.resolvingHeadDirect );
  _.assert( !!o.resolvingHeadReverse );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertRoutineOptions( pathResolveLinkFull_body, arguments );

  let hub = o.hub || self.hub;
  if( hub && hub !== self && path.isGlobal( o.filePath ) )
  return hub.pathResolveLinkFull.body.call( hub, o );

  if( o.sync )
  return _pathResolveLinkFullSync();
  else
  return _pathResolveLinkFullAsync();

  /**/

  function _pathResolveLinkFullSync()
  {

    /*
      statRead should be before resolving
      because resolving does not guarantee reading stat
    */

    // if( _.strEnds( o.filePath, '/statReadActSync/src' ) )
    // debugger;

    if( !o.stat )
    o.stat = self.statReadAct
    ({
      filePath : result,
      throwing : 0,
      resolvingSoftLink : 0,
      sync : 1,
    });

    if( !o.resolvingSoftLink && ( !o.resolvingTextLink || !self.usingTextLink ) )
    {

      if( o.stat )
      return result;

      if( !o.allowingMissed )
      {
        result = null;
        if( o.throwing )
        {
          debugger;
          throw _.err( 'File does not exist', _.strQuote( o.filePath ) );
        }
      }

      return result;
    }

    // if( o.resolvingSoftLink )
    // debugger;

    if( o.resolvingHeadDirect )
    {

      let filePath = result;
      let o2 =
      {
        hub : hub,
        filePath : result,
        resolvingSoftLink : o.resolvingSoftLink,
        resolvingTextLink : o.resolvingTextLink,
        allowingMissed : o.allowingMissed,
        allowingCycled: o.allowingCycled,
        throwing : o.throwing,
        stat : null,
        // stat : o.stat,
      }

      result = self.pathResolveLinkHeadDirect.body.call( self, o2 );
      // o.stat = o2.stat;

    }

    // if( o.resolvingSoftLink )
    // debugger;

    if( result )
    {

      let o2 =
      {
        stat : o.stat,
        hub : hub,
        filePath : result,
        resolvingSoftLink : o.resolvingSoftLink,
        resolvingTextLink : o.resolvingTextLink,
        preservingRelative : o.preservingRelative,
        allowingMissed : o.allowingMissed,
        allowingCycled : o.allowingCycled,
        throwing : o.throwing,
      }

      result = self.pathResolveLinkTail.body.call( self, o2 );
      o.stat = o2.stat;
      _.assert( o.stat !== undefined );

    }
    else
    {
      if( !o.allowingMissed )
      {
        result = null;
        if( o.throwing )
        {
          debugger;
          throw _.err( 'File does not exist', _.strQuote( o.filePath ) );
        }
      }
    }

    // if( !o.resolvingHeadDirect || o.stat )
    // if( o.resolvingHeadReverse )
    if( o.stat && o.resolvingHeadReverse )
    {

      let absolutePath = _.mapIs( result ) ? result.absolutePath : result;
      let o2 =
      {
        hub : hub,
        filePath : absolutePath,
        resolvingSoftLink : o.resolvingSoftLink,
        resolvingTextLink : o.resolvingTextLink,
        allowingMissed : o.allowingMissed,
        allowingCycled: o.allowingCycled,
        throwing : o.throwing,
      }

      let r = self.pathResolveLinkHeadReverse.body.call( self, o2 );
      if( r === absolutePath )
      r = _.mapIs( result ) ? result.filePath : result;
      result = r;

    }

    return _.mapIs( result ) ? result.filePath : result;
  }

  /**/

  function _pathResolveLinkFullAsync()
  {
    let con = new _.Consequence().take( null );

    if( !o.stat )
    con.thenKeep( () =>
    {
      return self.statReadAct
      ({
        filePath : result,
        throwing : 0,
        resolvingSoftLink : 0,
        sync : 0
      })
    })

    con.thenKeep( ( stat ) =>
    {
      o.stat = stat;

      if( !o.resolvingSoftLink && ( !o.resolvingTextLink || !self.usingTextLink ) )
      {

        if( o.stat )
        return result;

        if( !o.allowingMissed )
        {
          result = null;
          if( o.throwing )
          {
            debugger;
            throw _.err( 'File does not exist', _.strQuote( o.filePath ) );
          }
        }

        return result;
      }

      if( o.resolvingHeadDirect )
      {

        let filePath = result;
        let o2 =
        {
          hub : hub,
          filePath : result,
          resolvingSoftLink : o.resolvingSoftLink,
          resolvingTextLink : o.resolvingTextLink,
          allowingMissed : o.allowingMissed,
          allowingCycled: o.allowingCycled,
          throwing : o.throwing,
          stat : null,
          // stat : o.stat,
        }

        result = self.pathResolveLinkHeadDirect.body.call( self, o2 );
        // o.stat = o2.stat;

      }

      if( result )
      {

        let o2 =
        {
          stat : o.stat,
          hub : hub,
          filePath : result,
          resolvingSoftLink : o.resolvingSoftLink,
          resolvingTextLink : o.resolvingTextLink,
          preservingRelative : o.preservingRelative,
          allowingMissed : o.allowingMissed,
          allowingCycled : o.allowingCycled,
          throwing : o.throwing,
        }

        result = self.pathResolveLinkTail.body.call( self, o2 );
        o.stat = o2.stat;
        _.assert( o.stat !== undefined );

      }
      else
      {
        if( !o.allowingMissed )
        {
          result = null;
          if( o.throwing )
          {
            debugger;
            throw _.err( 'File does not exist', _.strQuote( o.filePath ) );
          }
        }
      }

      if( o.stat && o.resolvingHeadReverse )
      {

        let absolutePath = _.mapIs( result ) ? result.absolutePath : result;
        let o2 =
        {
          hub : hub,
          filePath : absolutePath,
          resolvingSoftLink : o.resolvingSoftLink,
          resolvingTextLink : o.resolvingTextLink,
          allowingMissed : o.allowingMissed,
          allowingCycled: o.allowingCycled,
          throwing : o.throwing,
        }

        let r = self.pathResolveLinkHeadReverse.body.call( self, o2 );
        if( r === absolutePath )
        r = _.mapIs( result ) ? result.filePath : result;
        result = r;

      }

      return _.mapIs( result ) ? result.filePath : result;

    })

    return con;
  }
}

_.routineExtend( pathResolveLinkFull_body, _pathResolveLink );

var defaults = pathResolveLinkFull_body.defaults;
defaults.stat = null;
defaults.sync = null;
defaults.resolvingHeadDirect = 1;
defaults.resolvingHeadReverse = 1;
defaults.preservingRelative = 0;

//

let pathResolveLinkFull = _.routineFromPreAndBody( pathResolveLinkFull_pre, pathResolveLinkFull_body );
pathResolveLinkFull.having.aspect = 'entry';

//

function pathResolveLinkTail_pre()
{
  let self = this;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );

  return o;
}

//

function pathResolveLinkTail_body( o )
{
  let self = this;

  _.assert( _.routineIs( self.pathResolveLinkTailChain.body ) );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertRoutineOptions( pathResolveLinkTail_body, arguments );

  if( _.strEnds( o.filePath, '/self' ) )
  debugger;

  let o2 = _.mapExtend( null, o );
  o2.found = [];
  o2.result = [ o.filePath ];
  let r = self.pathResolveLinkTailChain.body.call( self, o2 );
  o.stat = o2.stat;

  let result = Object.create( null );

  // result.relative = r[ r.length-1 ];

  result.filePath = o2.result[ o2.result.length-1 ];
  result.absolutePath = o2.found[ o2.found.length-1 ];

  // let result = r[ r.length-1 ];

  if( result.filePath === null )
  {
    let cycle = false;
    if( o2.found.length > 2 )
    cycle = _.arrayRightIndex( o2.found, o2.found[ o2.found.length-2 ], o2.found.length-3 ) !== -1;
    if( cycle && o.allowingCycled || !cycle && o.allowingMissed )
    {
      result.filePath = o2.result[ o2.result.length-2 ];
      result.absolutePath = o2.found[ o2.found.length-2 ];
    }
  }

  // if( o.filePath !== result )
  // logger.log( 'pathResolveLinkTail', o.filePath, '->', result );

  _.assert( result.filePath === null || _.strIs( result.filePath ) );
  _.assert( result.absolutePath === null || _.strIs( result.absolutePath ) );

  return result;
}

_.routineExtend( pathResolveLinkTail_body, _pathResolveLink );

var defaults = pathResolveLinkTail_body.defaults;
defaults.stat = null;
defaults.preservingRelative = 0;

//

let pathResolveLinkTail = _.routineFromPreAndBody( pathResolveLinkTail_pre, pathResolveLinkTail_body );
pathResolveLinkTail.having.aspect = 'entry';

//

function pathResolveLinkTailChain_pre()
{
  let self = this;
  let path = self.path;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );

  _.assert( path.isAbsolute( o.filePath ) );

  if( o.found === null )
  o.found = [];

  if( o.result === null )
  o.result = [ o.filePath ];

  return o;
}

//

/*
 - both o.found and o.result have no duplicates, except case when link is cycled
 - o.found has only absolute paths, always
 - o.result has corresponding element before the iteration starts, the iteration check o.found and put new element ot o.found
*/

function pathResolveLinkTailChain_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );
  _.assert( _.boolLike( o.throwing ) );
  _.assert( _.arrayIs( o.found ) );
  _.assert( _.arrayIs( o.result ) );
  _.assert( path.isAbsolute( o.filePath ) );
  _.assertRoutineOptions( pathResolveLinkTailChain_body, arguments );

  let hub = o.hub || self.hub;
  if( hub && hub !== self && path.isGlobal( o.filePath ) )
  return hub.pathResolveLinkTailChain.body.call( hub, o );

  if( _.arrayHas( o.found, o.filePath ) )
  {
    if( o.throwing && !o.allowingCycled )
    {
      throw _.err( 'Links cycle at', _.strQuote( o.filePath ) );
    }
    else
    {
      o.found.push( o.filePath, null );
      o.result.push( null );

      if( o.allowingCycled )
      o.stat = self.statReadAct
      ({
        filePath : o.filePath,
        throwing : 0,
        resolvingSoftLink : 0,
        sync : 1,
      });

      return o.result;
    }
  }

  o.found.push( o.filePath );

  /*
    condition to avoid recursion in stat and overburden
    pathResolveLinkTail does not guarantee reading stat
  */

  if( !o.resolvingSoftLink && ( !o.resolvingTextLink || !self.usingTextLink ) )
  {
    return o.result;
  }

  /* */

  if( !o.stat )
  o.stat = self.statReadAct
  ({
    filePath : o.filePath,
    throwing : 0,
    resolvingSoftLink : 0,
    sync : 1,
  });

  if( !o.stat )
  {
    o.result.push( null );
    o.found.push( null );

    // should throw error if any part of chain does not exist
    if( o.throwing && !o.allowingMissed )
    {
      debugger;
      throw _.err( 'Does not exist file', _.strQuote( o.filePath ) );
    }

    return o.result;
  }

  /* */

  if( o.resolvingSoftLink && o.stat.isSoftLink() )
  {
    let filePath = self.pathResolveSoftLink({ filePath : o.filePath });
    /* qqq : implement extended options vova : done for hd,extract */
    /* qqq : add test coverage, please */
    if( o.preservingRelative && !path.isAbsolute( filePath ) )
    {
      o.result.push( filePath );
      o.filePath = path.join( o.filePath, filePath );
    }
    else
    {
      o.filePath = path.join( o.filePath, filePath )
      o.result.push( o.filePath );
    }
    o.stat = null;
    return self.pathResolveLinkTailChain.body.call( self, o );
  }

  /* */

  if( self.usingTextLink )
  if( o.resolvingTextLink && o.stat.isTextLink() )
  {
    let filePath = self.pathResolveTextLink({ filePath : o.filePath });
    /* qqq : implement extended options */
    if( o.preservingRelative && !path.isAbsolute( filePath ) )
    {
      o.result.push( filePath );
      o.filePath = path.join( o.filePath, filePath )
    }
    else
    {
      o.filePath = path.join( o.filePath, filePath )
      o.result.push( o.filePath );
    }
    o.stat = null;
    return self.pathResolveLinkTailChain.body.call( self, o );
  }

  return o.result;
}

_.routineExtend( pathResolveLinkTailChain_body, pathResolveLinkTail.body );

var defaults = pathResolveLinkTailChain_body.defaults;
defaults.result = null;
defaults.found = null;

//

let pathResolveLinkTailChain = _.routineFromPreAndBody( pathResolveLinkTailChain_pre, pathResolveLinkTailChain_body );
pathResolveLinkTailChain.having.aspect = 'entry';

//

function pathResolveLinkHeadDirect_pre()
{
  let self = this;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );
  return o;
}

//

function pathResolveLinkHeadDirect_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );
  _.assert( _.boolLike( o.throwing ) );
  _.assert( path.isAbsolute( o.filePath ) );
  _.assertRoutineOptions( pathResolveLinkHeadDirect_body, arguments );

  let hub = o.hub || self.hub;
  if( hub && hub !== self && path.isGlobal( o.filePath ) )
  return hub.pathResolveLinkHeadDirect.body.call( hub, o );

  if( !o.resolvingSoftLink && ( !o.resolvingTextLink || !self.usingTextLink ) )
  return o.filePath;

  let splits = path.split( o.filePath );
  let filePath = '/';
  let o2 = _.mapExtend( null, o );

  for( let i = 1 ; i < splits.length ; i++ )
  {

    if( i === splits.length-1 )
    {
      filePath = path.join( filePath, splits[ i ] );
      break;
    }

    filePath = path.join( filePath, splits[ i ] );
    o2.filePath = filePath;
    o2.stat = null;
    o2.preservingRelative = 0;
    if( i === splits.length-1 )
    o2.stat = o.stat;

    if( !o2.stat )
    o2.stat = self.statReadAct
    ({
      filePath : filePath,
      throwing : 0,
      sync : 1,
      resolvingSoftLink : 0,
    });

    if( !o2.stat )
    {
      filePath = path.join.apply( path, _.arrayAppendArrays( [], [ filePath, splits.slice( i+1 ) ] ) );
      o.stat = null;
      break;
    }

    if( ( o2.resolvingSoftLink && o2.stat.isSoftLink() ) || ( o2.resolvingTextLink && self.usingTextLink && o2.stat.isTextLink() ) )
    filePath = self.pathResolveLinkTail.body.call( self, o2 ).absolutePath;
    if( i === splits.length-1 )
    o.stat = o2.stat;
  }

  return filePath;
}

_.routineExtend( pathResolveLinkHeadDirect_body, _pathResolveLink );

var defaults = pathResolveLinkHeadDirect_body.defaults;
defaults.stat = null;

//

let pathResolveLinkHeadDirect = _.routineFromPreAndBody( pathResolveLinkHeadDirect_pre, pathResolveLinkHeadDirect_body );
pathResolveLinkHeadDirect.having.aspect = 'entry';

//

function pathResolveLinkHeadReverse_pre()
{
  let self = this;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );
  return o;
}

//

function pathResolveLinkHeadReverse_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );
  _.assert( _.boolLike( o.throwing ) );
  _.assert( path.isAbsolute( o.filePath ) );
  _.assertRoutineOptions( pathResolveLinkHeadReverse_body, arguments );

  let hub = o.hub || self.hub;
  if( hub && hub !== self && path.isGlobal( o.filePath ) )
  return hub.pathResolveLinkHeadReverse.body.call( hub, o );

  let prefixPath = o.filePath;
  let postfixPath = '';

  // console.log( 'pathResolveLinkHeadReverse', o.filePath );

  // if( o.filePath === 'extract+src:///src/a1' )
  // debugger;

  while( !path.isRoot( prefixPath ) )
  {
    let o2 = _.mapExtend( null, o );
    o2.filePath = prefixPath;
    o2.preservingRelative = 0;
    prefixPath = self.pathResolveLinkTail( o2 ).absolutePath;
    postfixPath = path.join( path.fullName( prefixPath ), postfixPath );
    prefixPath = path.dir( prefixPath );
    _.assert( !_.strBegins( prefixPath, '/..' ) && !_.strHas( prefixPath, '///..' ) )
  }

  // if( o.filePath === 'extract+src:///src/a1' )
  // debugger;

  let result = '/' + postfixPath;

  if( path.parse )
  result = ( path.parse( prefixPath ).origin || '' ) + result;

  return result;
}

_.routineExtend( pathResolveLinkHeadReverse_body, _pathResolveLink );

//

let pathResolveLinkHeadReverse = _.routineFromPreAndBody( pathResolveLinkHeadReverse_pre, pathResolveLinkHeadReverse_body );
pathResolveLinkHeadReverse.having.aspect = 'entry';

// --
// record
// --

function _recordFactoryFormEnd( recordFactory )
{
  let self = this;
  _.assert( recordFactory instanceof _.FileRecordFactory );
  _.assert( arguments.length === 1, 'Expects single argument' );
  return recordFactory;
}

//

function _recordFormBegin( record )
{
  let self = this;
  return record;
}

//

function _recordPathForm( record )
{
  let self = this;
  return record;
}

//

function _recordFormEnd( record )
{
  let self = this;
  return record;
}

//

function _recordAbsoluteGlobalMaybeGet( record )
{
  let self = this;
  _.assert( record instanceof _.FileRecord );
  _.assert( arguments.length === 1, 'Expects single argument' );
  return record.absolute;
}

//

function _recordRealGlobalMaybeGet( record )
{
  let self = this;
  _.assert( record instanceof _.FileRecord );
  _.assert( arguments.length === 1, 'Expects single argument' );
  return record.real;
}

//

function record( filePath )
{
  let self = this;

  _.assert( arguments.length === 1 );

  if( filePath instanceof _.FileRecord )
  {
    return filePath;
  }

  _.assert( _.strIs( filePath ), () => 'Expects string {-filePath-}, but got ' + _.strType( filePath ) );

  return self.recordFactory().record( filePath );
}

var having = record.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;
having.kind = 'record';

//

function _recordsSort( o )
{
  let self = this;

  if( arguments.length === 1 )
  if( _.longIs( o ) )
  {
    o = { src : o }
  }

  if( arguments.length === 2 )
  {
    o =
    {
      src : arguments[ 0 ],
      sorter : arguments[ 1 ]
    }
  }

  if( _.strIs( o.sorter ) )
  {
    let parseOptions =
    {
      src : o.sorter,
      fields : { hardlinks : 1, modified : 1 }
    }
    o.sorter = _.strSorterParse( parseOptions );
  }

  _.routineOptions( _recordsSort, o );

  _.assert( _.longIs( o.src ) );
  _.assert( _.longIs( o.sorter ) );

  for( let i = 0; i < o.src.length; i++ )
  {
    if( !( o.src[ i ] instanceof _.FileRecord ) )
    throw _.err( '_recordsSort : expects FileRecord instances in src, got:', _.strType( o.src[ i ] ) );
  }

  let result = o.src.slice();

  let knownSortMethods = [ 'modified', 'hardlinks' ];

  for( let i = 0; i < o.sorter.length; i++ )
  {
    let sortMethod =  o.sorter[ i ][ 0 ];
    let sortByMax = o.sorter[ i ][ 1 ];

    _.assert( knownSortMethods.indexOf( sortMethod ) !== -1, '_recordsSort : unknown sort method: ', sortMethod );

    let routine = sortByMax ? _.entityMax : _.entityMin;

    if( sortMethod === 'hardlinks' )
    {
      let selectedRecord = routine( result, ( record ) => record.stat ? record.stat.nlink : 0 ).element;
      result = [ selectedRecord ];
    }

    if( sortMethod === 'modified' )
    {
      let selectedRecord = routine( result, ( record ) => record.stat ? record.stat.mtime.getTime() : 0 ).element;
      result = _.entityFilter( result, ( record ) =>
      {
        if( record.stat && record.stat.mtime.getTime() === selectedRecord.stat.mtime.getTime() )
        return record;
      });
    }
  }

  _.assert( result.length === 1 );

  return result[ 0 ];
}

_recordsSort.defaults =
{
  src : null,
  sorter : null
}

//

function recordFactory( factory )
{
  let self = this;

  factory = factory || Object.create( null );

  if( factory instanceof _.FileRecordFactory )
  {

    if( !factory.hubFileProvider && self.hub )
    factory.hubFileProvider = self.hub;

    if( !factory.defaultFileProvider )
    factory.defaultFileProvider = self;

    return factory
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !factory.defaultFileProvider )
  factory.defaultFileProvider = self;

  return _.FileRecordFactory( factory );
}

var having = recordFactory.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 0;
having.kind = 'record';

//

function recordFilter( filter )
{
  let self = this;

  filter = filter || Object.create( null );

  if( filter instanceof _.FileRecordFilter )
  {

    if( !filter.hubFileProvider && self.hub )
    filter.hubFileProvider = self.hub;

    if( !filter.defaultFileProvider )
    filter.defaultFileProvider = self;

    return filter
  }

  _.assert( arguments.length === 0 || arguments.length === 1 );

  if( !filter.defaultFileProvider )
  filter.defaultFileProvider = self;

  return _.FileRecordFilter( filter );
}

var having = recordFilter.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 0;
having.kind = 'record';

// --
// stat
// --

/*
  qqq : statReadAct of Extract and HD handle links in head of path differently
  HD always resolve them
  add test routine statReadActLinkedHead
  Vova : statReadActLinkedHead added, soft links are handled, text links need tests and implementation, low priority
*/

let statReadAct = Object.create( null );
statReadAct.name = 'statReadAct';

var defaults = statReadAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;
defaults.throwing = 0;
defaults.resolvingSoftLink = null;

var having = statReadAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = statReadAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

function statRead_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routineIs( self.statReadAct ) );

  let o2 =
  {
    filePath : o.filePath,
    resolvingTextLink : o.resolvingTextLink,
    resolvingSoftLink : o.resolvingSoftLink,
    sync : o.sync,
    throwing : o.throwing,
  	allowingMissed : 0,
  	allowingCycled : 0,
  }

  // debugger;
  // logger.log( 'statRead', o2.filePath );

  /* xxx qqq : add option sync */
  /* xxx aaa : done */
  let result = self.pathResolveLinkFull( o2 );

  if( o.sync )
  {
    return end( result );
  }
  else
  {
    // let result = new _.Consequence().take( o2.stat );
    return result.thenKeep( end );
  }

  /* - */

  function end( result )
  {
    if( result === null )
    {
      if( o.throwing )
      throw _.err( 'Failed to resolve' );
      else
      return result;
    }

    let stat = o2.stat;
    if( stat )
    {
      _.assert( _.routineIs( stat.isTerminal ), 'Stat should have routine isTerminal' );
      _.assert( _.routineIs( stat.isDir ), 'Stat should have routine isDir' );
      _.assert( _.routineIs( stat.isTextLink ), 'Stat should have routine isTextLink' );
      _.assert( _.routineIs( stat.isSoftLink ), 'Stat should have routine isSoftLink' );
      _.assert( _.routineIs( stat.isHardLink ), 'Stat should have routine isHardLink' );
      _.assert( _.strIs( stat.filePath ), 'Stat should have file path' );
    }
    return stat;
  }

}

_.routineExtend( statRead_body, statReadAct );

statRead_body.defaults.resolvingTextLink = 0;
statRead_body.having.driving = 0;
statRead_body.having.aspect = 'body';

//

/**
 * Returns object with information about a file.
 * @param {String|Object} o Path to a file or object with options.
 * @param {String|FileRecord} [ o.filePath=null ] - Path to a file or instance of FileRecord @see{@link wFileRecord}
 * @param {Boolean} [ o.sync=true ] - Determines in which way file stats will be readed : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=false ] - Controls error throwing. Returns null if error occurred and ( throwing ) is disabled.
 * @param {Boolean} [ o.resolvingTextLink=false ] - Enables resolving of text links @see{@link wFileProviderPartial~resolvingTextLink}.
 * @param {Boolean} [ o.resolvingSoftLink=true ] - Enables resolving of soft links @see{@link wFileProviderPartial~resolvingSoftLink}.
 * @returns {Object|wConsequence|null}
 * If ( o.filePath ) path exists - returns file stats as Object, otherwise returns null.
 * If ( o.sync ) mode is disabled - returns Consequence instance @see{@link wConsequence }.
 * @example
 * wTools.fileProvider.statResolvedRead( './existingDir/test.txt' );
 * // returns
 * Stats
 * {
    dev : 2523469189,
    mode : 16822,
    nlink : 1,
    uid : 0,
    gid : 0,
    rdev : 0,
    blksize : undefined,
    ino : 13229323905402304,
    size : 0,
    blocks : undefined,
    atimeMs : 1525429693979.7004,
    mtimeMs : 1525429693979.7004,
    ctimeMs : 1525429693979.7004,
    birthtimeMs : 1513244276986.976,
    atime : '2018-05-04T10:28:13.980Z',
    mtime : '2018-05-04T10:28:13.980Z',
    ctime : '2018-05-04T10:28:13.980Z',
    birthtime : '2017-12-14T09:37:56.987Z',
  }
 *
 * @example
 * wTools.fileProvider.statResolvedRead( './notExistingFile.txt' );
 * // returns null
 *
 * @example
 * let consequence = wTools.fileProvider.statResolvedRead
 * ({
 *  filePath : './existingDir/test.txt',
 *  sync : 0
 * });
 * consequence.got( ( err, stats ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( stats );
 * })
 *
 * @method statResolvedRead
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.filePath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.filePath ) path to a file doesn't exist.
 * @memberof wFileProviderPartial
 */

let statRead = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, statRead_body );

statRead.having.aspect = 'entry';
statRead.having.hubRedirecting = 0;

statRead.defaults.resolvingSoftLink = 0;
statRead.defaults.resolvingTextLink = 0;

//

let statResolvedRead = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, statRead_body );

statResolvedRead.having.aspect = 'entry';
statResolvedRead.having.hubRedirecting = 0;

statResolvedRead.defaults.resolvingSoftLink = null;
statResolvedRead.defaults.resolvingTextLink = null;

//

/**
 * Returns sum of sizes of files in `paths`.
 * @example
 * let path1 = 'tmp/sample/file1',
   path2 = 'tmp/sample/file2',
   textData1 = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
   textData2 = 'Aenean non feugiat mauris';

   wTools.fileWrite( { filePath : path1, data : textData1 } );
   wTools.fileWrite( { filePath : path2, data : textData2 } );
   let size = wTools.filesSize( [ path1, path2 ] );
   console.log(size); // 81
 * @param {string|string[]} paths path to file or array of paths
 * @param {Object} [o] additional o
 * @param {Function} [o.onBegin] callback that invokes before calculation size.
 * @param {Function} [o.onEnd] callback.
 * @returns {number} size in bytes
 * @method filesSize
 * @memberof wFileProviderPartial
 */

function filesSize( o )
{
  let self = this;
  o = o || Object.create( null );

  if( _.strIs( o ) || _.arrayIs( o ) )
  o = { filePath : o };

  _.assert( arguments.length === 1, 'Expects single argument' );

  o.filePath = _.arrayAs( o.filePath );

  let optionsForSize = _.mapExtend( null, o );
  optionsForSize.filePath = o.filePath[ 0 ];

  let result = self.fileSize( optionsForSize );

  for( let p = 1 ; p < o.filePath.length ; p++ )
  {
    optionsForSize.filePath = o.filePath[ p ];
    result += self.fileSize( optionsForSize );
  }

  return result;
}

var having = filesSize.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

var operates = filesSize.operates = Object.create( null );

//

function fileSize_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let stat = self.statResolvedRead( o );

  _.sure( _.objectIs( stat ) );

  return stat.size;
}

_.routineExtend( fileSize_body, statResolvedRead );

var having = fileSize_body.having;
having.driving = 0;
having.aspect = 'body';
having.hubRedirecting = 0;

//

let _fileExistsAct = Object.create( null );
statReadAct.name = 'fileExistsAct';

var defaults = _fileExistsAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;

var having = _fileExistsAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = _fileExistsAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

function fileExistsAct( o )
{
  let self = this;
  let o2 = _.mapExtend( null, o );
  _.assert( fileExistsAct, arguments );
  o2.throwing = 0;
  o2.resolvingSoftLink = 0;
  debugger;
  let result = self.statReadAct( o2 );
  _.assert( result === null || _.objectIs( result ) );
  _.assert( arguments.length === 1 );
  return !!result;
}

_.routineExtend( fileExistsAct, _fileExistsAct );

//

/**
 * Returns object with information about a file.
 * @param {String|Object} o Path to a file or object with options.
 * @param {String|FileRecord} [ o.filePath=null ] - Path to a file or instance of FileRecord @see{@link wFileRecord}
 * @param {Boolean} [ o.sync=true ] - Determines in which way file stats will be readed : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=false ] - Controls error throwing. Returns null if error occurred and ( throwing ) is disabled.
 * @param {Boolean} [ o.resolvingTextLink=false ] - Enables resolving of text links @see{@link wFileProviderPartial~resolvingTextLink}.
 * @param {Boolean} [ o.resolvingSoftLink=true ] - Enables resolving of soft links @see{@link wFileProviderPartial~resolvingSoftLink}.
 * @returns {Object|wConsequence|null}
 * If ( o.filePath ) path exists - returns file stats as Object, otherwise returns null.
 * If ( o.sync ) mode is disabled - returns Consequence instance @see{@link wConsequence }.
 * @example
 * wTools.fileProvider.fileExists( './existingDir/test.txt' );
 * // returns
 * Stats
 * {
    dev : 2523469189,
    mode : 16822,
    nlink : 1,
    uid : 0,
    gid : 0,
    rdev : 0,
    blksize : undefined,
    ino : 13229323905402304,
    size : 0,
    blocks : undefined,
    atimeMs : 1525429693979.7004,
    mtimeMs : 1525429693979.7004,
    ctimeMs : 1525429693979.7004,
    birthtimeMs : 1513244276986.976,
    atime : '2018-05-04T10:28:13.980Z',
    mtime : '2018-05-04T10:28:13.980Z',
    ctime : '2018-05-04T10:28:13.980Z',
    birthtime : '2017-12-14T09:37:56.987Z',
  }
 *
 * @example
 * wTools.fileProvider.fileExists( './notExistingFile.txt' );
 * // returns null
 *
 * @example
 * let consequence = wTools.fileProvider.fileExists
 * ({
 *  filePath : './existingDir/test.txt',
 *  sync : 0
 * });
 * consequence.got( ( err, stats ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( stats );
 * })
 *
 * @method fileExists
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.filePath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.filePath ) path to a file doesn't exist.
 * @memberof wFileProviderPartial
 */

function fileExists_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.routineIs( self.fileExistsAct ) );

  // let o2 = _.mapOnly( o, self.fileExistsAct.defaults );

  return self.fileExistsAct( o );
}

_.routineExtend( fileExists_body, fileExistsAct );

var having = fileExists_body.having;
having.driving = 0;
having.aspect = 'body';

//

let fileExists = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, fileExists_body );

var having = fileExists.having;
fileExists.having.aspect = 'entry';

// --
// read
// --

let streamReadAct = Object.create( null );
statReadAct.name = 'streamReadAct';

var defaults = streamReadAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.encoding = null;

var having = streamReadAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = streamReadAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

function streamRead_body( o )
{
  let self = this;
  let result;
  let optionsRead = _.mapExtend( null, o );
  delete optionsRead.throwing;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !o.throwing )
  {
    try
    {
      result = self.streamReadAct( optionsRead );
    }
    catch( err )
    {
      return null;
    }
  }
  else
  {
    result = self.streamReadAct( optionsRead );
  }

  return result;
}

_.routineExtend( streamRead_body, streamReadAct );

var defaults = streamRead_body.defaults;
defaults.throwing = null;

var having = streamRead_body.having;
having.driving = 0;
having.aspect = 'body';

let streamRead = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, streamRead_body );
streamRead.having.aspect = 'entry';

//

function fileRead_pre( routine, args )
{
  let self = this;

  let o = self._preFilePathScalarWithoutProviderDefaults.apply( self, arguments );

  if( o.verbosity === null )
  o.verbosity = _.numberClamp( self.verbosity - 5, 0, 9 );

  self._providerDefaults( o );

  return o;
}

//

let fileReadAct = Object.create( null );
fileReadAct.name = 'fileReadAct';

var defaults = fileReadAct.defaults = Object.create( null );
defaults.sync = null;
defaults.filePath = null;
defaults.encoding = null;
defaults.advanced = null;
defaults.resolvingSoftLink = null;

var having = fileReadAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = fileReadAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 };

//

function fileRead_body( o )
{
  let self = this;
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( o.encoding ) );

  let encoder = fileRead.encoders[ o.encoding ];

  if( o.resolvingTextLink && self.usingTextLink )
  o.filePath = self.pathResolveTextLink( o.filePath );

  /* exec */

  handleBegin();

  let optionsRead = _.mapOnly( o, self.fileReadAct.defaults );

  try
  {
    result = self.fileReadAct( optionsRead );
  }
  catch( err )
  {
    if( o.sync )
    result = err;
    else
    result = new _.Consequence().error( err );
  }

  /* throwing */

  if( o.sync )
  {
    if( _.errIs( result ) )
    return handleError( result );
    return handleEnd( result );
  }
  else
  {

    result
    .thenKeep( handleEnd )
    .except( handleError )
    ;

    return result;
  }

  /* return */

  return handleEnd( result );

  /* begin */

  function handleBegin()
  {

    if( encoder && encoder.onBegin )
    _.sure( encoder.onBegin.call( self, { operation : o, encoder : encoder }) === undefined );

    if( !o.onBegin )
    return;

    let r = o

    debugger;
    _.Consequence.Take( o.onBegin, r );
  }

  /* end */

  function handleEnd( data )
  {

    try
    {
      let context = { data : data, operation : o, encoder : encoder, provider : self };
      if( encoder && encoder.onEnd )
      _.sure( encoder.onEnd.call( self, context ) === undefined );
      data = context.data;
    }
    catch( err )
    {
      debugger;
      handleError( err );
      return null;
    }

    if( o.verbosity >= 1 )
    self.logger.log( ' . Read :', o.filePath );

    o.result = data;

    let r;
    if( o.returningRead )
    r = data;
    else
    r = o;

    if( o.onEnd )
    debugger;
    if( o.onEnd )
    _.Consequence.Take( o.onEnd, o );

    return r;
  }

  /* error */

  function handleError( err )
  {

    if( encoder && encoder.onError )
    try
    {
      err = _._err
      ({
        args : [ stack, '\nfileRead( ', o.filePath, ' )\n', err ],
        usingSourceCode : 0,
        level : 0,
      });
      err = encoder.onError.call( self, { error : err, operation : o, encoder : encoder })
    }
    catch( err2 )
    {
      /* there the simplest output is reqired to avoid recursion */
      console.error( err2 );
      console.error( err.toString() + '\n' + err.stack );
    }

    if( o.onError )
    _.Consequence.Error( o.onError, err );

    if( o.throwing )
    throw _.err( err );

    return null;
  }

}

_.routineExtend( fileRead_body, fileReadAct );

var defaults = fileRead_body.defaults;
defaults.returningRead = 1;
defaults.throwing = null;
// defaults.name = null;
defaults.onBegin = null;
defaults.onEnd = null;
defaults.onError = null;
defaults.resolvingTextLink = null;
defaults.verbosity = null;

var having = fileRead_body.having;
having.driving = 0;
having.aspect = 'body';

fileRead_body.encoders = _.FileReadEncoders;
_.assert( _.objectIs( fileRead_body.encoders ) );

//

/**
 * Reads the entire content of a file.
 * Accepts single paramenter - path to a file ( o.filePath ) or options map( o ).
 * Returns wConsequence instance. If `o` sync parameter is set to true (by default) and returnRead is set to true,
    method returns encoded content of a file.
 * There are several way to get read content : as argument for function passed to wConsequence.got(), as second argument
    for `o.onEnd` callback, and as direct method returns, if `o.returnRead` is set to true.
 *
 * @example
 * // content of tmp/json1.json : {"a" :1, "b" :"s", "c" : [ 1, 3, 4 ] }
   let fileReadOptions =
   {
     sync : 0,
     filePath : 'tmp/json1.json',
     encoding : 'json',

     onEnd : function( err, result )
     {
       console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
     }
   };

   let con = wTools.fileProvider.fileRead( fileReadOptions );

   // or
   fileReadOptions.onEnd = null;
   let con2 = wTools.fileProvider.fileRead( fileReadOptions );

   con2.got(function( err, result )
   {
     console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
   });

 * @example
   fileRead({ filePath : file.absolute, encoding : 'buffer.node' })

 * @param {Object} o Read options
 * @param {String} [o.filePath=null] Path to read file
 * @param {Boolean} [o.sync=true] Determines in which way will be read file. If this set to false, file will be read
    asynchronously, else synchronously
 * Note : if even o.sync sets to true, but o.returnRead if false, method will path resolve read content through wConsequence
    anyway.
 * @param {Boolean} [o.returningRead=true] If this parameter sets to true, o.onBegin callback will get `o` options, wrapped
    into object with key 'options' and options as value.
 * @param {Boolean} [o.throwing=false] Controls error throwing. Returns null if error occurred and ( throwing ) is disabled.
 * @param {String} [o.name=null]
 * @param {String} [o.encoding='utf8'] Determines encoding processor. The possible values are :
 *    'utf8' : default value, file content will be read as string.
 *    'json' : file content will be parsed as JSON.
 *    'arrayBuffer' : the file content will be return as raw ArrayBuffer.
 * @param {fileRead~onBegin} [o.onBegin=null] @see [@link fileRead~onBegin]
 * @param {Function} [o.onEnd=null] @see [@link fileRead~onEnd]
 * @param {Function} [o.onError=null] @see [@link fileRead~onError]
 * @param {*} [o.advanced=null]
 * @returns {wConsequence|ArrayBuffer|string|Array|Object}
 * @throws {Error} If missed arguments.
 * @throws {Error} If ( o ) has extra parameters.
 * @method fileRead
 * @memberof FileProvider.Partial
 */

/**
 * This callback is run before fileRead starts read the file. Accepts error as first parameter.
 * If in fileRead passed 'o.returningRead' that is set to true, callback accepts as second parameter object with key 'options'
    and value that is reference to options object passed into fileRead method, and user has ability to configure that
    before start reading file.
 * @callback fileRead~onBegin
 * @param {Error} err
 * @param {Object|*} options options argument passed into fileRead.
 */

/**
 * This callback invoked after file has been read, and accepts encoded file content data (by depend from
    options.encoding value), string by default ('utf8' encoding).
 * @callback fileRead~onEnd
 * @param {Error} err Error occurred during file read. If read success it's sets to null.
 * @param {ArrayBuffer|Object|Array|String} result Encoded content of read file.
 */

/**
 * Callback invoke if error occurred during file read.
 * @callback fileRead~onError
 * @param {Error} error
 */

let fileRead = _.routineFromPreAndBody( fileRead_pre, fileRead_body );

fileRead.having.aspect = 'entry';
fileRead.having.hubResolving = 1;

//

/**
 * Reads the entire content of a file synchronously.
 * Method returns encoded content of a file.
 * Can accepts `filePath` as first parameters and options as second
 *
 * @example
 * // content of tmp/json1.json : { "a" : 1, "b" : "s", "c" : [ 1, 3, 4 ]}
 let fileReadOptions =
 {
   filePath : 'tmp/json1.json',
   encoding : 'json',

   onEnd : function( err, result )
   {
     console.log(result); // { a : 1, b : 's', c : [ 1, 3, 4 ] }
   }
 };

 let res = wTools.fileReadSync( fileReadOptions );
 // { a : 1, b : 's', c : [ 1, 3, 4 ] }

 * @param {Object} o read options
 * @param {string} o.filePath path to read file
 * @param {boolean} [o.returningRead=true] If this parameter sets to true, o.onBegin callback will get `o` options, wrapped
 into object with key 'options' and options as value.
 * @param {boolean} [o.silent=false] If set to true, method will caught errors occurred during read file process, and
 pass into o.onEnd as first parameter. Note : if sync is set to false, error will caught anyway.
 * @param {string} [o.name=null]
 * @param {string} [o.encoding='utf8'] Determines encoding processor. The possible values are :
 *    'utf8' : default value, file content will be read as string.
 *    'json' : file content will be parsed as JSON.
 *    'arrayBuffer' : the file content will be return as raw ArrayBuffer.
 * @param {fileRead~onBegin} [o.onBegin=null] @see [@link fileRead~onBegin]
 * @param {Function} [o.onEnd=null] @see [@link fileRead~onEnd]
 * @param {Function} [o.onError=null] @see [@link fileRead~onError]
 * @param {*} [o.advanced=null]
 * @returns {wConsequence|ArrayBuffer|string|Array|Object}
 * @throws {Error} if missed arguments
 * @throws {Error} if `o` has extra parameters
 * @method fileReadSync
 * @memberof wFileProviderPartial
 */

let fileReadSync = _.routineFromPreAndBody( fileRead.pre, fileRead.body );

fileReadSync.defaults.sync = 1;
fileReadSync.having.aspect = 'entry';

//

function fileReadJson_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self.fileRead( o );
}

_.routineExtend( fileReadJson_body, fileRead );

var defaults = fileReadJson_body.defaults;
defaults.sync = 1;
defaults.encoding = 'json';

var having = fileReadJson_body.having;
having.driving = 0;
having.aspect = 'body';

//

/**
 * Reads a JSON file and then parses it into an object.
 *
 * @example
 * // content of tmp/json1.json : {"a" :1, "b" :"s", "c" :[1, 3, 4]}
 *
 * let res = wTools.fileReadJson( 'tmp/json1.json' );
 * // { a : 1, b : 's', c : [ 1, 3, 4 ] }
 * @param {string} filePath file path
 * @returns {*}
 * @throws {Error} If missed arguments, or passed more then one argument.
 * @method fileReadJson
 * @memberof wFileProviderPartial
 */

let fileReadJson = _.routineFromPreAndBody( fileRead.pre, fileReadJson_body );

fileReadJson.having.aspect = 'entry';

//

function fileReadJs_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  return self.fileRead( o );
}

_.routineExtend( fileReadJs_body, fileRead );

var defaults = fileReadJs_body.defaults;
defaults.sync = 1;
defaults.encoding = 'js.structure';

var having = fileReadJs_body.having;
having.driving = 0;
having.aspect = 'body';

//

let fileReadJs = _.routineFromPreAndBody( fileRead.pre, fileReadJs_body );
var having = fileReadJs.having;
fileReadJs.having.aspect = 'entry';

//

function _fileInterpret_pre( routine, args )
{
  let self = this;

  _.assert( args.length === 1 );

  let o = args[ 0 ];

  if( self.path.like( o ) )
  o = { filePath : self.path.from( o ) };

  _.routineOptions( routine, o );
  let encoding = o.encoding;
  self._providerDefaults( o );
  o.encoding = encoding;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( _.strIs( o.filePath ) );

  o.filePath = self.path.normalize( o.filePath );

  return o;
}

//

function _fileInterpret_body( o )
{
  let self = this;
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !o.encoding )
  {
    let ext = self.path.ext( o.filePath );
    for( let e in fileInterpret.encoders )
    {
      let encoder = fileInterpret.encoders[ e ];
      if( !encoder.exts )
      continue;
      if( encoder.forInterpreter !== undefined && !encoder.forInterpreter )
      continue;
      if( _.arrayHas( encoder.exts, ext ) )
      {
        o.encoding = e;
        break;
      }
    }
  }

  if( !o.encoding )
  o.encoding = fileRead.defaults.encoding;

  return self.fileRead( o );
}

_.routineExtend( _fileInterpret_body, fileRead );

_fileInterpret_body.defaults.encoding = null;

let fileInterpret = _.routineFromPreAndBody( _fileInterpret_pre, _fileInterpret_body );

fileInterpret.having.aspect = 'entry';

//

// let hashReadAct = Object.create( null );
// hashReadAct.name = 'hashReadAct';

let hashReadAct = ( function hashReadAct()
{
  let Crypto;

  return function hashReadAct( o )
  {
    let self = this;

    _.assert( arguments.length === 1, 'Expects single argument' );

    // if( o.verbosity >= 3 )
    // self.logger.log( ' . hashRead :', o.filePath );

    if( Crypto === undefined )
    Crypto = require( 'crypto' );
    let md5sum = Crypto.createHash( 'md5' );

    /* */

    if( o.sync && _.boolLike( o.sync ) )
    {
      let result;
      try
      {
        let stat = self.statResolvedRead({ filePath : o.filePath, sync : 1, throwing : 0 });
        _.sure( !!stat, 'Cant get stats of file ' + _.strQuote( o.filePath ) );
        if( stat.size > self.hashFileSizeLimit )
        throw _.err( 'File is too big ' + _.strQuote( o.filePath ) + ' ' + stat.size + ' > ' + self.hashFileSizeLimit );
        let read = self.fileReadSync( o.filePath );
        md5sum.update( read );
        result = md5sum.digest( 'hex' );
      }
      catch( err )
      {
        // if( o.throwing )
        throw err;
        // result = NaN;
      }

      return result;

    }
    else if( o.sync === 'worker' )
    {

      debugger; throw _.err( 'not implemented' );

    }
    else
    {
      let con = new _.Consequence();
      let stream = self.streamRead( o.filePath );

      stream.on( 'data', function( d )
      {
        md5sum.update( d );
      });

      stream.on( 'end', function()
      {
        let hash = md5sum.digest( 'hex' );
        con.take( hash );
      });

      stream.on( 'error', function( err )
      {
        // if( o.throwing )
        con.error( _.err( err ) );
        // else
        // con.take( NaN );
      });

      return con;
    }
  }

})();

var defaults = hashReadAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;
// defaults.throwing = null;

var having = hashReadAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = hashReadAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//
//
// let hashRead_body = ( function()
// {
//   let Crypto;
//
//   return function hashRead( o )
//   {
//     let self = this;
//
//     _.assert( arguments.length === 1, 'Expects single argument' );
//
//     debugger;
//     if( o.verbosity >= 3 )
//     self.logger.log( ' . hashRead :', o.filePath );
//
//     if( Crypto === undefined )
//     Crypto = require( 'crypto' );
//     let md5sum = Crypto.createHash( 'md5' );
//
//     /* */
//
//     if( o.sync && _.boolLike( o.sync ) )
//     {
//       let result;
//       try
//       {
//         let stat = self.statResolvedRead({ filePath : o.filePath, sync : 1, throwing : 0 });
//         _.sure( !!stat, 'Cant get stats of file ' + _.strQuote( o.filePath ) );
//         if( stat.size > self.hashFileSizeLimit )
//         throw _.err( 'File is too big ' + _.strQuote( o.filePath ) + ' ' + stat.size + ' > ' + self.hashFileSizeLimit );
//         let read = self.fileReadSync( o.filePath );
//         md5sum.update( read );
//         result = md5sum.digest( 'hex' );
//       }
//       catch( err )
//       {
//         if( o.throwing )
//         throw err;
//         result = NaN;
//       }
//
//       return result;
//
//     }
//     else if( o.sync === 'worker' )
//     {
//
//       debugger; throw _.err( 'not implemented' );
//
//     }
//     else
//     {
//       let con = new _.Consequence();
//       let stream = self.streamRead( o.filePath );
//
//       stream.on( 'data', function( d )
//       {
//         md5sum.update( d );
//       });
//
//       stream.on( 'end', function()
//       {
//         let hash = md5sum.digest( 'hex' );
//         con.take( hash );
//       });
//
//       stream.on( 'error', function( err )
//       {
//         if( o.throwing )
//         con.error( _.err( err ) );
//         else
//         con.take( NaN );
//       });
//
//       return con;
//     }
//   }
//
// })();

//

/**
 * Returns md5 hash string based on the content of the terminal file.
 * @param {String|Object} o Path to a file or object with options.
 * @param {String|FileRecord} [ o.filePath=null ] - Path to a file or instance of FileRecord @see{@link wFileRecord}
 * @param {Boolean} [ o.sync=true ] - Determines in which way file will be read : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=false ] - Controls error throwing. Returns NaN if error occurred and ( throwing ) is disabled.
 * @param {Boolean} [ o.verbosity=0 ] - Sets the level of console output.
 * @returns {Object|wConsequence|NaN}
 * If ( o.filePath ) path exists - returns hash as String, otherwise returns null.
 * If ( o.sync ) mode is disabled - returns Consequence instance @see{@link wConsequence }.
 * @example
 * wTools.fileProvider.hashRead( './existingDir/test.txt' );
 * // returns 'fd8b30903ac80418777799a8200c4ff5'
 *
 * @example
 * wTools.fileProvider.hashRead( './notExistingFile.txt' );
 * // returns NaN
 *
 * @example
 * let consequence = wTools.fileProvider.hashRead
 * ({
 *  filePath : './existingDir/test.txt',
 *  sync : 0
 * });
 * consequence.got( ( err, hash ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( hash );
 * })
 *
 * @method hashRead
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.filePath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.filePath ) path to a file doesn't exist or file is a directory.
 * @memberof wFileProviderPartial
 */

function hashRead_body( o )
{
  let self = this;
  let result;

  if( o.verbosity >= 1 )
  self.logger.log( ' . hashRead :', o.filePath );

  try
  {
    result = self.hashReadAct( o );
  }
  catch( err )
  {
    if( o.throwing )
    throw _.err( 'Cant read hash of', o.filePath, '\n', err );
    else
    return NaN;
  }

  if( _.consequenceIs( result ) )
  result.finally( ( err, arg ) =>
  {
    if( err )
    if( o.throwing )
    throw _.err( 'Cant read hash of', o.filePath, '\n', err );
    else
    return NaN;
    return arg;
  });

  return result;
}

_.routineExtend( hashRead_body, hashReadAct );

var defaults = hashRead_body.defaults;
defaults.throwing = null;
defaults.verbosity = null;

var having = hashRead_body.having;
having.driving = 0;
having.aspect = 'body';

let hashRead = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, hashRead_body );
hashRead.having.aspect = 'entry';

//

// let hashRead = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, hashRead_body );
//
// hashRead.having.aspect = 'entry';

//

let dirReadAct = Object.create( null );
dirReadAct.name = 'dirReadAct';

var defaults = dirReadAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;
// defaults.throwing = null;

var having = dirReadAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = dirReadAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

function dirRead_pre( routine, args )
{
  let self = this;
  let o = self._preFilePathScalarWithProviderDefaults.apply( self, arguments );
  return o;
  // _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  // _.assert( args.length === 0 || args.length === 1 );
  //
  // let o = args[ 0 ] || Object.create( null );
  //
  // if( self.path.like( o ) )
  // o = { filePath : self.path.from( o ) };
  //
  // _.routineOptions( routine, o );
  // self._providerDefaults( o );
  //
  // _.assert( self.path.isAbsolute( o.filePath ) );
  //
  // return o;
}

//

function dirRead_body( o )
{
  let self = this;
  let result;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.arrayHas( [ 'record', 'absolute', 'relative' ], o.outputFormat ) )
  _.assertRoutineOptions( dirRead_body, arguments );

  let filePath = o.filePath;
  let o2 = _.mapExtend( null, o );
  delete o2.outputFormat;
  delete o2.basePath;
  delete o2.throwing;
  o2.filePath = self.path.normalize( o2.filePath );

  /* */

  try
  {
    result = self.dirReadAct( o2 );
  }
  catch( err )
  {
    if( o.throwing )
    throw _.err( err );
    else
    return null;
  }

  /* */

  if( o2.sync )
  {
    if( result )
    result = adjust( result );
  }
  else
  {
    result.finally( function( err, list )
    {
      if( err )
      if( o.throwing )
      throw _.err( err );
      else
      return null;
      if( list )
      return adjust( list );
      return list;
    });
  }

  return result;

  /* - */

  function adjust( result )
  {
    if( _.strIs( result ) )
    {
      filePath = self.path.dir( filePath );
      result = [ result ];
    }

    _.assert( _.arrayIs( result ) );

    result.sort( function( a, b )
    {
      a = a.toLowerCase();
      b = b.toLowerCase();
      if( a < b ) return -1;
      if( a > b ) return +1;
      return 0;
    });

    /*
    qqq : add test case for this line
    Vova : low priority
    */
    // let isDir = self.resolvedIsDir( o.filePath );

    if( o.outputFormat === 'absolute' )
    result = result.map( function( relative )
    {
      return self.path.join( filePath, relative );
    });
    else if( o.outputFormat === 'record' )
    result = result.map( function( relative )
    {
      return self.recordFactory({ dirPath : filePath, basePath : o.basePath }).record( relative );
    });
    else if( o.basePath )
    result = result.map( function( relative )
    {
      return self.path.relative( o.basePath, self.path.join( filePath, relative ) );
    });

    return result;
  }

}

_.routineExtend( dirRead_body, dirReadAct );

var defaults = dirRead_body.defaults;
defaults.outputFormat = 'relative';
defaults.basePath = null;
defaults.throwing = 0;

var having = dirRead_body.having;
having.driving = 0;
having.aspect = 'body';

//

/**
 * Returns list of files located in a directory. List is represented as array of paths to that files.
 * @param {String|Object} o Path to a directory or object with options.
 * @param {String|FileRecord} [ o.filePath=null ] - Path to a directory or instance of FileRecord @see{@link wFileRecord}
 * @param {Boolean} [ o.sync=true ] - Determines in which way list of files will be read : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=false ] - Controls error throwing. Returns null if error occurred and ( throwing ) is disabled.
 * @param {String} [ o.outputFormat='relative' ] - Sets style of a file path in a result array. Possible values : 'relative', 'absolute', 'record'.
 * @param {String} [ o.basePath=o.filePath ] - Relative path to a files from directory located by path ( o.filePath ). By default is equal to ( o.filePath );
 * @returns {Array|wConsequence|null}
 * If ( o.filePath ) path exists - returns list of files as Array, otherwise returns null.
 * If ( o.sync ) mode is disabled - returns Consequence instance @see{@link wConsequence }.
 *
 * @example
 * wTools.fileProvider.dirRead( './existingDir' );
 * // returns [ 'a.txt', 'b.js', 'c.md' ]
 *
 * @example
 * wTools.fileProvider.dirRead( './notExistingDir' );
 * // returns null
 *
 * * @example
 * wTools.fileProvider.dirRead( './existingEmptyDir' );
 * // returns []
 *
 * @example
 * let consequence = wTools.fileProvider.dirRead
 * ({
 *  filePath : './existingDir',
 *  sync : 0
 * });
 * consequence.got( ( err, files ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( files );
 * })
 *
 * @method dirRead
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.filePath ) path is not a String or instance of FileRecord @see{@link wFileRecord}
 * @throws { Exception } If ( o.filePath ) path doesn't exist.
 * @memberof wFileProviderPartial
 */

let dirRead = _.routineFromPreAndBody( dirRead_pre, dirRead_body );

dirRead.having.aspect = 'entry';

//

function dirReadDirs_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = self.dirRead( o );

  result = result.filter( function( path )
  {
    let stat = self.statResolvedRead( path );
    if( stat.isDir() )
    return true;
  });

  return result;
}

_.routineExtend( dirReadDirs_body, dirRead );

var having = dirReadDirs_body.having;
having.driving = 0;
having.aspect = 'body';

//

let dirReadDirs = _.routineFromPreAndBody( dirRead.pre, dirReadDirs_body );
dirReadDirs.having.aspect = 'entry';

//

function dirReadTerminals_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = self.dirRead( o );

  result = result.filter( function( path )
  {
    let stat = self.statResolvedRead( path );
    if( !stat.isDir() )
    return true;
  });

  return result;

}

_.routineExtend( dirReadTerminals_body, dirRead );

var having = dirReadTerminals_body.having;
having.driving = 0;
having.aspect = 'body';

//

let dirReadTerminals = _.routineFromPreAndBody( dirRead.pre, dirReadTerminals_body );
dirReadTerminals.having.aspect = 'entry';

//

function filesFingerprints( files )
{
  let self = this;

  if( _.strIs( files ) || files instanceof _.FileRecord )
  files = [ files ];

  _.assert( _.arrayIs( files ) || _.mapIs( files ) );

  let result = Object.create( null );

  for( let f = 0 ; f < files.length ; f++ )
  {
    let record = self.record( files[ f ] );
    let fingerprint = Object.create( null );

    if( !record.isActual )
    continue;

    fingerprint.size = record.stat.size;
    fingerprint.hash = record.hashRead();

    result[ record.relative ] = fingerprint;
  }

  return result;
}

var having = filesFingerprints.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

//

/**
 * Check if two paths, file stats or FileRecords are associated with the same file or files with same content.
 * @example
 * let path1 = 'tmp/sample/file1',
     path2 = 'tmp/sample/file2',
     usingExtraStat = true,
     buffer = Buffer.from( [ 0x01, 0x02, 0x03, 0x04 ] );

   wTools.fileWrite( { filePath : path1, data : buffer } );
   setTimeout( function()
   {
     wTools.fileWrite( { filePath : path2, data : buffer } );

     let sameWithoutTime = wTools.filesAreSame( path1, path2 ); // true

     let sameWithTime = wTools.filesAreSame( path1, path2, usingExtraStat ); // false
   }, 100);
 * @param {string|wFileRecord} ins1 first file to compare
 * @param {string|wFileRecord} ins2 second file to compare
 * @param {boolean} usingExtraStat if this argument sets to true method will additionally check modified time of files, and
    if they are different, method returns false.
 * @returns {boolean}
 * @method filesAreSame
 * @memberof wFileProviderPartial
 */

function filesAreSame_pre( routine, args )
{
  let self = this;
  let o;

  if( args.length === 2 || args.length === 3 )
  {
    o =
    {
      ins1 : args[ 0 ],
      ins2 : args[ 1 ],
      default : args[ 2 ],
    }
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.routineOptions( routine, o );

  return o;
}

//

function filesAreSame_body( o )
{
  let self = this;

  // debugger;
  let f = self.recordFactory({ resolvingSoftLink : 0, resolvingTextLink : 0 });
  // debugger;

  o.ins1 = f.record( o.ins1 );
  o.ins2 = f.record( o.ins2 );

  /* no stat */

  if( !o.ins1.stat )
  return false;
  if( !o.ins2.stat )
  return false;

  if( o.ins1.factory.effectiveFileProvider === o.ins2.factory.effectiveFileProvider && o.ins1.stat.ino > 0 )
  {
    let could = _.statsAreHardLinked( o.ins1.stat, o.ins2.stat );
    if( could === true || could === _.maybe )
    return true;
  }

  /* dir */

  if( o.ins1.stat.isDir() )
  {
    if( !o.ins2.stat.isDir() )
    return false;
    debugger;

    if( o.ins1.factory.effectiveFileProvider === o.ins2.factory.effectiveFileProvider && o.ins1.stat.ino > 0 )
    if( self.UsingBigIntForStat )
    return o.ins1.ino === o.ins2.ino;
    else
    return o.ins1.ino === o.ins2.ino ? null : false;

    // if( o.ins1.ino > 0 )
    // if( o.ins1.ino === o.ins2.ino )
    // return true;
    // if( o.ins1.size !== o.ins2.size )
    // return false;
    // return o.ins1.real === o.ins2.real;

    return false;
  }

  /* soft link */

  if( o.ins1.isSoftLink )
  {
    debugger;
    if( !o.ins2.isSoftLink )
    return false;
    return self.pathResolveSoftLink( o.ins1 ) === self.pathResolveSoftLink( o.ins2 );
  }

  /* text link */

  if( self.usingTextLink )
  if( o.ins1.isTextLink )
  {
    debugger;
    if( !o.ins2.isTextLink )
    return false;
    return self.pathResolveTextLink( o.ins1 ) === self.pathResolveTextLink( o.ins2 );
  }

  /* hard linked */

  if( o.ins1.factory.effectiveFileProvider === o.ins2.factory.effectiveFileProvider && o.ins1.stat.ino > 0 )
  if( self.UsingBigIntForStat )
  if( o.ins1.stat.ino === o.ins2.stat.ino )
  return true;

  /* false for empty files */

  if( !o.ins1.stat.size || !o.ins2.stat.size )
  return false;

  /* size */

  if( o.ins1.stat.size !== o.ins2.stat.size )
  return false;

  /* hash */

  try
  {
    let h1 = o.ins1.hashRead();
    let h2 = o.ins2.hashRead();

    _.assert( _.strIs( h1 ) && _.strIs( h2 ) );

    return h1 === h2;
  }
  catch( err )
  {
    return o.default;
  }
}

var defaults = filesAreSame_body.defaults = Object.create( null );
defaults.ins1 = null;
defaults.ins2 = null;
defaults.default = NaN;

var having = filesAreSame_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.aspect = 'body';

var operates = filesAreSame_body.operates = Object.create( null );
operates.ins1 = { pathToRead : 1 };
operates.ins2 = { pathToRead : 1 };

/*
qqq : add operate to methods which miss it
aaa : done
*/

//

let filesAreSame = _.routineFromPreAndBody( filesAreSame_pre, filesAreSame_body );
filesAreSame.having.aspect = 'entry';

//

/**
 * Return file size in bytes. For symbolic links return false. If onEnd callback is defined, method returns instance
    of wConsequence.
 * @example
 * let path = 'tmp/fileSize/data4',
     bufferData1 = Buffer.from( [ 0x01, 0x02, 0x03, 0x04 ] ), // size 4
     bufferData2 = Buffer.from( [ 0x07, 0x06, 0x05 ] ); // size 3

   wTools.fileWrite( { filePath : path, data : bufferData1 } );

   let size1 = wTools.fileSize( path );
   console.log(size1); // 4

   let con = wTools.fileSize( {
     filePath : path,
     onEnd : function( size )
     {
       console.log( size ); // 7
     }
   } );

   wTools.fileWrite( { filePath : path, data : bufferData2, append : 1 } );

 * @param {string|Object} o o object or path string
 * @param {string} o.filePath path to file
 * @param {Function} [o.onBegin] callback that invokes before calculation size.
 * @param {Function} o.onEnd this callback invoked in end of pathCurrent js event loop and accepts file size as
    argument.
 * @returns {number|boolean|wConsequence}
 * @throws {Error} If passed less or more than one argument.
 * @throws {Error} If passed unexpected parameter in o.
 * @throws {Error} If filePath is not string.
 * @method fileSize
 * @memberof wFileProviderPartial
 */

let fileSize = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, fileSize_body );

fileSize.having.aspect = 'entry';

_.assert( fileSize.having.hubRedirecting === 0 );

//

function isTerminal_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.assertRoutineOptions( isTerminal_body, arguments ) );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );

  // let stat = self.statReadAct
  // ({
  //   filePath : o.filePath,
  //   throwing : 0,
  //   sync : 1,
  //   resolvingSoftLink : 0,
  // });

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : o.resolvingTextLink,
    // stat : stat,
    throwing : 0
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  // if( o.filePath === null )
  // return false;

  if( o2.stat === null )
  return false;

  return o2.stat.isTerminal();
}

var defaults = isTerminal_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;

var having = isTerminal_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.hubResolving = 1;

var operates = isTerminal_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

/**
 * Returns true if file at ( filePath ) is an existing regular terminal file.
 * @example
 * wTools.isTerminal( './existingDir/test.txt' ); // true
 * @param {string} filePath Path string
 * @returns {boolean}
 * @method isTerminal
 * @memberof wFileProviderPartial
 */

let isTerminal = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isTerminal_body );

isTerminal.having.aspect = 'entry';

//

/**
 * Returns true if resolved file at ( filePath ) is an existing regular terminal file.
 * @example
 * wTools.isTerminal( './existingDir/test.txt' ); // true
 * @param {string} filePath Path string
 * @returns {boolean}
 * @method resolvedIsTerminal
 * @memberof wFileProviderPartial
 */

let resolvedIsTerminal = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isTerminal_body );

resolvedIsTerminal.defaults.resolvingSoftLink = null;
resolvedIsTerminal.defaults.resolvingTextLink = null;

resolvedIsTerminal.having.aspect = 'entry';

//

function isDir_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.assertRoutineOptions( isDir_body, arguments ) );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );

  // o.filePath = self.pathResolveLinkFull
  // ({
  //   filePath : o.filePath,
  //   resolvingSoftLink : o.resolvingSoftLink,
  //   resolvingTextLink : o.resolvingTextLink,
  // });
  //
  // let stat = self.statRead
  // ({
  //   filePath : o.filePath,
  //   resolvingSoftLink : 0,
  //   resolvingTextLink : 0,
  // });

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : o.resolvingTextLink,
    // stat : stat,
    throwing : 0
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  if( !o2.stat )
  return false;

  return o2.stat.isDir();
}

var defaults = isDir_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;

var having = isDir_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;

var operates = isDir_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

/**
 * Return True if file at ( filePath ) is an existing directory.
 * If file is symbolic link to file or directory return false.
 * @example
 * wTools.isDir( './existingDir/' ); // true
 * @param {string} filePath Tested path string
 * @returns {boolean}
 * @method isDir
 * @memberof wFileProviderPartial
 */

let isDir = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isDir_body );

isDir.having.aspect = 'entry';

//

/**
 * Return True if file at resolved ( filePath ) is an existing directory.
 * If file is symbolic link to file or directory return false.
 * @example
 * wTools.isDir( './existingDir/' ); // true
 * @param {string} filePath Tested path string
 * @returns {boolean}
 * @method resolvedIsDir
 * @memberof wFileProviderPartial
 */

let resolvedIsDir = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isDir_body );

resolvedIsDir.defaults.resolvingSoftLink = null;
resolvedIsDir.defaults.resolvingTextLink = null;

resolvedIsDir.having.aspect = 'entry';

//

/**
 * Return True if file at `filePath` is a hard link.
 * @param filePath
 * @returns {boolean}
 * @method isHardLink
 * @memberof wFileProviderPartial
 */

function isHardLink_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.assertRoutineOptions( isHardLink_body, arguments ) );
  _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );

  // let stat = self.statReadAct
  // ({
  //   filePath : o.filePath,
  //   throwing : 0,
  //   sync : 1,
  //   resolvingSoftLink : 0,
  // });
  //
  // let o2 =
  // {
  //   filePath : o.filePath,
  //   resolvingSoftLink : o.resolvingSoftLink,
  //   resolvingTextLink : o.resolvingTextLink,
  //   stat : stat,
  //   throwing : 0
  // }
  //
  // o.filePath = self.pathResolveLinkFull( o2 );

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : o.resolvingTextLink,
    // stat : stat,
    throwing : 0
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  // if( o.filePath === null )
  // return false;

  if( o2.stat === null )
  return false;

  return o2.stat.isHardLink();
}

var defaults = isHardLink_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;

var having = isHardLink_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.hubResolving = 1;

var operates = isHardLink_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

let isHardLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isHardLink_body );

isHardLink.defaults.resolvingSoftLink = 0;
isHardLink.defaults.resolvingTextLink = 0;

isHardLink.having.aspect = 'entry';

//

let resolvedIsHardLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isHardLink_body );

resolvedIsHardLink.defaults.resolvingSoftLink = null;
resolvedIsHardLink.defaults.resolvingTextLink = null;

resolvedIsHardLink.having.aspect = 'entry';

//

/**
 * Return True if `filePath` is a symbolic link.
 * @param filePath
 * @returns {boolean}
 * @method isSoftLink
 * @memberof wFileProviderPartial
 */

function isSoftLink_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.assertRoutineOptions( isSoftLink_body, arguments ) );
  // _.assert( _.boolLike( o.resolvingSoftLink ) );
  _.assert( _.boolLike( o.resolvingTextLink ) );

  // let stat = self.statReadAct
  // ({
  //   filePath : o.filePath,
  //   throwing : 0,
  //   sync : 1,
  //   resolvingSoftLink : 0,
  // });
  //
  // let o2 =
  // {
  //   filePath : o.filePath,
  //   resolvingSoftLink : 0,
  //   resolvingTextLink : o.resolvingTextLink,
  //   stat : stat,
  //   throwing : 0
  // }
  //
  // o.filePath = self.pathResolveLinkFull( o2 );

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : 0,
    resolvingTextLink : o.resolvingTextLink,
    // stat : stat,
    throwing : 0,
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  // if( o.filePath === null )
  // return false;

  if( o2.stat === null )
  return false;

  return o2.stat.isSoftLink()
}

var defaults = isSoftLink_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingTextLink = 0;

var having = isSoftLink_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.hubResolving = 1;

var operates = isSoftLink_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

let isSoftLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isSoftLink_body );
isSoftLink.defaults.resolvingTextLink = 0;
isSoftLink.having.aspect = 'entry';

//

let resolvedIsSoftLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isSoftLink_body );
resolvedIsSoftLink.defaults.resolvingTextLink = null;
resolvedIsSoftLink.having.aspect = 'entry';

//

function isTextLink_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.assertRoutineOptions( isTextLink_body, arguments ) );
  _.assert( _.boolLike( o.resolvingSoftLink ) );

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : 0,
    throwing : 0
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  if( o2.stat === null )
  return false;

  return o2.stat.isTextLink();
}

var defaults = isTextLink_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;

var having = isTextLink_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.hubResolving = 1;

var operates = isTextLink_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

//

let isTextLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isTextLink_body );
isTextLink.defaults.resolvingSoftLink = 0;
isTextLink.having.aspect = 'entry';

//

let resolvedIsTextLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isTextLink_body );
resolvedIsTextLink.defaults.resolvingSoftLink = null;
resolvedIsTextLink.having.aspect = 'entry';

//

//

function isLink_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let result = false;

  if( o.resolvingSoftLink && o.resolvingTextLink )
  return result;

  // let stat = self.statReadAct
  // ({
  //   filePath : o.filePath,
  //   throwing : 0,
  //   sync : 1,
  //   resolvingSoftLink : 0,
  // });
  //
  // let o2 =
  // {
  //   filePath : o.filePath,
  //   resolvingSoftLink : o.resolvingSoftLink,
  //   resolvingTextLink : o.resolvingTextLink,
  //   stat : stat,
  //   throwing : 0
  // }
  //
  // o.filePath = self.pathResolveLinkFull( o2 );

  let o2 =
  {
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : o.resolvingTextLink,
    // stat : stat,
    throwing : 0
  }

  o.filePath = self.pathResolveLinkFull( o2 );

  _.assert( o2.stat !== undefined );

  // if( o.filePath === null )
  // return result;

  if( o2.stat === null )
  return result;

  result = o2.stat.isLink();

  return result;
}

var defaults = isLink_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;
defaults.usingTextLink = 0;

var having = isLink_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.aspect = 'body';
having.driving = 0;

var operates = isLink_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 };

//

let isLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isLink_body );

isLink.having.aspect = 'entry';

//

let resolvedIsLink = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, isLink_body );

resolvedIsLink.defaults.resolvingSoftLink = null;
resolvedIsLink.defaults.resolvingTextLink = null;

resolvedIsLink.having.aspect = 'entry';

//

/**
 * Returns True if file at ( filePath ) is an existing empty directory, otherwise returns false.
 * If file is symbolic link to file or directory return false.
 * @example
 * wTools.fileProvider.dirIsEmpty( './existingEmptyDir/' ); // true
 * @param {string} filePath - Path to the directory.
 * @returns {boolean}
 * @method dirIsEmpty
 * @memberof wFileProviderPartial
 */

function dirIsEmpty( filePath )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( self.isDir( filePath ) )
  return !self.dirRead( filePath ).length;

  return false;
}

var having = dirIsEmpty.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

//

function resolvedDirIsEmpty( filePath )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let o = { filePath : filePath };

  if( self.resolvedIsDir( o ) )
  return !self.dirRead( o.filePath ).length;

  return false;
}

var having = resolvedDirIsEmpty.having = Object.create( null );

having.writing = 0;
having.reading = 1;
having.driving = 0;

// --
// write
// --

let streamWriteAct = Object.create( null );
streamWriteAct.name = 'streamWriteAct';

var defaults = streamWriteAct.defaults = Object.create( null );
defaults.filePath = null;

var having = streamWriteAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = streamWriteAct.operates = Object.create( null );
operates.filePath = { pathToWrite : 1 }

//

function streamWrite_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  let o2 = _.mapExtend( null, o );

  return self.streamWriteAct( o2 );
}

_.routineExtend( streamWrite_body, streamWriteAct );

var having = streamWrite_body.having;
having.driving = 0;
having.aspect = 'body';

//

let streamWrite = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, streamWrite_body );
streamWrite.having.aspect = 'entry';

//

let fileWriteAct = Object.create( null );
fileWriteAct.name = 'fileWriteAct';

var defaults = fileWriteAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;
defaults.data = '';
defaults.encoding = 'original.type';
defaults.writeMode = 'rewrite';

var having = fileWriteAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = fileWriteAct.operates = Object.create( null );
operates.filePath = { pathToWrite : 1 }

//

function fileWrite_pre( routine, args )
{
  let self = this;
  let o;

  if( args[ 1 ] !== undefined )
  {
    o = { filePath : args[ 0 ], data : args[ 1 ] };
    _.assert( args.length === 2 );
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
    _.assert( _.objectIs( o ), 'Expects 2 arguments {-o.filePath-} and {-o.data-} to write, or single options map' );
  }

  _.assert( o.data !== undefined, 'Expects defined {-o.data-}' );
  _.routineOptions( routine, o );
  self._providerDefaults( o );
  _.assert( _.strIs( o.filePath ), 'Expects string {-o.filePath-}' );
  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  return o;
}

//

function fileWrite_body( o )
{
  let self = this;
  let path = self.path;

  o.encoding = o.encoding || self.encoding;

  let encoder = self.fileWrite.encoders[ o.encoding ];

  let o2 = _.mapOnly( o, self.fileWriteAct.defaults );

  if( encoder && encoder.onBegin )
  _.sure( encoder.onBegin.call( self, { operation : o2, encoder : encoder, data : o2.data } ) === undefined );

  _.assert( arguments.length === 1, 'Expects single argument' );

  // debugger;
  // if( !path.isSafe( o.filePath, o.safe ) )
  if( !path.isSafe( o.filePath, self.safe ) )
  {
    debugger;
    throw path.ErrorNotSafe( 'Writing', o.filePath, o.safe );
  }

  log();

  /* makingDirectory */

  if( o.makingDirectory )
  {
    self.dirMakeForFile( o.filePath );
  }

  let terminateLink = !self.resolvingSoftLink && self.isSoftLink( o.filePath );

  if( terminateLink && o.writeMode !== 'rewrite' )
  {
    self.fieldPush( 'resolvingSoftLink', 1 );
    let readData = self.fileRead({ filePath :  o.filePath, encoding : 'original.type' });
    self.fieldPop( 'resolvingSoftLink', 1 );

    let writeData = o.data;

    if( _.bufferBytesIs( readData ) )
    writeData = _.bufferBytesFrom( writeData );
    else if( _.bufferRawIs( readData ) )
    writeData = _.bufferRawFrom( writeData );
    else
    _.assert( _.strIs( readData ), 'not implemented for:', _.strType( readData ) );

    if( o.writeMode === 'append' )
    {
      if( _.strIs( writeData ) )
      o2.data = _.strJoin([ readData, writeData ]);
      else
      o2.data = _.bufferJoin( readData, writeData )
    }
    else if( o.writeMode === 'prepend' )
    {
      if( _.strIs( writeData ) )
      o2.data = _.strJoin([ writeData, readData ]);
      else
      o2.data = _.bufferJoin( writeData, readData )
    }
    else
    throw _.err( 'not implemented writeMode :', o.writeMode )

    o2.writeMode = 'rewrite';
  }

  /* purging */

  if( o.purging || terminateLink )
  {
    self.filesDelete({ filePath : o2.filePath, throwing : 0 });
  }

  let result = self.fileWriteAct( o2 );

  if( encoder && encoder.onEnd )
  _.sure( encoder.onEnd.call( self, { operation : o, encoder : encoder, data : o.data, result : result } ) === undefined );

  return result;

  /* log */

  function log()
  {
    if( o.verbosity >= 3 )
    self.logger.log( ' + writing', _.toStrShort( o.data ), 'to', o.filePath );
  }

}

_.routineExtend( fileWrite_body, fileWriteAct );

var defaults = fileWrite_body.defaults;
defaults.verbosity = null;
defaults.makingDirectory = 1;
defaults.purging = 0;

var having = fileWrite_body.having;
having.driving = 0;
having.aspect = 'body';

fileWrite_body.encoders = _.FileWriteEncoders;
_.assert( _.objectIs( fileWrite_body.encoders ) );

//

/**
 * Writes data to a file. `data` can be a string or a buffer. Creating the file if it does not exist yet.
 * Returns wConsequence instance.
 * By default method writes data synchronously, with replacing file if exists, and if parent dir hierarchy doesn't
   exist, it's created. Method can accept two parameters : string `filePath` and string\buffer `data`, or single
   argument : options object, with required 'filePath' and 'data' parameters.
 * @example
 *
    let data = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      options =
      {
        filePath : 'tmp/sample.txt',
        data : data,
        sync : false,
      };
    let con = wTools.fileWrite( options );
    con.got( function()
    {
        console.log('write finished');
    });
 * @param {Object} options write options
 * @param {string} options.filePath path to file is written.
 * @param {string|Buffer} [options.data=''] data to write
 * @param {boolean} [options.append=false] if this options sets to true, method appends passed data to existing data
    in a file
 * @param {boolean} [options.sync=true] if this parameter sets to false, method writes file asynchronously.
 * @param {boolean} [options.force=true] if it's set to false, method throws exception if parents dir in `filePath`
    path is not exists
 * @param {boolean} [options.silentError=false] if it's set to true, method will catch error, that occurs during
    file writes.
 * @param {boolean} [options.verbosity=false] if sets to true, method logs write process.
 * @param {boolean} [options.clean=false] if sets to true, method removes file if exists before writing
 * @returns {wConsequence}
 * @throws {Error} If arguments are missed
 * @throws {Error} If passed more then 2 arguments.
 * @throws {Error} If `filePath` argument or options.PathFile is not string.
 * @throws {Error} If `data` argument or options.data is not string or Buffer,
 * @throws {Error} If options has unexpected property.
 * @method fileWrite
 * @memberof wFileProviderPartial
 */

let fileWrite = _.routineFromPreAndBody( fileWrite_pre, fileWrite_body );

fileWrite.having.aspect = 'entry';

_.assert( _.mapIs( fileWrite.encoders ) );

//

function fileAppend_body( o )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self.fileWrite( o );
}

_.routineExtend( fileAppend_body, fileWriteAct );

var defaults = fileAppend_body.defaults;
defaults.writeMode = 'append';

var having = fileAppend_body.having;
having.driving = 0;
having.aspect = 'body';

//

let fileAppend = _.routineFromPreAndBody( fileWrite_pre, fileAppend_body );
fileAppend.having.aspect = 'entry';

//

function fileWriteJson_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  /* stringify */

  let originalData = o.data;
  if( o.jsLike )
  {
    o.data = _.toJs( o.data );
  }
  else
  {
    if( o.cloning )
    o.data = _.cloneData({ src : o.data });
    if( o.pretty )
    o.data = _.toJson( o.data, { cloning : 0 } );
    else
    o.data = JSON.stringify( o.data );
  }

  if( o.prefix )
  o.data = o.prefix + o.data;

  /* validate */

  if( Config.debug && o.pretty ) try
  {

    // let parsedData = o.jsLike ? _.exec( o.data ) : JSON.parse( o.data );
    // _.assert( _.entityEquivalent( parsedData, originalData ), 'not identical' );

  }
  catch( err )
  {

    // debugger;
    self.logger.log( '-' );
    self.logger.error( 'JSON:' );
    self.logger.error( _.toStr( o.data, { levels : 999 } ) );
    self.logger.log( '-' );
    throw _.err( 'Cant convert JSON\n', err );
  }

  /* write */

  // delete o.prefix;
  // delete o.pretty;
  // delete o.jsLike;
  // delete o.cloning;

  let o2 = _.mapOnly( o, self.fileWrite.defaults );

  return self.fileWrite( o2 );
}

_.routineExtend( fileWriteJson_body, fileWrite );

var defaults = fileWriteJson_body.defaults;
defaults.prefix = '';
defaults.jsLike = 0;
defaults.pretty = 1;
defaults.sync = null;
defaults.cloning = _.toJson.cloning;

var having = fileWriteJson_body.having;
having.driving = 0;
having.aspect = 'body';

_.assert( _.boolLike( _.toJson.defaults.cloning ) );

//

/**
 * Writes data as json string to a file. `data` can be a any primitive type, object, array, array like. Method can
    accept options similar to fileWrite method, and have similar behavior.
 * Returns wConsequence instance.
 * By default method writes data synchronously, with replacing file if exists, and if parent dir hierarchy doesn't
 exist, it's created. Method can accept two parameters : string `filePath` and string\buffer `data`, or single
 argument : options object, with required 'filePath' and 'data' parameters.
 * @example
 * let fileProvider = _.FileProvider.Default();
 * let fs = require('fs');
   let data = { a : 'hello', b : 'world' },
   let con = fileProvider.fileWriteJson( 'tmp/sample.json', data );
   // file content : { "a" : "hello", "b" : "world" }

 * @param {Object} o write options
 * @param {string} o.filePath path to file is written.
 * @param {string|Buffer} [o.data=''] data to write
 * @param {boolean} [o.append=false] if this options sets to true, method appends passed data to existing data
 in a file
 * @param {boolean} [o.sync=true] if this parameter sets to false, method writes file asynchronously.
 * @param {boolean} [o.force=true] if it's set to false, method throws exception if parents dir in `filePath`
 path is not exists
 * @param {boolean} [o.silentError=false] if it's set to true, method will catch error, that occurs during
 file writes.
 * @param {boolean} [o.verbosity=false] if sets to true, method logs write process.
 * @param {boolean} [o.clean=false] if sets to true, method removes file if exists before writing
 * @param {string} [o.pretty=''] determines data stringify method.
 * @returns {wConsequence}
 * @throws {Error} If arguments are missed
 * @throws {Error} If passed more then 2 arguments.
 * @throws {Error} If `filePath` argument or options.PathFile is not string.
 * @throws {Error} If options has unexpected property.
 * @method fileWriteJson
 * @memberof wFileProviderPartial
 */

let fileWriteJson = _.routineFromPreAndBody( fileWrite_pre, fileWriteJson_body );
fileWriteJson.having.aspect = 'entry';

//

let fileWriteJs = _.routineFromPreAndBody( fileWrite_pre, fileWriteJson_body );

var defaults = fileWriteJs.defaults;
defaults.jsLike = 1;

var having = fileWriteJs.having;
having.driving = 0;
having.aspect = 'body';

//

function fileTouch_pre( routine, args )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.assert( args.length === 1 || args.length === 2 );

  let o = args[ 0 ];

  if( args.length === 2 )
  {
    o =
    {
      filePath : self.path.from( args[ 0 ] ),
      data : args[ 1 ]
    }
  }
  else
  {
    if( self.path.like( o ) )
    o = { filePath : self.path.from( o ) };
  }

  _.routineOptions( routine, o );
  self._providerDefaults( o );
  _.assert( _.strIs( o.filePath ), 'Expects string {-o.filePath-}, but got', _.strType( o.filePath ) );

  return o;
}

//

function fileTouch_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( self.fileExists( o.filePath ) )
  {
    // let stat = self.statRead( o.filePath );
    if( !self.resolvedIsTerminal( o.filePath ) )
    {
      throw _.err( o.filePath, 'is not terminal' );
      return null;
    }
    o.data = self.fileRead({ filePath : o.filePath, encoding : 'original.type' });
  }
  else
  {
    o.data = '';
  }

  // o.data = stat ? self.fileRead({ filePath : o.filePath, encoding : 'original.type' }) : '';
  self.fileWrite( o );

  return self;
}

_.routineExtend( fileTouch_body, fileWrite );

var defaults = fileTouch_body.defaults;
defaults.data = null;

var having = fileTouch_body.having;
having.driving = 0;
having.aspect = 'body';

//

let fileTouch = _.routineFromPreAndBody( fileTouch_pre, fileTouch_body );
fileTouch.having.aspect = 'entry';

//

let fileTimeSetAct = Object.create( null );
fileTimeSetAct.name = 'fileTimeSetAct';

var defaults = fileTimeSetAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.atime = null;
defaults.mtime = null;

var having = fileTimeSetAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = fileTimeSetAct.operates = Object.create( null );
operates.filePath = { pathToWrite : 1 }

//

function fileTimeSet_pre( routine, args )
{
  let self = this;
  let o;

  if( args.length === 3 )
  o =
  {
    filePath : args[ 0 ],
    atime : args[ 1 ],
    mtime : args[ 2 ],
  }
  else if( args.length === 2 ) /* qqq : tests required */ /* aaa : case exists */
  {
    let stat = args[ 1 ];
    if( _.strIs( stat ) )
    stat = self.statResolvedRead({ filePath : stat, sync : 1, throwing : 1 })
    // _.assert( _.fileStatIs( stat ) );
    o =
    {
      filePath : args[ 0 ],
      atime : stat.atime,
      mtime : stat.mtime,
    }
  }
  else
  {
    _.assert( args.length === 1 );
    o = args[ 0 ];
  }

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );
  _.routineOptions( routine, o );

  return o;
}

//

function fileTimeSet_body( o )
{
  let self = this;
  _.assert( arguments.length === 1, 'Expects single argument' );
  return self.fileTimeSetAct( o );
}

_.routineExtend( fileTimeSet_body, fileTimeSetAct );

var having = fileTimeSet_body.having;
having.driving = 0;
having.aspect = 'body';

//

let fileTimeSet = _.routineFromPreAndBody( fileTimeSet_pre, fileTimeSet_body );
var having = fileTimeSet.having;
having.aspect = 'entry';

//

let fileDeleteAct = Object.create( null );
fileDeleteAct.name = 'fileDeleteAct';

var defaults = fileDeleteAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;

var having = fileDeleteAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = fileDeleteAct.operates = Object.create( null );
operates.filePath = { pathToWrite : 1 }

//

function fileDelete_body( o )
{
  let self = this;
  let path = self.path;
  let result = null;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.numberIs( o.safe ) );

  if( _.arrayIs( o.filePath ) )
  {
    if( o.sync )
    {
      for( let f = 0 ; f < o.filePath.length ; f++ )
      {
        let o2 = _.mapExtend( null, o );
        o2.filePath = o.filePath[ f ];
        fileDelete_body.call( self, o2 );
      }
      return;
    }
    else
    {
      let con = new _.Consequence().take( null );
      let cons = [];
      for( let f = 0 ; f < o.filePath.length ; f++ )
      {
        let o2 = _.mapExtend( null, o );
        o2.filePath = o.filePath[ f ];
        cons[ f ] = fileDelete_body.call( self, o2 );
      }
      con.andKeep( cons );
      return con;
    }
  }

  /* is safe */

  o.filePath = self.pathResolveLinkTailChain
  ({
    filePath : o.filePath,
    resolvingSoftLink : o.resolvingSoftLink,
    resolvingTextLink : o.resolvingTextLink,
  });

  _.assert( path.s.allAreAbsolute( o.filePath ) );
  if( !path.s.allAreSafe( o.filePath, o.safe ) )
  {
    debugger;
    throw path.ErrorNotSafe( 'Deleting', o.filePath, o.safe );
  }

  /* act */

  act( o.filePath[ 0 ] );

  return result;

  /* */

  function act( filePath )
  {

    let o2 = _.mapExtend( null, o );

    o2.filePath = filePath;

    delete o2.throwing;
    delete o2.verbosity;
    delete o2.resolvingSoftLink;
    delete o2.resolvingTextLink;
    delete o2.safe;

    /* */

    try
    {
      result = self.fileDeleteAct( o2 );
    }
    catch( err )
    {
      if( o.throwing )
      debugger;
      log( 0 );
      _.assert( o.sync );
      if( o.throwing )
      throw _.err( err );
      return null;
    }

    /* */

    if( o.sync )
    {
      log( 1 );
    }
    else
    result.finally( function( err, arg )
    {
      log( !err );
      if( err )
      {
        if( o.throwing )
        throw err;
        return null;
      }
      return arg;
    });

  }

  /* */

  function log( ok )
  {
    if( !( o.verbosity >= 2 ) )
    return;
    if( ok )
    self.logger.log( ' - fileDelete ' + o.filePath );
    else
    self.logger.log( ' ! failed fileDelete ' + o.filePath );
  }

}

_.routineExtend( fileDelete_body, fileDeleteAct );

var defaults = fileDelete_body.defaults;
defaults.throwing = null;
defaults.verbosity = null;
defaults.safe = null;
defaults.resolvingSoftLink = 0;
defaults.resolvingTextLink = 0;

var having = fileDelete_body.having;
having.driving = 0;
having.aspect = 'body';

//

/**
 * Deletes a terminal file or empty directory.
 * @param {String|Object} o Path to a file or object with options.
 * @param {String|FileRecord} [ o.filePath=null ] Path to a file or instance of FileRecord @see{@link wFileRecord}
 * @param {Boolean} [ o.sync=true ] Determines in which way file stats will be readed : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=false ] Controls error throwing. Returns null if error occurred and ( throwing ) is disabled.
 * @returns {undefined|wConsequence|null}
 * If ( o.filePath ) doesn't exist and ( o.throwing ) is disabled - returns null.
 * If ( o.sync ) mode is disabled - returns Consequence instance @see{@link wConsequence }.
 *
 * @example
 * wTools.fileProvider.fileDelete( './existingDir/test.txt' );
 *
 * @example
 * let consequence = wTools.fileProvider.fileDelete
 * ({
 *  filePath : './existingDir/test.txt',
 *  sync : 0
 * });
 * consequence.got( ( err, result ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( result );
 * })
 *
 * @method fileDelete
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.filePath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.filePath ) path to a file doesn't exist or file is an directory with files.
 * @memberof wFileProviderPartial
 */

let fileDelete = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, fileDelete_body );
fileDelete.having.aspect = 'entry';

//

let fileResolvedDelete = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, fileDelete_body, 'fileResolvedDelete' );
fileResolvedDelete.defaults.resolvingSoftLink = null;
fileResolvedDelete.defaults.resolvingTextLink = null;
fileResolvedDelete.having.aspect = 'entry';

//

let dirMakeAct = Object.create( null );
dirMakeAct.name = 'dirMakeAct';

var defaults = dirMakeAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;

var having = dirMakeAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = dirMakeAct.operates = Object.create( null );
operates.filePath = { pathToWrite : 1 }

//

function dirMake_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( path.isNormalized( o.filePath ) );

  let o2 = { filePath : o.filePath }
  let filePath = self.pathResolveLinkFull( o2 );

  /* qqq : use fileExists instead of statRead where possible
     aaa : done
  */
  if( self.fileExists( filePath ) )
  {

    // debugger;
    // let stat = self.statResolvedRead( filePath );
    let stat = o2.stat;
    _.assert( !!stat );
    if( stat.isTerminal() )
    if( o.rewritingTerminal )
    self.fileDelete( filePath );
    else
    return handleError( _.err( 'Cant rewrite terminal file', _.strQuote( filePath ), 'by directory file.' ) );

    if( stat.isDir() )
    {
      if( !o.recursive  )
      return handleError( _.err( 'File already exists:', _.strQuote( filePath ) ) );
      else
      return o.sync ? undefined : new _.Consequence().take( null );
    }

  }

  let exists = self.fileExists( path.dir( filePath ) );

  if( !o.recursive && !exists )
  return handleError( _.err( 'Directory', _.strQuote( filePath ), ' doesn\'t exist!. Use {-o.recursive-} option to create it.' ) );

  let splits = [ filePath ];
  let dir = filePath;

  if( !exists )
  while( !exists )
  {
    dir = path.dir( dir );

    if( dir === '/' )
    break;

    // exists = !!self.statResolvedRead( dir );
    exists = self.fileExists( dir );

    if( !exists )
    {
      _.arrayPrependOnce( splits, dir );
    }
    else
    {
      break;
    }
  }

  /* */

  if( o.sync )
  {
    for( let i = 0; i < splits.length; i++ )
    onPart.call( self, splits[ i ] );
  }
  else
  {
    let con = new _.Consequence().take( null );
    for( let i = 0; i < splits.length; i++ )
    con.thenKeep( _.routineSeal( self, onPart, [ splits[ i ] ] ) );

    return con;
  }

  /* */

  function onPart( filePath )
  {
    let self = this;
    let o2 = _.mapOnly( o, self.dirMakeAct.defaults );
    o2.filePath = filePath;
    return self.dirMakeAct( o2 );
  }

  /* */

  function handleError( err )
  {
    debugger;
    if( o.sync )
    throw err;
    else
    return new _.Consequence().error( err );
  }

}

_.routineExtend( dirMake_body, dirMakeAct );

var defaults = dirMake_body.defaults;
defaults.recursive = 1;
defaults.rewritingTerminal = 1;

var having = dirMake_body.having;
having.driving = 0;
having.aspect = 'body';

//

let dirMake = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, dirMake_body );
dirMake.having.aspect = 'entry';

//

function dirMakeForFile_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  o.filePath = self.path.dir( o.filePath );

  return self.dirMake( o );
}

_.routineExtend( dirMakeForFile_body, dirMakeAct );

var defaults = dirMakeForFile_body.defaults;
defaults.recursive = 1;

var having = dirMakeForFile_body.having;
having.driving = 0;
having.aspect = 'body';

//

let dirMakeForFile = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, dirMakeForFile_body );
dirMakeForFile.having.aspect = 'entry';

// --
// linking
// --

function _link_pre( routine, args )
{
  let self = this;
  let o = self._preSrcDstPathWithProviderDefaults.apply( self, arguments );
  _.mapSupplementNulls( o, routine.defaults );
  return o;
}

//

function _linkMultiple( o, link )
{
  let self = this;

  if( o.dstPath.length < 2 )
  return o.sync ? true : new _.Consequence().take( true );

  _.assert( !!o );
  _.assert( _.strIs( o.srcPath ) || o.srcPath === null );
  _.assert( _.strIs( o.sourceMode ) || _.longIs( o.sourceMode ) );
  _.assert( _.boolLike( o.allowingMissed ) );
  _.assert( _.boolLike( o.allowingCycled ) );

  let needed = 0;
  let factory = self.recordFactory({ allowingMissed : o.allowingMissed, allowingCycled : o.allowingCycled });
  let records = factory.records( o.dstPath );
  // Vova : should allow missing files?
  // Kos : need to investigate
  let newestRecord;
  let mostLinkedRecord;

  if( o.srcPath )
  {
    if( !self.statResolvedRead( o.srcPath ) )
    return error( _.err( '{ o.srcPath } ', o.srcPath, ' doesn\'t exist.' ) );
    newestRecord = mostLinkedRecord = self.record( o.srcPath );
  }
  else
  {
    let sorter = o.sourceMode;
    _.assert( !!sorter, 'Expects { option.sourceMode }' );
    newestRecord = self._recordsSort( records, sorter );

    if( !newestRecord )
    return error( _.err( 'Source file was not selected, probably provided paths { o.dstPath } do not exist.' ) );

    let zero = self.UsingBigIntForStat ? BigInt( 0 ) : 0;
    mostLinkedRecord = _.entityMax( records, ( record ) => record.stat ? record.stat.nlink : zero ).element;
  }

  for( let p = 0 ; p < records.length ; p++ )
  {
    let record = records[ p ];
    if( !record.stat || !_./*statsCouldBeLinked*/statsAreHardLinked( newestRecord.stat, record.stat ) )
    {
      needed = 1;
      break;
    }
  }

  if( !needed )
  return o.sync ? true : new _.Consequence().take( true );

  /* */

  if( mostLinkedRecord.absolute !== newestRecord.absolute )
  {
    let read = self.fileRead({ filePath : newestRecord.absolute, encoding : 'original.type' });
    self.fileWrite( mostLinkedRecord.absolute, read );
    /*
      fileCopy cant be used here
      because hardlinks of most linked file with other files should be preserved
    */
  }

  /* */

  if( o.sync )
  {
    for( let p = 0 ; p < records.length ; p++ )
    {
      if( !onRecord( records[ p ] ) )
      return false;
    }
    return true;
  }
  else
  {
    let cons = [];
    let result = { err : undefined, got : true };
    let throwing = o.throwing;
    o.throwing = 1;

    function handler( err, got )
    {
      if( err && !_.definedIs( result.err ) )
      result.err = err;
      else
      result.got &= got;
    }

    for( let p = 0 ; p < records.length ; p++ )
    cons.push( onRecord( records[ p ] ).tap( handler ) );

    let con = new _.Consequence().take( null );

    con.andKeep( cons )
    .finally( () =>
    {
      if( result.err )
      {
        if( throwing )
        throw result.err;
        else
        return false;
      }
      return result.got;
    });

    return con;
  }

  /* - */

  function error( err )
  {
    if( o.sync )
    throw err;
    else
    return new _.Consequence().error( err );
  }

  /* */

  function onRecord( record )
  {
    if( record === mostLinkedRecord )
    return o.sync ? true : new _.Consequence().take( true );

    if( !o.allowDiffContent )
    if( record.stat && newestRecord.stat.mtime.getTime() === record.stat.mtime.getTime() && newestRecord.stat.birthtime.getTime() === record.stat.birthtime.getTime() )
    {
      if( _.statsHaveDifferentContent( newestRecord.stat , record.stat ) )
      {
        let err = _.err( 'Several files has the same date but different content', newestRecord.absolute, record.absolute );
        debugger;
        if( o.sync )
        throw err;
        else
        return new _.Consequence().error( err );
      }
    }

    if( !record.stat || !_./*statsCouldBeLinked*/statsAreHardLinked( mostLinkedRecord.stat , record.stat ) )
    {
      let linkOptions = _.mapExtend( null, o );
      linkOptions.allowingMissed = 0; // Vova : hardLink does not allow missing srcPath
      linkOptions.dstPath = record.absolute;
      linkOptions.srcPath = mostLinkedRecord.absolute;
      debugger;
      return link.call( self, linkOptions );
    }

    return o.sync ? true : new _.Consequence().take( true );
  }

}

//

function _link_functor( gen )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routineOptions( _link_functor, gen );

  let onAct = gen.onAct;
  let actMethodName = gen.actMethodName;
  let entryMethodName = _.strRemoveEnd( gen.actMethodName, 'Act' );
  let onVerify1 = gen.onVerify1;
  let onVerify2 = gen.onVerify2;
  let renaming = gen.renaming;
  let skippingSamePath = gen.skippingSamePath;
  let skippingMissed = gen.skippingMissed;

  _.assert( _.routineIs( onAct ) );
  _.assert( _.objectIs( onAct.defaults ) );
  _.assert( onVerify1 === null || _.routineIs( onVerify1 ) );
  _.assert( onVerify2 === null || _.routineIs( onVerify2 ) );

  /* - */

  function _link_body( o )
  {
    let self = this;
    let path = self.hub ? self.hub.path : self.path;
    let o2;
    let c = Object.create( null );

    c.ended = false;
    c.linkAct = onAct;
    c.result = undefined;
    c.tempPath = undefined;
    c.tempPathSrc = undefined;
    c.dstStat = undefined;
    c.srcStat = undefined;
    c.options = o;
    c.options2 = undefined;

    c.verify1 = o.sync ? verify1 : verify1Async;
    c.verify2 = o.sync ? verify2 : verify2Async;
    c.verifyDst = o.sync ? verifyDstSync : verifyDstAsync;
    c.pathResolve = o.sync ? pathResolve : pathResolveAsync;
    c.linksResolve = o.sync ? linksResolve : linksResolveAsync;
    c.log = log;
    c.tempRenameCan = tempRenameCan;
    c.tempRename = o.sync ? tempRenameSync : tempRenameAsync;
    c.tempRenameRevert = o.sync ? tempRenameRevertSync : tempRenameRevertAsync;
    c.tempDelete = tempDelete;
    c.tempNameMake = tempNameMake
    c.validateSize = validateSize;
    c.error = error;
    c.end = end;

    if( !o.sync )
    {
      c.con1 = new _.Consequence().take( null );
      c.con2 = new _.Consequence();
      // qqq : why two?
      /* aaa : to split execution into veryfication and linking:
      linking stage needs own exception handler,
      linking stage will not be launched if error was thrown on veryfication or stage ended early
      */

    }

    Object.preventExtensions( c );

    /* */

    if( o.sync )
    {

      c.verify1( arguments );
      if( c.ended )
      return c.end();

      /*
      zzz : _linkMultiple should work not only for hardlinks
      Vova : low priority
      */

      if( _.longIs( o.dstPath ) && c.linkAct.having.hardLinking )
      return _linkMultiple.call( self, o, _link_body );
      _.assert( _.strIs( o.srcPath ) && _.strIs( o.dstPath ) );

      c.pathResolve();
      if( c.ended )
      return c.end();

      c.linksResolve();
      if( c.ended )
      return c.end();

      c.verify2();
      if( c.ended )
      return c.end();

      o2 = c.options2 = _.mapOnly( o, c.linkAct.defaults );

      try
      {

        if( self.fileExists( o2.dstPath ) )
        {
          c.verifyDst()
          if( tempRenameCan() )
          tempRenameSync();
        }
        else if( o.makingDirectory )
        {
          self.dirMakeForFile( o2.dstPath );
        }

        c.linkAct.call( self, c );
        log();

        c.validateSize();
        c.tempDelete();

      }
      catch( err )
      {

        debugger;
        c.tempRenameRevert();
        return error( _.err( 'Cant', entryMethodName, o.dstPath, '<-', o.srcPath, '\n', err ) );

      }

      return true;
    }
    else /* async */
    {

      /* main part */

      c.con2.thenKeep( () => self.fileExists( o2.dstPath ) );
      c.con2.thenKeep( ( dstExists ) =>
      {
        if( dstExists )
        {
          return c.verifyDst().thenKeep( () => tempRenameAsync() )
        }
        else if( o.makingDirectory )
        {
          return self.dirMakeForFile({ filePath : o2.dstPath, sync : 0 });
        }
        return dstExists;
      });

      c.con2.thenKeep( _.routineSeal( self, c.linkAct, [ c ] ) );

      c.con2.thenKeep( ( got ) =>
      {
        log();
        return c.tempDelete();
      });
      c.con2.thenKeep( () =>
      {
        c.tempPath = null;
        validateSize();
        return true;
      });

      c.con2.except( ( err ) =>
      {
        return c.tempRenameRevert()
        .finally( () =>
        {
          return error( _.err( 'Cant', entryMethodName, o.dstPath, '<-', o.srcPath, '\n', err ) );
          /*
          qqq : linking routine should return null if error and throwing : 0
          aaa : works as expected
          */
        })
      })

      /* launcher */

      c.verify1( arguments );

      c.con1.thenKeep( () =>
      {
        if( _.longIs( o.dstPath ) && c.linkAct.having.hardLinking )
        {
          c.result = _linkMultiple.call( self, o, _link_body );
          return true;
        }
        _.assert( _.strIs( o.srcPath ) && _.strIs( o.dstPath ) );

        c.pathResolve();
        c.linksResolve();
        c.verify2();

        return true;
      })

      c.con1.thenKeep( () =>
      {
        if( c.result !== undefined ) //return result if ended early
        return c.result;
        //prepare options map and launch main part
        o2 = c.options2 = _.mapOnly( o, c.linkAct.defaults );
        c.con2.take( null );
        return c.con2;
      })

      return c.con1;
    }

    /* - */

    function verify1( args )
    {
      _.assert( args.length === 1, 'Expects single argument' );
      _.assert( _.routineIs( c.linkAct ), 'method', actMethodName, 'is not implemented' );
      _.assert( _.objectIs( c.linkAct.defaults ), 'method', actMethodName, 'does not have defaults, but should' );
      _.assertRoutineOptions( _link_body, args );
      _.assert( _.boolLike( o.resolvingSrcSoftLink ) );
      _.assert( _.boolLike( o.resolvingSrcTextLink ) );
      _.assert( _.boolLike( o.resolvingDstSoftLink ) );
      _.assert( _.boolLike( o.resolvingDstTextLink ) );
      _.assert( _.boolLike( o.allowingMissed ) );
      _.assert( _.boolLike( o.allowingCycled ) );

      if( onVerify1 )
      {
        let r = onVerify1.call( self, c );
        _.assert( r === undefined );
      }

    }

    function verify1Async( args )
    {
      c.con1.thenKeep( () =>
      {
        verify1( args );
        return true;
      })
    }

    /* - */

    function verify2()
    {

      /* allowingMissed */

      if( !o.allowingMissed || skippingMissed )
      {
        if( c.srcStat === undefined )
        c.srcStat = self.statRead({ filePath : o.srcPath, sync : 1 });
        if( !c.srcStat )
        {
          if( !o.allowingMissed )
          {
            debugger;
            let err = _.err( 'Source file', _.strQuote( o.srcPath ), 'does not exist' );
            error( err );
            return true;
          }
          if( skippingMissed )
          {
            end( false );
            return true;
          }
        }
      }

      /* equal paths */

      if( o.dstPath === o.srcPath )
      {

        if( skippingSamePath )
        {
          end( true );
          return true;
        }

        if( !o.allowingMissed )
        {
          let err = _.err( 'Making link on itself is not allowed. Please enable options {-o.allowingMissed-} if that was your goal.' );
          error( err );
          return true;
        }

      }

      /* skipping */

      if( onVerify2 )
      {
        let r = onVerify2.call( self, c );
        _.assert( r === undefined );
      }

      return false;
    }

    function verify2Async()
    {
      c.con1.thenKeep( () =>
      {
        return verify2()
      });
    }

    /* - */

    function verifyDstSync()
    {

      if( !o.rewriting )
      throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' exist and rewriting is off.' );

      if( c.dstStat === undefined )
      c.dstStat = self.statRead
      ({
        filePath : o2.dstPath,
        sync : 1,
      });

      if( c.dstStat.isDirectory() && !o.rewritingDirs )
      throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' is a directory and rewritingDirs is off.' );

    }

    /* - */

    function verifyDstAsync()
    {

      if( !o.rewriting )
      throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' exist and rewriting is off.' );

      return self.statRead
      ({
        filePath : o2.dstPath,
        sync : 0,
      })
      .thenKeep( ( stat ) =>
      {
        _.assert( c.dstStat === undefined );
        c.dstStat = stat;
        if( c.dstStat.isDirectory() && !o.rewritingDirs )
        throw _.err( 'Destination file ' + _.strQuote( o2.dstPath ) + ' is a directory and rewritingDirs is off.' );
        return stat;
      })
    }

    /* - */

    function pathResolve()
    {

      _.assert( o.originalSrcPath === null, 'not tested' );
      _.assert( o.originalDstPath === null, 'not tested' );

      if( !o.originalSrcPath )
      o.originalSrcPath = o.srcPath;
      if( !o.originalDstPath )
      o.originalDstPath = o.dstPath;

      if( !path.isAbsolute( o.dstPath ) )
      {
        _.assert( path.isAbsolute( o.srcPath ), () => 'Expects absolute path {-o.srcPath-}, but got', _.strQuote( o.srcPath ) );
        o.dstPath = path.resolve( o.srcPath, o.dstPath );
      }
      // else if( !_.path.isGlobal( o.srcPath ) && !path.isAbsolute( o.srcPath ) )
      else if( !path.isAbsolute( o.srcPath ) )
      {
        _.assert( path.isAbsolute( o.dstPath ), () => 'Expects absolute path {-o.dstPath-}, but got', _.strQuote( o.dstPath ) );
        o.srcPath = path.resolve( o.dstPath, o.srcPath );
      }

      _.assert( path.isAbsolute( o.srcPath ) );
      _.assert( path.isAbsolute( o.dstPath ) );

    }

    /* */

    function pathResolveAsync()
    {
      c.con1.thenKeep( () =>
      {
        pathResolve();
        return true;
      })
    }

    /* - */

    function linksResolve()
    {

      // debugger; // xxx

      try
      {

        _.assert( path.isAbsolute( o.srcPath ) );
        _.assert( path.isAbsolute( o.dstPath ) );

        if( o.resolvingDstSoftLink || ( o.resolvingDstTextLink && self.usingTextLink ) )
        {
          let o2 =
          {
            filePath : o.dstPath,
            resolvingSoftLink : o.resolvingDstSoftLink,
            resolvingTextLink : o.resolvingDstTextLink,
            allowingCycled : 1,
            allowingMissed : 1,
          }
          o.dstPath = self.pathResolveLinkFull( o2 );
          c.dstStat = o2.stat; /* it's ok */
        }

        /* */

        if( o.resolvingSrcSoftLink || ( o.resolvingSrcTextLink && self.usingTextLink ) )
        {
          let o2 =
          {
            filePath : o.srcPath,
            resolvingSoftLink : o.resolvingSrcSoftLink,
            resolvingTextLink : o.resolvingSrcTextLink,
            allowingCycled : o.allowingCycled,
            allowingMissed : o.allowingMissed,
            throwing : o.throwing
          }
          o.srcPath = self.pathResolveLinkFull( o2 );
          c.srcStat = o2.stat;
        }
        else
        {
          /* do not read stat if possible */
          c.srcStat = self.statRead({ filePath : o.srcPath, sync : 1 });
        }

      }
      catch( err )
      {
        debugger;
        c.error( err );
      }

    }

    function linksResolveAsync()
    {

      c.con1.thenKeep( () =>
      {
        _.assert( path.isAbsolute( o.srcPath ) );
        _.assert( path.isAbsolute( o.dstPath ) );

        if( o.resolvingDstSoftLink || ( o.resolvingDstTextLink && self.usingTextLink ) )
        {
          let o2 =
          {
            filePath : o.dstPath,
            resolvingSoftLink : o.resolvingDstSoftLink,
            resolvingTextLink : o.resolvingDstTextLink,
            sync : 0,
            allowingCycled : 1,
            allowingMissed : 1,
          }
          return self.pathResolveLinkFull( o2 ).thenKeep( ( dstPath ) =>
          {
            o.dstPath = dstPath;
            c.dstStat = o2.stat;
            return true;
          })
        }

        return true;
      })

      /* */

      c.con1.thenKeep( () =>
      {
        if( o.resolvingSrcSoftLink || ( o.resolvingSrcTextLink && self.usingTextLink ) )
        {
          let o2 =
          {
            filePath : o.srcPath,
            resolvingSoftLink : o.resolvingSrcSoftLink,
            resolvingTextLink : o.resolvingSrcTextLink,
            allowingCycled : o.allowingCycled,
            allowingMissed : o.allowingMissed,
            sync : 0,
            throwing : o.throwing
          }
          return self.pathResolveLinkFull( o2 )
          .thenKeep( ( srcPath ) =>
          {
            o.srcPath = srcPath;
            c.srcStat = o2.stat;
            return true;
          })
        }
        else
        {
          /* do not read stat if possible */
          return self.statRead({ filePath : o.srcPath, sync : 0 })
          .thenKeep( ( srcStat ) =>
          {
            c.srcStat = srcStat;
            return true;
          });
        }
      })
    }

    /* - */

    function log()
    {
      if( !o.verbosity || o.verbosity < 2 )
      return;
      self.logger.log( ' +', entryMethodName, ':', path.moveReport( o.dstPath, o.srcPath ) );
    }

    /* - */

    function tempRenameCan()
    {

      _.assert( _.fileStatIs( c.dstStat ) );

      if( !renaming )
      return false;

      /*
      qqq : if breakingSrcHardLink is on then src file should be broken
      aaa : fixed
      */

      if( _.boolLike( o.breakingDstHardLink ) )
      if( !o.breakingDstHardLink && c.dstStat.isHardLink() )
      return false;

      return true;
    }

    /* - */

    function tempRenameSync()
    {

      c.tempPath = c.tempNameMake( o2.dstPath );
      if( self.statRead({ filePath : c.tempPath }) )
      self.filesDelete( c.tempPath );
      self.fileRenameAct
      ({
        dstPath : c.tempPath,
        srcPath : o.dstPath,
        originalDstPath : c.tempPath,
        originalSrcPath : o.dstPath,
        sync : 1,
        // resolvingSrcSoftLink : 0,
        // resolvingSrcTextLink : 0,
        // verbosity : 0,
      });

    }

    function tempRenameAsync()
    {
      if( !tempRenameCan() )
      return false;

      c.tempPath = c.tempNameMake( o2.dstPath );
      return self.statRead
      ({
        filePath : c.tempPath,
        sync : 0
      })
      .thenKeep( ( tempStat ) =>
      {
        if( tempStat )
        return self.filesDelete( c.tempPath );
        return tempStat;
      })
      .thenKeep( () =>
      {
        return self.fileRenameAct
        ({
          dstPath : c.tempPath,
          srcPath : o.dstPath,
          originalDstPath : c.tempPath,
          originalSrcPath : o.dstPath,
          sync : 0,
          // resolvingSrcSoftLink : 0,
          // resolvingSrcTextLink : 0,
          // verbosity : 0,
        });
      })
    }

    /* - */

    function tempRenameRevertSync()
    {

      if( c.tempPath ) try
      {
        debugger;
        self.fileRenameAct
        ({
          dstPath : o.dstPath,
          srcPath : c.tempPath,
          originalDstPath : o.dstPath,
          originalSrcPath : c.tempPath,
          sync : 1,
        });
      }
      catch( err2 )
      {
        debugger;
        console.error( err2 );
        // console.error( err.toString() + '\n' + err.stack );
      }

      // qqq : ???
      // aaa : redundant code
      // if( c.tempPathSrc ) try
      // {
      //   debugger;
      //   self.filesDelete( o.srcPath );
      //   self.fileRenameAct
      //   ({
      //     dstPath : o.srcPath,
      //     srcPath : c.tempPathSrc,
      //     originalDstPath : o.srcPath,
      //     originalSrcPath : c.tempPathSrc,
      //     sync : 1,
      //   });
      // }
      // catch( err2 )
      // {
      //   debugger;
      //   console.error( err2 );
      //   // console.error( err.toString() + '\n' + err.stack );
      // }

    }

    function tempRenameRevertAsync()
    {
      if( !c.tempPath )
      return new _.Consequence().take( null );

      return self.fileRenameAct
      ({
        dstPath : o.dstPath,
        srcPath : c.tempPath,
        originalDstPath : o.dstPath,
        originalSrcPath : c.tempPath,
        sync : 0,
      })
      .finally( ( err2, got ) =>
      {
        if( err2 )
        console.error( err2 );
        return got;
      })
    }

    /* - */

    function tempDelete()
    {

      if( c.tempPath )
      {
        let tempPath = c.tempPath;
        c.tempPath = null;
        return self.filesDelete
        ({
          filePath : tempPath,
          verbosity : 0,
          sync : o.sync, /* qqq : implement o.sync, aaa : done */
        });
      }

      return null;
    }

    /* - */

    function tempNameMake( filePath )
    {
      return filePath + '-' + _.idWithGuid() + '.tmp';
    }

    /* - */

    function validateSize()
    {
      if( !Config.debug )
      return;
      if( !c.srcStat )
      return;
      if( o.srcPath === o.dstPath )
      return;

      let srcPath = o.srcPath;
      let dstPath = o.dstPath;

      if( actMethodName === 'fileCopyAct' )
      {
        if( c.srcStat.isSoftLink() )
        {
          let srcPathResolved = self.pathResolveSoftLink( srcPath );
          srcPath = self.path.join( srcPath, srcPathResolved );
          let srcStat = self.statReadAct({ filePath : srcPath, throwing : 0, resolvingSoftLink : 0, sync : 1 });
          if( srcStat )
          {
            c.srcStat = srcStat;
            let dstPathResolved = self.pathResolveSoftLink( dstPath );
            dstPath = self.path.join( dstPath, dstPathResolved );
          }
        }
      }
      else if( actMethodName === 'softLinkAct' )
      {
        let dstPathResolved = self.pathResolveSoftLink( o.dstPath );
        dstPath = self.path.join( dstPath, dstPathResolved );
      }
      else if( actMethodName === 'textLinkAct' )
      {
        self.fieldPush( 'usingTextLink', 1 );
        let dstPathResolved = self.pathResolveTextLink( o.dstPath );
        self.fieldPop( 'usingTextLink', 1 );
        dstPath = self.path.join( dstPath, dstPathResolved );
      }

      c.dstStat = self.statReadAct({ filePath : dstPath, throwing : 0, resolvingSoftLink : 0, sync : 1 });

      if( !c.dstStat && self.providersWithProtocolMap )
      if( self.isLink( o.dstPath ) )
      {
        //Vova: temporary allow broken dst link for linking operation through Hub
        let methodName = _.strReplaceAll( actMethodName, 'Act', '' );
        self.logger.warn( 'Warning: Hub.' + methodName + '.validateSize failed to get stat for broken dst link:', dstPath );
        return;
      }

      _.assert( !!c.srcStat );
      _.assert( !!c.dstStat );

      if( !( c.srcStat.size == c.dstStat.size ) )
      {
        let msg = `Warning: ${o.srcPath} (${c.srcStat.size}) and ${o.dstPath} (${c.dstStat.size}) should have same size!`;
        self.logger.warn( msg )
      }

    }

    /* - */

    function error( err )
    {
      _.assert( arguments.length === 1 );
      if( o.throwing )
      {
        if( o.sync )
        throw err;
        c.result = new _.Consequence().error( err );
        return end( c.result );
      }
      else
      {
        // if( o.sync )
        // return false;
        // return new _.Consequence().take( false );
        return end( null ); /* qqq : should return null, if error. not false. cover it, please */
      }
    }

    /* - */

    function end( r )
    {
      _.assert( arguments.length === 0 || arguments.length === 1 );
      _.assert( arguments.length === 0 || r !== undefined );
      c.ended = true;
      if( r !== undefined )
      if( o.sync )
      c.result = r;
      else if( _.consequenceIs( r ) )
      c.result = r;
      else
      c.result = _.Consequence().take( r );
      _.assert( !!o.sync || _.consequenceIs( c.result ) );
      _.assert( c.result !== undefined );
      return c.result;
    }

  }

  _.routineExtend( _link_body, onAct )

  var having = _link_body.having;

  having.driving = 0;
  having.aspect = 'body';
  // having.hubRedirecting = 0;

  let linkEntry = _.routineFromPreAndBody( _link_pre, _link_body, entryMethodName );

  var having = linkEntry.having;

  having.aspect = 'entry';

  /* qqq : at the end, all files should has the same size */

  return linkEntry;
}

_link_functor.defaults =
{

  actMethodName : null,
  onAct : null,
  onVerify1 : null,
  onVerify2 : null,

  renaming : true,
  skippingSamePath : true,
  skippingMissed : false,

}

//

let fileRenameAct = Object.create( null );
fileRenameAct.name = 'fileRenameAct';

var defaults = fileRenameAct.defaults = Object.create( null );
defaults.dstPath = null;
defaults.srcPath = null;
defaults.originalDstPath = null;
defaults.originalSrcPath = null;
defaults.sync = null;

var having = fileRenameAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = fileRenameAct.operates = Object.create( null );
operates.srcPath = { pathToRead : 1 }
operates.dstPath = { pathToWrite : 1 }

//

/**
 * Changes name of the file.
 * Takes single argument - object with options or two arguments : destination( o.dstPath ) and source( o.srcPath ) paths.
 * Routine changes name of the source file if ( o.srcPath ) and ( dstPath ) have different file names. Also moves source file to the new location( dstPath )
 * if parent dirs of ( o.srcPath ) and ( o.dstPath ) are not same. If ( o.dstPath ) path exists and ( o.rewriting ) is enabled, the destination file can be overwritten.
 *
 * @param {Object} o Object with options.
 * @param {String|FileRecord} [ o.dstPath=null ] - Destination path or instance of FileRecord @see{@link wFileRecord}. Path must be absolute.
 * @param {String|FileRecord} [ o.srcPath=null ] - Source path or instance of FileRecord @see{@link wFileRecord}. Path can be relative to destination path or absolute.
 * In case of FileRecord instance, absolute path will be used.
 * @param {Boolean} [ o.sync=true ] - Determines in which way file will be renamed : true - synchronously, otherwise - asynchronously.
 * In asynchronous mode returns wConsequence.
 * @param {Boolean} [ o.throwing=true ] - Controls error throwing. Returns false if error occurred and ( o.throwing ) is disabled.
 * @param {Boolean} [ o.rewriting=false ] - Controls rewriting of the destination file( o.dstPath ).
 * @returns {Boolean|wConsequence} Returns true after successful rename, otherwise false is returned. Also returns false if an error occurs and ( o.throwing ) is disabled.
 * In async mode returns Consequence instance @see{@link wConsequence } with same result.
 *
 * @example
 * wTools.fileProvider.fileRename( '/existingDir/notExistingDst', '/existingDir/existingSrc' );
 * //returns true
 *
 * @example
 * wTools.fileProvider.fileRename( '/existingDir/existingSrc', '/existingDir/existingSrc' );
 * //returns false
 *
 * @example
 * wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/notExistingDst',
 *  srcPath : '/existingDir/notExistingSrc',
 *  throwing : 1
 * });
 * //throws an Error
 *
 * @example
 * wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/notExistingDst',
 *  srcPath : '/existingDir/notExistingSrc',
 *  throwing : 0
 * });
 * //returns false
 *
 * @example
 * wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/notExistingDst',
 *  srcPath : '/existingDir/notExistingSrc',
 *  throwing : 0
 * });
 * //returns false
 *
 * @example
 * wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/existingDst',
 *  srcPath : '/existingDir/existingSrc',
 *  throwing : 0,
 *  rewriting : 0
 * });
 * //returns false
 *
 * @example
 * wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/existingDst',
 *  srcPath : '/existingDir/existingSrc',
 *  throwing : 0,
 *  rewriting : 1
 * });
 * //returns true
 *
 * @example
 * let consequence = wTools.fileProvider.fileRename
 * ({
 *  dstPath : '/existingDir/notExistingDst',
 *  srcPath : '/existingDir/existingSrc',
 *  sync : 0
 * });
 * consequence.got( ( err, got ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( got ); // true
 * })
 *
 * @method fileRename
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.srcPath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.dstPath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.srcPath ) path to a file doesn't exist.
 * @throws { Exception } If destination( o.dstPath ) and source( o.srcPath ) files exist and ( o.rewriting ) is disabled.
 * @memberof wFileProviderPartial
 */

function _fileRenameAct( c )
{
  let self = this;
  return self.fileRenameAct( c.options2 );
}

_.routineExtend( _fileRenameAct, fileRenameAct );

let fileRename = _link_functor
({
  actMethodName : 'fileRenameAct',
  onAct : _fileRenameAct,
  skippingSamePath : true,
  skippingMissed : false,
});

var defaults = fileRename.body.defaults;

defaults.rewriting = 0;
defaults.rewritingDirs = 0;
defaults.makingDirectory = 0;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;
defaults.throwing = null;
defaults.verbosity = null;

defaults.resolvingSrcSoftLink = 1;
defaults.resolvingSrcTextLink = 0;
defaults.resolvingDstSoftLink = 0;
defaults.resolvingDstTextLink = 0;

//

let fileCopyAct = Object.create( null );
fileCopyAct.name = 'fileCopyAct';

var defaults = fileCopyAct.defaults = Object.create( null );
defaults.dstPath = null;
defaults.srcPath = null;
defaults.originalDstPath = null;
defaults.originalSrcPath = null;
defaults.breakingDstHardLink = 0;
defaults.sync = null;

var having = fileCopyAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = fileCopyAct.operates = Object.create( null );
operates.srcPath = { pathToRead : 1 }
operates.dstPath = { pathToWrite : 1 }

//

/**
 * Creates copy of a file. Accepts two arguments: ( srcPath ), ( dstPath ) or options object.
 * Returns true if operation is finished successfully or if source and destination paths are equal.
 * Otherwise throws error with corresponding message or returns false, it depends on ( o.throwing ) property.
 * In asynchronously mode returns wConsequence instance.
 * @example
   let fileProvider = _.FileProvider.Default();
   let result = fileProvider.fileCopy( 'src.txt', 'dst.txt' );
   console.log( result );// true
   let stats = fileProvider.statResolvedRead( 'dst.txt' );
   console.log( stats ); // returns Stats object
 * @example
   let fileProvider = _.FileProvider.Default();
   let consequence = fileProvider.fileCopy
   ({
     srcPath : 'src.txt',
     dstPath : 'dst.txt',
     sync : 0
   });
   consequence.got( function( err, got )
   {
     if( err )
     throw err;
     console.log( got ); // true
     let stats = fileProvider.statResolvedRead( 'dst.txt' );
     console.log( stats ); // returns Stats object
   });

 * @param {Object} o - options object.
 * @param {string} o.srcPath path to source file.
 * @param {string} o.dstPath path where to copy source file.
 * @param {boolean} [o.sync=true] If set to false, method will copy file asynchronously.
 * @param {boolean} [o.rewriting=true] Enables rewriting of destination path if it exists.
 * @param {boolean} [o.throwing=true] Enables error throwing. Returns false if error occurred and ( o.throwing ) is disabled.
 * @param {boolean} [o.verbosity=true] Enables logging of copy process.
 * @returns {wConsequence}
 * @throws {Error} If missed argument, or pass more than 2.
 * @throws {Error} If dstPath or dstPath is not string.
 * @throws {Error} If options object has unexpected property.
 * @throws {Error} If ( o.rewriting ) is false and destination path exists.
 * @throws {Error} If path to source file( srcPath ) not exists and ( o.throwing ) is enabled, otherwise returns false.
 * @method fileCopy
 * @memberof wFileProviderPartial
 */

function _fileCopyVerify2( c )
{
  let self = this;
  let o = c.options;

  _.assert( _.strIs( o.srcPath ) );
  _.assert( _.fileStatIs( c.srcStat ) || c.srcStat === null );

  if( c.srcStat === undefined )
  c.srcStat = self.statRead({ filePath : o.srcPath, sync : 1 });

  if( c.srcStat === null )
  return;

  if( c.srcStat.isDir() )
  {
    debugger;
    c.error( _.err( 'Cant copy directory ' + _.strQuote( o.srcPath ) + ', consider method filesCopy'  ) );
  }

}

function _fileCopyAct( c )
{
  let self = this;
  let o = c.options2;

  _.assert( _.fileStatIs( c.srcStat ) || c.srcStat === null );

  if( c.srcStat === null )
  {
    // return self.fileDeleteAct({ filePath : o.dstPath, sync : o.sync });
  }
  else if( c.srcStat.isSoftLink() )
  {
    debugger;

    /* should not throw error for missed neither for cycled */
    let srcResolvedPath = self.pathResolveSoftLink
    ({
      filePath : o.srcPath,
      // allowingMissed : o.allowingMissed,
      // allowingCycled : o.allowingCycled,
    });

    return self.softLinkAct
    ({
      dstPath : o.dstPath,
      srcPath : srcResolvedPath,
      originalDstPath : o.originalDstPath,
      originalSrcPath : srcResolvedPath,
      sync : o.sync,
      type : null,
    });

  }
  else
  {

    return self.fileCopyAct
    ({
      dstPath : o.dstPath,
      srcPath : o.srcPath,
      originalDstPath : o.originalDstPath,
      originalSrcPath : o.originalSrcPath,
      breakingDstHardLink : o.breakingDstHardLink,
      sync : o.sync,
    });

  }

}

_.routineExtend( _fileCopyAct, fileCopyAct );

let fileCopy = _link_functor
({
  actMethodName : 'fileCopyAct',
  onAct : _fileCopyAct,
  onVerify2 : _fileCopyVerify2,
  skippingSamePath : true,
  skippingMissed : false,
});

var defaults = fileCopy.body.defaults;

defaults.rewriting = 1;
defaults.rewritingDirs = 0;
defaults.makingDirectory = 0;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;
defaults.throwing = null;
defaults.verbosity = null;

// defaults.breakingSrcHardLink = 0;
defaults.resolvingSrcSoftLink = 1;
defaults.resolvingSrcTextLink = 0;

defaults.breakingDstHardLink = 0;
defaults.resolvingDstSoftLink = 0;
defaults.resolvingDstTextLink = 0;

//

/**
 * Creates hard link( new name ) to existing source( o.srcPath ) named as ( o.dstPath ).
 *
 * Accepts only ready options.
 * Expects normalized absolute paths for source( o.srcPath ) and destination( o.dstPath ), routine makes nativization by itself.
 * Source ( o.srcPath ) must be an existing terminal file.
 * Destination ( o.dstPath ) must not exist in filesystem.
 * Folders structure before destination( o.dstPath ) must exist in filesystem.
 * If source( o.srcPath ) and destination( o.dstPath ) paths are equal, operiation is considered as successful.
 *
 * @method hardLinkAct
 * @memberof wFileProviderPartial
 */

let hardLinkAct = Object.create( null );
hardLinkAct.name = 'hardLinkAct';

var defaults = hardLinkAct.defaults = Object.create( null );
defaults.dstPath = null;
defaults.srcPath = null;
defaults.originalDstPath = null;
defaults.originalSrcPath = null;
defaults.breakingSrcHardLink = 0;
defaults.breakingDstHardLink = 1;
defaults.sync = null;

var having = hardLinkAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;
having.hardLinking = 1;

var operates = hardLinkAct.operates = Object.create( null );
operates.srcPath = { pathToRead : 1 }
operates.dstPath = { pathToWrite : 1 }

//

/**
 * Creates hard link( new name ) to existing source( o.srcPath ) named as ( o.dstPath ).
 * Rewrites target( o.dstPath ) by default if it exists. Logging of working process is controled by option( o.verbosity ).
 * Returns true if link is successfully created. If some error occurs during execution method uses option( o.throwing ) to
 * determine what to do - throw error or return false.
 *
 *
 * @param { wTools~linkOptions } o - options { @link wTools~linkOptions  }
 * @property { boolean } [ o.breakingSrcHardLink=false ] - Breaks all hardlinks to source( o.srcPath ) file before creating a new hardlink.
 * @property { boolean } [ o.breakingDstHardLink=true ] - Breaks all hardlinks to destination( o.dstPath ) file before creating a new hardlink.
 *
 *
 * This is how routine links two existing hardlinks( = ) depending on combination of breakingSrcHardLink and breakingDstHardLink:
 * f1 = src - dst = f2
 * breakingSrcHardLink:1 breakingDstHardLink:1 - breaks hardlinks: f1 = src and dst = f2
 * breakingSrcHardLink:1 breakingDstHardLink:0 - breaks hardlink f1 = src
 * breakingSrcHardLink:0 breakingDstHardLink:1 - breaks hardlink dst = f2
 * breakingSrcHardLink:0 breakingDstHardLink:0 - preserves both hardlinks, is forbidden because its impossible to implement on FileProvider.HardDrive
 *
 * @method hardLink
 * @throws { exception } If( o.srcPath ) doesn`t exist.
 * @throws { exception } If cant link ( o.srcPath ) with ( o.dstPath ).
 * @memberof wFileProviderPartial
 */

function _hardLinkVerify1( c )
{
  let self = this;
  let o = c.options;
  _.assert( _.boolLike( o.breakingSrcHardLink ) );
  _.assert( _.boolLike( o.breakingDstHardLink ) );
  _.assert
  (
    !!c.options.breakingSrcHardLink || !!c.options.breakingDstHardLink,
    'Both source and destination hardlinks could not be preserved, please set breakingSrcHardLink or breakingDstHardLink to true'
  );
  _.assert( o.allowingMissed === 0 || _.longIs( o.dstPath ), 'o.allowingMissed could be disabled when linking two files' );

}

function _hardLinkVerify2( c )
{
  let self = this;
  let o = c.options;

  if( c.srcStat === undefined )
  c.srcStat = self.statRead({ filePath : o.srcPath, sync : 1 });
  _.assert( _.fileStatIs( c.srcStat ) );

  if( !c.srcStat.isTerminal() )
  {
    c.error( _.err( 'Source file should be a terminal.' ) );
  }
  else
  {
    let linked = self.filesAreHardLinked([ o.dstPath, o.srcPath ]);
    if( linked || linked === _.maybe )
    c.end( true );
  }
}

function _hardLinkAct( c )
{
  let self = this;

  if( c.options.breakingSrcHardLink )
  if( !self.fileExists( c.options2.dstPath ) )
  {
    if( c.srcStat.isHardLink() )
    self.hardLinkBreak( c.options2.srcPath );
  }
  else
  {
    if( !c.options.breakingDstHardLink )
    if( c.dstStat.isHardLink() )
    {
      let srcData = self.fileRead( c.options2.srcPath );
      self.fileWrite( c.options2.dstPath, srcData );
      self.fileDelete( c.options2.srcPath );
      let dstPath = c.options2.dstPath;
      c.options2.dstPath = c.options2.srcPath;
      c.options2.srcPath = dstPath;
    }
  }

  return self.hardLinkAct( c.options2 );
}

_.routineExtend( _hardLinkAct, hardLinkAct );

let hardLink = _link_functor
({
  actMethodName : 'hardLinkAct',
  onAct : _hardLinkAct,
  onVerify1 : _hardLinkVerify1,
  onVerify2 : _hardLinkVerify2,
  skippingSamePath : true,
  skippingMissed : false,
});

var defaults = hardLink.body.defaults;

defaults.rewriting = 1;
defaults.rewritingDirs = 0;
defaults.makingDirectory = 0;
defaults.throwing = null;
defaults.verbosity = null;
defaults.allowDiffContent = 0;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;
defaults.sourceMode = 'modified>hardlinks>';

defaults.breakingSrcHardLink = 0;
defaults.resolvingSrcSoftLink = 1;
defaults.resolvingSrcTextLink = 0;
defaults.breakingDstHardLink = 1;
defaults.resolvingDstSoftLink = 0;
defaults.resolvingDstTextLink = 0;

//

let softLinkAct = Object.create( null );
softLinkAct.name = 'softLinkAct';

var defaults = softLinkAct.defaults = Object.create( null );
defaults.dstPath = null;
defaults.srcPath = null;
defaults.originalDstPath = null;
defaults.originalSrcPath = null;
defaults.sync = null;
defaults.type = null;

var having = softLinkAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = softLinkAct.operates = Object.create( null );
operates.srcPath = { pathToRead : 1 }
operates.dstPath = { pathToWrite : 1 }

//

/**
 * link methods options
 * @typedef { object } wTools~linkOptions
 * @property { boolean } [ dstPath= ] - Target file.
 * @property { boolean } [ srcPath= ] - Source file.
 * @property { boolean } [ o.sync=true ] - Runs method in synchronous mode. Otherwise asynchronously and returns wConsequence object.
 * @property { boolean } [ rewriting=true ] - Rewrites target( o.dstPath ).
 * @property { boolean } [ verbosity=true ] - Logs working process.
 * @property { boolean } [ throwing=true ] - Enables error throwing. Otherwise returns true/false.
 * @property { boolean } [ o.breakingSrcHardLink= ] - Breaks all hardlinks to source( o.srcPath ) file before link operation.
 * @property { boolean } [ o.breakingDstHardLink= ] - Breaks all hardlinks to destination( o.dstPath ) file before link operation.
 */

/**
 * Creates soft link( symbolic ) to existing source( o.srcPath ) named as ( o.dstPath ).
 * Rewrites target( o.dstPath ) by default if it exist. Logging of working process is controled by option( o.verbosity ).
 * Returns true if link is successfully created. If some error occurs during execution method uses option( o.throwing ) to
 * determine what to do - throw error or return false.
 *
 * @param { wTools~linkOptions } o - options { @link wTools~linkOptions  }
 *
 * @method softLink
 * @throws { exception } If( o.srcPath ) doesn`t exist.
 * @throws { exception } If cant link ( o.srcPath ) with ( o.dstPath ).
 * @memberof wFileProviderPartial
 */

function _softLinkAct( c )
{
  let self = this;
  return self.softLinkAct( c.options2 );
}

_.routineExtend( _softLinkAct, softLinkAct );

function _softLinkVerify2( c )
{
  let self = this;
  let o = c.options;

  if( !o.allowingMissed )
  // if( self.filesAreSoftLinked([ o.dstPath, o.srcPath ]) )
  if( o.dstPath === o.srcPath )
  c.error( _.err( 'Soft link cycle', path.moveReport( o.dstPath, o.srcPath ) ) );

  // if( o.dstPath !== o.srcPath && self.filesAreSoftLinked([ o.dstPath, o.srcPath ]) )
  // if( o.dstPath === o.srcPath )
  // return true;

  // if( o.dstPath !== o.srcPath && self.filesAreSoftLinked([ o.dstPath, o.srcPath ]) )
  // return true;

}

let softLink = _link_functor
({
  actMethodName : 'softLinkAct',
  onAct : _softLinkAct,
  onVerify2 : _softLinkVerify2,
  skippingSamePath : false,
  skippingMissed : false,
});

var defaults = softLink.body.defaults;

defaults.rewriting = 1;
defaults.rewritingDirs = 0;
defaults.makingDirectory = 0;
defaults.throwing = null;
defaults.verbosity = null;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;

defaults.resolvingSrcSoftLink = 0;
defaults.resolvingSrcTextLink = 0;
defaults.resolvingDstSoftLink = 0;
defaults.resolvingDstTextLink = 0;

//

function textLinkAct( o )
{
  let self = this;
  let path = self.path;

  _.assertRoutineOptions( textLinkAct, arguments );
  _.assert( path.is( o.srcPath ) );
  _.assert( path.isAbsolute( o.dstPath ) );

  let srcPath = o.srcPath;
  if( !self.path.isAbsolute( o.originalSrcPath ) )
  srcPath = o.originalSrcPath;

  let result = self.fileWrite({ filePath : o.dstPath, data : 'link ' + srcPath, sync : o.sync });

  if( o.sync )
  return true;
  else
  return result;
}

var defaults = textLinkAct.defaults = Object.create( null );
defaults.dstPath = null;
defaults.srcPath = null;
defaults.sync = null;
defaults.originalDstPath = null;
defaults.originalSrcPath = null;

var having = textLinkAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = textLinkAct.operates = Object.create( null );
operates.srcPath = { pathToRead : 1 }
operates.dstPath = { pathToWrite : 1 }

//

/**
 * Creates text link to existing source( o.srcPath ) named as ( o.dstPath ).
 * Rewrites target( o.dstPath ) by default if it exist. Logging of working process is controled by option( o.verbosity ).
 * Returns true if link is successfully created. If some error occurs during execution method uses option( o.throwing ) to
 * determine what to do - throw error or return false.
 *
 * @param { wTools~linkOptions } o - options { @link wTools~linkOptions  }
 *
 * @method textLink
 * @throws { exception } If( o.srcPath ) doesn`t exist.
 * @throws { exception } If cant link ( o.srcPath ) with ( o.dstPath ).
 * @memberof wFileProviderPartial
 */

function _textLinkAct( c )
{
  let self = this;
  return self.textLinkAct( c.options2 );
}

_.routineExtend( _textLinkAct, textLinkAct );

function _textLinkVerify2( c )
{
  let self = this;
  let o = c.options;
  // qqq : cover filesAreTextLinked aaa : done
  if( o.dstPath !== o.srcPath && self.filesAreTextLinked([ o.dstPath, o.srcPath ]) )
  debugger;
  if( o.dstPath !== o.srcPath && self.filesAreTextLinked([ o.dstPath, o.srcPath ]) )
  c.end( true );
}

let textLink = _link_functor
({
  actMethodName : 'textLinkAct',
  onAct : _textLinkAct,
  onVerify2 : _textLinkVerify2,
  skippingSamePath : false,
  skippingMissed : false,
});

var defaults = textLink.body.defaults;

defaults.rewriting = 1;
defaults.rewritingDirs = 0;
defaults.makingDirectory = 0;
defaults.throwing = null;
defaults.verbosity = null;
defaults.allowingMissed = 0;
defaults.allowingCycled = 0;

defaults.resolvingSrcSoftLink = 0;
defaults.resolvingSrcTextLink = 0;
defaults.resolvingDstSoftLink = 0;
defaults.resolvingDstTextLink = 0;

//

function fileExchange_pre( routine, args )
{
  let self = this;
  let o;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( args.length === 2 )
  {
    o =
    {
      dstPath : args[ 0 ],
      srcPath : args[ 1 ],
    }
    _.assert( args.length === 2 );
  }
  else
  {
    o = args[ 0 ];
    _.assert( args.length === 1 );
  }

  _.routineOptions( routine, o );
  self._providerDefaults( o );
  _.assert( _.strIs( o.srcPath ) && _.strIs( o.dstPath ) );

  return o;
}

//

function fileExchange_body( o )
{
  let self  = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  // throw _.err( 'not tested after introducing of allowingCycled' );
  // let src = self.statResolvedRead({ filePath : o.srcPath, throwing : 0 });
  // let dst = self.statResolvedRead({ filePath : o.dstPath, throwing : 0 });

  let src = _statResolvedRead( o.srcPath );
  let dst = _statResolvedRead( o.dstPath );

  let optionsForRename =
  {
    resolvingSrcTextLink : 0,
    resolvingDstTextLink : 0,
    resolvingSrcSoftLink : 0,
    resolvingDstSoftLink : 0,
    allowingMissed : 0
  }

  if( !src.stat || !dst.stat )
  {
    if( o.allowingMissed )
    {
      if( !src.stat && dst.stat )
      {
        o.srcPath = dst.filePath;
        o.dstPath = src.filePath;
      }
      if( !src.stat && !dst.stat )
      return _returnNull();

      return self.fileRename( _.mapExtend( null, o, optionsForRename ) );
    }
    else if( o.throwing )
    {
      let err;

      if( !src.stat && !dst.stat )
      {
        err = _.err( 'srcPath and dstPath not exist! srcPath: ', o.srcPath, ' dstPath: ', o.dstPath )
      }
      else if( !src.stat )
      {
        err = _.err( 'srcPath not exist! srcPath: ', o.srcPath );
      }
      else if( !dst.stat )
      {
        err = _.err( 'dstPath not exist! dstPath: ', o.dstPath );
      }

      if( o.sync )
      throw err;
      else
      return new _.Consequence().error( err );
    }
    else
    return _returnNull();
  }

  let tempPath = src.filePath + '-' + _.idWithGuid() + '.tmp';

  o.dstPath = tempPath;

  var o2 = _.mapExtend( null, o, optionsForRename );

  o2.originalSrcPath = null;
  o2.originalDstPath = null;

  if( o.sync )
  {
    self.fileRename( _.mapExtend( null, o2 ) );
    o2.dstPath = src.filePath;
    o2.srcPath = dst.filePath;
    self.fileRename( _.mapExtend( null, o2 ) );
    o2.dstPath = dst.filePath;
    o2.srcPath = tempPath;
    return self.fileRename( _.mapExtend( null, o2 ) );
  }
  else
  {
    let con = self.fileRename( _.mapExtend( null, o2 ) );

    con.thenKeep( () =>
    {
      o2.dstPath = src.filePath;
      o2.srcPath = dst.filePath;
      return self.fileRename( _.mapExtend( null, o2 ) );
    });

    con.thenKeep( () =>
    {
      o2.dstPath = dst.filePath;
      o2.srcPath = tempPath;
      return self.fileRename( _.mapExtend( null, o2 ) );
    });

    con.except( ( err ) =>
    {
      if( !o.throwing )
      return null;
      throw err;
    });

    return con;
  }

  /* - */

  function _statResolvedRead( filePath )
  {
    let o2 =
    {
      filePath : filePath,
      resolvingTextLink : self.resolvingTextLink,
      resolvingSoftLink : self.resolvingSoftLink,
      sync : 1,
      throwing : o.throwing,
      allowingMissed : o.allowingMissed,
      allowingCycled : o.allowingCycled,
    }
    filePath = self.pathResolveLinkFull( o2 );
    return { filePath : filePath, stat : o2.stat };
  }

  /* - */

  function _returnNull()
  {
    if( o.sync )
    return null;
    else
    return new _.Consequence().take( null );
  }

}

var defaults = fileExchange_body.defaults = Object.create( null );
defaults.srcPath = null;
defaults.dstPath = null;
defaults.sync = null;
defaults.allowingMissed = 1;
defaults.allowingCycled = 1;
defaults.throwing = null;
defaults.verbosity = null;

var having = fileExchange_body.having = Object.create( null );
having.writing = 1;
having.reading = 1;
having.driving = 0;
having.aspect = 'body';

//

/**
 * Swaps content of the two files.
 * Takes single argument - object with options or two arguments : destination( o.dstPath ) and source( o.srcPath ) paths.
 * @param {Object} o Object with options.
 * @param {String|FileRecord} [ o.dstPath=null ] - Destination path or instance of FileRecord @see{@link wFileRecord}. Path must be absolute.
 * @param {String|FileRecord} [ o.srcPath=null ] - Source path or instance of FileRecord @see{@link wFileRecord}. Path can be relative to destination path or absolute.
 * In case of FileRecord instance, absolute path will be used.
 * @param {Boolean} [ o.sync=true ] - Determines execution mode: true - synchronously, false - asynchronously.
 * In asynchronous mode returns wConsequence @see{@link wConsequence }.
 * @param {Boolean} [ o.throwing=true ] - Controls error throwing. Returns false if error occurred and ( o.throwing ) is disabled.
 * @param {Boolean} [ o.allowingMissed=true ] - Allows missing of the file( s ). If source ( o.srcPath ) is missing - ( o.srcPath ) becomes destination and ( o.dstPath ) becomes the source. Routine returns null if both paths are missing.
 * @returns {Boolean|wConsequence} Returns true after successful exchange, otherwise false is returned. Also returns false if an error occurs and ( o.throwing ) is disabled.
 * In async mode returns Consequence instance @see{@link wConsequence } with same result.
 *
 * @example
 * wTools.fileProvider.fileExchange( '/existingDir/existingDst', '/existingDir/existingSrc' );
 * //returns true
 *
 * @example
 * let consequence = wTools.fileProvider.fileExchange
 * ({
 *  dstPath : '/existingDir/existingDst',
 *  srcPath : '/existingDir/existingSrc',
 *  sync : 0
 * });
 * consequence.got( ( err, got ) =>
 * {
 *    if( err )
 *    throw err;
 *
 *    console.log( got ); // true
 * })
 *
 * @method fileExchange
 * @throws { Exception } If no arguments provided.
 * @throws { Exception } If ( o.srcPath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.dstPath ) is not a String or instance of wFileRecord.
 * @throws { Exception } If ( o.srcPath ) path to a file doesn't exist.
 * @throws { Exception } If destination( o.dstPath ) and source( o.srcPath ) files exist and ( o.rewriting ) is disabled.
 * @memberof wFileProviderPartial
 */

let fileExchange = _.routineFromPreAndBody( fileExchange_pre, fileExchange_body );
fileExchange.having.aspect = 'entry';

// --
// link
// --

let hardLinkBreakAct = Object.create( null );
hardLinkBreakAct.name = 'hardLinkBreakAct';

var defaults = hardLinkBreakAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;

var having = hardLinkBreakAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = hardLinkBreakAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1, pathToWrite : 1 }

//

function hardLinkBreak_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.routineIs( self.hardLinkBreakAct ) )
  return self.hardLinkBreakAct( o );
  else
  {
    let options =
    {
      filePath :  o.filePath,
      purging : 1
    };

    if( o.sync )
    return self.fileTouch( options );
    else
    return _.timeOut( 0, () => self.fileTouch( options ) );
  }
}

_.routineExtend( hardLinkBreak_body, hardLinkBreakAct );

var having = hardLinkBreak_body.having;
having.driving = 0;
having.aspect = 'body';

//

let hardLinkBreak = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, hardLinkBreak_body );
hardLinkBreak.having.aspect = 'entry';

//

let softLinkBreakAct = Object.create( null );
softLinkBreakAct.name = 'softLinkBreakAct';

var defaults = softLinkBreakAct.defaults = Object.create( null );
defaults.filePath = null;
defaults.sync = null;

var having = softLinkBreakAct.having = Object.create( null );
having.writing = 1;
having.reading = 0;
having.driving = 1;

var operates = softLinkBreakAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1, pathToWrite : 1 }

//

function softLinkBreak_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( _.routineIs( self.softLinkBreakAct ) )
  return self.softLinkBreakAct( o );
  else
  {
    let options =
    {
      filePath :  o.filePath,
      purging : 1
    };

    if( o.sync )
    return self.fileTouch( options );
    else
    return _.timeOut( 0, () => self.fileTouch( options ) );
  }
}

_.routineExtend( softLinkBreak_body, softLinkBreakAct );

var having = softLinkBreak_body.having;
having.driving = 0;
having.aspect = 'body';

//

let softLinkBreak = _.routineFromPreAndBody( _preFilePathScalarWithProviderDefaults, softLinkBreak_body );
softLinkBreak.having.aspect = 'entry';

//

let filesAreHardLinkedAct = Object.create( null );
filesAreHardLinkedAct.name = 'filesAreHardLinkedAct';

var defaults = filesAreHardLinkedAct.defaults = Object.create( null );
defaults.filePath = null;

var having = filesAreHardLinkedAct.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 1;

var operates = filesAreHardLinkedAct.operates = Object.create( null );
operates.filePath = { pathToRead : 1, vector : [ 2, 2 ] }

//

/**
 * Check if one of paths is hard link to other.
 * @example
   let fs = require( 'fs' );

   let path1 = '/home/tmp/sample/file1',
   path2 = '/home/tmp/sample/file2',
   buffer = Buffer.from( [ 0x01, 0x02, 0x03, 0x04 ] );

   wTools.fileWrite( { filePath : path1, data : buffer } );
   fs.symlinkSync( path1, path2 );

   let linked = wTools.filesAreHardLinked( path1, path2 ); // true

 * @param {string|wFileRecord} ins1 path string/file record instance
 * @param {string|wFileRecord} ins2 path string/file record instance

 * @returns {boolean}
 * @throws {Error} if missed one of arguments or pass more then 2 arguments.
 * @method filesAreHardLinked
 * @memberof wFileProviderPartial
 */

function filesAreLinked_pre( routine, args )
{
  let self = this;
  let o;

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  if( args.length === 2 )
  {
    o = { filePath : [ args[ 0 ], args[ 1 ] ] }
  }
  else if( _.arrayLike( args[ 0 ] ) )
  {
    _.assert( args.length === 1 );
    o = { filePath : args[ 0 ] }
  }
  else
  {
    _.assert( args.length === 1 );
    o = args[ 0 ];
  }

  _.assert( _.mapIs( o ) );

  o = self._preFilePathVectorWithProviderDefaults.call( self, routine, [ o ] );

  return o;
}

//

function filesAreHardLinked_body( o )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertRoutineOptions( filesAreHardLinked_body, arguments );

  if( !o.filePath.length )
  return true;

  if( _.routineIs( self.filesAreHardLinkedAct ) )
  {
    for( let i = 1 ; i < o.filePath.length ; i++ )
    {
      let r = self.filesAreHardLinkedAct({ filePath : [ o.filePath[ 0 ], o.filePath[ i ] ] });
      _.assert( _.boolIs( r ) );
      if( !r )
      return r;
    }
    return true;
  }

  let statFirst = self.statRead( o.filePath[ 0 ] );
  if( !statFirst )
  return false;

  for( let i = 1 ; i < o.filePath.length ; i++ )
  {
    let statCurrent = self.statRead( self.path.from( o.filePath[ i ] ) );
    if( !statCurrent || !_./*statsCouldBeLinked*/statsAreHardLinked( statFirst, statCurrent ) )
    return false;
  }

  /*
    should return _.maybe, not true if result is not precise
  */

  if( self.UsingBigIntForStat )
  return true;

  return _.maybe;
}

_.routineExtend( filesAreHardLinked_body, filesAreHardLinkedAct );

var having = filesAreHardLinked_body.having;
having.aspect = 'body';

//

let filesAreHardLinked = _.routineFromPreAndBody( filesAreLinked_pre, filesAreHardLinked_body );

var having = filesAreHardLinked.having;
having.driving = 0;
having.aspect = 'entry';

//

function filesAreSoftLinked_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertRoutineOptions( filesAreSoftLinked_body, arguments );
  _.assert( o.filePath.length >= 2 );

  o.filePath = path.s.normalize( o.filePath );

  _.assert( path.s.allAreAbsolute( o.filePath ) );

  if( o.filePath[ 0 ] === o.filePath[ 1 ] )
  return false;

  let resolved = [];

  for( let i = 0 ; i < o.filePath.length ; i++ )
  {
    resolved[ i ] = self.pathResolveLinkFull
    ({
      filePath : o.filePath[ i ],
      resolvingSoftLink : true,
      resolvingTextLink : o.resolvingTextLink,
    });
    _.assert( path.is( resolved[ 0 ] ) );
  }

  for( let i = 1 ; i < resolved.length ; i++ )
  {
    if( resolved[ 0 ] !== resolved[ i ] )
    return false;
  }

  return true;
}

var defaults = filesAreSoftLinked_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingTextLink = 0;

var operates = filesAreSoftLinked_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

var having = filesAreSoftLinked_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.aspect = 'body';

//

let filesAreSoftLinked = _.routineFromPreAndBody( filesAreLinked_pre, filesAreSoftLinked_body );

filesAreSoftLinked.having.driving = 0;
filesAreSoftLinked.having.aspect = 'entry';

//

function filesAreTextLinked_body( o )
{
  let self = this;
  let path = self.path;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assertRoutineOptions( filesAreTextLinked_body, arguments );
  _.assert( o.filePath.length >= 2 );

  o.filePath = path.s.normalize( o.filePath );

  _.assert( path.s.allAreAbsolute( o.filePath ) );

  if( o.filePath[ 0 ] === o.filePath[ 1 ] )
  return false;

  let resolved = [];

  for( let i = 0 ; i < o.filePath.length ; i++ )
  {
    resolved[ i ] = self.pathResolveLinkFull
    ({
      filePath : o.filePath[ i ],
      resolvingSoftLink : o.resolvingSoftLink,
      resolvingTextLink : true,
    });
    _.assert( path.is( resolved[ i ] ) );
  }

  for( let i = 1 ; i < resolved.length ; i++ )
  {
    if( resolved[ 0 ] !== resolved[ i ] )
    return false;
  }

  return true;
}

var defaults = filesAreTextLinked_body.defaults = Object.create( null );
defaults.filePath = null;
defaults.resolvingSoftLink = 0;

var operates = filesAreTextLinked_body.operates = Object.create( null );
operates.filePath = { pathToRead : 1 }

var having = filesAreTextLinked_body.having = Object.create( null );
having.writing = 0;
having.reading = 1;
having.driving = 0;
having.aspect = 'body';

//

let filesAreTextLinked = _.routineFromPreAndBody( filesAreLinked_pre, filesAreTextLinked_body );

filesAreTextLinked.having.driving = 0;
filesAreTextLinked.having.aspect = 'entry';

// --
// accessor
// --

function _protocolsSet( protocols )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );

  if( protocols === null )
  {
    self[ protocolsSymbol ] = [];
    self[ protocolSymbol ] = null;
    return protocols;
  }

  if( _.strIs( protocols ) )
  return self._protocolsSet([ protocols ]);

  _.assert( _.arrayIs( protocols ) )
  _.assert( protocols.every( ( p ) => !_.strHas( p, ':' ) && !_.strHas( p, '/' ) ) );

  protocols = protocols.map( ( p ) => p.toLowerCase() );

  let protocol = protocols[ 0 ] || null;

  _.assert( _.strIs( protocol ) || protocol === null );

  self[ protocolsSymbol ] = protocols;
  self[ protocolSymbol ] = protocol;

  if( protocol )
  self[ originPathSymbol ] = self.originsForProtocols( protocol );
  else
  self[ originPathSymbol ] = null;

}

var having = _protocolsSet.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 0;
having.kind = 'inter';

//

function _protocolSet( protocol )
{
  let self = this;

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( protocol === null || _.strIs( protocol ) );

  self._protocolsSet( protocol );
}

var having = _protocolSet.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 0;
having.kind = 'inter';

//

function _originPathSet( origins )
{
  let self = this;
  self.protocols = self.protocolsForOrigins( origins );
}

var having = _originPathSet.having = Object.create( null );
having.writing = 0;
having.reading = 0;
having.driving = 0;
having.kind = 'inter';

// --
// vars
// --

let verbositySymbol = Symbol.for( 'verbosity' );
let protocolsSymbol = Symbol.for( 'protocols' );
let protocolSymbol = Symbol.for( 'protocol' );
let originPathSymbol = Symbol.for( 'originPath' );

let WriteMode = [ 'rewrite', 'prepend', 'append' ];

let ProviderDefaults =
{
  'encoding' : null,
  'resolvingSoftLink' : null,
  'resolvingTextLink' : null,
  'usingSoftLink' : null,
  'usingTextLink' : null,
  'verbosity' : null,
  'sync' : null,
  'throwing' : null,
  'safe' : null,
  'hub' : null,
}

// --
// relationship
// --

let Composes =
{

  protocols : _.define.own([]),

  encoding : 'utf8',
  hashFileSizeLimit : 1 << 22,

  resolvingSoftLink : 1,
  resolvingTextLink : 0,
  usingSoftLink : 1,
  usingTextLink : 0,

  verbosity : 0,
  sync : 1,
  throwing : 1,
  safe : 1,
  stating : 1,

}

let Aggregates =
{
}

let Associates =
{
  path : null,
  logger : null,
  hub : null,
}

let Restricts =
{
}

let Medials =
{
  protocol : null,
  originPath : null,
}

let Statics =
{
  MakeDefault : MakeDefault,
  Path : _.path.CloneExtending({ fileProvider : Self }),
  WriteMode : WriteMode,
  ProviderDefaults : ProviderDefaults
}

let Forbids =
{

  done : 'done',
  currentAct : 'currentAct',
  current : 'current',
  resolvingHardLink : 'resolvingHardLink',

  pathNativize : 'pathNativize',
  pathsNativize : 'pathsNativize',
  pathCurrent : 'pathCurrent',
  pathResolve : 'pathResolve',
  pathsResolve : 'pathsResolve',

  softLinkRead : 'softLinkRead',
  softLinkReadAct : 'softLinkReadAct',
  linkSoftAct : 'linkSoftAct',
  linkSoft : 'linkSoft',
  linkHardAct : 'linkHardAct',
  linkHard : 'linkHard',
  pathResolveHardLinkAct : 'pathResolveHardLinkAct',
  pathResolveHardLink : 'pathResolveHardLink',

  isTerminalAct : 'isTerminalAct',
  isDirAct : 'isDirAct',
  isTextLinkAct : 'isTextLinkAct',
  isSoftLinkAct : 'isSoftLinkAct',
  isHardLinkAct : 'isHardLinkAct',

}

let Accessors =
{
  protocols : 'protocols',
  protocol : 'protocol',
  originPath : 'originPath',
}

// --
// declare
// --

let Proto =
{

  init,
  finit,
  MakeDefault,

  // functors

  _vectorize,
  _vectorizeAll,
  _vectorizeAny,
  _vectorizeNone,

  // etc

  _fileOptionsGet,
  _providerDefaults,
  assertProviderDefaults,
  _preFilePathScalarWithoutProviderDefaults,
  _preFilePathScalarWithProviderDefaults,
  _preFilePathVectorWithoutProviderDefaults,
  _preFilePathVectorWithProviderDefaults,
  _preSrcDstPathWithoutProviderDefaults,
  _preSrcDstPathWithProviderDefaults,

  // hub

  protocolsForOrigins,
  originsForProtocols,
  providerForPath,
  providerRegisterTo,
  providerUnregister,
  hasProvider,

  // path

  localFromGlobal,
  localsFromGlobals : _vectorizeKeysAndVals( localFromGlobal ),

  globalFromLocal,
  globalsFromLocals : _vectorizeKeysAndVals( globalFromLocal ),

  pathNativizeAct,
  pathCurrentAct : null,
  pathDirTempAct,

  // resolve

  pathResolveSoftLinkAct,
  pathResolveSoftLink,

  pathResolveTextLinkAct,
  // _pathResolveTextLink,
  pathResolveTextLink,

  pathResolveLinkFull,
  pathResolveLinkTail,
  pathResolveLinkTailChain,
  pathResolveLinkHeadDirect,
  pathResolveLinkHeadReverse,

  // record

  _recordFactoryFormEnd,
  _recordFormBegin,
  _recordPathForm,
  _recordFormEnd,

  _recordAbsoluteGlobalMaybeGet,
  _recordRealGlobalMaybeGet,

  record,
  _recordsSort,
  recordFactory,
  recordFilter,

  // stat

  statReadAct,
  statRead,
  statsRead : _vectorize( statRead ),
  statResolvedRead,
  statsResolvedRead : _vectorize( statResolvedRead ),

  filesSize,
  fileSize,

  fileExistsAct,
  fileExists,
  filesExists : _vectorize( fileExists ),
  filesExistsAll : _vectorizeAll( fileExists ),
  filesExistsAny : _vectorizeAny( fileExists ),
  filesExistsNone : _vectorizeNone( fileExists ),

  isTerminal,
  areTerminals : _vectorize( isTerminal ),
  allAreTerminals : _vectorizeAll( isTerminal ),
  anyAreTerminals : _vectorizeAny( isTerminal ),
  noneAreTerminals : _vectorizeNone( isTerminal ),
  resolvedIsTerminal,
  resolvedAreTerminals : _vectorize( resolvedIsTerminal ),
  resolvedAllAreTerminals : _vectorizeAll( resolvedIsTerminal ),
  resolvedAnyAreTerminals : _vectorizeAny( resolvedIsTerminal ),
  resolvedNoneAreTerminals : _vectorizeNone( resolvedIsTerminal ),

  isDir,
  areDirs : _vectorize( isDir ),
  allAreDirs : _vectorizeAll( isDir ),
  anyAreDirs : _vectorizeAny( isDir ),
  noneAreDirs : _vectorizeNone( isDir ),
  resolvedIsDir,
  resolvedAreDirs : _vectorize( resolvedIsDir ),
  resolvedAllAreDirs : _vectorizeAll( resolvedIsDir ),
  resolvedAnyAreDirs : _vectorizeAny( resolvedIsDir ),
  resolvedNoneAreDirs : _vectorizeNone( resolvedIsDir ),

  isHardLink,
  areHardLinks : _vectorize( isHardLink ),
  allAreHardLinks : _vectorizeAll( isHardLink ),
  anyAreHardLinks : _vectorizeAny( isHardLink ),
  noneAreHardLinks : _vectorizeNone( isHardLink ),
  resolvedIsHardLink,
  resolvedAreHardLinks : _vectorize( resolvedIsHardLink ),
  resolvedAllAreHardLinks : _vectorizeAll( resolvedIsHardLink ),
  resolvedAnyAreHardLinks : _vectorizeAny( resolvedIsHardLink ),
  resolvedNoneAreHardLinks : _vectorizeNone( resolvedIsHardLink ),

  isSoftLink,
  filesAreSoftLinks : _vectorize( isSoftLink ),
  allAreSoftLinks : _vectorizeAll( isSoftLink ),
  anyAreSoftLinks : _vectorizeAny( isSoftLink ),
  noneAreSoftLinks : _vectorizeNone( isSoftLink ),
  resolvedIsSoftLink,
  resolvedAreSoftLinks : _vectorize( resolvedIsSoftLink ),
  resolvedAllAreSoftLinks : _vectorizeAll( resolvedIsSoftLink ),
  resolvedAnyAreSoftLinks : _vectorizeAny( resolvedIsSoftLink ),
  resolvedNoneAreSoftLinks : _vectorizeNone( resolvedIsSoftLink ),

  isTextLink,
  filesAreTextLinks : _vectorize( isTextLink ),
  allAreTextLinks : _vectorizeAll( isTextLink ),
  anyAreTextLinks : _vectorizeAny( isTextLink ),
  noneAreTextLinks : _vectorizeNone( isTextLink ),
  resolvedIsTextLink,
  resolvedAreTextLinks : _vectorize( resolvedIsTextLink ),
  resolvedAllAreTextLinks : _vectorizeAll( resolvedIsTextLink ),
  resolvedAnyAreTextLinks : _vectorizeAny( resolvedIsTextLink ),
  resolvedNoneAreTextLinks : _vectorizeNone( resolvedIsTextLink ),

  isLink,
  areLinks : _vectorize( isLink ),
  allAreLinks : _vectorizeAll( isLink ),
  anyAreLinks : _vectorizeAny( isLink ),
  noneAreLinks : _vectorizeNone( isLink ),
  resolvedIsLink,
  filesResolvedAreLinks : _vectorize( resolvedIsLink ),
  filesResolvedAllAreLinks : _vectorizeAll( resolvedIsLink ),
  filesResolvedAnyAreLinks : _vectorizeAny( resolvedIsLink ),
  filesResolvedNoneAreLinks : _vectorizeNone( resolvedIsLink ),

  dirIsEmpty,
  dirsAreEmpty : _vectorize( dirIsEmpty ),
  dirsAllAreEmpty : _vectorizeAll( dirIsEmpty ),
  dirsAnyAreEmpty : _vectorizeAny( dirIsEmpty ),
  dirsNoneAreEmpty : _vectorizeNone( dirIsEmpty ),
  resolvedDirIsEmpty,
  resolvedDirsAreEmpty : _vectorize( resolvedDirIsEmpty ),
  resolvedDirsAllAreEmpty : _vectorizeAll( resolvedDirIsEmpty ),
  resolvedDirsAnyAreEmpty : _vectorizeAny( resolvedDirIsEmpty ),
  resolvedDirsNoneAreEmpty : _vectorizeNone( resolvedDirIsEmpty ),

  // read

  streamReadAct,
  streamRead,

  fileReadAct,
  fileRead,
  fileReadSync,
  fileReadJson,
  fileReadJs,
  fileInterpret,

  hashReadAct,
  hashRead,

  dirReadAct,
  dirRead,
  dirReadDirs,
  dirReadTerminals,

  filesFingerprints,
  filesAreSame,

  // write

  streamWriteAct,
  streamWrite,

  fileWriteAct,
  fileWrite,
  fileAppend,
  fileWriteJson,
  fileWriteJs,
  fileTouch,

  fileTimeSetAct,
  fileTimeSet,

  fileDeleteAct,
  fileDelete,
  fileResolvedDelete,

  dirMakeAct,
  dirMake,
  dirMakeForFile,

  // linking

  _link_pre,
  _linkMultiple,
  _link_functor,

  fileRenameAct,
  fileRename,

  fileCopyAct,
  fileCopy,

  hardLinkAct,
  hardLink,

  softLinkAct,
  softLink,

  textLinkAct,
  textLink,

  /* qqq : cover routine textLink */

  fileExchange,

  // link

  hardLinkBreakAct,
  hardLinkBreak,
  softLinkBreakAct,
  softLinkBreak,

  filesAreHardLinkedAct,
  filesAreHardLinked,
  filesAreSoftLinked,
  filesAreTextLinked,

  // accessor

  _protocolsSet,
  _protocolSet,
  _originPathSet,

  // relations

  Composes,
  Aggregates,
  Associates,
  Restricts,
  Medials,
  Statics,
  Forbids,
  Accessors,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.Copyable.mixin( Self );
_.FieldsStack.mixin( Self );
_.Verbal.mixin( Self );

_.assert( _.routineIs( Self.prototype.statsResolvedRead ) );
_.assert( _.objectIs( Self.prototype.statsResolvedRead.defaults ) );

// --
// export
// --

_.FileProvider[ Self.shortName ] = Self;

// if( typeof module !== 'undefined' )
// if( _global_.WTOOLS_PRIVATE )
// { /* delete require.cache[ module.id ]; */ }

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

_.assert( _.FileProvider.Partial.prototype.statRead.defaults.resolvingSoftLink === 0 );
_.assert( _.FileProvider.Partial.prototype.statRead.defaults.resolvingTextLink === 0 );

})();
