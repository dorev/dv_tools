#define DV_GENERATE_MAGIC_NUMBER

//#define TEST_CONCAT
#ifndef TEST_CONCAT
    #include "dv_version.mqh"
    #include "dv_config.mqh"
    #include "dv_logger.mqh"
    #include "dv_common.mqh"
    #include "dv_vector.mqh"
    #include "dv_map.mqh"
    #include "dv_class_vector.mqh"
    #include "dv_class_map.mqh"
    #include "dv_ui_manager.mqh"
    #include "dv_order_manager.mqh"
#else
    #include "../dv_tools.mqh"
#endif

///////////////////////////////////////////////////////////////////////////////
// Testing variables and macros

string __TEST_NAME__ = "";
string __TEST_SERIE_NAME__ = "";
#define NEW_TEST_SERIE(x)                   __TEST_SERIE_NAME__ = x; INFO("STARTING TESTS: " + __TEST_SERIE_NAME__);
#define NEW_TEST(x)                         __TEST_NAME__ = x; INFO("TESTING: " + __TEST_NAME__);
#define EXPECT(condition, errorMessage)     if (!(condition)) { ERROR(errorMessage); ERROR("FAILED TEST: " + __TEST_NAME__); return false; }
#define EXPECT_EQ(lhs, rhs, errorMessage)   if (!(equals(lhs, rhs))) { ERROR(errorMessage + " >>> " + lhs + " != " + rhs); ERROR("FAILED TEST: " + __TEST_NAME__); return false; }
#define FAIL(x)                             ERROR("FAILED TEST " + __TEST_NAME__ + ": " + x); return false;
#define SUCCEEDED_TESTS                     INFO("SUCCEEDED TESTS: " + __TEST_SERIE_NAME__); return true;

class TestClass
{
public:

    int number;
    string text;

    TestClass(): number(-1), text("")
    {}

    TestClass(int n, string t = "defaut text"): number(n), text(t)
    {}

    TestClass(const TestClass& other): number(other.number), text(other.text)
    {}
};

///////////////////////////////////////////////////////////////////////////////
// Main

int OnInit()
{
    logger::init();

    if (
        vector_tests()          &&
        map_tests()             &&
        class_vector_tests()    &&
        class_map_tests()       &&
        ui_manager_tests()      &&
        log_tests()             &&
        order_book_tests()      &&
        1)
    {
        Print("PASSED TESTS");
        Print("PASSED TESTS");
        Print("PASSED TESTS");
    }
    else
    {
        Print("FAILED TESTS");
        Print("FAILED TESTS");
        Print("FAILED TESTS");
    }

    Print("MagicNumber value : " + MagicNumber);

    logger::shutdown();

    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {}
void OnTick(){}
void OnTimer(){}

///////////////////////////////////////////////////////////////////////////////

bool log_tests()
{
    NEW_TEST_SERIE("log macros")

    DEBUG("debug test " + 1)
    INFO("info test " + 2)
    WARNING("warn test " + 3)
    ERROR("error test " + 4)

    ///////////////////////////////////////////////////////////////////////////

    SUCCEEDED_TESTS

}

///////////////////////////////////////////////////////////////////////////////

bool vector_tests()
{
    NEW_TEST_SERIE("vector")
    NEW_TEST("vector<int>")
    vector<int> v;

    int i = 0;
    v.push(i);
    EXPECT_EQ(v.get(0), 0, "Index 0 should have been" + IntegerToString(i))

    v.push(1);
    EXPECT_EQ(v.get(1), 1, "Index 1 should have been 1")

    v.set(0, 2);
    EXPECT_EQ(v.get(0), 2, "Index 0 should have been 2")

    v.erase(0);
    EXPECT_EQ(v.get(0), 1, "Index 0 should have been 1, the shifted value after erase()")
    EXPECT_EQ(v.size(), 1, "Size of vector should have changed to 1")

    v.push(3);
    EXPECT_EQ(v.find(3), 1, "Index returned by find(3) should have been 1")
    EXPECT_EQ(v.find(9), -1, "Index returned by find(9) should have been -1")

    v.reserve(64);
    EXPECT_EQ(v.capacity(), 64, "reserve(64) should have expanded capacity to 64");

    v.fill(42);
    EXPECT_EQ(v.get(62), 42, "Arbitrarily select index should be 42 after filling the vector")

    v.fill(0, 16);
    EXPECT_EQ(v.get(15), (int)NULL, "Vector should have been filled with NULL up to the 16th element")
    EXPECT_EQ(v.get(16), 42, "Elements of vector beyond the 16th index should not have been altered")

    int v_original_capacity = v.capacity();
    v.clear();
    EXPECT_EQ(v.size(), 0, "clear() should have reset the vector size to 0")
    EXPECT_EQ(v.capacity(), v_original_capacity, "clear(false) should not have altered the vector capacity")

    v.clear(true);
    EXPECT_EQ(v.capacity(), DV_DEFAULT_CONTAINER_RESERVE, "clear(true) should have reset the vectory capacity to the default value")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("vector<string>")
    vector<string> vs;

    string s = "test0";
    vs.push(s);
    EXPECT_EQ(vs.get(0), "test0", "Index 0 should have been 'test0'")

    vs.push("test1");
    EXPECT_EQ(vs.get(1), "test1", "Index 1 should have been 'test1'")

    vs.set(0, "test2");
    EXPECT_EQ(vs.get(0), "test2", "Index 0 should have been 'test2'")

    vs.erase(0);
    EXPECT_EQ(vs.get(0), "test1", "Index 0 should have been 'test1', the shifted value after erase()")
    EXPECT_EQ(vs.size(), 1, "Size of vector should have changed to 1")

    vs.push("test3");
    EXPECT_EQ(vs.find("test3"), 1, "Index returned by find('test3') should have been 1")
    EXPECT_EQ(vs.find("test99"), -1, "Index returned by find('test99') should have been -1")

    vs.reserve(64);
    EXPECT_EQ(vs.capacity(), 64, "reserve(64) should have expanded capacity to 64");

    vs.fill("test42");
    EXPECT_EQ(vs.get(62), "test42", "Arbitrarily select index should be 'test42' after filling the vector")

    vs.fill(0, 16);
    EXPECT_EQ(vs.get(15), NULL, "Vector should have been filled with NULL up to the 16th element")
    EXPECT_EQ(vs.get(16), "test42", "Elements of vector beyond the 16th index should not have been altered")

    int vs_original_capacity = vs.capacity();
    vs.clear();
    EXPECT_EQ(vs.size(), 0, "clear() should have reset the vector size to 0")
    EXPECT_EQ(vs.capacity(), vs_original_capacity, "clear(false) should not have altered the vector capacity")

    vs.clear(true);
    EXPECT_EQ(v.capacity(), DV_DEFAULT_CONTAINER_RESERVE, "clear(true) should have reset the vectory capacity to the default value")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("vector<int> constructors and assignement")

    vector<int> v_to_copy;
    v_to_copy.push(1).push(2).push(3);

    vector<int> v1(v_to_copy);
    bool v1_is_good = v1.get(0) == 1 && v1.get(1) == 2 && v1.get(2) == 3;
    EXPECT(v1_is_good, "Values not copied correctly using copy-contructor")

    int init_array[3] = { 1, 2, 3};
    vector<int> v2(init_array);
    bool v2_is_good = v2.get(0) == 1 && v2.get(1) == 2 && v2.get(2) == 3;
    EXPECT(v2_is_good, "Values not copied correctly when initializing with array")

    vector<int> v3 = init_array;

    bool v3_is_good = v3.get(0) == 1 && v3.get(1) == 2 && v3.get(2) == 3;

    EXPECT(v3_is_good, "Values not copied correctly when assigning with array")

    vector<int> v4;
    v4 = v3;

    bool v4_is_good = v4.get(0) == 1 && v4.get(1) == 2 && v4.get(2) == 3;

    EXPECT(v4_is_good, "Values not copied correctly when assigning with array")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("vector<string> constructors and assignement")

    vector<string> vs_to_copy;
    vs_to_copy.push("1").push("2").push("3");

    vector<string> vs1(vs_to_copy);
    bool vs1_is_good = equals(vs1.get(0), "1") && equals(vs1.get(1), "2") && equals(vs1.get(2), "3");
    EXPECT(vs1_is_good, "Values not copied correctly using copy-contructor")

    string init_array_s[3] = { "1", "2", "3"};
    vector<string> vs2(init_array_s);
    bool vs2_is_good = equals(vs2.get(0), "1") && equals(vs2.get(1), "2") && equals(vs2.get(2), "3");
    EXPECT(vs2_is_good, "Values not copied correctly when initializing with array")

    vector<string> vs3 = init_array_s;

    bool vs3_is_good = equals(vs3.get(0), "1") && equals(vs3.get(1), "2") && equals(vs3.get(2), "3");
    EXPECT(vs3_is_good, "Values not copied correctly when assigning with array")

    vector<string> vs4;
    vs4 = vs3;

    bool vs4_is_good = equals(vs4.get(0), "1") && equals(vs4.get(1), "2") && equals(vs4.get(2), "3");
    EXPECT(vs4_is_good, "Values not copied correctly when assigning with array")

    ///////////////////////////////////////////////////////////////////////////

    SUCCEEDED_TESTS
}

///////////////////////////////////////////////////////////////////////////////

bool class_vector_tests()
{
    NEW_TEST_SERIE("class_vector")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject>")

    class_vector<TestClass> o;
    TestClass tc;
    tc.number = 42;
    tc.text = "and six";

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject>::emplace")
    EXPECT_EQ(o.size(), 0, "object_vector size should be 0 if no emplace() occured yet")
    o.emplace(); // index 0
    EXPECT_EQ(o.size(), 1, "object_vector size should be 1")

    o.emplace(0); // index 1
    o.emplace(1, "1"); // index 2
    o.emplace(tc); // index 35
    EXPECT_EQ(o.size(), 4, "object_vector size should be 4")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject>::get_ref")
    TestClass* tcp1 = o.get_ref(2);
    EXPECT_EQ(tcp1.number, 1, "TestClass number content should have been 1")
    EXPECT_EQ(tcp1.text, "1", "TestClass text content should have been '1'")

    TestClass* tcp2 = o.get_ref(3);
    EXPECT_EQ(tcp2.number, 42, "TestClass number content should have been 42")
    EXPECT_EQ(tcp2.text, "and six", "TestClass text content should have been 'and six'")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject>::erase")
    o.erase(1);
    EXPECT_EQ(o.get_ref(1).text, "1", "Text of object held at index one should now be '1'")
    EXPECT_EQ(o.size(), 3, "object_vector size should have shrunk to 3")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject> copy constructor")
    class_vector<TestClass> o_copy(o);
    EXPECT_EQ(o_copy.get_ref(1).text, "1", "Content of copy-constructed object_vector should be identical to source")
    EXPECT_EQ(o_copy.size(), 3, "Content of copy-constructed object_vector should be identical to source")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_vector<TestObject>::clear")
    o.clear();
    EXPECT_EQ(o.size(), 0, "object_vector size should be 0 after clear()")

    o_copy.resize(0);
    EXPECT_EQ(o_copy.size(), 0, "object_vector size should be 0 after resize(0)")

    ///////////////////////////////////////////////////////////////////////////

    SUCCEEDED_TESTS
}

///////////////////////////////////////////////////////////////////////////////

bool map_tests()
{
    NEW_TEST_SERIE("map")
    NEW_TEST("map<int,string>")

    map<int,string> m;

    m.set(2, "2");
    EXPECT_EQ(m.get(2), "2", "Key 2 should hold value '2'")

    m.set(2, "23");
    m.set(4, "56");
    int four = 4;
    EXPECT_EQ(m.get(2), "23", "Key 2 should hold value '23'")
    EXPECT_EQ(m.get(four), "56", "Key 4 passed by reference should hold value '56'")

    m.erase(2);
    EXPECT_EQ(m.contains(2), false, "Key 2 should not be in the map anymore")

    // contains
    EXPECT(m.contains(4), "map should contains an key 4")

    m.set(5, "5");
    m.set(6, "6");
    m.set(7, "7");
    m.clear();
    EXPECT_EQ(m.size(), 0, "map size should be 0 after clear()")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("map<string, int> constructors and assignements")

    m.set(1, "1").set(2, "2").set(3, "3");
    map<int, string> m2(m);

    EXPECT_EQ(m2.get(3), "3", "second map should have copied this value from the other")

    map<int, string> m3 = m2;
    EXPECT_EQ(m3.get(2), "2", "second map should have copied this value from the other")

    ///////////////////////////////////////////////////////////////////////////

    SUCCEEDED_TESTS
}

///////////////////////////////////////////////////////////////////////////////

bool class_map_tests()
{
    NEW_TEST_SERIE("class_map")
    NEW_TEST("class_map<string, TestClass>")

    class_map<string, TestClass> m;

    m.emplace("minus one");
    m.emplace("zero", 0);
    m.emplace("second", 2, "two");

    TestClass tc(12, "12");
    m.set("first", tc);

    EXPECT_EQ(m.get_ref("first").number, 12, "Value of 'first' item member 'number' should be 12")

    TestClass* tp = NULL;
    if (m.access("first", tp))
    {
        tp.number = 34;
    }

    EXPECT_EQ(m.get_ref("first").number, 34, "Value of 'first' item member 'number' should have been changed to 34")

    EXPECT_EQ(m.size(), 4, "The class_map size should be 4 at this point")

    m.erase("second");
    EXPECT_EQ(m.size(), 3, "The class_map size should be 3 after erasing an entry")
    EXPECT_EQ(m.access("second", tp), false, "The erased element should not be accessible")

    m.clear();
    EXPECT_EQ(m.size(), 0, "The class_map size should be 0 after clear() call")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("class_map<string, TestClass> constructors and assignements")

    SUCCEEDED_TESTS
}

///////////////////////////////////////////////////////////////////////////////

bool ui_manager_tests()
{
    int sleep_duration = 500;

    NEW_TEST_SERIE("ui_manager")
    NEW_TEST("ui_manager - label_t create")
    ui_manager ui;

    int test_count = 10;
    int x = 0;
    int y = 0;
    string coord = "";

    for(x = 0; x < test_count; ++x)
    {
        for(y = 0; y < test_count; ++y)
        {
            coord = "(" + IntegerToString(x) + ", " + IntegerToString(y) + ")";

            if (!ui.create_label(coord, coord, dv_col(x), dv_row(y)))
            {
                FAIL("Unable to create new label")
            }
        }
    }

    for(x = 0; x < test_count; ++x)
    {
        for(y = 0; y < test_count; ++y)
        {
            coord = "(" + IntegerToString(x) + ", " + IntegerToString(y) + ")";

            if (ui.delete_label(coord))
            {
                ui.update();
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - label_t move")

    ui.create_label("test_label", "TEST LABEL");
    Sleep(sleep_duration);
    ui.move_label("test_label", dv_col(2), dv_row(2));
    Sleep(sleep_duration);

    label_t* label = NULL;
    if (ui.access("test_label", label) == false)
    {
        FAIL("Unable to access label object")
    }

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - label_t init")

    EXPECT_EQ(label.get_font(),  DV_DEFAULT_LABEL_FONT  , "Font should have been 'Consolas'")
    EXPECT_EQ(label.get_color(), DV_DEFAULT_LABEL_COLOR , "Color should have been 'clrRed'")
    EXPECT_EQ(label.get_size(),  DV_DEFAULT_LABEL_SIZE  , "Size should have been 12")
    EXPECT_EQ(label.get_id(),    "test_label"           , "Id should have been 'test_label'")

    string  new_font  = "Times New Roman";
    color   new_color = clrPink;
    int     new_size  = 42;

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - label_t builder pattern")

    label.set_font(new_font)
         .set_color(new_color)
         .set_size(new_size)
         .set_text("IS THIS A TEST?");

    ui.update();

    EXPECT_EQ(label.get_font(),  new_font,  "Font should have been " + new_font)
    EXPECT_EQ(label.get_color(), new_color, "New color is wrong")
    EXPECT_EQ(label.get_size(),  new_size,  "Size should have been " + IntegerToString(new_size))

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - label_t deletion")

    ui.delete_label("test_label");
    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - hline_t")

    // create
    ui.create_hline("test_hline", Bid);
    Sleep(sleep_duration);

    // modify

    hline_t* hline = NULL;
    if (ui.access("test_hline", hline) == false)
    {
        FAIL("Unable to access hline object")
    }

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - hline_t modify")

    int k = 127;
    int i = 0;
    double new_price = 0;
    for(i = 0; i < k; ++i)
    {
        new_price = Bid - (k * k * Pip) + (k * i * Pip);
        hline.set_price(new_price)
        .set_color(i << 16)
        .set_width(i / 16);

        ui.update();
    }
    for(i = 0; i < k; ++i)
    {
        new_price = Bid - (k * k * Pip) + (k * i * Pip);
        hline.set_price(new_price)
        .set_color(i << 8)
        .set_width(i / 16);

        ui.update();
    }
    for(i = 0; i < k; ++i)
    {
        new_price = Bid - (k * Pip) + (k * i * Pip);
        hline.set_price(new_price)
        .set_color(i)
        .set_width(i / 16);

        ui.update();
    }

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - hline_t delete")
    ui.delete_hline("test_hline");

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////
    NEW_TEST("ui_manager - vline_t")

    // create
    ui.create_vline("test_vline", iTime(NULL, 0, 0));
    Sleep(sleep_duration);

    // modify

    vline_t* vline = NULL;
    if (ui.access("test_vline", vline) == false)
    {
        FAIL("Unable to access vline object")
    }

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - vline_t modify")

    k = 127;
    datetime new_time = 0;
    for(i = 0; i < k; ++i)
    {
        new_time = iTime(NULL, 0, i);
        vline.set_time(new_time)
        .set_color(i << 16)
        .set_width(i / 16);

        ui.update();
    }
    for(i = 0; i < k; ++i)
    {
        new_time = iTime(NULL, 0, i + 40);
        vline.set_time(new_time)
        .set_color(i << 8)
        .set_width(i / 16);

        ui.update();
    }
    for(i = 0; i < k; ++i)
    {
        new_time = iTime(NULL, 0, i + 80);
        vline.set_time(new_time)
        .set_color(i)
        .set_width(i / 16);

        ui.update();
    }

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - vline_t delete")
    ui.delete_vline("test_vline");

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - triangle")

    int a_x = 10;
    int a_y = 10;
    int x0 = 10;
    int y0 = 10;
    int x1 = 40;
    int y1 = 10;
    int x2 = 10;
    int y2 = 40;
    int red = 128;
    int green = 64;
    int blue = 0;
    color triangle_color = (red & 0xFF) | ((green << 8) & 0xFF00) | ((blue << 16) & 0xFF0000);

    ui.create_triangle("test_triangle", a_x, a_y, x0, y0, x1, y1, x2, y2, triangle_color);
    ui.update();

    Sleep(sleep_duration);

    for(i = 0; i < k; ++i)
    {
        a_x++;
        a_y++;
        x0+=1;
        y0+=2;
        x1+=2;
        y1+=1;
        x2+=4;
        y2+=3;
        red++;
        green++;
        blue++;
        triangle_color = (red & 0xFF) | ((green << 8) & 0xFF00) | ((blue << 16) & 0xFF0000);

        ui.edit_triangle_anchors("test_triangle", a_x, a_y);
        ui.edit_triangle_color("test_triangle", triangle_color);
        ui.edit_triangle_points("test_triangle", x0, y0, x1, y1, x2, y2);

        ui.update();
        Sleep(25);
    }

    ui.delete_triangle("test_triangle");

    Sleep(sleep_duration);

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("ui_manager - rectangle")

    ui.create_rectangle("test_rectangle", Time[4], Ask + 10 * Pip, Time[14], Bid - 10 * Pip);
    ui.update();
    Sleep(sleep_duration);
    ui.edit_rectangle_corners("test_rectangle", Time[20], Ask + 20 * Pip, Time[24], Bid - 20 * Pip);
    ui.update();
    Sleep(sleep_duration);
    ui.edit_rectangle_style("test_rectangle", clrBlue, STYLE_DASHDOT, 5);
    ui.update();
    Sleep(sleep_duration);
    ui.delete_rectangle("test_rectangle");

    SUCCEEDED_TESTS
}


int opened = 0;
int closed = 0;
int new_closed = 0;
int archived = 0;

void refresh_order_book_counts(order_manager& ob)
{
    Sleep(1000);
    ob.refresh();
    opened = ob.opened_orders_count();
    closed = ob.closed_orders_count();
    new_closed = ob.new_closed_orders_count();
    archived = ob.archived_orders_count();
}

// Uncomment this to enable this test
#define ORDER_BOOK_TESTS
bool order_book_tests()
{
#ifdef ORDER_BOOK_TESTS

    ERROR("ORDER_BOOK TESTS WILL BE EXECUTED")
    ERROR("ORDERS ARE BEING OPENED AND CLOSED")
    ERROR("SORRY IF IT'S REAL MONEY!")

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST_SERIE("order_manager")
    NEW_TEST("order_manager - detecting opened order")

    order_t* order = NULL;
    order_manager orders;

    orders.close_all();
    orders.archive_closed_orders();
    orders.clear_archive();

    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "No open orders should exist in the order_manager");
    EXPECT_EQ(0, closed, "No closed orders should exist in the order_manager");
    EXPECT_EQ(0, new_closed, "No new closed orders should exist in the order_manager");
    //EXPECT_EQ(0, archived, "No archived orders should exist in the order_manager");

    double ask = Ask;
    double lots = MarketInfo(_Symbol, MODE_MINLOT);
    double slippage = DV_MAX_PIP_SLIPPAGE * Pip;
    int ticket = OrderSend(NULL, OP_BUY, lots, ask, slippage, 0, ask + 100 * Pip, "Test", MagicNumber);

    refresh_order_book_counts(orders);
    EXPECT_EQ(1, opened, "There should only be one open order");
    EXPECT_EQ(0, closed, "No closed orders should exist in the order_manager");
    EXPECT_EQ(0, new_closed, "No new closed orders should exist in the order_manager");
    //EXPECT_EQ(0, archived, "No archived orders should exist in the order_manager");

    class_map<int, order_t>* opened_map = orders.get_opened_orders_map_ref();
    class_map<int, order_t>* closed_map = orders.get_closed_orders_map_ref();

    vector<int> tickets = opened_map.get_keys_ref();
    EXPECT_EQ(1, tickets.size(), "There should only be one ticket in the order_manager at this point")

    if (opened_map.access(tickets.get(0), order))
    {
        EXPECT_EQ(order.get_ticket(), ticket, "Created ticket should be equivalent to the one found in the order_manager")
        EXPECT_EQ(order.get_type(), OP_BUY, "Created ticket should be a BUY")
        EXPECT_EQ(order.get_lots(), lots, "Created ticket should match the original size")

        double open_range_high = ask + slippage;
        double open_range_low = ask - slippage;
        bool good_open_price = order.get_open_price() >= open_range_low &&
                               order.get_open_price() <= open_range_high;
        EXPECT(good_open_price, "Created ticket should match the original open price")
    }
    else
    {
        FAIL("An open order should have been accessible")
    }

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("order_manager - closed order detection")

    double bid = Bid;
    DISCARD_I(OrderClose(ticket, lots, bid, DV_MAX_PIP_SLIPPAGE * Pip))
    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "There should be no more opened order at this point");
    EXPECT_EQ(1, closed, "There should be only one closed order at this point");
    EXPECT_EQ(1, new_closed, "There should be only one new closed order at this point");
    //EXPECT_EQ(0, archived, "No archived orders should exist in the order_manager");

    order = NULL;
    if (orders.access_new_closed(order))
    {
        EXPECT_EQ(order.get_ticket(), ticket, "Created ticket should be equivalent to the one found in the order_manager")
        EXPECT_EQ(order.get_type(), OP_BUY, "Created ticket should be a BUY")
        EXPECT_EQ(order.get_lots(), lots, "Created ticket should match the original size")

        double close_range_high = ask + slippage;
        double close_range_low = ask - slippage;
        bool good_close_price = order.get_close_price() >= close_range_low &&
                                order.get_close_price() <= close_range_high;

        EXPECT(good_close_price, "Created ticket should match the original open price")
    }
    else
    {
        FAIL("A new closed order should have been accessible")
    }

    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "No opened order should remain");
    EXPECT_EQ(1, closed, "At this point there should be exactly one closed story");
    EXPECT_EQ(0, new_closed, "The last new closed story has been consulted so this value should be zero");
    //EXPECT_EQ(0, archived, "No archived orders should exist in the order_manager");

    orders.archive_closed_orders();
    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "No opened order should remain");
    EXPECT_EQ(0, closed, "The last closed story should have been archived");
    EXPECT_EQ(0, new_closed, "The last new closed story has been consulted so this value should be zero");
    //EXPECT_EQ(1, archived, "The should be one archived order here");

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("order_manager - open order with order_t static function")

    order_t::open(OP_BUY, lots, Ask);
    order_t::open(OP_SELL, lots, Bid);
    ticket = order_t::open(OP_BUY, lots, Ask);
    refresh_order_book_counts(orders);
    EXPECT_EQ(3, opened, "There should be three open orders");
    EXPECT_EQ(0, closed, "No closed orders should exist in the order_manager");
    EXPECT_EQ(0, new_closed, "No new closed orders should exist in the order_manager");
    //EXPECT_EQ(1, archived, "No archived orders should exist in the order_manager");

    ///////////////////////////////////////////////////////////////////////////

    NEW_TEST("order_manager - close_all_except() and close_all()")
    orders.close_all_except(ticket);
    refresh_order_book_counts(orders);
    EXPECT_EQ(1, opened, "There should only be one open order");
    EXPECT_EQ(2, closed, "2 closed orders should exist in the order_manager");
    EXPECT_EQ(2, new_closed, "2 new closed orders should exist in the order_manager");

    EXPECT_EQ(opened_map.size(), 1, "There should be one remaining order")
    EXPECT(opened_map.contains(ticket), "The remaining opened order should be the one excluded: " + IntegerToString(ticket))

    // close_all
    order_t::open(OP_BUY, lots, Ask);
    order_t::open(OP_BUY, lots, Ask);
    orders.close_all();
    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "There should not be any opened order left");
    EXPECT_EQ(5, closed, "5 closed orders should exist in the order_manager");
    EXPECT_EQ(5, new_closed, "All 5 closed orders should still be new");

    orders.archive_closed_orders();
    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "No opened orders should exist in the order_manager");
    EXPECT_EQ(0, closed, "No closed orders should exist in the order_manager");
    EXPECT_EQ(0, new_closed, "No new closed orders should exist in the order_manager");
    //EXPECT_EQ(6, archived, "6 files should be archived at this point");

    orders.clear_archive();
    refresh_order_book_counts(orders);
    EXPECT_EQ(0, opened, "No opened orders should exist in the order_manager");
    EXPECT_EQ(0, closed, "No closed orders should exist in the order_manager");
    EXPECT_EQ(0, new_closed, "No new closed orders should exist in the order_manager");
    //EXPECT_EQ(0, archived, "All archived orders should have been purged");

    ///////////////////////////////////////////////////////////////////////////

    SUCCEEDED_TESTS

#else

    ERROR("ORDER_BOOK TESTS WILL NOT BE EXECUTED")
    ERROR("ORDERS WILL BE OPENED AND CLOSED")
    ERROR("BE SURE YOU ARE USING A DEMO ACCOUNT")
    return true;

#endif
};