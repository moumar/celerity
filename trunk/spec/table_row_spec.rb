require File.dirname(__FILE__) + '/spec_helper.rb'

describe TableRow do
  
  before :all do
    @browser = IE.new
  end

  before :each do
    @browser = IE.new
    @browser.goto(TEST_HOST + "/tables.html")
  end
  
  describe "#exists?" do
    it "should return true if the table row exists" do
      @browser.row(:id, "outer_first").should exist
      @browser.row(:id, /outer_first/).should exist
      @browser.row(:index, 1).should exist
      @browser.row(:xpath, "//tr[@id='outer_first']")
    end

    it "should return true if the element exists (default how = :id)" do
      @browser.row("outer_last").should exist
    end

    it "should return false if the table row exists" do
      
    end

    it "should raise ArgumentError when 'what' argument is invalid" do
      lambda { @browser.row(:id, 3.14).exists? }.should raise_error(ArgumentError)
    end

    it "should raise MissingWayOfFindingObjectException when 'how' argument is invalid" do
      lambda { @browser.row(:no_such_how, 'some_value').exists? }.should raise_error(MissingWayOfFindingObjectException)
    end
  end
  
  describe "#column_count" do
    it "should return the number of columns (cells) in the row" do
      @browser.table(:id, 'outer').rows[1].column_count.should == 2
      @browser.table(:id, 'outer')[2].column_count.should == 2
      @browser.table(:id, 'colspan')[1].column_count.should == 1
      @browser.table(:id, 'colspan').rows[2].column_count.should == 2
      @browser.rows[1].column_count.should == 4
    end
  end
  
  describe "#length" do
    it "should return the number of rows" do
      @browser.table(:id, 'outer').rows.length.should == 3
      @browser.table(:id, 'inner').rows.length.should == 1
    end
  end
  
  describe "#[]" do
    it "should " do # FIXME: description
      @browser.table(:id, 'outer').row(:index, 1)[1].text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[1][1].text.should == "Table 1, Row 1, Cell 1"
      @browser.table(:id, 'outer')[3][1].text.should == "Table 1, Row 3, Cell 1"
    end
  end
  
  describe "#each" do
    it "should " do # FIXME: description
      index = 1
      @browser.table(:id, 'outer')[2].each do |c|
        case index
        when 1
          c.text.should == "Table 1, Row 2, Cell 1"
        when 2
          c.text.should == "Table 1, Row 2, Cell 2 Table 2, Row 1, Cell 1 Table 2, Row 1, Cell 2"
        end
        index += 1
      end
    end
  end

  after :all do
    @browser.close
  end
  
end
