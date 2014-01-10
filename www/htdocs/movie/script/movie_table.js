
$( document ).ready( function( ) {
  set_filter_handler( );
  load_table_content( 1, NUMBER_OF_MOVIES );
} );



/**
 * This function sets all handler for the filter
 */
function set_filter_handler( )
{
  var input_filter_title        = document.getElementById( "filter-title" );
  var input_filter_subtitle     = document.getElementById( "filter-subtitle" );
  var input_filter_runtime      = document.getElementById( "filter-runtime" );
  var input_filter_release_date = document.getElementById( "filter-release-date" );

  input_filter_title.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      handler_filter_title( );
    }
  }

  input_filter_subtitle.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      handler_filter_subtitle( );
    }
  }

  input_filter_runtime.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      handler_filter_runtime( );
    }
  }

  input_filter_release_date.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      handler_filter_release_date( );
    }
  }
}


/**
 * This function creates the movie data table
 *
 * @param from Index of the first item to select
 * @param count Number of items to select
 */
function load_table_content( from, count )
{
  var params = { };
  params[ 'method' ]  = 'get_table_data';
  params[ 'from' ]    = from;
  params[ 'count' ]   = count;

  $.post( PATH, params, function( data ) {
    if( ( data !== undefined ) && ( data != "" ) ) {
      fill_table( data );
    } else {
      console.log( "No data received" );
    }
  } ).fail( function( ) {
    console.log( "Error getting table data" );
  });
}


/**
 * This methods writes the table content to the table and sets the paging
 *
 * @param data Json containing all data for the table and the paging information
 */
function fill_table( data )
{
  var movies = jQuery.parseJSON( data );

  // all entries after the first one are tabe rows
  for( var i = 1; i < movies.length; i++ ) {
    // +1 because row 0 are the column titels and row 1 filter
    // first data row has to be 2 and i starts at 1 ... so +1 = 2
    add_row( movies[ i ], i + 1 );
  }

  // first entry specifies the paging
  set_paging( movies[ 0 ] );
}


/**
 * This function adds one row to the movie table
 *
 * @param entry All values for one row
 * @param id ID for the new table row
 */
function add_row( entry, id )
{
  var table = document.getElementById( "table-data" );
  var row   = table.insertRow( -1 );

  row.id    = "data-row-" + add_leading_zero( id );
  row.classList.add( "data-row" );


  /* setting the Movie ID as data attribute for later use, to start the movie */
  row.setAttribute( 'data-id', entry[ 'id' ] );


  /* adding onclick event handler */
  row.onclick = function( ) {
    handler_data_row( this.id );
  }


  /* setting cell class and content */
  var cell_1 = row.insertCell( 0 );
  var cell_2 = row.insertCell( 1 );
  var cell_3 = row.insertCell( 2 );
  var cell_4 = row.insertCell( 3 );

  cell_1.classList.add( "data-column-00" );
  cell_2.classList.add( "data-column-01" );
  cell_3.classList.add( "data-column-02" );
  cell_4.classList.add( "data-column-03" );

  cell_1.innerHTML = entry[ 'title' ];
  cell_2.innerHTML = entry[ 'subtitle' ];
  cell_3.innerHTML = entry[ 'runtime' ];
  cell_4.innerHTML = entry[ 'release_date' ];
}


/**
 * This function sets the paging
 *
 * @param paging Object containing all paging information
 */
function set_paging( paging )
{
  console.log( "set_paging" );
}


/**
 * This function handles the keypress event of the title filter
 */
function handler_filter_title( )
{
  console.log( "handler_filter_title" );
}


/**
 * This function handles the keypress event of the subtitle filter
 */
function handler_filter_subtitle( )
{
  console.log( "handler_filter_subtitle" );
}


/**
 * This function handles the keypress event of the runtime filter
 */
function handler_filter_runtime( )
{
  console.log( "handler_filter_runtime" );
}


/**
 * This function handles the keypress event of the release date filter
 */
function handler_filter_release_date( )
{
  console.log( "handler_filter_release_date" );
}


/**
 *
 */
function handler_data_row( id )
{
  console.log( "table row with id: " + id + " was clicked." );
}


/**
 * In this projekt a Table has about 40 rows (but never more than 99).
 * This function adds a leading zero if neccessary for the row ID.
 *
 * @param n row ID
 */
function add_leading_zero( n )
{
  return ( n < 10 ) ? ( "0" + n ) : n;
}