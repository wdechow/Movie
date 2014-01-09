
/* This path ensures that the mod_perl handler for project movie is used */
var path = "/promov";

/* This variable sets the amount of Movies listed in table per page */
var number_of_movies = 20;

$( document ).ready( function( ) {
  load_site( );
} );



/**
 * This function loads the header, content and footer
 */
function load_site( )
{
  load_header( );
  load_content( "movie/components/content.html" );
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
    // When the content structure is fully loaded, i can load the movie data and filter handler
    set_filter_handler( );
    load_table_content( 1, number_of_movies );
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
    if( key.keyCode == 13 ) {
      handler_filter_title( );
    }
  }

  input_filter_subtitle.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == 13 ) {
      handler_filter_subtitle( );
    }
  }

  input_filter_runtime.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == 13 ) {
      handler_filter_runtime( );
    }
  }

  input_filter_release_date.onkeypress = function( key ) {
    /* If return was pressed in input field, trigger handler */
    if( key.keyCode == 13 ) {
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

  $.post( path, params, function( data ) {
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
    if( key.keyCode == 13 ) {
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