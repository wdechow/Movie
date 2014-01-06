
/* This path ensures that the mod_perl handler for project movie is used */
var path = "/promov";

$( document ).ready( function( ) {
  load_site( );
} );


/**
 * This function loads the header, content and footer
 */
function load_site( )
{
  $( "#header" ).load( "movie/components/header.html", function( ) {
    // When the header is fully loaded, i can set all handlers
    load_header_handlers( );
  } );

  $( "#content" ).load( "movie/components/main.html" );
  $( "#footer" ).load( "movie/components/footer.html" );

  // Request to test mod_perl
  $.post( path, { }, function( data ) {

  } ).success( function( ) {

  } );
}


/**
 * This function sets all handler for the header
 */
function load_header_handlers( )
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

  input_search.onkeypress = function( e ) {
    /* If return was pressed in input field, trigger handler */
    if( e.keyCode == 13 ) {
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