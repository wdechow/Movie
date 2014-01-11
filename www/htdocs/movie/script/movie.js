
/* This constant ensures that the mod_perl handler for project movie is used */
PATH = "/promov";

/* This constant sets the amount of Movies listed in table per page */
NUMBER_OF_MOVIES = 20;

/* This constant represents the key ID of the return key */
KEY_ID_RETURN = 13;

/* Specifies the number of columns contained in the movie table */
NUMBER_OF_COLUMNS = 4;

/* Specifies the default value of an filter input field. This value will be deleted on click, all others won't */
/* This variable has to be set to the same value as $main::NUMBER_OF_MOVIES in MovieAppl.pm */
FILTER_INPUT_DEFAULT_VAL = "filter nach ...";


$( document ).ready( function( ) {
  load_site( );
} );



/**
 * This function loads the header, content and footer
 */
function load_site( )
{
  load_header( );
  load_content( "movie/components/movie_table.html" );
  load_footer( );
}


/**
 * This function loads the header for the site
 */
 function load_header( )
 {
   $( "#header" ).load( "movie/components/header.html", function( ) {
    // When the header is fully loaded, i can set all handlers
    set_header_handlers( );
  } );
 }


/**
 * This function loads the content for the site
 *
 * @param file Content file to load into the content div
 */
function load_content( file )
{
  $( "#content" ).load( file, function( ) {

  } );
}


/**
 * This function loads the footer for the site
 */
function load_footer( )
{
  $( "#footer" ).load( "movie/components/footer.html" );
}


/**
 * This function sets all handler for the header
 */
function set_header_handlers( )
{
  /* Menu handler */
  var link_preferences    = document.getElementById( "menu-preferences" );
  var link_detail_search  = document.getElementById( "menu-detail-search" );
  var link_add            = document.getElementById( "menu-add" );

  /* Search handler */
  var link_search         = document.getElementById( "search-image" );
  var input_search        = document.getElementById( "search-input" );


  link_preferences.onclick = function( ) {
    handler_menu_preferences( );
  }

  link_detail_search.onclick = function( ) {
    handler_menu_detail_search( );
  }

  link_add.onclick = function( ) {
    handler_menu_add( );
  }

  link_search.onclick = function( ) {
    handler_search( );
  }

  input_search.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      handler_search( );
    }
  }
}


/**
 * This function handles the onclick event of the preferences menu entry
 */
function handler_menu_preferences( )
{
  console.log( "handler_menu_preferences" );
}


/**
 * This function handles the onclick event of the detail search menu entry
 */
function handler_menu_detail_search( )
{
  console.log( "handler_menu_detail_search" );
}


/**
 * This function handles the onclick event of the add menu entry
 */
function handler_menu_add( )
{
  console.log( "handler_menu_add" );
}


/**
 * This function handles the onclick event of the search icon
 */
function handler_search( )
{
  console.log( "handler_search" );
}


/**
 * This function inserts an object before the object of the given id
 *
 * @param object The object to insert
 * @param id The ID of the object, the given object should be placed directly before of
 */
function add_before( object, id )
{
  var target = document.getElementById( id );
  target.parentNode.insertBefore( object, target );
}


/**
 * This function inserts an object after the object of the given id
 *
 * @param object The object to insert
 * @param id The ID of the object, the given object should be placed directly after of
 */
function add_after( object, id )
{
  var target = document.getElementById( id );
  target.parentNode.insertBefore( object, target.nextSibling );
}


/**
 * This function delets the object with the given id
 *
 * @param id ID of the object to delete
 */
function delete_object( id )
{
  var element = document.getElementById( id );

  if( element ) {
    element.parentNode.removeChild( element );
  }
}