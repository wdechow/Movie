
/* This path unsures that the mod_perl handler for project movie is used */
var path = "/promov";

$( document ).ready( function( ) {
  load_site( );
} );


/**
 * This function loads the header, content and footer
 */
function load_site( )
{
  $( "#movie-header" ).load( "movie/components/header.html" );
  $( "#movie-content" ).load( "movie/components/main.html" );
  $( "#movie-footer" ).load( "movie/components/footer.html" );

  // Request to test mod_perl
  $.post( path, { }, function( data ) {

  } ).success( function( ) {

  } );
}