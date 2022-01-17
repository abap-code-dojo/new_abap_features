CLASS ltcl_test DEFINITION DEFERRED.
CLASS zcl_code_dojo_new_features DEFINITION LOCAL FRIENDS ltcl_test .
CLASS ltcl_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA f_cut TYPE REF TO zcl_code_dojo_new_features.
    METHODS:
      setup,
      nine_numbers FOR TESTING,
      cities FOR TESTING,
      cities_count_loop FOR TESTING,
      cities_count_for FOR TESTING,
      material_prices FOR TESTING,
      range_name FOR TESTING,
      range_city FOR TESTING.
ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD nine_numbers.
    cl_abap_unit_assert=>assert_equals(
        act = f_cut->fill_demo_data_numbers(  )
        exp = VALUE zcl_code_dojo_new_features=>_numbers(
            ( i = 1 ) ( i = 2 ) ( i = 3 ) ( i = 4 ) ( i = 5 ) ( i = 6 ) ( i = 7 ) ( i = 8 ) ( i = 9 ) ) ).
  ENDMETHOD.

  METHOD setup.
    f_cut = NEW #( ).
    f_cut->fill_demo_data( ).
  ENDMETHOD.
  METHOD cities.
    cl_abap_unit_assert=>assert_equals(
    act = f_cut->get_cities( )
    exp = VALUE string_table(  ( `Berlin` ) ( `Hannover` ) ( `Hamburg` ) ) ).
  ENDMETHOD.

  METHOD cities_count_loop.
    cl_abap_unit_assert=>assert_equals(
    act = f_cut->get_cities_count_loop( )
    exp = VALUE zcl_code_dojo_new_features=>_cities_count(
      ( city = `Berlin`   count = 3 )
      ( city = `Hannover` count = 1 )
      ( city = `Hamburg`  count = 1 ) ) ).
  ENDMETHOD.

  METHOD cities_count_for.
    cl_abap_unit_assert=>assert_equals(
    act = f_cut->get_cities_count_for( )
    exp = VALUE zcl_code_dojo_new_features=>_cities_count(
      ( city = `Berlin`   count = 3 )
      ( city = `Hannover` count = 1 )
      ( city = `Hamburg`  count = 1 ) ) ).
  ENDMETHOD.

  METHOD material_prices.
    DATA(result) = f_cut->get_material_prices( ).
    cl_abap_unit_assert=>assert_equals(
    act = result
    exp = VALUE zcl_code_dojo_new_features=>_material_prices_sum(
       ( mtart = `HOLZ`   count = 3 price = `6.66` )
       ( mtart = `METALL` count = 2 price = `9.99` ) ) ).
  ENDMETHOD.

  METHOD range_name.
    cl_abap_unit_assert=>assert_equals(
    act = f_cut->fill_ranges_table_name( )
    exp = VALUE zcl_code_dojo_new_features=>_generic_range_tab(
      ( sign = 'I' option = 'EQ' low = 'Kattafelt' )
      ( sign = 'I' option = 'EQ' low = 'Odertal'   )
      ( sign = 'I' option = 'EQ' low = 'Dschäksn'  )
      ( sign = 'I' option = 'EQ' low = 'Johnson'   )
      ( sign = 'I' option = 'EQ' low = 'Bungee'    ) ) ).
  ENDMETHOD.

  METHOD range_city.
    cl_abap_unit_assert=>assert_equals(
    act = f_cut->fill_ranges_table_city( )
    exp = VALUE zcl_code_dojo_new_features=>_generic_range_tab(
      ( sign = 'I' option = 'EQ' low = `Berlin`   )
      ( sign = 'I' option = 'EQ' low = `Hannover` )
      ( sign = 'I' option = 'EQ' low = `Hamburg`  ) ) ).
  ENDMETHOD.

ENDCLASS.
