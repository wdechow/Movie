
/* This variable stores the id of the last row that was expanded */
var LAST_EXPANDED_ID = "";

/* Saves the current page number to make paging easier */
var CURRENT_PAGE    = 1;

/* saves number of pages to make paging easier */
var NUMBER_OF_PAGES = 1;


$( document ).ready( function( ) {
  set_filter_handler( );
  load_table_content( 1, NUMBER_OF_MOVIES );
  set_paging_handler( );
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


  /* filter title */
  input_filter_title.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      search_filter_title( );
    }
  }

  input_filter_title.onclick = function( ) {
    clear_filter_input( "#filter-title" );
  }


  /* filter subtitle */
  input_filter_subtitle.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      search_filter_subtitle( );
    }
  }

  input_filter_subtitle.onclick = function( ) {
    clear_filter_input( "#filter-subtitle" );
  }


  /* filter runtime */
  input_filter_runtime.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      search_filter_runtime( );
    }
  }

  input_filter_runtime.onclick = function( ) {
    clear_filter_input( "#filter-runtime" );
  }


  /* filter release date */
  input_filter_release_date.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == KEY_ID_RETURN ) {
      search_filter_release_date( );
    }
  }

  input_filter_release_date.onclick = function( ) {
    clear_filter_input( "#filter-release-date" );
  }
}


/**
 * This function sets the handler for next page, last page, previous page and first page button
 */
function set_paging_handler( )
{
  var first_page    = document.getElementById( "paging-first" );
  var previous_page = document.getElementById( "paging-previous" );
  var next_page     = document.getElementById( "paging-next" );
  var last_page     = document.getElementById( "paging-last" );

  first_page.onclick = function( )  {
    set_page( 1 );
  }

  previous_page.onclick = function( )  {
    set_page( CURRENT_PAGE - 1 );
  }

  next_page.onclick = function( )  {
    set_page( CURRENT_PAGE + 1 );
  }

  last_page.onclick = function( )  {
    set_page( NUMBER_OF_PAGES );
  }
}


/**
 * This function loads the content for the given page number and handles the new paging
 *
 * @param page_number Page number to load
 */
function set_page( page_number )
{
  CURRENT_PAGE = page_number;

  var from = CURRENT_PAGE * NUMBER_OF_MOVIES;
  load_table_content( from, NUMBER_OF_MOVIES );
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

    add_row( movies[ i ], i );
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
  cell_3.innerHTML = format_runtime( entry[ 'runtime' ] );
  cell_4.innerHTML = entry[ 'release_date' ];
}


/**
 * This function sets the paging
 *
 * @param paging Object containing all paging information (paging[ 'pages' ])
 */
function set_paging( paging )
{
  NUMBER_OF_PAGES = paging[ 'pages' ];

  $( "#paging-info" ).text( get_paging_text( ) );


  if( NUMBER_OF_PAGES === 1 ) {
    /* If there is only one page i can disable all 4 buttons */
    disable_next( );
    disable_privious( );
  } else if( CURRENT_PAGE === NUMBER_OF_PAGES ) {
    /* If the current page ist the last page i can disable the next and last buttons */
    enable_privious( );
    disable_next( );
  } else if ( CURRENT_PAGE === 1 ) {
    /* If the current page ist the first page i can disable the previous and first buttons */
    enable_next( );
    disable_privious( );
  }
}


/**
 * Creates the text for the paging-info div
 *
 * @return the paging info text
 */
function get_paging_text( )
{
  if( NUMBER_OF_PAGES === 1 ) {
    return "Seite 1";
  } else {
    return "Seite " + CURRENT_PAGE + " von " + NUMBER_OF_PAGES;
  }
}


/**
 * Disables the next and last button
 */
function disable_next( )
{
  $( "#paging-last" ).prop( 'disabled', 'true' );
  $( "#paging-next" ).prop( 'disabled', 'true' );
}


/**
 * Disables the privious and first button
 */
function disable_privious( )
{
  $( "#paging-first" ).prop( 'disabled', 'true' );
  $( "#paging-previous" ).prop( 'disabled', 'true' );
}


/**
 * Enables the next and last button
 */
function enable_next( )
{
  $( "#paging-last" ).prop( 'disabled', 'false' );
  $( "#paging-next" ).prop( 'disabled', 'false' );
}


/**
 * Enables the privious and first button
 */
function enable_privious( )
{
  $( "#paging-first" ).prop( 'disabled', 'false' );
  $( "#paging-previous" ).prop( 'disabled', 'false' );
}


/**
 * This function handles the keypress event of the title filter
 */
function search_filter_title( )
{
  console.log( "search_filter_title" );
}


/**
 * This function handles the keypress event of the subtitle filter
 */
function search_filter_subtitle( )
{
  console.log( "search_filter_subtitle" );
}


/**
 * This function handles the keypress event of the runtime filter
 */
function search_filter_runtime( )
{
  console.log( "search_filter_runtime" );
}


/**
 * This function handles the keypress event of the release date filter
 */
function search_filter_release_date( )
{
  console.log( "search_filter_release_date" );
}


/**
 * This method clears the input for the filter of the given id
 *
 * @param id ID of the input to clear, preceeded by #
 */
function clear_filter_input( id )
{
  if( $( id ).val( ) === FILTER_INPUT_DEFAULT_VAL ) {
    $( id ).val( "" );
  }
}


/**
 * This function handles the click event on a table row
 */
function handler_data_row( id )
{
  collaps_expanded_rows( );
  expand_row( id );
}


/**
 * This function shows the expand row, containing startoptions and detail information
 *
 * @param id ID of the clicked row
 */
function expand_row( id )
{
  var row_to_expand = document.getElementById( id );

  /* If the same row is clicked a second time, i do not expand any row */
  if( id === LAST_EXPANDED_ID ) {

    if( ! row_is_expanded( ) ) {
      /*
        if there is no expanded row, collaps_axpanded_rows has been called
        and i can reset LAST_EXPANDED_ID
      */
      LAST_EXPANDED_ID = "";
    }

    return;
  }

  LAST_EXPANDED_ID = id;


  /* This row contains the call, containing the start options and detail divs */
  var expand_row = document.createElement( 'tr' );
  expand_row.id = "expand-row";


  /* Setting the data-id attribute for the expanded row for further use */
  /* This way it's much more convinient to retrieve it in the start_options.js */
  var movie_id = row_to_expand.getAttribute( 'data-id' );
  expand_row.setAttribute( 'data-id', movie_id );


  /* This cell contains the start options and detail divs */
  var cell_1 = expand_row.insertCell( 0 );
  cell_1.id = "expand-cell";
  cell_1.colSpan = NUMBER_OF_COLUMNS;


  /* This is the spacer table row */
  var spacer_row = document.createElement( 'tr' );
  spacer_row.id = "spacer-row";
  spacer_row.classList.add( "table-spacer" );
  spacer_row.colSpan = NUMBER_OF_COLUMNS;


  /* Inserting the expanded row and the spacer in the table */
  add_after( expand_row, id );
  add_after( spacer_row, expand_row.id );


  /* Loading the start options and detail content */
  $( "#expand-cell" ).load( "movie/components/start_options.html", function( ) {
    console.log( "content loaded" );
  } );
}


/**
 * Collapses all expanded rows
 */
function collaps_expanded_rows( )
{
  delete_object( "expand-row" );
  delete_object( "spacer-row" );
}


/**
 * This function checks if there are any expanded rows
 *
 * @return true if there is at least one expanded row, false else
 */
function row_is_expanded( )
{
  var element = document.getElementById( "expand-row" );

  return element ? true : false;
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


/**
 * This function formats the runtime in the desired form
 *
 * @param runtime Unformatted runtime
 *
 * @return Formatted runtime
 */
function format_runtime( runtime )
{
  return runtime + " Minuten";
}