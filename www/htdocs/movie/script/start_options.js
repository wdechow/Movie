
$( document ).ready( function( ) {
  set_start_option_handler( );
  load_details( );
} );


function set_start_option_handler( )
{
  console.log( "set_start_option_handler" );
}


/**
 * This functions requests the neccessary information for the start options and detail div
 */
function load_details( )
{
  var params = { };
  params[ 'method' ]  = 'get_movie_detail';
  params[ 'id' ]      = get_selected_movie_id( );

  $.post( PATH, params, function( data ) {
    if( ( data !== undefined ) && ( data != "" ) ) {

      var json_data = jQuery.parseJSON( data );

      set_start_options( json_data[ 'languages' ], json_data[ 'subtitles' ] );
      set_details( json_data[ 'actors' ], json_data[ 'cover' ] );

    } else {

      console.log( "No data received" );
    }
  } ).fail( function( ) {

    console.log( "Error getting table data" );
  });
}


/**
 * This functions gets the movie id from the expanded row attribute
 *
 * @return Movie ID of the expanded row
 */
function get_selected_movie_id( )
{
  var expanded_row = document.getElementById( "expand-row" );
  return expanded_row.getAttribute( 'data-id' );
}


/**
 * This function sets all start options
 *
 * @param languages Array of all languages available for this movie
 * @param subtitles Array of all subtitles available for this movie
 */
function set_start_options( languages, subtitles )
{
  /* add languages to language select */
  for( var i = 0; i < languages.length; i++ ) {

    add_select( 'start-option-language-select', languages[ i ] );
  }


  /* add subtitles to subtitle select */
  for( var i = 0; i < subtitles.length; i++ ) {

    add_select( 'start-option-subtitle-select', subtitles[ i ] );
  }
}


/**
 * Adds the gicen object to the select with the given id
 *
 * @param element_id ID of the select the objects should be added to
 * @param object Object to add, has to contain id, value and text
 */
function add_select( element_id, object )
{
  var select = document.getElementById( element_id );
  var option = document.createElement( 'option' );

  option.text   = object[ 'text' ];
  option.value  = object[ 'value' ];
  option.setAttribute( 'data-id', object[ 'id' ] );

  select.add( option );
}


/**
 *
 */
function set_details( )
{

}