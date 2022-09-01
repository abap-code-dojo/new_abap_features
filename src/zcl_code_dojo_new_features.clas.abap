CLASS zcl_code_dojo_new_features DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF _generic_range_str,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE c LENGTH 50,
             high   TYPE c LENGTH 50,
           END OF _generic_range_str,
           _generic_range_tab TYPE STANDARD TABLE OF _generic_range_str WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ts_demodata,
        name_first TYPE string,
        name_last  TYPE string,
        city       TYPE string,
      END OF ts_demodata .
    TYPES:
      tt_demodata TYPE STANDARD TABLE OF ts_demodata WITH DEFAULT KEY .
    TYPES:
      BEGIN OF _number,
        i TYPE i,
      END OF _number .
    TYPES:
      _numbers TYPE SORTED TABLE OF _number WITH UNIQUE KEY i .
    TYPES:
      BEGIN OF _city_count,
        city  TYPE string,
        count TYPE i,
      END OF _city_count .
    TYPES:
      _cities_count TYPE STANDARD TABLE OF _city_count WITH DEFAULT KEY .
    TYPES:
      BEGIN OF _material_price,
        matnr TYPE matnr,
        mtart TYPE string,
        price TYPE p LENGTH 8 DECIMALS 2,
      END OF _material_price .
    TYPES:
      _material_prices TYPE STANDARD TABLE OF _material_price WITH DEFAULT KEY .
    TYPES:
      BEGIN OF _material_price_sum,
        mtart TYPE string,
        count TYPE i,
        price TYPE p LENGTH 8 DECIMALS 2,
      END OF _material_price_sum .
    TYPES:
      _material_prices_sum TYPE STANDARD TABLE OF _material_price_sum WITH DEFAULT KEY .

    METHODS fill_demo_data .
    METHODS fill_demo_data_numbers
      RETURNING
        VALUE(numbers) TYPE _numbers .
    METHODS fill_demo_data_materials
      RETURNING
        VALUE(prices) TYPE _material_prices .
    METHODS get_cities
      RETURNING
        VALUE(cities) TYPE string_table .
    METHODS get_cities_count_loop
      RETURNING
        VALUE(result) TYPE _cities_count .
    METHODS get_cities_count_for
      RETURNING
        VALUE(result) TYPE _cities_count .
    METHODS get_material_prices
      RETURNING
        VALUE(result) TYPE _material_prices_sum .
    METHODS create_text
      RETURNING VALUE(text) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA demo TYPE tt_demodata .
    DATA numbers TYPE _numbers .
    DATA material_prices TYPE _material_prices .

    METHODS fill_demo_data_addresses
      RETURNING
        VALUE(addressdata) TYPE tt_demodata .
    METHODS fill_ranges_table_city
      RETURNING
        VALUE(range_tab) TYPE _generic_range_tab .
    METHODS fill_ranges_table_name
      RETURNING
        VALUE(range_tab) TYPE _generic_range_tab .
    METHODS fill_ranges_table_header
      RETURNING
        VALUE(range_tab) TYPE _generic_range_tab .
ENDCLASS.



CLASS zcl_code_dojo_new_features IMPLEMENTATION.


  METHOD fill_demo_data.

    demo            = fill_demo_data_addresses( ).
    numbers         = fill_demo_data_numbers( ).
    material_prices = fill_demo_data_materials( ).

  ENDMETHOD.


  METHOD fill_demo_data_addresses.

    addressdata = VALUE #(
      (  name_first = 'Ivonne'  name_last = 'Kattafelt'      city = 'Berlin' )
      (  name_first = 'Lena'    name_last = 'Odertal'        city = 'Berlin' )
      (  name_first = 'Michael' name_last = 'Dschäksn'       city = 'Berlin' )
      (  name_first = 'John'    name_last = 'Johnson'        city = 'Hannover' )
      (  name_first = 'Enno'    name_last = 'Bungee'         city = 'Hamburg' ) ).

  ENDMETHOD.


  METHOD fill_demo_data_materials.

    prices = VALUE #(
               ( matnr = 'PF12345AA' mtart = 'HOLZ'   price = '1.11' )
               ( matnr = 'PF12345AB' mtart = 'HOLZ'   price = '2.22' )
               ( matnr = 'PF12345AC' mtart = 'HOLZ'   price = '3.33' )
               ( matnr = 'GE99999KK' mtart = 'METALL' price = '4.44' )
               ( matnr = 'GE99999OO' mtart = 'METALL' price = '5.55' ) ).

  ENDMETHOD.


  METHOD fill_demo_data_numbers.

    numbers = VALUE #( FOR i = 1 WHILE i < 10 ( i = i )  ).

  ENDMETHOD.


  METHOD fill_ranges_table_city.

    range_tab = VALUE #( FOR city IN get_cities( ) ( sign = 'I' option = 'EQ' low = city ) ).

  ENDMETHOD.


  METHOD fill_ranges_table_header.

    range_tab = VALUE #( sign = 'I' option = 'EQ'
      ( low = 'ONE' )
      ( low = 'TWO' )
      ( low = 'THREE' ) ).

  ENDMETHOD.


  METHOD fill_ranges_table_name.

    range_tab = VALUE #( FOR line IN demo ( sign = 'I' option = 'EQ' low = line-name_last ) ).

  ENDMETHOD.


  METHOD get_cities.

    LOOP AT demo INTO DATA(address)
      GROUP BY address-city
      INTO DATA(city).
      APPEND city TO cities.
    ENDLOOP.


  ENDMETHOD.


  METHOD get_cities_count_for.

    "w/o hungarian notation
    result = VALUE #( FOR GROUPS city_group OF address IN demo
                      GROUP BY ( city  = address-city
                                 count = GROUP SIZE )
                      ( city_group ) ).

    "with hungarian notation
*    rt_result = VALUE #( FOR GROUPS ls_city_group OF ls_address IN mt_demo
*                      GROUP BY ( city  = ls_address-city
*                                 count = GROUP SIZE )
*                      ( ls_city_group ) ).

  ENDMETHOD.


  METHOD get_cities_count_loop.

    LOOP AT demo INTO DATA(address)
      GROUP BY ( city = address-city count = GROUP SIZE )
      INTO DATA(city_group).
*      APPEND value #( city = city-city count = city-count ) TO result.
      APPEND city_group TO result.
    ENDLOOP.

  ENDMETHOD.


  METHOD get_material_prices.

    result = VALUE #( FOR GROUPS grp OF material IN material_prices
                  GROUP BY ( mtart  = material-mtart
                             count = GROUP SIZE )
                  ( mtart = grp-mtart
                    count = grp-count
                    price = REDUCE #( INIT sum = '0.00'
                                      FOR i IN material_prices WHERE ( mtart = grp-mtart )
                                      NEXT sum = sum + i-price )  ) ).

  ENDMETHOD.

  METHOD create_text.

    text = |Hallo { sy-uname }, es ist { sy-uzeit } am { sy-datum }|.

  ENDMETHOD.

ENDCLASS.
