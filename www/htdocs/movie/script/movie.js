
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
    // When the header is fully loaded, i can set the onclick handlers for the links
    load_menu( );
  } );

  $( "#content" ).load( "movie/components/main.html" );
  $( "#footer" ).load( "movie/components/footer.html" );

  // Request to test mod_perl
  $.post( path, { }, function( data ) {

  } ).success( function( ) {

  } );
}


/**
 * This function sets the onclick handler for all menu entries
 */
function load_menu( )
{
  var link_preferences    = document.getElementById( "menu-preferences" );
  var link_detail_search  = document.getElementById( "menu-detail-search" );
  var link_add            = document.getElementById( "menu-add" );

  link_preferences.onclick = function( ) {
    handler_menu_preferences( );
  }

  link_detail_search.onclick = function( ) {
    handler_menu_detail_search( );
  }

  link_add.onclick = function( ) {
    handler_menu_add( );
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