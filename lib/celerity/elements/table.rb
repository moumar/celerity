module Celerity

  class Table < Element
    include ClickableElement
    include Enumerable
    include Container

    TAGS = [ Identifier.new('table') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:summary, :width, :border, :frame, :rules,
                                    :cellspacing, :cellpadding, :align, :bgcolor]
    DEFAULT_HOW = :id

    def locate
      super
      if @object # cant call assert_exists here, as an exists? method call will fail
        @rows = @object.getRows
        @cells = []
        @rows.each do |row|
          row.getCells.each do |c|
            @cells << c
          end
        end
      end
    end
    
    #
    # @return [Celerity::TableRows]
    #
    
    def rows
      assert_exists
      TableRows.new(self, :object, @rows)
    end
    
    #
    # @return [Celerity::TableCells]
    #
    
    def cells
      assert_exists
      TableCells.new(self, :object, @cells)
    end
    
    #
    # Iterates through each row in the table.
    # @yieldparam [Celerity::TableRow] row A row.
    #
    
    def each
      assert_exists
      @rows.each { |row| yield TableRow.new(self, :object, row)  }
    end

    #
    # Returns the TableRow at the given index (1-indexed).
    #
    #   browser.table(:foo, 'bar')[1] # => #<TableRow...>
    #   browser.table(:foo, 'bar').child_row[1] # => #<TableRow...>
    #
    # @param [Fixnum] index The index of the wanted row, 1-indexed.
    # @raise [Celerity::Exception::UnknownRowException]
    # @return [Celerity::TableRow]
    #
    
    def child_row(index)
      assert_exists

      if (index - INDEX_OFFSET) >= @rows.length
        raise UnknownRowException, "Unable to locate a row at index #{index}"
      end

      TableRow.new(self, :object, @rows[index - INDEX_OFFSET])
    end
    alias_method :[], :child_row

    #
    # Returns the TableCell at the given index (1-indexed).
    #
    # In a 10-column row, table.child_cell[11] will return the first cell on the second row.
    #
    # @param [Fixnum] index The index of the wanted cell, 1-indexed.
    # @raise [Celerity::Exception::UnknownCellException]
    # @return [Celerity::TableCell]
    #
    
    def child_cell(index)
      assert_exists

      if (index - INDEX_OFFSET) >= @cells.length
        raise UnknownCellException, "Unable to locate a cell at index #{index}"
      end
      TableCell.new(self, :object, @cells[index - INDEX_OFFSET])
    end

    #
    # The number of rows in the table
    # @return [Fixnum]
    #
    
    def row_count
      assert_exists
      @object.getRowCount
    end
    
    #
    # Returns the number of columns on the row at the given index. (1-indexed)
    # Default is the number of columns on the first row
    # @param [Fixnum] index An index, 1-indexed (optional).
    # @return [Fixnum]
    #
    
    def column_count(index = INDEX_OFFSET)
      assert_exists
      @object.getRow(index - INDEX_OFFSET).getCells.length
    end

    #
    # Returns the text of each cell in the the table as a two-dimensional array.
    # @return [Array<Array<String>>]
    #
    
    def to_a
      assert_exists
      # @object.getRows.map do |table_row|
      #   table_row.getCells.map { |td| td.asText.strip }
      # end
      rows.map do |table_row|
        table_row.map { |td| td.text }
      end
    end

    def column_values(column_number)
      (1..row_count).map { |index| self[index][column_number].text }
    end

    def row_values(row_number)
      (1..column_count(row_number)).map { |index| self[row_number][index].text }
    end

  end # Table
end # Celerity